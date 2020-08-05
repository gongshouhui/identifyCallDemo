//
//  YSBussinessFlowValuationController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBussinessFlowValuationController.h"
#import "YSFlowValuationViewModel.h"
#import "YSFlowHandleViewController.h"
@interface YSBussinessFlowValuationController ()

@end

@implementation YSBussinessFlowValuationController

- (void)loadView {
    [super loadView];
    self.viewModel = [[YSFlowValuationViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //写在这里主要是因为cell没有和viewModel绑定，暂时在这里刷新，后来s有时间改为数据驱动
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowValuationViewModel *viewModel = (YSFlowValuationViewModel *)self.viewModel;
    [viewModel turnOtherViewControllerWith:self andIndexPath:indexPath];
    
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
				YSFlowValuationViewModel *viewModel = strongSelf.viewModel;
				[viewModel editValuationComeplete:^{
					flowHandleViewController.flowHandleType = FlowHandleTypeApproval;
					[strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
				} failue:^(NSString * _Nonnull message) {
					[QMUITips showError:message inView:strongSelf.view hideAfterDelay:1.5];
				}];
				
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
