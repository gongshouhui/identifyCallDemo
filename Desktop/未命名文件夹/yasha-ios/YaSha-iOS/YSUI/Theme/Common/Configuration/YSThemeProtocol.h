//
//  YSThemeProtocol.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/28.
//

#import <Foundation/Foundation.h>

// 所有主题均应实现这个协议，规定了 QMUI Demo 里常用的几个关键外观属性
@protocol YSThemeProtocol <NSObject>

@required

/// 来自于 QMUIConfigurationTemplate 里的自带方法，用于应用配置表里的设置
- (void)setupConfigurationTemplate;

- (UIColor *)themeTintColor;
- (UIColor *)themeListTextColor;
- (UIColor *)themeCodeColor;
- (UIColor *)themeGridItemTintColor;
/** tabBar主题 */
- (NSArray<UIImage *> *)themeTabBarItemImage;
- (NSArray *)themeTabBarItemImageSelected;
- (UIImage *)themeTabBarBackgroundImage;
/**tabbar item正常状态下的颜色*/
- (UIColor *)themeTabBarItemNormalColor;
/**tabbar item选中状态下的颜色*/
- (UIColor *)themeTabBarItemSelectedColor;
//导航栏文字颜色
- (UIColor *)themeNavTitleColor;
//导航栏颜色
- (UIColor *)themeNavColor;
//导航栏按钮颜色
- (UIColor *)themeNavBarTintColor;
- (NSString *)themeName;

/** logo */
- (UIImage *)themeLogoImage;
- (UIColor *)loginButtonColor;

- (UIImage *)themeContactBackgroundImage;

/** 我的背景图 */
- (UIImage *)themeMineBackgroundImage;

/** 日历背景色 */
- (UIColor *)themeCalendarColor;
/**工作台图片*/
- (UIImage *)themeWorkItemImageWithItemType:(NSInteger)itemType;
/**引导页图片*/
- (NSArray<UIImage *> *)themeGuideImages;//节日特别需要显示的引导页
/**工作台Banner图片*/
- (UIImage *)workBenchBannerImage;
@end

/// 所有能响应主题变化的对象均应实现这个协议，目前主要用于 QDCommonViewController 及 QDCommonTableViewController
@protocol YSChangingThemeDelegate <NSObject>

@required

- (void)themeBeforeChanged:(NSObject<YSThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<YSThemeProtocol> *)themeAfterChanged;

@end
