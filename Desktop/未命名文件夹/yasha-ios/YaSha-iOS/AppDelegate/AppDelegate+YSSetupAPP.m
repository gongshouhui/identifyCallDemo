
//
//  AppDelegate+YSSetupAPP.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/23.
//
//

#import "AppDelegate+YSSetupAPP.h"
#import <AFNetworking.h>
#import <WXApi.h>
#import <Bugly/Bugly.h>
#import "TalkingData.h"
#import <JPUSHService.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <JSPatchPlatform/JSPatch.h>
#import "YSIdentPhoneModel.h"
#import "CallDirectoryHandler.h"
#import "YSACLModel.h"
#import "YSContactModel.h"

@implementation AppDelegate (YSSetupAPP)

- (void)setupApp {
    [self reachability];
    [self registerWeChat];
    [self setupAMap];
#ifndef DEBUG
#if YASHA_DEBUG == 0//正式环境打包版本
    [self setupBugly];
#endif
#endif
    
    [self setupTalkingData];
//    [self setupJSPatch];
}
- (void)setupRealm {
//    //realm.schemaVersion版本出错时，直接删除就可以装任意版本了，解决卸载app都删除不了共享数据库的问题，只能手动添加彻底删除，如有问题打开注释，，，删除后没有创建数据库前不能迁移了，会报空错
//            NSURL *url = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.yasha.group"] URLByAppendingPathComponent:@"default"] URLByAppendingPathExtension:@"realm"];
//           [[NSFileManager defaultManager] removeItemAtURL:url error:nil];

    // APP Group 宿主程序数据库共享
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
#if YASHA_DEBUG == 1
    configuration.fileURL = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.yasha.group"] URLByAppendingPathComponent:@"test"] URLByAppendingPathExtension:@"realm"];
#else
    configuration.fileURL = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.yasha.group"] URLByAppendingPathComponent:@"default"] URLByAppendingPathExtension:@"realm"];
#endif
    
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    DLog(@"数据库地址:%@", [RLMRealmConfiguration defaultConfiguration].fileURL);
    // 数据迁移（必须设置版本）
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // 设置新的架构版本。必须大于之前所使用的版本
    // （如果之前从未设置过架构版本，那么当前的架构版本为 0）
    
    config.schemaVersion = 10;
    
    // 设置模块，如果 Realm 的架构版本低于上面所定义的版本，
    // 那么这段代码就会自动调用
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // 我们目前还未执行过迁移，因此 oldSchemaVersion == 0
        if (oldSchemaVersion < 10 ) {
             //新添字段架构中有，但不会自动复制
            //清空通讯录时间错，相当于通讯录数据重新全量更新一次m，这样才会将新添的字段复制
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"contactsTimestamp"];
            // 没有什么要做的！
            // Realm 会自行检测新增和被移除的属性，完成自动迁移
            // 然后会自动更新磁盘上的架构
            // enumerateObjects:block: 方法遍历了存储在 Realm 文件中的每一个“Person”对象
            
//            [migration enumerateObjects:YSContactModel.className block:^(RLMObject *oldObject, RLMObject *newObject) {
//                // 将名字进行合并，存放在 fullName 域中
//                newObject[@"flow"];
//            }];
         
        }
    };
    // 通知 Realm 为默认的 Realm 数据库使用这个新的配置对象
    [RLMRealmConfiguration setDefaultConfiguration:config];
    // 现在我们已经通知了 Realm 如何处理架构变化，
    // 打开文件将会自动执行迁移
    [RLMRealm defaultRealm];
}
/**
 * 网络监测
 */
- (void)reachability {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
//                DLog(@"网络状态:未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [QMUITips showError:@"您的网络已断开" inView:self.window hideAfterDelay:1];
//                DLog(@"网络状态:没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                DLog(@"网络状态:移动数据");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                DLog(@"网络状态:WiFi");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

/**
 * 注册微信
 */
- (void)registerWeChat {
    [WXApi registerApp:@"wxedb2e8213c893534"];
}

/**
 * 配置高德地图
 */
- (void)setupAMap {
    [AMapServices sharedServices].apiKey = @"549571871d1dfc82fdae1d334ea1cf26";
}

/**
 * 配置Bugly
 */
- (void)setupBugly {

    [Bugly startWithAppId:@"984d7708aa"];
    [Bugly setUserIdentifier:[YSUtility getUID]];

//    BuglyConfig * config = [[BuglyConfig alloc] init];
//    // 设置自定义日志上报的级别，默认不上报自定义日志
//    config.reportLogLevel = BuglyLogLevelWarn;
//    [Bugly startWithAppId:@"984d7708aa" config:config];
    
}

/**
 * 配置TalkingData统计
 */
- (void)setupTalkingData {
#ifndef DEBUG
#if YASHA_DEBUG == 0//正式环境打包版本
    [TalkingData sessionStarted:@"ECAAE436311C4EAF92594590D93B2A07" withChannelId:@"iOS"];
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setLatitude:0 longitude:0];
    //    在 viewWillAppear 或 viewDidAppear 方法里调用 trackPageBegin 方法：
    //    [TalkingData trackPageBegin:@"page_name"];
    //    在 viewWillDisappear 或者 viewDidDisappear 方法里调用 trackPageEnd 方法：
    //    [TalkingData trackPageEnd:@"page_name"];
    //    trackPageBegin 和 trackPageEnd 必须成对调用。
    //    自定义事件（含灵动分析）见文档
#endif
#endif
    [TalkingData sessionStarted:@"9CCCA427795C4CDD951E2B31FD0567FC" withChannelId:@"iOS"];
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setLatitude:0 longitude:0];
}

/**
 * 配置JSPatch
 */
- (void)setupJSPatch {
    [JSPatch startWithAppKey:@"e64cd5e33bd9ced5"];
    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQChCb1KL46Ke8pBFR5JwQi09ITC\nZLAhvzVJlLTzOl6cz/Xmrm8oQ578UF3gNY2q+RGQECkDE7Rot6G5Vzw9vUrY5V0N\ndwt+iPaO1U5OyISMLCGVUP14UDbSobIph8Z+gHAzOZyvk4ZJp5cn8MeNGDSU9eMe\nRzHcDpq+CUuQOrNOjwIDAQAB\n-----END PUBLIC KEY-----"];
#if YASHA_DEBUG == 1
    [JSPatch setupDevelopment];
#endif
}

/**
 * 获取用户权限
 */
- (void)saveUserACL {
    // 先调用时间戳接口，不一致时更新权限
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getTimestampApi];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            if (![YSUtility saveTimeStamp:response]) {
                DLog(@"时间戳不一致");
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self updateUserACL];
                });
            }
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

/**
 * 获取通讯录
 */

- (void)saveContactWithAll:(BOOL)all {
    if (!all) {
        NSString *updateUrl = [NSString stringWithFormat:@"%@%@", YSDomain, getContactUpdateConfig];
        [YSNetManager ys_request_GETWithUrlString:updateUrl isNeedCache:NO parameters:nil successBlock:^(id response) {
            if ([response[@"code"] intValue] == 1) {
                // 1 全量更新
                if ([response[@"data"][@"contact"] intValue] == 1) {
                    [self updateAllContact];
                }else{//0 增量更新
                    [self updateIncrementContact];
                }
            }
        } failureBlock:^(NSError *error) {
            
        } progress:nil];
    } else {
        [self updateAllContact];
    }
}
//全量更新通讯录
- (void)updateAllContact {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getAllOrgTreeApi];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            if ([response[@"data"][@"org"] count] || [response[@"data"][@"person"] count]) {
               
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //全量更新请求成功后有值就删除原来所有的数据后重新存储
                    [YSDataManager clearContact];
                    [YSDataManager saveContactDB:response isAll:YES];
                });
                [YSUtility saveContactsTimestamp:response];
            }
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAllContactFailure" object:nil];//如果请求失败通知通讯录页面
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAllContactFailure" object:nil];//如果请求失败通知通讯录页面
    } progress:nil];
}
//增量更新通讯录
- (void)updateIncrementContact {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getAllOrgTreeApi];
    NSString *contactsTimestamp = [YSUserDefaults objectForKey:@"contactsTimestamp"];
    NSDictionary *payload = @{
                              @"contactsTimestamp": contactsTimestamp
                              };
    //获取当地时间措和后台时间措这段时间又没有变化
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        
        if ([response[@"code"] integerValue] == 1) {
            if (![YSUtility saveContactsTimestamp:response]) {
                if ([response[@"data"][@"org"] count] || [response[@"data"][@"person"] count]) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [YSDataManager saveContactDB:response isAll:NO];
                    });
                }
            }
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}
/**
 * 更新权限系统
 */
- (void)updateUserACL {
    RLMResults *ACLResults = [YSACLModel allObjects];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:ACLResults];
    [realm commitWriteTransaction];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getUserACLApi];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [YSDataManager saveUserACLDB:response];
            });
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

/**
 * 提交日志
 */
- (void)postLog {
    
    if ([YSUserDefaults boolForKey:@"isLogin"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, addLog];
        NSDictionary *payload = @{
                                  @"platform": @"1",
                                  @"loginIp": [YSUtility getIPAddress],
                                  @"deviceId": [JPUSHService registrationID] ?[JPUSHService registrationID] : @"",
                                  };
        
        [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
            DLog(@"登录日志:%@", response);
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
        } progress:nil];
    }

}

/**
 *更新APP
 */
- (void)updateAPPWithAlert:(BOOL)alert {
    if (![YSUserDefaults boolForKey:@"isLogin"]) {//未登录不检查更新
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/1", YSDomain, getAPPVersionAPI];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"版本更新信息:%@", response);
        
        if ([response[@"code"] integerValue] == 1) {
            if ([response[@"data"][@"versionCode"] doubleValue] > [[YSUtility getCurrentVersion] doubleValue]) {
                QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
                }];
                QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"前往更新" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
                    DLog(@"前往更新");
                    UIApplication *application = [UIApplication sharedApplication];
                    NSURL *url;
#if YASHA_DEBUG == 1
                    //if ([response[@"data"][@"vtype"] intValue] == 0) {
                    NSString *urlStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@%@%@.plist", YSUpdateDomain, response[@"data"][@"path"],response[@"data"][@"fileName"]];
                    url = [NSURL URLWithString:urlStr];
                    DLog(@"=====%@",url);
                    //} else {
                    // url = [NSURL URLWithString:@"https://imapitest.chinayasha.com/download/app.html"];
                    //}
#else
                    //if ([response[@"data"][@"vtype"] intValue] == 0) {
                  
                        url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@%@%@.plist", YSUpdateDomain, response[@"data"][@"path"],response[@"data"][@"fileName"]]];
                    //} else {
//                        url = [NSURL URLWithString:@"https://imapi.chinayasha.com/download/app.html"];
//                    }
#endif
                    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                        [application openURL:url options:@{}
                           completionHandler:^(BOOL success) {
                               DLog(@"打开成功:%@", [NSString stringWithFormat:@"%@", url]);
                           }];
                    } else {
                        BOOL success = [application openURL:url];
                        DLog(@"打开成功:%d", success);
                    }
                }];
                
                if (alert) {
                    NSString *message = [response[@"data"][@"description"] stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
                    BOOL isForced = [response[@"data"][@"updateInstall"] boolValue];
                    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"更新" message:[NSString stringWithFormat:@"%@\n\n点击安装后请回到桌面耐心等待，系统将自动更新", message] preferredStyle:QMUIAlertControllerStyleAlert];
                    if (isForced) {//强制更新;
                        [alertController addAction:action2];
                    }else{
                        [alertController addAction:action1];
                        [alertController addAction:action2];
                    }
                    [alertController showWithAnimated:YES];
                }
                //更新后不会再我的界面显示更新按钮
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
                //判断是否重新登录
                if ([response[@"data"][@"isLogin"] isEqual:@"1"]) {
                    [YSUtility logout];
                    [self setLoginControllerWithAlert:NO];
                }else{
                    
                    [[self cyl_tabBarController].viewControllers[3].tabBarItem.cyl_tabButton cyl_showTabBadgePoint];
                }
            }//引导页设置头新的版本信息
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)addFestivalScreenImage {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"guidance1"];
    [self.window addSubview:imageView];

    [self.window bringSubviewToFront:imageView];
    [self.window makeKeyAndVisible];
    [NSThread sleepForTimeInterval:10];
}
///** 更新权限 */
//- (void)updateAPPPrivilege {
//    [YSUtility deleteFileWithName:@"default.realm"];
//    
//    dispatch_group_t downloadGroup = dispatch_group_create();
//    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getPrivilege];
//    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
//        //        DLog(@"获取权限:%@", response);
//        if ([response[@"code"] intValue] == 1) {
//            [YSDataManager saveACLDB:response];
//            dispatch_group_enter(downloadGroup);
//        }
//    } failureBlock:^(NSError *error) {
//        DLog(@"error:%@", error);
//    } progress:nil];
//    NSString *PMSACLString = [NSString stringWithFormat:@"%@%@", YSDomain, getPMSACL];
//    [YSNetManager ys_request_GETWithUrlString:PMSACLString isNeedCache:NO parameters:nil successBlock:^(id response) {
//        //        DLog(@"获取项目管理权限:%@", response);
//        if ([response[@"code"] intValue] == 1) {
//            [YSDataManager savePMSACLDB:response];
//            dispatch_group_enter(downloadGroup);
//        }
//    } failureBlock:^(NSError *error) {
//        DLog(@"error:%@", error);
//    } progress:nil];
//    
//    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
//        
//    });
//}


@end
