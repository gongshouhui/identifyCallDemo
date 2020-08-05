//
//  YSTextField.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/7.
//
//

#import <UIKit/UIKit.h>

@interface YSTextField : UITextField
@property (nonatomic,strong) UILabel *lineLb;
- (void)setImageName:(NSString *)imageName placeholder:(NSString *)placeholder;
- (void)setCaptchaImageName:(NSString *)imageName placeholder:(NSString *)placeholder;
- (void)setImageName:(NSString *)imageName frame:(CGRect)frame backgroundFrame:(CGRect)bgframe placeholder:(NSString *)placeholder;
@end
