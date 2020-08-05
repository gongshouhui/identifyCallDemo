//
//  YSFlowPresentBackController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/3/6.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowbBussinessPresentBackController.h"
#import "YSFlowBussinessPresentBackViewModel.h"
@interface YSFlowbBussinessPresentBackController ()

@end

@implementation YSFlowbBussinessPresentBackController

- (void)loadView {
    [super loadView];
    self.viewModel = [[YSFlowBussinessPresentBackViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];// 早于视图下载完前创建viewModel
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
