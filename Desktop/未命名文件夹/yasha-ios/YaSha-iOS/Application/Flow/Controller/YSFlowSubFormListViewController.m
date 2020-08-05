//
//  YSFlowSubFormListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowSubFormListViewController.h"
#import "YSFlowFormListCell.h"

@interface YSFlowSubFormListViewController ()

@end

@implementation YSFlowSubFormListViewController

static NSString *cellIdentifier = @"FlowFormListCell";

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = self.titleString;
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSFlowFormListCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSFlowFormListModel *cellModel = self.dataSource[indexPath.row];
    [cell setCellModel:cellModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListModel *cellModel = self.dataSource[indexPath.row];
    if ([cellModel.fieldType isEqual:@"separator"]) {
        return 20;
    } else {
        return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFlowFormListCell *cell) {
            YSFlowFormListModel *cellModel = self.dataSource[indexPath.row];
            [cell setCellModel:cellModel];
        }];
    }
}

@end
