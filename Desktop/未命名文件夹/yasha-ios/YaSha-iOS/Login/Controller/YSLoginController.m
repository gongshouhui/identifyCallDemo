//
//  YSLoginController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSLoginController.h"
#import "YSForgetPasswordController.h"
#import "YSTabBarControllerConfig.h"
#import "AppDelegate.h"
#import "AppDelegate+YSSetupAPP.h"
#import <JPUSHService.h>
#import <JSPatchPlatform/JSPatch.h>


@interface YSLoginController ()<UITextFieldDelegate, QMUINavigationControllerDelegate>

@property (nonatomic, strong) RACSignal *loginButtonSignal;

@end

@implementation YSLoginController

- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable {
    return YES;
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (YSLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[YSLoginView alloc] init];
        _loginView.passwordTextField.delegate = self;
        _loginView.accountTextField.delegate = self;
    }
    return _loginView;
}

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.loginView];
    YSWeak;
    [[_loginView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf doNetworking];
    }];
    [[_loginView.forgetButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YSForgetPasswordController *forgetPasswordController = [[YSForgetPasswordController alloc] init];
        [weakSelf.navigationController pushViewController:forgetPasswordController animated:YES];
    }];
    [self monitorLogin];
    if (_alert) {
        [QMUITips showInfo:@"请重新登录" inView:self.view hideAfterDelay:2];
    }
    
#if YASHA_DEBUG == 1
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"  徐灵菲  " forState:UIControlStateNormal];
    [_loginView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(kTopHeight+10);
    }];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.loginView.passwordTextField.text = @"yasha@123456";
        weakSelf.loginView.accountTextField.text = @"00009843";
        weakSelf.loginView.loginButton.enabled = YES;
        weakSelf.loginView.loginButton.backgroundColor = kThemeColor;
    }];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor orangeColor];
    [button2 setTitle:@"  郭子立  " forState:UIControlStateNormal];
    [_loginView addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(button.mas_bottom).mas_equalTo(10);
    }];
    [[button2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.loginView.passwordTextField.text = @"ys@123456";
        weakSelf.loginView.accountTextField.text = @"00013280";
        weakSelf.loginView.loginButton.enabled = YES;
        weakSelf.loginView.loginButton.backgroundColor = kThemeColor;
    }];
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = [UIColor orangeColor];
    [button3 setTitle:@"  邵斐  " forState:UIControlStateNormal];
    [_loginView addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(button2.mas_bottom).mas_equalTo(10);
    }];
    [[button3 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.loginView.passwordTextField.text = @"ys@123456";
        weakSelf.loginView.accountTextField.text = @"00007957";
        weakSelf.loginView.loginButton.enabled = YES;
        weakSelf.loginView.loginButton.backgroundColor = kThemeColor;
    }];
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.backgroundColor = [UIColor orangeColor];
    [button4 setTitle:@"  高帆  " forState:UIControlStateNormal];
    [_loginView addSubview:button4];
    [button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(button3.mas_bottom).mas_equalTo(10);
    }];
    [[button4 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.loginView.passwordTextField.text = @"ys@123456";
        weakSelf.loginView.accountTextField.text = @"00008686";
        weakSelf.loginView.loginButton.enabled = YES;
        weakSelf.loginView.loginButton.backgroundColor = kThemeColor;
    }];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    button5.backgroundColor = [UIColor orangeColor];
    [button5 setTitle:@"  张杏娟  " forState:UIControlStateNormal];
    [_loginView addSubview:button5];
    [button5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kTopHeight+10);
    }];
    
    [[button5 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.loginView.passwordTextField.text = @"ys@123456";
        weakSelf.loginView.accountTextField.text = @"00000002";
        weakSelf.loginView.loginButton.enabled = YES;
        weakSelf.loginView.loginButton.backgroundColor = kThemeColor;
    }];
    
    UIButton *button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    button6.backgroundColor = [UIColor orangeColor];
    [button6 setTitle:@"  岑伟  " forState:UIControlStateNormal];
    [_loginView addSubview:button6];
    [button6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(button5.mas_bottom).mas_equalTo(10);
    }];
    [[button6 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.loginView.passwordTextField.text = @"ys@22222";
        weakSelf.loginView.accountTextField.text = @"00004907";
        weakSelf.loginView.loginButton.enabled = YES;
        weakSelf.loginView.loginButton.backgroundColor = kThemeColor;
    }];
    UIButton *button7 = [UIButton buttonWithType:UIButtonTypeCustom];
    button7.backgroundColor = [UIColor orangeColor];
    [button7 setTitle:@" 杨钊  " forState:UIControlStateNormal];
    [_loginView addSubview:button7];
    [button7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(button6.mas_bottom).mas_equalTo(10);
    }];
    [[button7 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        _loginView.passwordTextField.text = @"ys@123456";
        _loginView.accountTextField.text = @"00013271";
        _loginView.loginButton.enabled = YES;
        _loginView.loginButton.backgroundColor = kThemeColor;
    }];
    
#endif
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _loginView.accountTextField) {
        [textField resignFirstResponder];
        [_loginView.passwordTextField becomeFirstResponder];
    }
    if (textField == _loginView.passwordTextField) {
        [textField resignFirstResponder];
        [self doNetworking];
    }
    return YES;
}

- (void)monitorLogin {
    YSWeak;
    RACSignal *validAccountSignal = [_loginView.accountTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 0);
    }];
    RACSignal *validPasswordSignal = [_loginView.passwordTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 0);
    }];
    
    _loginButtonSignal = [RACSignal combineLatest:@[validAccountSignal, validPasswordSignal] reduce:^id(NSNumber *accountValid, NSNumber *passwordValid) {
        return @([accountValid boolValue] && [passwordValid boolValue]);
    }];
    
    RAC(_loginView.loginButton, backgroundColor) = [_loginButtonSignal map:^id(id value) {
        if ([value boolValue]) {
            weakSelf.loginView.loginButton.enabled = YES;
            return YSThemeManagerShare.currentTheme.loginButtonColor;
        } else {
            weakSelf.loginView.loginButton.enabled = NO;
            return kUIColor(204, 204, 204, 1.0);
        }
    }];
}

- (void)doNetworking {
    if (_loginView.loginButton.enabled) {
        [_loginView.accountTextField resignFirstResponder];
        [_loginView.passwordTextField resignFirstResponder];
        [QMUITips showLoading:@"登录中..." inView:self.loginView];
        NSDictionary *payload = @{@"userName": _loginView.accountTextField.text,
                                  @"pwd": _loginView.passwordTextField.text,
                                  @"platform": @"1"};
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&error];
        NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *enString = [YSUtility encryptString:dataString];
        NSDictionary *dic = @{
                              @"encodeContext": enString
                              };
        DLog(@"=======%@",enString);
        NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, loginApi];
        [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:dic successBlock:^(id response) {
            DLog(@"登录结果:%@",response);
            if ([response[@"code"] intValue] == 0) {
                [QMUITips hideAllToastInView:self.loginView animated:YES];
            } else if ([response[@"code"] intValue] == 3) {
                [QMUITips showError:@"解析失败" inView:self.loginView hideAfterDelay:1];
            } else {
                DLog(@"登录成功");
                [QMUITips hideAllToastInView:self.loginView animated:YES];
                NSUserDefaults *userDefaults = YSUserDefaults;
                [userDefaults setObject:_loginView.accountTextField.text forKey:@"account"];
                [userDefaults synchronize];
				//保存登录信息
                [YSUtility loginSuccess:response[@"data"]];
                [JSPatch setupUserData:@{@"userId": [YSUtility getUID]}];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate saveUserACL];//获取权限，换人登录的时候
                [delegate enterTabBarController];
                [delegate postLog];
            }
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
            [QMUITips hideAllToastInView:self.loginView animated:YES];
            [QMUITips showError:@"请检查网络" inView:self.loginView hideAfterDelay:1];
        } progress:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_loginView.accountTextField resignFirstResponder];
    [_loginView.passwordTextField resignFirstResponder];
}
- (void)dealloc {
    DLog(@"释放了");
}

@end
