//
//  YSLoginController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"
#import "YSLoginView.h"

@interface YSLoginController : YSCommonViewController

@property (nonatomic, strong) YSLoginView *loginView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) BOOL alert;

@end
