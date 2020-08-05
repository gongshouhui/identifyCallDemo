//
//  YSFlowLaunchListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowLaunchListViewController.h"
#import "YSCommonFlowLaunchListViewController.h"
#import "YSFlowLaunchListModel.h"
#import "YSEMSApplyTripViewController.h"
#import "YSFlowLaunchListModel.h"
#import "YSWorkOverTimeViewController.h"//加班/因公外出
#import "YSPaidLeaveWViewController.h"//请假/调休
#import "YSProjectGWViewController.h"//项目调休申请
#import "YSModifyLanchFlowViewController.h"//申请的流程 修改

@interface YSFlowLaunchListViewController ()

@end

@implementation YSFlowLaunchListViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"新建流程";
}

- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    [self doNetworking];//自定义流程

}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getProcessListApi];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"发起流程列表:%@", response);
        self.dataSource = [NSArray yy_modelArrayWithClass:[YSFlowLaunchListModel class] json:response[@"data"]];
        [self ys_reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
        [self ys_showNetworkError];
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    YSFlowLaunchListModel *cellModel = self.dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = cellModel.modelName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowLaunchListModel *cellModel = self.dataSource[indexPath.row];
   
    if ([cellModel.modelKey isEqualToString:@"ems_business_flow_new"] || [cellModel.modelKey isEqualToString:@"ems_business_flow"]) {
        YSEMSApplyTripViewController *vc = [[YSEMSApplyTripViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cellModel.modelKey isEqualToString:@"atds_jiab_apply_flow"] || [cellModel.modelKey isEqualToString:@"atds_ygwc_apply_flow"]){
        // 加班atds_jiab_apply_flow / 因公外出atds_ygwc_apply_flow
        YSWorkOverTimeViewController *workVC = [YSWorkOverTimeViewController new];
        workVC.lanchModel = cellModel;
        [self.navigationController pushViewController:workVC animated:YES];
    }else if ([cellModel.modelKey isEqualToString:@"atds_qingj_apply_flow"]){
        //请假/调休 atds_qingj_apply_flow
        YSPaidLeaveWViewController *paidLeaveVC = [YSPaidLeaveWViewController new];
        paidLeaveVC.lanchModel = cellModel;
        [self.navigationController pushViewController:paidLeaveVC animated:YES];
        
    }else if ([cellModel.modelKey isEqualToString:@"project_tx_apply_flow"]){
        //项目调休 atds_qingj_apply_flow
        YSProjectGWViewController *projectVC = [YSProjectGWViewController new];
        projectVC.lanchModel = cellModel;
        [self.navigationController pushViewController:projectVC animated:YES];
        
    }else if ([cellModel.modelKey isEqualToString:@"atds_writeOff_apply_flow"]){
        //申请过的流程 修改 atds_writeOff_apply_flow
        YSModifyLanchFlowViewController *modifyFlowVC = [YSModifyLanchFlowViewController new];
        modifyFlowVC.lanchModel = cellModel;
        [self.navigationController pushViewController:modifyFlowVC animated:YES];
    } else{
        //自定义流程
        YSCommonFlowLaunchListViewController *commonFlowLaunchListViewController = [[YSCommonFlowLaunchListViewController alloc] init];
        commonFlowLaunchListViewController.cellModel = cellModel;
        [self.navigationController pushViewController:commonFlowLaunchListViewController animated:YES];
    }
    
   
}

@end
