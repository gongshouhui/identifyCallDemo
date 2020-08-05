//
//  YSUIHelper.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/28.
//

#import <Foundation/Foundation.h>

@interface YSUIHelper : NSObject

+ (void)forceInterfaceOrientationPortrait;

@end

@interface YSUIHelper (QMUIMoreOperationAppearance)

+ (void)customMoreOperationAppearance;

@end


@interface YSUIHelper (QMUIAlertControllerAppearance)

+ (void)customAlertControllerAppearance;

@end


@interface YSUIHelper (UITabBarItem)

+ (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag;

@end


@interface YSUIHelper (Button)

+ (QMUIButton *)generateDarkFilledButton;
+ (QMUIButton *)generateLightBorderedButton;

@end


@interface NSString (Code)

- (void)enumerateCodeStringUsingBlock:(void (^)(NSString *codeString, NSRange codeRange))block;

@end


@interface YSUIHelper (SavePhoto)

+ (void)showAlertWhenSavedPhotoFailureByPermissionDenied;

@end


@interface YSUIHelper (Calculate)

+ (NSString *)humanReadableFileSize:(long long)size;

@end


@interface YSUIHelper (Theme)

+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
