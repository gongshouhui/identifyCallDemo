//
//  YSLoginView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/7.
//
//

#import "YSLoginView.h"

@interface YSLoginView ()

@end

@implementation YSLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.image = YSThemeManagerShare.currentTheme.themeLogoImage;
    [self addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(85*kWidthScale, 85*kWidthScale));
    }];
    
    _accountTextField = [[YSTextField alloc] init];
    [_accountTextField setImageName:@"账户" placeholder:@"请输入用户名/工号/手机号"];
    _accountTextField.text = [YSUserDefaults objectForKey:@"account"];
    [self addSubview:_accountTextField];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_logoImageView.mas_bottom).offset(100);
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    
    _passwordTextField = [[YSTextField alloc] init];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.returnKeyType = UIReturnKeyGo;
    [_passwordTextField setImageName:@"密码" placeholder:@"请输入密码"];
    [self addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_accountTextField.mas_bottom).offset(25);
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    
    _forgetButton = [[UIButton alloc] init];
	_forgetButton.hidden = YES;
    _forgetButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self addSubview:_forgetButton];
    [_forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_passwordTextField.mas_bottom).offset(10);
        make.right.mas_equalTo(_passwordTextField.mas_right);
        make.size.mas_equalTo(CGSizeMake(65*kWidthScale, 25*kHeightScale));
    }];
    
    _loginButton = [YSUIHelper generateDarkFilledButton];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    [self addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_passwordTextField.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
    }];
}

@end
