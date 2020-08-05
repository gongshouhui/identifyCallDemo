//
//  YSApplicationFunctionViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/17.
//

#import "YSApplicationFunctionViewController.h"

#import "YSFlowPageController.h"    // 新流程中心
#import "YSCalendarViewController.h"    // 日程
#import "YSNewsPageController.h"    // 新闻公告
#import "YSAssetsFunctionViewController.h"    // 固定资产
#import "YSRepairViewController.h"    // 自助报障
#import "YSPMSZSFunctionViewController.h"    // 装饰项目管理
#import "YSPMSMQFunctionViewController.h"
#import "YSSupplyFunctionViewController.h"  //供应链

#import "YSEMSFunctionViewController.h"    // EMS
#import "YSAssessmentViewController.h"    //CRM
#import "YSRechargeViewController.h"  //一卡通
#import "YSMessageListViewController.h"   //消息列表

//测试供应商界面
#import "YSFlowSuuplyViewController.h"
#import "AppDelegate+YSSetupAPP.h"
#import "YSACLModel.h"
#import "YSContactModel.h"
#import "YSDepartmentModel.h"
#import "AppDelegate.h"
#import "UIImage+YSImage.h"
#import <JPEngine.h>
#import "YSWYQYManager.h"
//#import "QYSDK.h"
#import "YSHRServiceViewController.h"
#import "YSSelfHelpViewController.h"
#import "YSReportAndOpinionController.h"
#import "YSReactNativeBaseViewController.h"
#import "YSAssetsScanView.h"
#import "YSScanSignController.h"
#import "YSScanViewController.h"

@interface YSApplicationFunctionViewController ()
@property (nonatomic,strong)RLMNotificationToken *token;
/**新模块授权信息*/
@property (nonatomic,strong) NSMutableDictionary *authDic;
/**代办未读个数*/
@property (nonatomic,assign) NSInteger todoNumber;//临时存储角标个数
/**新闻未读个数*/
@property (nonatomic,assign) NSInteger newsNumber;//临时存储新闻角标个数

@end

@implementation YSApplicationFunctionViewController

- (NSMutableDictionary *)authDic {
    if (!_authDic) {
        _authDic = [NSMutableDictionary dictionary];
    }
    return _authDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作台";
	//添加扫描按钮
	self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"scan")  position:QMUINavigationButtonPositionRight target:self action:@selector(scan)];
    RLMResults *results = [YSACLModel allObjects];
    //数据库开始写入时回调一次，写入完成时回调一次,改动时也会调用一次
    self.token = [results addNotificationBlock:^(RLMResults<YSACLModel *> *results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (change && [results count]) {
            [self.dataSourceArray removeAllObjects];
            [self getDatasourceArray];
        }
        
    }];
    [self commonDeal];
    [self getDatasourceArray];
    [self propertyAndEMSAuthority];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpViewController:) name:@"jumpViewController" object:nil];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getContactFailure) name:@"updateAllContactFailure" object:nil];//监听工作台请求通讯录接口失败的情况，留给用户点击重新拉取的机会
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self doNetworking];//角标
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)getContactFailure {
    AppDelegate *delegae = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegae.getContactFailure = YES;
}
- (void)jumpViewController:(NSNotification *)notification {
   
    YSMessageListViewController *VC = [YSMessageListViewController new];
    [self.rt_navigationController pushViewController:VC animated:YES];
    
    
}

- (void)getDatasourceArray {
    
    //营销报备权限
    
    BOOL crmResult = [YSUtility checkAuthoritySystemSn:@"crm" andModuleSn:@[@"pro_track_info",@"pro_report_info"] andCompanyId:nil andPermissionValue:PermissionQueryValue];
    
    // 装饰信息权限
    BOOL zsResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSInfoManagementModel andCompanyId:ZScompanyId andPermissionValue:PermissionQueryValue];
    // 幕墙信息权限
	//ystemSn = 'mqpms' AND moduleSn = 'new_base_info' AND companyId = '0001K310000000000F91' AND permissionValue = 1 
    BOOL mqResults = [YSUtility checkDatabaseSystemSn:MQInfomanagement andModuleSn:MQModuleIdentification andCompanyId:MQcompanyId andPermissionValue:PermissionQueryValue];
    // 装饰进度权限
    BOOL zsPlanaResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSPlanManagementModel andCompanyId:ZScompanyId andPermissionValue:PermissionQueryValue];
    //供应商库权限
    BOOL libraryPermissions = [YSUtility checkDatabaseSystemSn:SupplySystem andModuleSn:SupplyModel andCompanyId:nil andPermissionValue:PermissionQueryValue];
    //材料管理权限
    BOOL materialPermissions = [YSUtility checkDatabaseSystemSn:SupplySystem andModuleSn:MaterialModel andCompanyId:nil andPermissionValue:PermissionQueryValue];
    //招标管理权限
    
    BOOL tenderPermissions = [YSUtility checkDatabaseSystemSn:SupplySystem andModuleSn:TenderModel andCompanyId:nil andPermissionValue:PermissionQueryValue];

    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemNeedToDo),

                                                                           @"name": @"待办",
                                                                           @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemNeedToDo],
                                                                           @"modelName": @"flowCenter",
                                                                           @"className": @"YSFlowPageController",
                                                                           @"unreadCount":@(self.todoNumber)}]];
    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemCalendar),
                                                                           @"name": @"日程",
                                                                           @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemCalendar],
                                                                           @"modelName": @"",
                                                                           @"className":@"YSCalendarViewController"}]];
    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemNewsBulletin),
                                                                           @"name": @"新闻公告",
                                                                           @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemNewsBulletin],
                                                                           @"modelName": @"newsBulletin",
                                                                           @"className": @"YSNewsPageController",
                                                                           @"unreadCount":@(self.newsNumber)}]];
    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemRecharge),
                                                                           @"name": @"一卡通充值",
                                                                           @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemRecharge],
                                                                           @"modelName": @"",
                                                                           @"className": @"YSRechargeViewController"}]];
    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType":@(WorkbenchItemHR),
                                                                           @"name": @"HR服务",
                                                                           @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemHR],
                                                                           @"modelName": @"",
                                                                           @"className": @"YSHRServiceViewController"}]];
//
//	[self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType":@(WorkbenchItemQY),
//																		   @"name": @"亚厦小管家",
//																		   @"imageName":@"hr_AI_Gicon",
//																		   @"modelName": @"",
//																		   @"className": @""}]];
	
	
   

    BOOL EAMResult = self.authDic[EAMAuthority];
    DLog(@"%@",EAMAuthority);
    if (EAMResult) {
        [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemAssets),
                                                                               @"name": @"固定资产",
                                                                               @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemAssets],
                                                                               @"modelName": @"",
                                                                               @"className": @"YSAssetsFunctionViewController"}]];
    }
    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemRepair),
                                                                           @"name": @"自助报障",
                                                                           @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemRepair],
                                                                           @"modelName": @"",
                                                                           @"className": @"YSRepairViewController"}]];
    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemVedioMetting),
                                                                           @"name":@"视频会议",
                                                                           @"imageName":[YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemVedioMetting],                                                    @"className": @""
                                                                           }]];
    
    if (crmResult) {
        [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"id": @(WorkbenchItemCRM),
                                                                               @"name":@"CRM",
                                                                               @"imageName":[YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemCRM],                                                    @"className": @"YSAssessmentViewController"
                                                                               }]];
    }
  
    if (zsResults || zsPlanaResults) {
        [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemPMSZS),
                                                                               @"name": @"项目管理",
                                                                               @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemPMSZS],
                                                                               @"modelName": @"",
                                                                               @"className":@"YSPMSZSFunctionViewController"}]];
    }
    if (mqResults) {
        [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemPMSMQ),
                                                                               @"name": @"项目管理",
                                                                               @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemPMSMQ],
                                                                               @"modelName": @"",
                                                                               @"className": @"YSPMSMQFunctionViewController"}]];
    }
    
    if (libraryPermissions || materialPermissions || tenderPermissions){
        [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemSupply),
                                                                               @"name": @"供应链",
                                                                               @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemSupply],
                                                                               @"modelName": @"",
                                                                               @"className": @"YSSupplyFunctionViewController"}]];
    }
    
    BOOL EMSResult = EMSResult = self.authDic[EMSAuthority];
    if (EMSResult) {
        [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemEMS),
                                                                               @"name": @"EMS",
                                                                               @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemEMS],
                                                                               @"modelName": @"",
                                                                               @"className": @"YSEMSFunctionViewController"}]];
    }
	[self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemEMS),
																		   @"name": @"投诉举报",
																		   @"imageName":@"ico-投诉举报",
																		   @"modelName": @"",
																		   @"className": @"YSReportAndOpinionController"}]];
    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemEMS),
                                                                           @"name": @"行政服务",
                                                                           @"imageName":@"icoAdministrativeShow",
                                                                           @"modelName": @"",
                                                                           @"className": @""}]];
    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"workBenchType": @(WorkbenchItemEMS),
    @"name": @"复工证明申请",
    @"imageName":@"icoWorkProve",
    @"modelName": @"",
    @"className": @"YSWorkProveRemoveViewController"}]];
    [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"id": @(WorkbenchItemAdd),
                                                                        @"name": @"",
                                                                           @"imageName": [YSThemeManagerShare.currentTheme themeWorkItemImageWithItemType:WorkbenchItemAdd],
                                                @"modelName": @"",
                                                @"className": @""}]];
    [self.collectionView reloadData];
    
}
#pragma mark - UICollectionView 代理方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YSApplicationBannerView *applicationBannerView = (YSApplicationBannerView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        applicationBannerView.imageView.image = YSThemeManager.sharedInstance.currentTheme.workBenchBannerImage;
        supplementaryView = applicationBannerView;
    }
    return supplementaryView;
}
//查询模块权限
- (void)propertyAndEMSAuthority {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getPropertyAndEMSAuthority] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"=======%@",response);
        if ([response[@"code"] integerValue] == 1) {
            _authDic = nil;
            for (NSDictionary *authItem in response[@"data"]) {
                [self.authDic setValue:@1 forKey:authItem[@"name"]];
            }
            [self.dataSourceArray removeAllObjects];
            [self getDatasourceArray];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
}
#pragma mark - 更新各种角标
- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getCornerMarkApi];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            if ([response[@"code"] integerValue] == 1) {
                //角标存储一下，防止角标请求回调先完成，而权限回调未完成导致数据重置角标消失
                for (NSDictionary *infoDic in response[@"data"][@"info"]) {
                    if ([infoDic[@"modelName"] isEqualToString:@"flowCenter"]) {
                        self.todoNumber = [infoDic[@"unreadCount"] integerValue];
                    }
                    if ([infoDic[@"modelName"] isEqualToString:@"newsBulletin"]) {
                        self.newsNumber = [infoDic[@"unreadCount"] integerValue];
                    }
                }
                
                [YSDataManager getApplicationsWithBadgeWithDatasource:self.dataSourceArray andResponse:response];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *badgeValue = [NSString stringWithFormat:@"%@", response[@"data"][@"total"]];
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[badgeValue integerValue]];
                    DLog(@"currentThread---%@",[NSThread currentThread]);
                    [self.collectionView reloadData];
                });
            }
        });
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
        [self.collectionView reloadData];
    } progress:nil];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    if (model.workBenchType == WorkbenchItemVedioMetting) {
        [self downloadApp];
	}else if(model.workBenchType == WorkbenchItemQY){
		//[self addQIYUViewController];
    }else if([model.name isEqualToString:@"行政服务"]){
        /*NSURL *jsCodeLocation;
        
        //jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
        jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
        //jsCodeLocation = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"index.ios.jsbundle" ofType:nil]];
        RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation moduleName:@"YaShaRN" initialProperties:nil launchOptions:nil];
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view = rootView;
        [self.navigationController pushViewController:vc animated:YES];*/
        YSReactNativeBaseViewController *vc = [[YSReactNativeBaseViewController alloc] initWithPageName:@"YaShaRN" initialProperty:@{}];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        Class someClass = NSClassFromString(model.className);
        if (someClass) {
            UIViewController *viewController = [[someClass alloc] init];
            if ([viewController isKindOfClass:[YSNewsPageController class]]) {
                YSNewsPageController *vc = viewController;//新闻角标刷新
                vc.refreshBlock = ^{
                    //[self doNetworking];
                };
            }
            if ([viewController isKindOfClass:[YSFlowPageController class]]) {
                YSFlowPageController *vc = viewController;//新闻角标刷新
                vc.refreshBlock = ^{
                    //[self doNetworking];
                };
            }
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            [QMUITips showInfo:@"敬请期待！" inView:self.view hideAfterDelay:1];
        }
    }
}


#pragma mark - app更新信息  获取通讯录
- (void)commonDeal {
    AppDelegate *delegae = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegae.getContactFailure = NO;
    //通讯录时间错
    NSString *timeStamp = [YSUtility getContactsTimestamp];
    NSString *orgConditions = [NSString stringWithFormat:@"pNum = '1' AND delFlag = '1' AND status = '1' AND isPublic != '0'"];
    RLMResults *orgResults = [[YSDepartmentModel objectsWhere:orgConditions] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];
    if (timeStamp && orgResults.count != 0) {
        [delegae saveContactWithAll:NO];
    }else{
        [delegae saveContactWithAll:YES];
    }
    [self getPatchData];
    //检查更新
    [delegae updateAPPWithAlert:YES];
	
}
- (void)downloadApp {
	
    NSURL *urlII = [NSURL URLWithString:@"welinksoftclient://"];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"welinksoftclient://"]];
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:urlII];
    if (hadInstalledWeixin)
    {
        
		
        //打开APP
        [[UIApplication sharedApplication] openURL:urlII];
        
    }else{
        
       
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/huawei-cloudlink/id1354340495?mt=8"]];
    }
}
#pragma mark - 主题改变通知

- (void)themeBeforeChanged:(NSObject<YSThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<YSThemeProtocol> *)themeAfterChanged {
    [self.dataSourceArray removeAllObjects];
    [self getDatasourceArray];//刷新图标
    self.titleView.titleLabel.textColor = themeAfterChanged.themeNavTitleColor;
    //修改导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:themeAfterChanged.themeNavColor] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - <QMUINavigationControllerDelegate>

- (BOOL)shouldSetStatusBarStyleLight {
    return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
#pragma mark - 下载热更新
- (void)getPatchData {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/1", YSDomain, patchApi,appVersion];
    NSUserDefaults *userDefault = YSUserDefaults;
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"成功%@",response);
		NSDictionary *lastResponse = response;
        if(response[@"data"] != nil && ![response[@"data"] isEqual:[NSNull null]]){
            NSString *savedPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/patch%@.txt",response[@"data"][@"code"]]];
            if(![[userDefault objectForKey:@"version"] isEqualToString:[ NSString stringWithFormat:@"%@",response[@"data"][@"updateTime"]]]){
                [YSNetManager ys_downLoadFileWithUrlString:[NSString stringWithFormat:@"%@", response[@"data"][@"path"]] parameters:nil savaPath:savedPath successBlock:^(id response) {
					[userDefault setObject:[NSString stringWithFormat:@"%@",lastResponse[@"data"][@"updateTime"]] forKey:@"version"];
					[userDefault setObject:[NSString stringWithFormat:@"/Documents/patch%@.txt",lastResponse[@"data"][@"code"]] forKey:@"saveAddress"];
					[userDefault setObject:appVersion forKey:@"JSPatchSaveAppversion"];
					
					[userDefault synchronize];
                    DLog(@"下载1111成功%@",response);
                } failureBlock:^(NSError *error) {
                    DLog(@"下载失败");
                } downLoadProgress:nil];
            }
        }
    } failureBlock:^(NSError *error) {
        DLog(@"失败");
    } progress:nil];
}


//#pragma mark - 网易七鱼机器人
//- (void)addQIYUViewController {
//	QYCustomUIConfig *config = [[QYSDK sharedSDK] customUIConfig];
//	config.rightBarButtonItemColorBlackOrWhite = !StatusbarStyleLightInitially;
//	QYSource *source = [[QYSource alloc] init];
//	source.title = @"亚厦小管家";
//	//source.urlString = @"https://8.163.com/";
//	QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
//	sessionViewController.sessionTitle = @"亚厦小管家";
//	sessionViewController.source = source;
//	//[[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[QYSessionViewController class]];
//	[YSWYQYManager setUpCurrentUserInfo];
//	UIImage *image = StatusbarStyleLightInitially ? UIImageMake(@"返回白") : UIImageMake(@"返回");
//	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//	backBtn.frame = CGRectMake(0, 0, 30, 30);
//	[backBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
//	[backBtn setImage:image forState:UIControlStateNormal];
//	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//	sessionViewController.navigationItem.leftBarButtonItem = leftItem;
//	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
//	nav.navigationBar.barStyle = StatusbarStyleLightInitially ? UIBarStyleBlack : UIBarStyleDefault;
//	[self presentViewController:nav animated:YES completion:nil];
//	//    YSWYQYManager *qyManager = [[YSWYQYManager alloc]initWithCurrentViewController:self];
//	//    [qyManager presentQYControllerWithCurrentController];
//	
//}
//- (void)onBack:(id)sender {
//	[self dismissViewControllerAnimated:YES completion:nil];
//}
#pragma mark - 扫描方法
- (void)scan {
	
	YSScanViewController *scanVC = [[YSScanViewController alloc]init];
	[self.navigationController pushViewController:scanVC animated:NO];
}
@end
