
//
//  YSFlowListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/13.
//

#import "YSFlowListViewController.h"
#import "YSFlowListCell.h"
#import "YSFlowListModel.h"
#import "YSFlowDetailPageController.h"
#import "YSCommonFlowFormListViewController.h"
#import "YSFlowModel.h"
#import "YSFlowTouchButton.h"
#import "YSFlowCustomDetailController.h"
#import "YSFlowMapViewController.h"
#import "YSCommonBussinessFlowInfoController.h"

@interface YSFlowListViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) NSMutableDictionary *payload;
@property (nonatomic, strong) YSFlowTouchButton *touchButton;

@end

@implementation YSFlowListViewController
- (NSMutableDictionary *)payload {
	if (!_payload) {
		_payload = [NSMutableDictionary dictionary];
	}
	return _payload;
}
//设置安全区
- (UIEdgeInsets)tableViewInitialContentInset {
	return UIEdgeInsetsMake(0, 0, kTopHeight+kBottomHeight, 0);
}
- (instancetype)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAndFilter:) name:@"searchFlow" object:nil];//在视图未出现的时候注册通知,搜索和筛选的通知监听
	}
	return self;
}
- (void)viewDidLoad {
	[super viewDidLoad];
}
- (void)initTableView {
	[super initTableView];
	[self.tableView registerClass:[YSFlowListCell class] forCellReuseIdentifier:cellIdentifier];
	// 流程状态更新通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFlowStatus:) name:@"PostUpdateFlowStatus" object:nil];
	// 流程发起后刷新处理
	if (self.flowType == YSFlowTypeSent) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTodo) name:@"PostUpdateFlowTodo" object:nil];
	}
	[self doNetworking];
}
// 后期删除，只适用于旧流程中心
- (void)updateTodo {
	self.pageNumber = 1;
	[self doNetworking];
}
#pragma mark - 搜索监听通知
- (void)searchAndFilter:(NSNotification *)notification {
	[self.payload setObject:notification.userInfo[@"name"] forKey:@"formName"];
	self.pageNumber = 1;
	[self doNetworking];
}
# pragma mark -- 获得流程中心的列表
- (void)doNetworking {
	[super doNetworking];
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd/%zd", YSDomain, getFlowListApi, self.flowType+1, self.pageNumber];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:_payload successBlock:^(id response) {
		DLog(@"流程列表:%@", response);
		[QMUITips hideAllToastInView:self.view animated:YES];
		if ([response[@"code"] intValue] == 1) {
			self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
			[self.dataSourceArray addObjectsFromArray:[YSDataManager getFlowListData:response]];
			
			if (self.dataSourceArray.count != 0) {
				if (_flowType == YSFlowTypeTodo && self.pageNumber == 1) {//待办更新数字,第一页的时候更新
					//待办流程的总条数
					[[NSNotificationCenter defaultCenter] postNotificationName:@"PostFlowTodoCount" object:nil userInfo:@{@"total": [NSString stringWithFormat:@"%@", response[@"total"]]}];
				}
			}
			self.tableView.mj_footer.state = self.dataSourceArray.count < [response[@"total"] intValue] ?MJRefreshStateIdle :MJRefreshStateNoMoreData ;
			if (self.dataSourceArray.count == 0 && self.dataSource.count == 0) {
				[self.tableView reloadData];
				[self showEmptyViewWithImage:UIImageMake(@"empty_待办") text:@" " detailText:@" " buttonTitle:@" " buttonAction:@selector(doNetworking)];
				[QMUITips hideAllToastInView:self.view animated:YES];
			}else {
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

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFlowListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	cell = [[YSFlowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	YSFlowListModel *cellModel = self.dataSourceArray[indexPath.row];
	[cell setCellModel:cellModel withFlowType:_flowType];
	
	return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 73*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	YSFlowListModel *cellModel = self.dataSourceArray[indexPath.row];
	
	if (cellModel.processType == 1 || cellModel.processType == 5) { //自定义流程
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

/** 流程处理后更新状态 */
/**
 转阅：转阅动作执行完毕后，回到当前界面，当前数据状态不做任何更新（知会节点只拥有转阅功能，转阅后现在是不需要刷新待办）。
 审批：审批动作执行完毕后，返回待办列表页，待办中该数据消失，已审批的流程数据在“已办”中查看。
 驳回：驳回动作执行完毕后，返回待办列表页，待办中该数据消失，已驳回的流程数据在“已办”中查看。
 加签：加签动作执行完毕后，返回待办列表页，待办中该数据消失，该流程数据在“已办”中查看
 转办：转办动作执行完毕后，返回待办列表页，待办中该数据消失，该流程数据在“已办”中查看
 暂存：暂存动作执行完毕后，返回待办列表页，待办中仍有该流程数据，不在“已办”中显示
 撤回：仅针对已处理未办结的流程，可在已办中点击流程详情页中撤回，点击撤回后，流程回到撤回者的待办中，界面回到已办的流程列表页。
 转阅已读：当turnread = yes，是别人转阅过来的，，做“转阅已读”处理，程序员自己执行，不需用户点击，待办中该数据消失，已办不显示
 评审：评审动作执行完毕后，返回待办列表页，待办中该数据消失，该流程数据在“已办”中查看
 协同：xie'tong动作执行完毕后，返回待办列表页，待办中该数据消失，该流程数据在“已办”中查看
 知会：知会动作执行完毕后，返回待办列表页，待办中该数据消失，“已办”中显示
 另：知会节点，进入详情页程序员自动调用流程处理接口，做知会处理
 */
#pragma mark - 流程状态改变通知
- (void)updateFlowStatus:(NSNotification *)notification {
	NSDictionary *handleDic = notification.userInfo;
	YSFlowHandleType flowHandleType = [handleDic[@"flowHandleType"] integerValue];
	YSFlowListModel *cellModel = handleDic[@"model"];
	NSArray *handleTypeArray = @[@"转阅", @"审批", @"驳回", @"加签", @"转办", @"暂存", @"撤回",@"转阅已读",@"评审",@"协同"];
	switch (flowHandleType) {
		case FlowHandleTypeTrans://不需要刷新数据，不需要文字提示，YSCommonFlowFormListViewController已有提示
			
			break;
		case FlowHandleTypeSave://不需要刷新数据
			[QMUITips showSucceed:[NSString stringWithFormat:@"流程%@成功", handleTypeArray[flowHandleType]] inView:self.view hideAfterDelay:1];
			break;
		case FlowHandleTypeRevoke://撤回，待办增加这条数据，已发改为撤回状态，已办不做处理
			if (self.flowType == YSFlowTypeTodo) {
				//数据不作处理了,更新待办个数
				[self getTodoCount];
			}
			if (self.flowType == YSFlowTypeSent) {
				cellModel.flowStatus = FlowHandleTypeRevoke;//指针,可以直接改也会生效
				[self ys_reloadData];
			}
			break;
			
		default:// @"审批", @"驳回", @"加签", @"转办",@"转阅已读",@"评审",@"协同，知会,
			/*****目前处理方式：待办减少这条数据，已办看情况,已发无变化，然后已办不刷新用户可选择自己手动刷新******/
			if (flowHandleType == FlowHandleTypeTurnRead || [cellModel.taskType isEqualToString:FlowTaskZH]) {//不需要文字提示成功
			}else{
				[QMUITips showSucceed:[NSString stringWithFormat:@"流程%@成功", handleTypeArray[flowHandleType]] inView:self.view hideAfterDelay:1];
			}
			
			if (self.flowType == YSFlowTypeTodo) {
				[self.dataSourceArray removeObject:cellModel];
				[self getTodoCount];
				[self ys_reloadData];
			}
			break;
	}
}

# pragma mark -- 获取待办数
- (void)getTodoCount {
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd/%zd", YSDomain, getFlowListApi, self.flowType+1, self.pageNumber];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		DLog(@"流程列表:%@", response);
		if ([response[@"code"] intValue] == 1) {
			if ([response[@"data"] count]) {
				NSInteger total = [response[@"total"] integerValue];
				if (_flowType == YSFlowTypeTodo) {
					[[NSNotificationCenter defaultCenter] postNotificationName:@"PostFlowTodoCount" object:nil userInfo:@{@"total": [NSString stringWithFormat:@"%zd",total]}];
				}
			}else{
				[[NSNotificationCenter defaultCenter] postNotificationName:@"PostFlowTodoCount" object:nil userInfo:@{@"total": @"0"}];
			}
		}
	} failureBlock:^(NSError *error) {
		
	} progress:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
