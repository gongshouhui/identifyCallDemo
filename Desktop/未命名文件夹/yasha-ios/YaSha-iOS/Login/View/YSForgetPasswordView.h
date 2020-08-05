//
//  YSForgetPasswordView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/28.
//

#import <UIKit/UIKit.h>
#import "YSTextField.h"

@interface YSForgetPasswordView : UIView

@property (nonatomic, strong) YSTextField *accountTextField;
@property (nonatomic, strong) YSTextField *captchaTextField;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *getCaptchaButton;
@property (nonatomic, strong) QMUIButton *getPasswordButton;

@end
