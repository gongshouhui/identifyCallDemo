//
//  YSAuthorizedAdjustController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/10/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAuthorizedAdjustController.h"
#import "YSRecruitAuthorizedAdjustViewModel.h"
@interface YSAuthorizedAdjustController ()

@end

@implementation YSAuthorizedAdjustController

- (void)loadView {
	[super loadView];
	self.viewModel = [[YSRecruitAuthorizedAdjustViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];
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
