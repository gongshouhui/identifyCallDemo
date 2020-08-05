//
//  AppDelegate+YSSetupAPP.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/23.
//
//

#import "AppDelegate.h"

@interface AppDelegate (YSSetupAPP)

/**
 * APP的基本配置（网络监测、注册微信、配置高德地图、配置Bugly、配置TalkingData统计、配置JSPatch）
 */
- (void)setupApp;
/**
 realm数据库相关配置
 */
- (void)setupRealm;
/**
 * 比较时间戳，不一致时更新权限系统
 */
- (void)saveUserACL;
/**
 * 更新权限系统
 */
- (void)updateUserACL;
/**
 * 全量获取通讯录
 */
- (void)saveContactWithAll:(BOOL)all;

/**
 * 提交日志
 */
- (void)postLog;

/**
 * 更新APP
 */
- (void)updateAPPWithAlert:(BOOL)alert;

- (void)updateAPPPrivilege;
/**当系统的启动图显示完毕后添加这个*/
- (void)addFestivalScreenImage;
@end
