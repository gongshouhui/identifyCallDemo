//
//  YSFlowTripDetailController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/12/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowTripDetailController.h"
#import "YSFlowFormListCell.h"
@interface YSFlowTripDetailController ()

@end

@implementation YSFlowTripDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"行程详情";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.detailArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
        YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"]; //出列可重用的cell
        if (cell == nil) {
            cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
        }
        [cell setCommonBusinessFlowDetailWithDictionary:self.detailArray[indexPath.row]];
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 44;
}
@end
