//
//  YSFlowTripViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/12/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowTripViewModel.h"
#import "YSFlowTripDetailController.h"
@implementation YSFlowTripViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getBusinessInfoByCodeApi, self.flowModel.businessKey];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			
			 [self setUpData:self.flowFormModel.info];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"mobileFiles"]) {
				YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
				[self.attachArray addObject:model];
			}
			if (self.attachArray.count > 0) {
				self.documentBtnTitle = [NSString stringWithFormat:@"关联文档(%lu)",(unsigned long)self.attachArray.count];
			}
			if (comleteBlock) {
				comleteBlock();
			}
		}else{
			if (fetchFailueBlock) {
				fetchFailueBlock(@"");//错误提示语由网络请求中心实现
			}
		}
	} failureBlock:^(NSError *error) {
		if (fetchFailueBlock) {
			fetchFailueBlock(@"");
		}
	} progress:nil];
	
}
- (void)setUpData:(NSDictionary *)dic {
	[self.dataSourceArray removeAllObjects];
	[self.dataSourceArray addObject:@{@"title":@"出差信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"出差人",@"content":dic[@"businessPname"]}];
	[self.dataSourceArray addObject:@{@"title":@"所属公司",@"content":dic[@"businessName"]}];
	[self.dataSourceArray addObject:@{@"title":@"职务级别",@"content":dic[@"jobLevelName"]}];
	[self.dataSourceArray addObject:@{@"title":@"职位",@"content":dic[@"businessPstation"]}];
	[self.dataSourceArray addObject:@{@"title":@"出差日期",@"content":[YSUtility timestampSwitchTime:[NSString stringWithFormat:@"%@",dic[@"startTime"]] andFormatter:@"yyyy-MM-dd"]}];
	[self.dataSourceArray addObject:@{@"title":@"返程日期",@"content":[YSUtility timestampSwitchTime:[NSString stringWithFormat:@"%@",dic[@"endTime"]] andFormatter:@"yyyy-MM-dd"]}];
	[self.dataSourceArray addObject:@{@"title":@"出差事由",@"content":dic[@"remark"]}];
	[self.dataSourceArray addObject:@{@"title":@"出差性质",@"content":dic[@"businessNature"]}];
	[self.dataSourceArray addObject:@{@"title":@"身份证号码",@"content":dic[@"idCard"]}];
	[self.dataSourceArray addObject:@{@"title":@"是否项目人员",@"content":[NSString stringWithFormat:@"%@",[dic[@"proPerson"] intValue]?@"是":@"否"]}];
	if ([dic[@"proPerson"] intValue]) {
		[self.dataSourceArray addObject:@{@"title":@"工程项目名称",@"content":dic[@"proName"]}];
		[self.dataSourceArray addObject:@{@"title":@"项目经理",@"content":dic[@"proManagerName"]}];
	}
	
	
	//行程明细
	[self.dataSourceArray addObject:@{@"title":@"行程明细",@"special":@(BussinessFlowCellHead)}];
	
	for (int i = 0; i < [dic[@"businessTripList"] count]; i ++) {
		NSDictionary *tripDic = dic[@"businessTripList"][i];
		//行程详情数组
		NSMutableArray *detailArray = [NSMutableArray array];
		
		[detailArray addObject:@{@"title":@"出差地区",@"content":[tripDic[@"businessArea"] intValue] == 1?@"国内":@"国外"}];
		
		[detailArray addObject:@{@"title":@"出发日期",@"content":[YSUtility timestampSwitchTime:[NSString stringWithFormat:@"%@",tripDic[@"startTime"]] andFormatter:@"yyyy-MM-dd"]}];
		[detailArray addObject:@{@"title":@"起止地",@"content":[tripDic[@"address"] isEqual:@""]?[NSString stringWithFormat:@"%@ → %@", tripDic[@"startCity"], tripDic[@"endCity"]] : tripDic[@"address"]}];
		[detailArray addObject:@{@"title":@"预定酒店",@"content":[NSString stringWithFormat:@"%@",[tripDic[@"bookHotal"] intValue]?@"是":@"否"]}];
		[detailArray addObject:@{@"title":@"出行方式",@"content":tripDic[@"tripMode"]}];
		if (![tripDic[@"buyTickets"] isEqualToString:@""]) {
			[detailArray addObject:@{@"title":@"交通代买",@"content":tripDic[@"buyTickets"]}];
		}
		[detailArray addObject:@{@"title":@"费用所属公司",@"content":tripDic[@"ownCompany"]}];
		
		if ([tripDic[@"proType"] isEqualToString:@"ccd_triptype_xm"]) {//项目
			[detailArray addObject:@{@"title":@"费用分摊",@"content":@"项目"}];
			[detailArray addObject:@{@"title":@"项目名称",@"content":tripDic[@"proName"]}];
			[detailArray addObject:@{@"title":@"项目性质",@"content":tripDic[@"proNature"]}];
				[detailArray addObject:@{@"title":@"项目经理",@"content":tripDic[@"proManagerName"]}];
		}else if([tripDic[@"proType"] isEqualToString:@"ccd_triptype_bbm"] ){//本部门和其他部门
				[detailArray addObject:@{@"title":@"费用分摊",@"content":@"本部门"}];
			[detailArray addObject:@{@"title":@"部门名称",@"content":tripDic[@"orgName"]}];
		}else{
			[detailArray addObject:@{@"title":@"费用分摊",@"content":@"其他部门"}];
			[detailArray addObject:@{@"title":@"部门名称",@"content":tripDic[@"orgName"]}];
		}
		
		[detailArray addObject:@{@"title":@"备注",@"content":tripDic[@"remark"]}];
		
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
		NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithInt:i+1]];
		[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"行程%@",numberString],@"content":@"查看详情",@"special":@(BussinessFlowCellTurn),@"file":detailArray}];
		[self.dataSourceArray addObject:@{@"title":@"出发日期",@"content":[YSUtility timestampSwitchTime:[NSString stringWithFormat:@"%@",tripDic[@"startTime"]] andFormatter:@"yyyy-MM-dd"]}];
		[self.dataSourceArray addObject:@{@"title":@"起止地",@"content":[tripDic[@"address"] isEqual:@""]?[NSString stringWithFormat:@"%@ → %@", tripDic[@"startCity"], tripDic[@"endCity"]] : tripDic[@"address"]}];
		[self.dataSourceArray addObject:@{@"title":@"交通代买",@"content":tripDic[@"buyTickets"]}];
		[self.dataSourceArray addObject:@{@"title":@"备注",@"content":tripDic[@"remark"]}];
	}
}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
	if ([cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		
		YSFlowTripDetailController *vc = [[YSFlowTripDetailController alloc]init];
		vc.detailArray = cellDic[@"file"];
		[viewController.navigationController pushViewController:vc animated:YES];
	}
	
}
@end
