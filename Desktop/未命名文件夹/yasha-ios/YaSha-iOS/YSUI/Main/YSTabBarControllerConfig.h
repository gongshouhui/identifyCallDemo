//
//  YSTabBarControllerConfig.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 16/11/23.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSThemeProtocol.h"

@interface YSBaseNavigationController: RTRootNavigationController

@end

@interface YSTabBarControllerConfig : NSObject <YSChangingThemeDelegate>

@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;
@property (nonatomic, copy) NSString *context;

@end
