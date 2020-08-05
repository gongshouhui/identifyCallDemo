//
//  YRecruitPersonAddController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/10/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YRecruitPersonAddController.h"
#import "YSRecruitPersonAddViewModel.h"
#import "YSFlowFormListCell.h"
@interface YRecruitPersonAddController ()

@end

@implementation YRecruitPersonAddController

- (void)loadView {
	[super loadView];
	self.viewModel = [[YSRecruitPersonAddViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];
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
	YSRecruitPersonAddViewModel *viewModel = (YSRecruitPersonAddViewModel *)self.viewModel;
	NSDictionary *cellDic = self.viewModel.dataSourceArray[indexPath.row];
	YSFlowFormListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	//cell点击展开收起逻辑
	if ([cellDic[@"special"] integerValue] == BussinessFlowCellExtend) {
		cell.extendButton.selected = !cell.extendButton.selected;
		YSWeak;
		[viewModel tableViewCellButtonClick:indexPath ExtendState:cell.extendButton.selected Complete:^{
				[weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewAutomaticDimension];
		}];
	}
	
	[self.viewModel turnOtherViewControllerWith:self andIndexPath:indexPath];
	
}
@end
