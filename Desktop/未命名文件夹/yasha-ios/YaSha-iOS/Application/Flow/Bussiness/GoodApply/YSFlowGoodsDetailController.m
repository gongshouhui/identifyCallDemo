//
//  YSFlowGoodsDetailController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowGoodsDetailController.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"
#import "YSFlowFormListCell.h"
#import "YSGoodsDetailTabHeaderView.h"
#import "YSGoodsDetailSectionHeaderView.h"
#import "YSGoodsDetailTabHeaderView.h"
#import "YSGoodsDetailSectionHeaderView.h"
#import "YSFlowGoodsApplyModel.h"
@interface YSFlowGoodsDetailController ()<YSGoodsDetailSectionHeaderViewDelegate>
@property (nonatomic,strong) NSMutableArray *openArray;
@end

@implementation YSFlowGoodsDetailController
- (NSMutableArray *)openArray {
	if (!_openArray) {
		_openArray = [[NSMutableArray alloc]init];
	}
	return _openArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	YSGoodsDetailTabHeaderView *headerView = [[NSBundle mainBundle]loadNibNamed:@"YSGoodsDetailTabHeaderView" owner:self options:nil].firstObject;
	headerView.frame = CGRectMake(0, 0, 0, 80);
	headerView.totalLb.text = [NSString stringWithFormat:@"共%ld种工地物资",self.goodsArray.count];
	headerView.totalPriceLb.text = [YSUtility thousandsFormat:self.totalMoney];
	self.tableView.tableHeaderView = headerView;
	[self setupData];

}

- (void)setupData {
	[self.dataSourceArray removeAllObjects];
	for (YSFlowGoodsDetailModel *goodModel in self.goodsArray) {
		[self.openArray addObject:@"close"];//记录展开收起
		NSMutableArray *infoArr = [NSMutableArray array];
		[infoArr addObject:@{@"special":@(BussinessFlowCellEmpty)}];
		[infoArr addObject:@{@"title":@"物品编码",@"special":@(BussinessFlowCellBG),@"content":goodModel.goodsNo}];
		[infoArr addObject:@{@"title":@"品牌",@"special":@(BussinessFlowCellBG),@"content":goodModel.brandName}];
		[infoArr addObject:@{@"title":@"规格型号",@"special":@(BussinessFlowCellBG),@"content":goodModel.proModel}];
		[infoArr addObject:@{@"title":@"单位",@"special":@(BussinessFlowCellBG),@"content":goodModel.buyUnit}];
		[infoArr addObject:@{@"title":@"金额(元)",@"special":@(BussinessFlowCellBG),@"content":[NSString stringWithFormat:@"%.2f",goodModel.totalPrice]}];
		[infoArr addObject:@{@"title":@"费用归属",@"special":@(BussinessFlowCellBG),@"content":goodModel.feeTypeStr}];
		[infoArr addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellBG),@"content":goodModel.remark}];
		[infoArr addObject:@{@"special":@(BussinessFlowCellEmpty)}];
		[self.dataSourceArray addObject:infoArr];
		
		
	}
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.goodsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.openArray[section] isEqualToString:@"open"]) {
		return [self.dataSourceArray[section] count];
	}else{
		return 0;
	}
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dataDic = self.dataSourceArray[indexPath.section][indexPath.row];
	 if([dataDic[@"special"] integerValue] == BussinessFlowCellBG){
		YSFlowBackGroundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowBackGroundCell"];
		if (cell == nil) {
			cell = [[YSFlowBackGroundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowBackGroundCell"];
		}
		cell.lableNameLabel.text = dataDic[@"title"];
		cell.valueLabel.text = dataDic[@"content"];
		cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
		return cell;
		
	}else if([dataDic[@"special"] integerValue] == BussinessFlowCellEmpty){
		YSFlowEmptyCell *cell = [[YSFlowEmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
		return cell;
		
	}else{
		YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"]; //出列可重用的cell
		
		if (cell == nil) {
			cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
		}
		[cell setCommonBusinessFlowDetailWithDictionary:dataDic];
		return cell;
	}
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	YSGoodsDetailSectionHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"YSGoodsDetailSectionHeaderView" owner:self options:nil].firstObject;
	headerView.delegate = self;
	headerView.tag = 100 + section;
	if ([self.openArray[section] isEqualToString:@"open"]) {
		headerView.arrowButton.selected = YES;
	}else{
		headerView.arrowButton.selected = NO;
	}
	headerView.goodModel = self.goodsArray[section];
	return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 118;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 15;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return UITableViewAutomaticDimension;
	
}
- (void)expandButtonDidClick:(UIButton *)button{
	NSInteger index = [button superview].tag - 100;
	if ([self.openArray[index] isEqualToString:@"open"]) {//展开
		[self.openArray replaceObjectAtIndex:index withObject:@"close"];
	}else{
		[self.openArray replaceObjectAtIndex:index withObject:@"open"];
	}
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
}
@end
