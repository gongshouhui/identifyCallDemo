//
//  YSCommonPageController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/25.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonPageController.h"

@interface YSCommonPageController ()<QMUINavigationControllerDelegate>

@property (nonatomic, strong, readwrite) QMUINavigationTitleView *titleView;

@end

@implementation YSCommonPageController

- (instancetype)init {
    if (self = [super init]) {
        self.scrollEnable = NO;
        self.titleColorSelected = kThemeColor;
        self.titleColorNormal = [UIColor blackColor];
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.progressColor = kThemeColor;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.titleView.title = title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleView = [[QMUINavigationTitleView alloc] init];
    self.titleView.title = self.title;
    self.navigationItem.titleView = self.titleView;
}

#pragma mark - <QMUINavigationControllerDelegate>

- (BOOL)shouldSetStatusBarStyleLight {
    return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (BOOL)preferredNavigationBarHidden {
    return NavigationBarHiddenInitially;
}

@end
