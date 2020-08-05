//
//  UIFont+YSSize.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/27.
//

#import "UIFont+YSSize.h"

@implementation UIFont (YSSize)
#define IS_IPHONE_4 ([[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568.0f)
// 6、7相同
#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0f)

// 这里设置iPhone6放大的字号数（现在是缩小2号，也就是iPhone6上字号为17，在iPhone4s和iPhone5上字体为15时，）
#define IPHONE5_INCREMENT 2
// 这里设置iPhone6Plus放大的字号数（现在是放大1号，也就是iPhone6上字号为17，在iPhone6P上字体为18时）
#define IPHONE6PLUS_INCREMENT 1

+ (void)load {
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    method_exchangeImplementations(newMethod, method);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        newFont = [UIFont qmui_lightSystemFontOfSize:fontSize - IPHONE5_INCREMENT];
    } else if (IS_IPHONE_6_PLUS) {
        newFont = [UIFont qmui_lightSystemFontOfSize:fontSize + IPHONE6PLUS_INCREMENT];
    } else {
        newFont = [UIFont qmui_lightSystemFontOfSize:fontSize];
    }
    
    return newFont;
}

@end
