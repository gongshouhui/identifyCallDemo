//
//  YSFlowAssociatedViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/9/17.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowAssociatedViewController.h"
#import "YSFlowCustomDetailController.h"
#import "YSFlowDetailPageController.h"
#import "YSFlowListCell.h"
#import "YSFlowMapViewController.h"
#import "YSCommonBussinessFlowInfoController.h"

@interface YSFlowAssociatedViewController ()

@end


NSString *const cellIdent = @"FlowListCell";
@implementation YSFlowAssociatedViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"关联流程";
	_flowType = YSFlowTypeFinished;
}

- (void)initTableView {
	[super initTableView];
	[self.tableView registerClass:[YSFlowListCell class] forCellReuseIdentifier:cellIdent];
	if (self.dataSourceArray.count > 0) {
		[self.tableView reloadData];
	}else {
		[self doNetworking];
	}
}

- (void)doNetworking{
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getRelateFlowVo,self.businessKey];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"流程列表:%@", response);
		
		[QMUITips hideAllToastInView:self.view animated:YES];
		if ([response[@"code"] intValue] == 1) {
			self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
			[self.dataSourceArray addObjectsFromArray:[YSDataManager getFlowListData:response]];
			self.tableView.mj_footer.state = self.dataSourceArray.count < [response[@"total"] intValue] ?MJRefreshStateIdle :MJRefreshStateNoMoreData ;
			if (self.dataSourceArray.count == 0 && self.dataSource.count == 0) {
				[self.tableView reloadData];
				[self showEmptyViewWithImage:UIImageMake(@"empty_待办") text:@" " detailText:@" " buttonTitle:@" " buttonAction:@selector(doNetworking)];
				[QMUITips hideAllToastInView:self.view animated:YES];
			} else {
				[self hideEmptyView];
				[self.tableView reloadData];
			}
			[self.tableView.mj_header endRefreshing];
		}
	} failureBlock:^(NSError *error) {
		[QMUITips hideAllToastInView:self.view animated:YES];
		[self.tableView.mj_header endRefreshing];
		self.tableView.mj_footer.state = MJRefreshStateNoMoreData ;
	} progress:nil];
	
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFlowListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	cell = [[YSFlowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
	YSFlowListModel *cellModel = self.dataSourceArray[indexPath.row];
	[cell setAssociatedFlowCell: cellModel];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFlowListModel *cellModel = self.dataSourceArray[indexPath.row];
	//自定义流程
	if (cellModel.processType == 1 || cellModel.processType == 5) {
		YSFlowCustomDetailController *flowDetailPageController = [[YSFlowCustomDetailController alloc] init];
		flowDetailPageController.flowType = _flowType;
		//获得流程列表数据model
		flowDetailPageController.cellModel = cellModel;
		[self.navigationController pushViewController:flowDetailPageController animated:YES];
	} else {
		YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:cellModel.processDefinitionKey];
		if (flowModel.isNewInterface) { //新的业务流程
			Class someClass = NSClassFromString(flowModel.className);
			YSCommonBussinessFlowInfoController *commonFlowFormListViewController = [[someClass alloc] init];
			YSCommonBussinessFlowInfoController *vc = (YSCommonBussinessFlowInfoController *)commonFlowFormListViewController;
			vc.flowModel = cellModel;
			vc.flowType = _flowType;
			YSFlowMapViewController *flowMapViewController = [[YSFlowMapViewController alloc] init];
			flowMapViewController.urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getApplyMapByIdForMobileApi, cellModel.processInstanceId];
			if (flowModel.isMobile) {
				[self.navigationController pushViewController:commonFlowFormListViewController animated:YES];
			} else {
				[QMUITips showInfo:@"此流程仅支持电脑端处理" inView:self.view hideAfterDelay:1];
			}
		}else {//老的业务流程
			YSFlowDetailPageController *flowDetailPageController = [[YSFlowDetailPageController alloc] init];
			flowDetailPageController.flowType = _flowType;
			//获得plist文件数据model
			flowDetailPageController.flowModel = flowModel;
			//获得流程列表数据model
			flowDetailPageController.cellModel = cellModel;
			//判断是否可以在手机端处理
			if (flowModel.isMobile) {
				[flowDetailPageController reloadData];
				[self.navigationController pushViewController:flowDetailPageController animated:YES];
			}else {
				[QMUITips showInfo:@"此流程仅支持电脑端处理" inView:self.view hideAfterDelay:1];
			}
		}
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 73*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
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
