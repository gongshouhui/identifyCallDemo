//
//  AppDelegate.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 16/11/17.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTabBarControllerConfig.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) YSTabBarControllerConfig *tabBarControllerConfig;
@property (nonatomic, assign) BOOL enterBackground;
@property (nonatomic, assign) BOOL getContactFailure;//最好记录在一个信息单利里

- (void)setLoginControllerWithAlert:(BOOL)alert;
- (void)enterTabBarController;
@end

