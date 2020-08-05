//
//  YSContractStampedViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/2/21.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContractStampedViewController.h"
#import "YSAttachmentClassificationVC.h"
#import "YSNewsAttachmentModel.h"
#import "YSContractStampedViewModel.h"

@interface YSContractStampedViewController ()
@property (nonatomic, strong) NSMutableArray *basicInformationArr;
@property (nonatomic, strong) NSMutableArray *attachmentArray;


@end

@implementation YSContractStampedViewController
- (void)loadView {
	[super loadView];
	self.viewModel = [[YSContractStampedViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];// 早于视图下载完前创建viewModel
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
@end
