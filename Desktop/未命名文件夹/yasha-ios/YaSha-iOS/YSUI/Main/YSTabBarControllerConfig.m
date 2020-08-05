//
//  YSTabBarControllerConfig.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 16/11/23.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSTabBarControllerConfig.h"
#import "YSSddressBookViewController.h"
#import "YSContactTableViewController.h"
#import "YSApplicationFunctionViewController.h"
#import "YSMessageViewController.h"
#import "YSMineViewController.h"

@interface YSBaseNavigationController ()

@property (nonatomic, assign) BOOL isWhite;

@end

@implementation YSBaseNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *returnController = [super popViewControllerAnimated:YES];
    return returnController;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        _isWhite = viewController.preferredStatusBarStyle == UIStatusBarStyleLightContent ? YES : NO;
        viewController.navigationItem.leftBarButtonItem = [self rt_customBackItemWithTarget:self action:@selector(popViewControllerAnimated:)];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIImage *image = _isWhite ? UIImageMake(@"返回白") : UIImageMake(@"返回");
    UIImage *backImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   // return [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"返回白") position:(QMUINavigationButtonPositionLeft) target:target action:action];//这个方法在里面设置了item的tintColor,但是这个是全局设置的
    return [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:target action:action];
}

@end

@interface YSTabBarControllerConfig ()<UITabBarControllerDelegate>

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;
@property (nonatomic,strong) NSArray *viewControllers;
@end

@implementation YSTabBarControllerConfig

- (CYLTabBarController *)tabBarController {
    if (!_tabBarController) {
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers tabBarItemsAttributes:self.tabBarItemsAttributesForController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeChangedNotification:) name:YSThemeChangedNotification object:nil];
        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (NSArray *)viewControllers {
    // 消息
    YSMessageViewController *messageViewController = [[YSMessageViewController alloc] init];
    messageViewController.hidesBottomBarWhenPushed = NO;
    YSBaseNavigationController *messageNavigationController = [[YSBaseNavigationController alloc] initWithRootViewController:messageViewController];
    
    // 通讯录
    YSSddressBookViewController *addressBookViewController = [[YSSddressBookViewController alloc] initWithStyle:UITableViewStyleGrouped];
    addressBookViewController.hidesBottomBarWhenPushed = NO;
    YSBaseNavigationController *addressBookNavigationController = [[YSBaseNavigationController alloc] initWithRootViewController:addressBookViewController];
    YSContactTableViewController *contactTableViewController = [[YSContactTableViewController alloc] init];
    contactTableViewController.hidesBottomBarWhenPushed = NO;
    YSBaseNavigationController *contactNavigationController = [[YSBaseNavigationController alloc] initWithRootViewController:contactTableViewController];
    
    // 应用
    YSApplicationFunctionViewController *applicationFunctionViewController = [[YSApplicationFunctionViewController alloc] init];
    applicationFunctionViewController.hidesBottomBarWhenPushed = NO;
    YSBaseNavigationController *applicationNavigationController = [[YSBaseNavigationController alloc] initWithRootViewController:applicationFunctionViewController];
    
    // 我的
    YSMineViewController *mineController = [[YSMineViewController alloc] initWithStyle:UITableViewStyleGrouped];
    mineController.hidesBottomBarWhenPushed = NO;
    YSBaseNavigationController *mineNavigationController = [[YSBaseNavigationController alloc] initWithRootViewController:mineController];
    NSArray *viewControllers = @[messageNavigationController,
                                 contactNavigationController,
                                 applicationNavigationController,
                                 mineNavigationController];
    
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"消息",
                                                 CYLTabBarItemImage : YSThemeManagerShare.currentTheme.themeTabBarItemImage[0],
                                                 CYLTabBarItemSelectedImage : YSThemeManagerShare.currentTheme.themeTabBarItemImageSelected[0],
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"通讯录",
                                                  CYLTabBarItemImage : YSThemeManagerShare.currentTheme.themeTabBarItemImage[1],
                                                  CYLTabBarItemSelectedImage : YSThemeManagerShare.currentTheme.themeTabBarItemImageSelected[1],
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"工作台",
                                                 CYLTabBarItemImage : YSThemeManagerShare.currentTheme.themeTabBarItemImage[2],
                                                 CYLTabBarItemSelectedImage : YSThemeManagerShare.currentTheme.themeTabBarItemImageSelected[2],
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : YSThemeManagerShare.currentTheme.themeTabBarItemImage[3],
                                                  CYLTabBarItemSelectedImage : YSThemeManagerShare.currentTheme.themeTabBarItemImageSelected[3]
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}

- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = YSThemeManagerShare.currentTheme.themeTabBarItemNormalColor;
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = YSThemeManagerShare.currentTheme.themeTabBarItemSelectedColor;
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setTranslucent:NO];//解决iOS12.1二级页面返回跳动问题
    //FIXED: #196
    [[UITabBar appearance] setBackgroundImage:YSThemeManagerShare.currentTheme.themeTabBarBackgroundImage];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // iOS10 后 需要使用 `-[CYLTabBarController hideTabBadgeBackgroundSeparator]` 见 AppDelegate 类中的演示;
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
     
}

- (void)handleThemeChangedNotification:(NSNotification *)notification {
    NSObject<YSThemeProtocol> *themeBeforeChanged = notification.userInfo[YSThemeBeforeChangedName];
    themeBeforeChanged = [themeBeforeChanged isKindOfClass:[NSNull class]] ? nil : themeBeforeChanged;
    
    NSObject<YSThemeProtocol> *themeAfterChanged = notification.userInfo[YSThemeAfterChangedName];
    themeAfterChanged = [themeAfterChanged isKindOfClass:[NSNull class]] ? nil : themeAfterChanged;
    
    [self themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
}

#pragma mark - <YSChangingThemeDelegate>

- (void)themeBeforeChanged:(NSObject<YSThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<YSThemeProtocol> *)themeAfterChanged {
#warning todo 更新
    [self updateTabTheme];
}
- (void)updateTabTheme {
    //更新tabBar背景图片,tabbaritem文字颜色，[UITabBar appearance]方法只能在控件创建前设置才会生效，控件创建后就不会起作用了，可以s遍历通过指针进行修改
    self.tabBarController.tabBar.backgroundImage = YSThemeManagerShare.currentTheme.themeTabBarBackgroundImage;
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = YSThemeManagerShare.currentTheme.themeTabBarItemNormalColor;
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = YSThemeManagerShare.currentTheme.themeTabBarItemSelectedColor;
    //更新tabbarItem的图片
    for (int i = 0; i < self.tabBarController.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabBarController.tabBar.items[i];
        item.image = YSThemeManagerShare.currentTheme.themeTabBarItemImage[i];
        item.selectedImage = YSThemeManagerShare.currentTheme.themeTabBarItemImageSelected[i];
        
        // 设置文字属性
        [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    }
    
}

@end
