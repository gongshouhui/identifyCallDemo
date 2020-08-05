//
//  YSFlowEmployeeLeaveController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/7.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowEmployeeLeaveController.h"
#import "YSFlowEmployeeLeaveViewModel.h"
#import "YSFlowHandleViewController.h"
@interface YSFlowEmployeeLeaveController ()

@end

@implementation YSFlowEmployeeLeaveController

- (void)loadView {
    [super loadView];
    self.viewModel = [[YSFlowEmployeeLeaveViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];// 早于视图下载完前创建viewModel
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

/** 处理/转阅 */
- (void)monitorAction {
	YSWeak;
	[self.flowFormBottomView.sendActionSubject subscribeNext:^(UIButton *button) {
		YSStrong;
		YSFlowHandleViewController *flowHandleViewController = [[YSFlowHandleViewController alloc] init];
		flowHandleViewController.cellModel = strongSelf.flowModel;
		if (button.tag == 0) {
			QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
				
			}];
			QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"审批" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
				YSFlowEmployeeLeaveViewModel *viewmModel = (YSFlowEmployeeLeaveViewModel *)strongSelf.viewModel;
				if (viewmModel.isEditing) {
					QMUIAlertAction *alertAction1 = [QMUIAlertAction actionWithTitle:@"是" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
						[viewmModel editWithConsensus:@"1" Comeplete:^{
							flowHandleViewController.flowHandleType = FlowHandleTypeApproval;
							flowHandleViewController.additionMessage = @"协商一致";
							[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
						} failue:^(NSString * _Nonnull message) {
							
						}];
					}];
					QMUIAlertAction *alertAction2 = [QMUIAlertAction actionWithTitle:@"否" style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
						[viewmModel editWithConsensus:@"0" Comeplete:^{
							flowHandleViewController.flowHandleType = FlowHandleTypeApproval;
							[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
							
						} failue:^(NSString * _Nonnull message) {
							
						}];
					}];
					QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"是否协商一致" preferredStyle:QMUIAlertControllerStyleAlert];
					
					[alertController addAction:alertAction1];
					[alertController addAction:alertAction2];
					[alertController showWithAnimated:YES];
					
					
					
				}else{
					flowHandleViewController.flowHandleType = FlowHandleTypeApproval;
					[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
				}
				
			}];
			QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"驳回" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
				flowHandleViewController.flowHandleType = FlowHandleTypeReject;
				[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
			}];
			QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"审批并加签" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
				flowHandleViewController.flowHandleType = FlowHandleTypeAdd;
				[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
			}];
			QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"转办" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
				flowHandleViewController.flowHandleType = FlowHandleTypeChange;
				[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
			}];
			QMUIAlertAction *action5 = [QMUIAlertAction actionWithTitle:@"暂存" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
				flowHandleViewController.flowHandleType = FlowHandleTypeSave;
				[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
			}];
			QMUIAlertAction *action6 = [QMUIAlertAction actionWithTitle:@"评审" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
				flowHandleViewController.flowHandleType = FlowHandleTypeReview;
				[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
			}];
			
			QMUIAlertAction *action7 = [QMUIAlertAction actionWithTitle:@"协同" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
				flowHandleViewController.flowHandleType = YSFlowHandleTypeSynergy;
				[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
			}];
			
			QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
			
			[alertController addAction:action0];
			
			if( [strongSelf.flowModel.taskType isEqualToString:FlowTaskPS]){
				[alertController addAction:action6];
			}else if([strongSelf.flowModel.taskType isEqualToString:FlowTaskXT]){
				[alertController addAction:action7];
			}else{
				[alertController addAction:action1];
				[alertController addAction:action2];
				[alertController addAction:action3];
			}
			
			[alertController addAction:action4];
			[alertController addAction:action5];
			[alertController showWithAnimated:YES];
		} else if (button.tag == 2) {
			flowHandleViewController.flowHandleType = FlowHandleTypeRevoke;
			[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
		} else {
			flowHandleViewController.flowHandleType = FlowHandleTypeTrans;
			[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
			
		}
	}];
}
@end
