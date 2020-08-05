//
//  YSThemeManager.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/27.
//

#import <Foundation/Foundation.h>
#import "YSThemeConfigModel.h"
#import "YSThemeProtocol.h"

#define YSThemeManagerShare [YSThemeManager sharedInstance]
/// 当主题发生变化时，会发送这个通知
extern NSString *const YSThemeChangedNotification;

/// 主题发生改变前的值，类型为 NSObject<YSThemeProtocol>，可能为 NSNull
extern NSString *const YSThemeBeforeChangedName;

/// 主题发生改变后的值，类型为 NSObject<YSThemeProtocol>，可能为 NSNull
extern NSString *const YSThemeAfterChangedName;

/**
 *  QMUI Demo 的皮肤管理器，当需要换肤时，请为 currentTheme 赋值；当需要获取当前皮肤时，可访问 currentTheme 属性。
 *  可通过监听 QDThemeChangedNotification 通知来捕获换肤事件，默认地，QDCommonViewController 及 QDCommonTableViewController 均已支持响应换肤，其响应方法是通过 QDChangingThemeDelegate 接口来实现的。
 */

@interface YSThemeManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSObject<YSThemeProtocol> *currentTheme;
/**显示节日闪屏的window*/
@property (nonatomic,strong) UIWindow *window;
/**检查是否有新的节日皮肤，并下载zip包，并解压d到指定的文件夹*/
- (void)checkoutNewSkin;
/**根据要求添加额外的闪屏页*/
- (void)addFestivalScreenImage;
@end
