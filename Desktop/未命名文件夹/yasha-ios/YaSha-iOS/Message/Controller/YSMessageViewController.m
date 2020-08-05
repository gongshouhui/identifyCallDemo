//
//  YSMessageViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/13.
//
//

#import "YSMessageViewController.h"
#import "YSPersonalInformationModel.h"
#import "YSChooseMorePeopleViewController.h"
#import "YSDingDingHeader.h"
#import "YSInternalModel.h"
#import "YSSingleton.h"
#import "YSContactModel.h"
#import "YSContactDetailViewController.h"
#import "YSThemeProtocol.h"
#import "YSSystemMessageView.h"
#import "YSMessageListViewController.h"
#import "YSMessageInfoCell.h"
#import "YSMessageInfoModel.h"
#import "YSWYQYManager.h"
//#import "QYSDK.h"
#import <IQKeyboardManager.h>
#import "YSMessageClockListGWViewController.h"//打卡列表


@interface YSMessageViewController ()
@property (nonatomic, strong) YSSystemMessageView *systemMessageView;
@property (nonatomic,strong) YSMessageInfoDetailModel *messageModel;
@property (nonatomic, strong) YSMessageInfoDetailModel *clockModel;
@property (nonatomic, assign) NSInteger clockNum;


@end

@implementation YSMessageViewController
#pragma mark - <QMUINavigationControllerDelegate>
- (BOOL)shouldSetStatusBarStyleLight {
    return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
- (instancetype)init {
    if (self = [super init]) {//重写init方法在tabbar创建的时候就请求数据x刷新角标
        [self getNoitDoNetworking];
    }
    return self;
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    //七鱼消息监听代理
    //[[[QYSDK sharedSDK] conversationManager] setDelegate:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 如果在会话中收到消息返回会话列表需要重新更新
    [self getNoitDoNetworking];
}

#pragma mark - tabviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSMessageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSMessageInfoCell"];
    if (cell == nil) {
        cell = [[YSMessageInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSMessageInfoCell"];
    }
    if (indexPath.row == 0) {//消息通知
        [cell setMessageInfoCell:self.messageModel];
    }
    
    //打卡通知
    if (indexPath.row == 1) {
        [cell setClockListCell:self.clockModel];
    }
	//七鱼客服暂时停用
//    if (indexPath.row == 1) {
//        QYSessionInfo *sessionInfo = [[[QYSDK sharedSDK] conversationManager] getSessionList].firstObject;
//        YSMessageInfoModel *infoModel = [[YSMessageInfoModel alloc]init];
//        YSMessageInfoDetailModel *detailModel = [[YSMessageInfoDetailModel alloc]init];
//        infoModel.data = detailModel;
//        infoModel.total = sessionInfo.unreadCount;
//        infoModel.data.title = sessionInfo.lastMessageText;
//        infoModel.data.createTime = [NSString stringWithFormat:@"%f",sessionInfo.lastMessageTimeStamp*1000];
//        [cell setQYMessageWith:infoModel];
//    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YSMessageListViewController *messageList = [[YSMessageListViewController alloc]init];
        [self.navigationController pushViewController:messageList animated:YES];
    }
    
    if (indexPath.row == 1) {//打卡
        YSMessageClockListGWViewController *clockVC = [YSMessageClockListGWViewController new];
        
        [self.navigationController pushViewController:clockVC animated:YES];
    }
//    if (indexPath.row == 1) {//七鱼
//        [self addQIYUViewController];
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68*kHeightScale;
}
- (void)getNoitDoNetworking {
    [QMUITips showLoadingInView:self.view];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getClockNoReadNumber];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"流程列表:%@", response);
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            self.messageModel = [YSMessageInfoDetailModel yy_modelWithJSON:[[response objectForKey:@"data"] objectForKey:@"system"]];
            self.clockModel = [YSMessageInfoDetailModel yy_modelWithJSON:[[response objectForKey:@"data"] objectForKey:@"clock"]];

            self.clockNum = [[[[response objectForKey:@"data"] objectForKey:@"clock"] objectForKey:@"noReadNumber"] integerValue];
            [self setBadgeValue:[[[[response objectForKey:@"data"] objectForKey:@"system"] objectForKey:@"noReadNumber"] integerValue]];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];
    } progress:nil];
    
    
}
// 更新未读角标逻辑：
// 1.点击事件后更新；
// 2.接收到新消息后更新；
// 3.左滑删除后更新。

- (void)setBadgeValue:(NSInteger )totalUnreadCount {
    NSString *value = totalUnreadCount > 999 ? @"999+" :[NSString stringWithFormat:@"%ld",totalUnreadCount];
        [self.rt_navigationController.tabBarItem setBadgeValue:totalUnreadCount <= 0 ? nil : value];
        if (totalUnreadCount >0) {
            NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getCornerMarkApi];
            [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
                if ([response[@"code"] integerValue] == 1) {
                    NSInteger totalNum = [[[response objectForKey:@"data"] objectForKey:@"total"] integerValue];
                    NSInteger applicationBadgeValue = totalNum-self.clockNum;
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:applicationBadgeValue];
                }
                
            } failureBlock:^(NSError *error) {
                DLog(@"error:%@", error);
            } progress:nil];
//             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalUnreadCount];
        }
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalUnreadCount <= 0 ? 0 : totalUnreadCount]
}
#pragma mark - 网易七鱼机器人
//- (void)addQIYUViewController {
//    QYCustomUIConfig *config = [[QYSDK sharedSDK] customUIConfig];
//    config.rightBarButtonItemColorBlackOrWhite = !StatusbarStyleLightInitially;
//    QYSource *source = [[QYSource alloc] init];
//    source.title = @"亚厦小管家";
//    //source.urlString = @"https://8.163.com/";
//   QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
//    sessionViewController.sessionTitle = @"亚厦小管家";
//    sessionViewController.source = source;
//    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[QYSessionViewController class]];
//    [YSWYQYManager setUpCurrentUserInfo];
//    UIImage *image = StatusbarStyleLightInitially ? UIImageMake(@"返回白") : UIImageMake(@"返回");
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 30, 30);
//    [backBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setImage:image forState:UIControlStateNormal];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    sessionViewController.navigationItem.leftBarButtonItem = leftItem;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
//    nav.navigationBar.barStyle = StatusbarStyleLightInitially ? UIBarStyleBlack : UIBarStyleDefault;
//    [self presentViewController:nav animated:YES completion:nil];
//    //    YSWYQYManager *qyManager = [[YSWYQYManager alloc]initWithCurrentViewController:self];
//    //    [qyManager presentQYControllerWithCurrentController];
//}
//#pragma mark - 七鱼客服消息回调
///**
// *  接收消息
// */
//- (void)onReceiveMessage:(QYMessageInfo *)message;
//{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}
///**
// *  会话未读数变化
// *
// *  @param count 未读数
// */
//- (void)onUnreadCountChanged:(NSInteger)count {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//   
//         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//   
//}
//- (void)onBack:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end
