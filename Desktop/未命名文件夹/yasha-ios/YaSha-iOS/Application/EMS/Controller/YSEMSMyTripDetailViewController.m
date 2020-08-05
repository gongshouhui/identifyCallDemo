//
//  YSEMSMyTripDetailViewController.m
//  YaSha-iOS
//
//  Created by hui on 2017/11/14.
//

#import "YSEMSMyTripDetailViewController.h"
#import "YSFlowFormListCell.h"
#import "YSEMSTripDetailModel.h"

@interface YSEMSMyTripDetailViewController ()
@property (nonatomic, strong) YSEMSTripDetailModel *EMSTripDetailModel;

@end

@implementation YSEMSMyTripDetailViewController

static NSString *cellIdentifier = @"FlowFormListCell";
- (void)initTableView {
	[super initTableView];
	self.title = @"出差详情";
	self.tableView.mj_header = nil;
	self.tableView.mj_footer = nil;
	[self.tableView registerClass:[YSFlowFormListCell class] forCellReuseIdentifier:cellIdentifier];
	[self doNetworking];
}

- (void)doNetworking {
	[super doNetworking];
	YSEMSMyTripSubListModel *subListModel = _cellModel.businessTripList[0];
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getMyTripDetailApi, subListModel.businessId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"获取出差详情:%@", response);
		if ([response[@"code"] intValue] == 1) {
			self.EMSTripDetailModel = [YSEMSTripDetailModel yy_modelWithJSON:response[@"data"]];
			[self.dataSourceArray removeAllObjects];
			[self doWithData];
		}
		
	} failureBlock:^(NSError *error) {
		DLog(@"error:%@", error);
		[self ys_showNetworkError];
	} progress:nil];
}

- (void)doWithData {
	NSMutableArray *bussinessArr = [NSMutableArray array];
	[bussinessArr addObject:@{@"name":@"出差人",@"content":self.EMSTripDetailModel.businessPname}];
	[bussinessArr addObject:@{@"name":@"所属公司",@"content":self.EMSTripDetailModel.businessName}];
	[bussinessArr addObject:@{@"name":@"出差事由",@"content":self.EMSTripDetailModel.remark}];
	[bussinessArr addObject:@{@"name":@"出差性质",@"content":self.EMSTripDetailModel.businessNature}];
	[bussinessArr addObject:@{@"name":@"职务级别",@"content":self.EMSTripDetailModel.jobLevelName}];
	[bussinessArr addObject:@{@"name":@"区域营销公司",@"content":self.EMSTripDetailModel.areaCompany}];
	[bussinessArr addObject:@{@"name":@"出差日期",@"content":self.EMSTripDetailModel.startTime}];
	[bussinessArr addObject:@{@"name":@"返程日期",@"content":self.EMSTripDetailModel.endTime}];
	[bussinessArr addObject:@{@"name":@"身份证号码",@"content":self.EMSTripDetailModel.idCard}];
	if ([self.EMSTripDetailModel.proPerson isEqualToString:@"否"]) {
		[bussinessArr addObject:@{@"name":@"是否为项目人员",@"content":self.EMSTripDetailModel.proPerson}];
	}else{
		[bussinessArr addObject:@{@"name":@"工程项目名称",@"content":self.EMSTripDetailModel.proName}];
		[bussinessArr addObject:@{@"name":@"项目经理",@"content":self.EMSTripDetailModel.proManagerName}];
	}
	//行程部分
	NSMutableArray *tripArr = [NSMutableArray array];
	for (int i = 0; i < self.EMSTripDetailModel.businessTripList.count; i ++) {
		YSEMSTripDetailListModel *detailListModel = self.EMSTripDetailModel.businessTripList[i];
		// [tripArr addObject:@{@"name":detailListModel.endCity,@"content":@"地址"}];
		[tripArr addObject:@{@"name":@"出差地区",@"content":detailListModel.businessArea}];
		[tripArr addObject:@{@"name":@"出差时间",@"content":detailListModel.startTime}];
		if (detailListModel.businessAreaCode == 1) {
			[tripArr addObject:@{@"name":@"出发地",@"content":detailListModel.startAddress}];
			[tripArr addObject:@{@"name":@"目的地",@"content":detailListModel.endAddress}];
		}else{
			[tripArr addObject:@{@"name":@"出发地址",@"content":detailListModel.endCity}];
		}
		[tripArr addObject:@{@"name":@"预定酒店",@"content": detailListModel.bookHotal}];
		[tripArr addObject:@{@"name":@"出行方式",@"content":detailListModel.tripMode}];
		[tripArr addObject:@{@"name":@"交通代买",@"content":detailListModel.buyTickets}];
		[tripArr addObject:@{@"name":@"费用所属公司",@"content":detailListModel.ownCompany}];
		//        [tripArr addObject:@{@"name":@"项目类型",@"content":detailListModel.proType}];
		//        [tripArr addObject:@{@"name":@"项目名称",@"content":detailListModel.proName}];
		
		if ([detailListModel.proType isEqualToString:@"ccd_triptype_xm"]) {//项目
			[tripArr addObject:@{@"name":@"费用分摊",@"content":@"项目"}];
			[tripArr addObject:@{@"name":@"项目名称",@"content":detailListModel.proName}];
			[tripArr addObject:@{@"name":@"项目性质",@"content":detailListModel.proNature}];
			[tripArr addObject:@{@"name":@"项目经理",@"content":detailListModel.proManagerName}];
		}else if([detailListModel.proType isEqualToString:@"ccd_triptype_bbm"]){//本部门和其他部门
			[tripArr addObject:@{@"name":@"费用分摊",@"content":@"本部门"}];
			[tripArr addObject:@{@"name":@"部门名称",@"content":detailListModel.orgName}];
		}else{
			[tripArr addObject:@{@"name":@"费用分摊",@"content":@"其他部门"}];
			[tripArr addObject:@{@"name":@"部门名称",@"content":detailListModel.orgName}];
		}
		
		
		if (detailListModel.remark.length > 0) {
			[tripArr addObject:@{@"name":@"备注",@"content":detailListModel.remark}];
		}
		
		
	}
	
	
	[self.dataSourceArray addObject:bussinessArr];
	[self.dataSourceArray addObject:tripArr];
	[self ys_reloadData];
	
	
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
	return [self.dataSourceArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	[cell setBusinessTripDetailWithDictionary:self.dataSourceArray[indexPath.section][indexPath.row]];
	return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [UIView new];
	view.backgroundColor = kUIColor(232, 234, 235, 1);
	
	if (section == 1) {
		UILabel *label = [[UILabel alloc]initWithFont:[UIFont systemFontOfSize:14] textColor:kGrayColor(119)];
		label.frame = CGRectMake(15, 10, SCREEN_WIDTH, 20);
		label.text = @"行程";
		[view addSubview:label];
	}
	return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 15;
			break;
			
		default:
			return 40;
			break;
	}
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

@end
