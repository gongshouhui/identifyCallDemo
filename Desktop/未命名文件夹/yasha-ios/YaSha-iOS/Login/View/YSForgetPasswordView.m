//
//  YSForgetPasswordView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/28.
//

#import "YSForgetPasswordView.h"

@implementation YSForgetPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _accountTextField = [[YSTextField alloc] init];
    [_accountTextField setImageName:@"账户" placeholder:@"请输入您的工号"];
    _accountTextField.text = [YSUserDefaults objectForKey:@"account"];
    [self addSubview:_accountTextField];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(kTopHeight+20);
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    
    _getCaptchaButton = [[UIButton alloc] init];
    _getCaptchaButton.layer.masksToBounds = YES;
    _getCaptchaButton.layer.cornerRadius = 5;
    _getCaptchaButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_getCaptchaButton setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    [self addSubview:_getCaptchaButton];
    [_getCaptchaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_accountTextField.mas_bottom).offset(30);
        make.right.mas_equalTo(_accountTextField.mas_right);
        make.size.mas_equalTo(CGSizeMake(140*kWidthScale, 40*kHeightScale));
    }];
    
    _captchaTextField = [[YSTextField alloc] init];
    _captchaTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_captchaTextField setCaptchaImageName:@"验证码" placeholder:@"请输入验证码"];
    [self addSubview:_captchaTextField];
    [_captchaTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_accountTextField.mas_bottom).offset(25);
        make.left.mas_equalTo(_accountTextField.mas_left);
        make.right.mas_equalTo(_getCaptchaButton.mas_left);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = [UIFont systemFontOfSize:10];
    _messageLabel.textColor = [UIColor redColor];
    [self addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_captchaTextField.mas_bottom).offset(4);
        make.left.mas_equalTo(_accountTextField.mas_left);
        make.right.mas_equalTo(_getCaptchaButton.mas_right);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    _getPasswordButton = [YSUIHelper generateDarkFilledButton];
    [_getPasswordButton setTitle:@"获取新密码" forState:UIControlStateNormal];
    [self addSubview:_getPasswordButton];
    [_getPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_captchaTextField.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
    }];
}

@end
