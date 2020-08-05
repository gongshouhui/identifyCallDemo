//
//  YSValuationSoftUseInfoController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSValuationSoftUseInfoController.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"
#import "YSFlowFormListCell.h"
#import "YSFlowEditCell.h"
@interface YSValuationSoftUseInfoController ()

@end

@implementation YSValuationSoftUseInfoController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Do any additional setup after loading the view.
}
- (void)setUserArr:(NSArray *)userArr {
	_userArr = userArr;
	NSDictionary *dic = _userArr[0];
	[self.dataSourceArray addObject:@{@"title":@"使用人",@"content":dic[@"receptionMan"]}];
	[self.dataSourceArray addObject:@{@"title":@"使用部门",@"content":dic[@"applyDept"]}];
	[self.dataSourceArray addObject:@{@"title":@"使用公司",@"content":dic[@"applyCompany"]}];
	[self.dataSourceArray addObject:@{@"title":@"关联项目",@"content":dic[@"ownProject"]}];
	[self.dataSourceArray addObject:@{@"title":@"预计使用日期",@"content":dic[@"useTimeStr"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"是否项目地使用",@"content":dic[@"ifProjectUse"]?@"是":@"否"}];
	[self.dataSourceArray addObject:@{@"title":@"收件人",@"content":dic[@"receiver"]}];
	[self.dataSourceArray addObject:@{@"title":@"收件人联系电话",@"content":dic[@"receiverPhone"]}];
	//area
	[self.dataSourceArray addObject:@{@"title":@"收件人地址",@"content":[NSString stringWithFormat:@"%@%@",dic[@"area"],dic[@"address"]]}];
	[self.tableView reloadData];
	
	
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dataDic = self.dataSourceArray[indexPath.row];
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
