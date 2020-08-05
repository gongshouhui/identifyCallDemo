//
//  YSValuationSoftWareUpdateDetail.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSValuationSoftWareUpdateDetailController.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"
#import "YSFlowFormListCell.h"
#import "YSFlowEditCell.h"
@interface YSValuationSoftWareUpdateDetailController ()

@end

@implementation YSValuationSoftWareUpdateDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setUpdateDataArr:(NSArray *)updateDataArr {
	_updateDataArr = updateDataArr;
	for (NSDictionary *dic in updateDataArr) {
		NSMutableArray *infoArray = [NSMutableArray array];
		NSString *title = [NSString stringWithFormat:@"软件升级内容（%ld）",[updateDataArr indexOfObject:dic] + 1];
		[infoArray addObject:@{@"title":title,@"special":@(BussinessFlowCellHeadWhite)}];
		[infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
		[infoArray addObject:@{@"title":@"需求类型",@"special":@(BussinessFlowCellBG),@"content":dic[@"demandTypeName"]}];
		[infoArray addObject:@{@"title":@"升级内容",@"special":@(BussinessFlowCellBG),@"content":dic[@"upgradeContent"]}];
		
		[infoArray addObject:@{@"title":@"节点数" ,@"special":@(BussinessFlowCellBG),@"content":[dic[@"nodeNumber"] integerValue] > 0 ? [NSString stringWithFormat:@"%ld",[dic[@"nodeNumber"] integerValue]] : @""}];
		[self.dataSourceArray addObject:infoArray];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataSourceArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dataDic = self.dataSourceArray[indexPath.section][indexPath.row];
	if ([dataDic[@"special"] integerValue] == BussinessFlowCellEdit) {
		YSFlowEditCell *cell = [[YSFlowEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.titleLb.text = dataDic[@"title"];
		return cell;
	}else if([dataDic[@"special"] integerValue] == BussinessFlowCellBG){
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

@end
