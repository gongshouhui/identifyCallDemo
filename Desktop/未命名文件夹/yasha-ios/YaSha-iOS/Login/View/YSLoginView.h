//
//  YSLoginView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/7.
//
//

#import <UIKit/UIKit.h>
#import "YSTextField.h"

@interface YSLoginView : UIView

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) YSTextField *accountTextField;
@property (nonatomic, strong) YSTextField *passwordTextField;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) QMUIButton *loginButton;

@end
