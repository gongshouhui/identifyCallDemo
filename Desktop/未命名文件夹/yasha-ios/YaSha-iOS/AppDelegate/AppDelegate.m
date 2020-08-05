//
//  AppDelegate.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 16/11/17.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+YSSetupAPP.h"
#import <WXApi.h>
#import <Bugly/Bugly.h>
#import <IQKeyboardManager.h>
#import "YSLoginController.h"
#import <JSPatchPlatform/JSPatch.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <JSPatchPlatform/JSPatch.h>

#import <AlipaySDK/AlipaySDK.h>
#import <KSGuaidViewManager.h>
#import <JPFPSStatus.h>
#import "YSUIConfigurationTemplate.h"
#import "YSUIConfigurationTemplateNewYear.h"

#import "DeviceAuth.h"
#import "YSMessageViewController.h"
#import "YSContactSelectPersonViewController.h"
#import <JPEngine.h>
//#import "QYSDK.h"

@interface AppDelegate () <WXApiDelegate, JPUSHRegisterDelegate,UITabBarControllerDelegate, CYLTabBarControllerDelegate>
/**程序从启动进入而不是从后台进入*/
@property (nonatomic,assign) BOOL isLanch;
@end

@implementation AppDelegate

#pragma mark - 打包注意事项
/**
 * 1.正式环境log关闭；
 * 2.Boundle Identifier、Version、Build等配置检查是否正确；
 * 3.Scheme 打包环境检查；
 * 4.权限系统检查；
 * 5.上线模块检查、不上线的模块记得关闭；
 * 6.数据库若迁移，宿主程序都要迁移。
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // iOS 7之后不允许在设置 rootViewController 之前做过于复杂的操作，那就先加一个
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:viewController];
    [self.window makeKeyAndVisible];
    //读取热更新文件
    NSUserDefaults *userDefault = YSUserDefaults;
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    if([userDefault objectForKey:@"saveAddress"] && [[userDefault objectForKey:@"JSPatchSaveAppversion"] isEqualToString:appVersion]){//当版本不一样的时候需要删除热更新包
//        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"];
        NSString *sourcePath = [NSHomeDirectory() stringByAppendingString:[userDefault objectForKey:@"saveAddress"]];
        // 从路径中读取字符串
        NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
        if (script) {
            [JPEngine startEngine];
            [JPEngine evaluateScript:script];
        }
        //                    [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
        //                        if (type == JPCallbackTypeJSException) {
        //                            NSAssert(NO, data[@"msg"]);
        //                        }
        //                    }];
    }
    // 配置 IQKeyboardManager
    //点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //隐藏键盘上方的tooBar
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    
    //配置realm
    [self setupRealm];
    
    // 应用 QMUI 皮肤,根据沙盒存储的配置模板，沙盒中没有则取默认配置模板值
    NSString *themeClassName;
    if ([YSUserDefaults valueForKey:YSSkinSign]) {//后台下载皮肤
        themeClassName = @"YSUIConfigurationDownLoadTemplate";
    }else {
        //支持本地更换皮肤
        themeClassName = [YSUserDefaults stringForKey:YSSelectedThemeClassName] ? : NSStringFromClass([YSUIConfigurationTemplate class]);
    }
    [YSThemeManager sharedInstance].currentTheme = [[NSClassFromString(themeClassName) alloc] init];
    [[YSThemeManager sharedInstance] checkoutNewSkin];
    //是否有节日闪屏页
    [[YSThemeManager sharedInstance] addFestivalScreenImage];
    
    
//    // 新特性页,有需要展开
//    NSArray *guideImageArr = [YSThemeManager sharedInstance].currentTheme.themeGuideImages;
//    if (guideImageArr.count) {
//        KSGuaidManager.images = guideImageArr;
//        KSGuaidManager.pageIndicatorTintColor = UIColorGrayLighten;
//        KSGuaidManager.currentPageIndicatorTintColor = kThemeColor;
//        KSGuaidManager.dismissButtonCenter = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT - 80);
//        KSGuaidManager.dismissButtonImage = [UIImage imageNamed:@"hidden"];
//        [KSGuaidManager begin];
//    }
   
    
    // 注册推送
    [self registerPush:application WithOptions:launchOptions];
    // 注册第三方服务类
    [self setupApp];
    
    //面部识别指纹识别
    NSUserDefaults *userDefaults = YSUserDefaults;
    if ([userDefaults boolForKey:@"safeLogin"]) {
        [DeviceAuth authDeviceWithDes:nil result:^(BOOL success, LAError error, NSString *errorDes) {
            if (success) {
                [self setLoginControllerWithAlert:NO];
            } else {
                DLog(@"error:%@", errorDes);
            }
        }];
    } else {
        [self setLoginControllerWithAlert:NO];
    }
    
    // 极光推送：当APP为关闭状态时，点击通知栏消息跳转到指定的页面
    
    //    [self jumpViewController:launchOptions];
    self.isLanch = YES;
    
    //    [JJException configExceptionCategory:JJExceptionGuardAll];
    //    [JJException startGuardException];
    //七鱼客服
    //[[QYSDK sharedSDK] registerAppId:QYAPPKEY appName:@"亚厦门户"];
    return YES;
}

#pragma mark —页面跳转
- (void)jumpViewController:(NSDictionary*)tfdic
{
    YSContactSelectPersonViewController *_viewController =  [[YSContactSelectPersonViewController alloc]init];
    UINavigationController *nav= (UINavigationController *)self.window.rootViewController;
    [nav pushViewController:_viewController animated:YES];
}

/** 登录判断 */
- (void)setLoginControllerWithAlert:(BOOL)alert {
    if ([YSUtility isLogin]) {
        // 以下只在登录状态下操作：更新权限、提交日志
        //        [JSPatch setupUserData:@{@"userId": [YSUtility getUID]}];
        [self saveUserACL];//保存或更新权限
        [self enterTabBarController];
        [self postLog];
    } else {
        YSLoginController *loginController = [[YSLoginController alloc] init];
        YSBaseNavigationController *navigationController = [[YSBaseNavigationController alloc] initWithRootViewController:loginController];
        loginController.alert = alert;
        [self.window setRootViewController:navigationController];
#if defined(DEBUG)||defined(_DEBUG)
        [[JPFPSStatus sharedInstance] open];
#endif
    }
}
/** 进入主页 */
- (void)enterTabBarController {
    //    dispatch_async(dispatch_get_main_queue(), ^{
    _tabBarControllerConfig = [[YSTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = _tabBarControllerConfig.tabBarController;
    tabBarController.delegate = self;
    _tabBarControllerConfig.tabBarController.selectedIndex = 2;
    [self.window setRootViewController:_tabBarControllerConfig.tabBarController];
#if defined(DEBUG)||defined(_DEBUG)
    [[JPFPSStatus sharedInstance] open];
#endif
    //    });
}

#pragma mark - CYLTabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView = [control cyl_tabImageView];
    if ([self cyl_tabBarController].selectedIndex % 2 == 0) {
        [self addScaleAnimationOnView:animationView repeatCount:1];
    } else {
        [self addRotateAnimationOnView:animationView];
    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0, @1.3, @0.9, @1.15, @0.5, @1.02, @1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}
#pragma mark - JPush

- (void)registerPush:(UIApplication *)application WithOptions:(NSDictionary *)launchOptions {
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // 注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // 注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    // 注册极光推送
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#if YASHA_DEBUG == 1
    [JPUSHService setupWithOption:launchOptions appKey:@"701dddc29d20a3f8701f7cfc" channel:@"YaSha" apsForProduction:1];
#else
    [JPUSHService setupWithOption:launchOptions appKey:@"5509de33fe94dae98fba476f" channel:@"YaSha" apsForProduction:1];
#endif
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp {
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //[[QYSDK sharedSDK] updateApnsToken:deviceToken];//注册七鱼通信
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    DLog(@"推送消息:%@", userInfo);
    //    NSInteger iconBadgeNumber = [userInfo[@"aps"][@"badge"] integerValue];
    //    NSInteger currentBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:currentBadgeNumber+1];
    //    [JPUSHService handleRemoteNotification:userInfo];
    if ([YSUtility isLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpViewController" object:nil userInfo:@{@"userInfo":userInfo}];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    DLog(@"推送消息:%@", userInfo);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    DLog(@"推送消息:%@", userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    DLog(@"推送消息:%@", userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        if ([YSUtility isLogin]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpViewController" object:nil userInfo:@{@"userInfo":userInfo}];
        }
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    self.enterBackground = YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 切换到前台后需要提交日志和检查更新
    
    if (!self.isLanch) {
        
        [self postLog];
    }
    self.isLanch = NO;
    
    
    [JSPatch sync];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    DLog(@"支付回调URL:%@", url);
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            
        }];
    }
    return YES;
}

@end
