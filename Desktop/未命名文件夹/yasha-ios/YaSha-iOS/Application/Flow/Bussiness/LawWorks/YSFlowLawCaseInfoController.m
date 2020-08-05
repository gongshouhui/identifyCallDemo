//
//  YSFlowLawCaseInfoController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/7.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowLawCaseInfoController.h"
#import "YSFlowLawCaseViewModel.h"
@interface YSFlowLawCaseInfoController ()<UITableViewDelegate>

@end

@implementation YSFlowLawCaseInfoController
- (void)loadView {
    [super loadView];
   self.viewModel = [[YSFlowLawCaseViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //写在这里主要是因为cell没有和viewModel绑定，暂时在这里刷新，后来s有时间改为数据驱动
    [self.viewModel getFlowlistComplete:^{
        
        self.coverNavView.titleLabel.text = self.viewModel.flowFormModel.baseInfo.title;
        [self.functionHeaderView setHeaderModel:self.viewModel.flowFormModel.baseInfo];
        [self.functionHeaderView.documentButton setTitle:self.viewModel.documentBtnTitle forState:UIControlStateNormal];
        [self.tableView reloadData];
        //定位当前的标题位置（该计算要在tableView刷新之后计算来保证header位置的准确）
        [self markSectionHeaderLocation];
    } failue:^(NSString * _Nonnull message) {
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowLawCaseViewModel *viewModel = (YSFlowLawCaseViewModel *)self.viewModel;
    [viewModel turnOtherViewControllerWith:self andIndexPath:indexPath];
   
}

@end
