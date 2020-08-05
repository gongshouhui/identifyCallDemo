//
//  YSFlowPMSContractController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowPMSContractController.h"
#import "YSFlowPMSContractInfoViewModel.h"
#import "FBKVOController.h"
@interface YSFlowPMSContractController ()
@property (nonatomic,strong) FBKVOController *KVOController;
@end

@implementation YSFlowPMSContractController
- (void)loadView {
    [super loadView];
    self.viewModel = [[YSFlowPMSContractInfoViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];// 早于视图下载完前创建viewModel
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
	
	//数据绑定
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    YSWeak;
    [self.KVOController observe:self.viewModel keyPath:@"reviewRemark" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [weakSelf.tableView reloadData];
        //定位当前的标题位置（该计算要在tableView刷新之后计算来保证header位置的准确）
        [weakSelf markSectionHeaderLocation];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowPMSContractInfoViewModel *viewModel = (YSFlowPMSContractInfoViewModel *)self.viewModel;
    [viewModel turnOtherViewControllerWith:self andIndexPath:indexPath];
    
}


@end
