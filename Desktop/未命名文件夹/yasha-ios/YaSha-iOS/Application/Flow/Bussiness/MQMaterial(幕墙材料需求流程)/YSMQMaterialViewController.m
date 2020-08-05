//
//  YSMQMaterialViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/6/13.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQMaterialViewController.h"
#import "YSFlowAttachmentViewController.h"
#import "YSBussinessMaterialModel.h"
#import "YSMQMaterialViewModel.h"
@interface YSMQMaterialViewController ()
@end

@implementation YSMQMaterialViewController
#pragma mark -- 懒加载
- (void)loadView {
    [super loadView];
    self.viewModel = [[YSMQMaterialViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];// 早于视图下载完前创建viewModel
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
   
     [QMUITips showLoadingInView:self.view];
    [self.viewModel getFlowlistComplete:^{
        [QMUITips hideAllTipsInView:self.view];
        self.coverNavView.titleLabel.text = self.viewModel.flowFormModel.baseInfo.title;
        [self.functionHeaderView setHeaderModel:self.viewModel.flowFormModel.baseInfo];
        [self.functionHeaderView.documentButton setTitle:self.viewModel.documentBtnTitle forState:UIControlStateNormal];
        
        [self.tableView reloadData];
        //定位当前的标题位置（该计算要在tableView刷新之后计算来保证header位置的准确）
        [self markSectionHeaderLocation];
        
    } failue:^(NSString * _Nonnull message) {
        [QMUITips hideAllTipsInView:self.view];
    }];
}


@end
