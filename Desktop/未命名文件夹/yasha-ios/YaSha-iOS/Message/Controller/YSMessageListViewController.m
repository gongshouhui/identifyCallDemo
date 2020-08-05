//
//  YSMessageListViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/6/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMessageListViewController.h"
#import "YSMessageListTableViewCell.h"
#import "YSMessageDetailsViewController.h"
#import "YSFlowDetailPageController.h"
#import "YSFlowListModel.h"
#import "YSFlowCustomDetailController.h"
#import "YSFlowMapViewController.h"
#import "YSCommonBussinessFlowInfoController.h"
@interface YSMessageListViewController ()

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;
@property (nonatomic, strong) NSMutableDictionary *payload;

@end

@implementation YSMessageListViewController

- (NSMutableDictionary *)payload {
	if (!_payload) {
		_payload = [NSMutableDictionary dictionary];
	}
	return _payload;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"消息通知";
}

- (void)initTableView {
	[super initTableView];
	[self addRightPopupMenuView];
	self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"点点点（黑）")  position:QMUINavigationButtonPositionRight target:self action:@selector(rightBarButtonAction:event:)];
	[self.tableView registerClass:[YSMessageListTableViewCell class] forCellReuseIdentifier:@"messageListCell"];
	
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self doNetworking];
}
- (void)doNetworking {
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, getNotificationList,self.pageNumber];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:self.payload successBlock:^(id response) {
		DLog(@"========%@",response);
		if ([response[@"code"] intValue] == 1) {
			self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
			[self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSFlowListModel class] json:response[@"data"]]];
			self.tableView.mj_footer.state = self.dataSourceArray.count < [response[@"total"] intValue] ?MJRefreshStateIdle :MJRefreshStateNoMoreData ;
			[self ys_reloadData];
			[self.tableView.mj_header endRefreshing];
		}
	} failureBlock:^(NSError *error) {
		[self ys_showNetworkError];
	} progress:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 68*kHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YSMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageListCell"];
	if (cell == nil) {
		cell = [[YSMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageListCell"];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	YSFlowListModel *model = self.dataSourceArray[indexPath.row];
	[cell setMessageCell:model];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	YSFlowListModel *model = self.dataSourceArray[indexPath.row];
	//系统详情
	if ([model.noticeType isEqualToString:@"3"]) {
		YSMessageDetailsViewController *messageDetailsViewController = [[YSMessageDetailsViewController alloc]init];
		messageDetailsViewController.cellModel = model;
		[self.navigationController pushViewController:messageDetailsViewController animated:YES];
	}else {
		//自定义流程
		if (model.processType == 1 || model.processType == 5) {
			NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, updateReadingStatus,model.id];
			[YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
				DLog(@"流程列表:%@", response);
				[QMUITips hideAllTipsInView:self.view];
				if ([response[@"data"] intValue] == 1) {
					model.status = @"1";
					[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
					if ([model.noticeType isEqualToString:@"2"] ||[model.noticeType isEqualToString:@"1"] ) {
						YSFlowCustomDetailController *flowDetailPageController = [[YSFlowCustomDetailController alloc] init];
						flowDetailPageController.flowType = YSFlowTypeTodo;
						flowDetailPageController.cellModel = model;
						[self.navigationController pushViewController:flowDetailPageController animated:YES];
					}
				}
			} failureBlock:^(NSError *error) {
				DLog(@"===========%@",error);
			} progress:nil];
		}else {
			YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:model.processDefinitionKey];
			//业务新流程界面
			if(flowModel.isNewInterface){
				Class someClass = NSClassFromString(flowModel.className);
				YSCommonBussinessFlowInfoController *commonFlowFormListViewController = [[someClass alloc] init];
				
				commonFlowFormListViewController.flowModel = model;
				YSFlowMapViewController *flowMapViewController = [[YSFlowMapViewController alloc] init];
				flowMapViewController.urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getApplyMapByIdForMobileApi, model.processInstanceId];
				if (flowModel.isMobile) {
					NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, updateReadingStatus,model.id];
					[YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
						[QMUITips hideAllToastInView:self.view animated:YES];
						if ([response[@"data"] intValue] == 1) {
							model.status = @"1";
							[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
							[self.navigationController pushViewController:commonFlowFormListViewController animated:YES];
						}
					} failureBlock:^(NSError *error) {
					} progress:nil];
				}else {
					[QMUITips showInfo:@"此流程仅支持电脑端处理" inView:self.view hideAfterDelay:1];
				}
			}else{
				if (flowModel.isMobile) {
					NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, updateReadingStatus,model.id];
					[YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
						[QMUITips hideAllToastInView:self.view animated:YES];
						if ([response[@"data"] intValue] == 1) {
							model.status = @"1";
							[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
							YSFlowDetailPageController *flowDetailPageController = [[YSFlowDetailPageController alloc] init];
							flowDetailPageController.flowType = YSFlowTypeTodo;
							YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:model.processDefinitionKey];
							//获得plist文件数据model
							flowDetailPageController.flowModel = flowModel;
							//获得流程列表数据model
							flowDetailPageController.cellModel = model;
							[flowDetailPageController reloadData];
							[self.navigationController pushViewController:flowDetailPageController animated:YES];
							
						}
					} failureBlock:^(NSError *error) {
					} progress:nil];
				}else {
					[QMUITips showInfo:@"此流程仅支持电脑端处理" inView:self.view hideAfterDelay:1];
				}
			}
		}
	}
}


- (void)addRightPopupMenuView {
	if (!self.rightPopupMenuView) {
		__weak __typeof(self)weakSelf = self;
		
		self.rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
		self.rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
		self.rightPopupMenuView.maximumWidth = 150*kWidthScale;
		self.rightPopupMenuView.shouldShowItemSeparator = YES;
		self.rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, self.rightPopupMenuView.padding.left, 0, self.rightPopupMenuView.padding.right);
		self.rightPopupMenuView.items = @[
										  [QMUIPopupMenuItem itemWithImage:nil title:@"所有消息类型" handler:^{
											  [weakSelf.payload setObject:@"" forKey:@"noticeType"];
											  [weakSelf doNetworking];
											  [weakSelf.rightPopupMenuView hideWithAnimated:YES];
										  }],
										  [QMUIPopupMenuItem itemWithImage:nil title:@"流程知会" handler:^{
											  [weakSelf.payload setObject:@"1" forKey:@"noticeType"];
											  [weakSelf doNetworking];
											  [weakSelf.rightPopupMenuView hideWithAnimated:YES];
										  }],
										  [QMUIPopupMenuItem itemWithImage:nil title:@"办结提醒" handler:^{
											  [weakSelf.payload setObject:@"2" forKey:@"noticeType"];
											  [weakSelf doNetworking];
											  [weakSelf.rightPopupMenuView hideWithAnimated:YES];
										  }],
										  [QMUIPopupMenuItem itemWithImage:nil title:@"系统待办" handler:^{
											  [weakSelf.payload setObject:@"4" forKey:@"noticeType"];
											  [weakSelf doNetworking];
											  [weakSelf.rightPopupMenuView hideWithAnimated:YES];
										  }],
										  [QMUIPopupMenuItem itemWithImage:nil title:@"系统消息" handler:^{
											  [weakSelf.payload setObject:@"3" forKey:@"noticeType"];
											  [weakSelf doNetworking];
											  [weakSelf.rightPopupMenuView hideWithAnimated:YES];
										  }],
										  [QMUIPopupMenuItem itemWithImage:nil title:@"撤回提醒" handler:^{
											  [weakSelf.payload setObject:@"5" forKey:@"noticeType"];
											  [weakSelf doNetworking];
											  [weakSelf.rightPopupMenuView hideWithAnimated:YES];
										  }],
										  [QMUIPopupMenuItem itemWithImage:nil title:@"驳回提醒" handler:^{
											  [weakSelf.payload setObject:@"6" forKey:@"noticeType"];
											  [weakSelf doNetworking];
											  [weakSelf.rightPopupMenuView hideWithAnimated:YES];
										  }]
										  ];
		
		self.rightPopupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
			
		};
	}
}

#pragma mark - rightBarButtonAction
- (void)rightBarButtonAction:(UIBarButtonItem *)sender event:(UIEvent *) event {
	NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
	UITouch *touch = [allTouches anyObject];   //视图中的所有对象
	CGPoint point = [touch locationInView:touch.window]; //返回触摸点在视图中的当前坐标
	CGRect rect = [touch.view convertRect:touch.view.frame toView:touch.window];
	[self.rightPopupMenuView layoutWithTargetRectInScreenCoordinate:rect];
	[self.rightPopupMenuView showWithAnimated:YES];
	
}

- (void)dealloc {
	DLog(@"释放");
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
