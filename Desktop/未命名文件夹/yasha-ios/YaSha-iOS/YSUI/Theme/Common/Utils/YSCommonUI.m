//
//  YSCommonUI.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/28.
//

#import "YSCommonUI.h"
#import "YSUIHelper.h"

NSString *const YSSelectedThemeClassName = @"selectedThemeClassName";

const CGFloat YSButtonSpacingHeight = 72;

@implementation YSCommonUI

+ (void)renderGlobalAppearances {
    [YSUIHelper customMoreOperationAppearance];
    [YSUIHelper customAlertControllerAppearance];
}

@end

@implementation YSCommonUI (ThemeColor)

static NSArray<UIColor *> *themeColors = nil;
+ (UIColor *)randomThemeColor {
    if (!themeColors) {
        themeColors = @[UIColorTheme1,
                        UIColorTheme2,
                        UIColorTheme3,
                        UIColorTheme4,
                        UIColorTheme5,
                        UIColorTheme6,
                        UIColorTheme7,
                        UIColorTheme8,
                        UIColorTheme9];
    }
    return themeColors[arc4random() % 9];
}

@end

@implementation YSCommonUI (Layer)

+ (CALayer *)generateSeparatorLayer {
    CALayer *layer = [CALayer layer];
    [layer qmui_removeDefaultAnimations];
    layer.backgroundColor = UIColorSeparator.CGColor;
    return layer;
}

@end
