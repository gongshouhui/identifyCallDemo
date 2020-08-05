//
//  YSFlowGoodsApplyController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowGoodsApplyController.h"
#import "YSFlowGoodsApplyViewModel.h"
@interface YSFlowGoodsApplyController ()

@end

@implementation YSFlowGoodsApplyController

- (void)loadView {
	[super loadView];
	self.viewModel = [[YSFlowGoodsApplyViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];// 早于视图下载完前创建viewModel
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self.viewModel turnOtherViewControllerWith:self andIndexPath:indexPath];
	
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
