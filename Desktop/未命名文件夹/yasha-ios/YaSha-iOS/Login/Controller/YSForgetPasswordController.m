//
//  YSForgetPasswordController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/28.
//

#import "YSForgetPasswordController.h"
#import "UIButton+YSCountDown.h"

@interface YSForgetPasswordController ()

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *securemobile;

@end

@implementation YSForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    _forgetPasswordView = [[YSForgetPasswordView alloc] init];
    [self.view addSubview:_forgetPasswordView];
    YSWeak;
    [[_forgetPasswordView.getCaptchaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *getCaptchaButton) {
        [getCaptchaButton startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:kThemeColor countColor:kUIColor(204, 204, 204, 1.0)];
        [weakSelf getCaptcha];
    }];
    [[_forgetPasswordView.getPasswordButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf getNewPassowrd];
    }];
    [self monitorAccount];
    [self monitorCaptcha];
}

- (void)monitorAccount {
    RACSignal *validAccountSignal = [_forgetPasswordView.accountTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length == 8);
    }];
    YSWeak;
    RAC(_forgetPasswordView.getCaptchaButton, backgroundColor) = [validAccountSignal map:^id(id value) {
        if ([value boolValue]) {
            weakSelf.forgetPasswordView.getCaptchaButton.enabled = YES;
            return kThemeColor;
        } else {
            weakSelf.forgetPasswordView.getCaptchaButton.enabled = NO;
            return kUIColor(204, 204, 204, 1.0);
        }
    }];
}

- (void)monitorCaptcha {
    RACSignal *validCaptchaSignal = [_forgetPasswordView.captchaTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length == 6);
    }];
    YSWeak;
    RAC(_forgetPasswordView.getPasswordButton, backgroundColor) = [validCaptchaSignal map:^id(id value) {
        if ([value boolValue]) {
            weakSelf.forgetPasswordView.getPasswordButton.enabled = YES;
            return kThemeColor;
        } else {
            weakSelf.forgetPasswordView.getPasswordButton.enabled = NO;
            return kUIColor(204, 204, 204, 1.0);
        }
    }];
}

- (void)getCaptcha {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getCaptchaApi, _forgetPasswordView.accountTextField.text];
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取验证码:%@", response);
        if ([response[@"code"] intValue] == 1) {
            _forgetPasswordView.messageLabel.text = [NSString stringWithFormat:@"验证码已发送至%@，请查收！", response[@"data"][@"securemobile"]];
            _userName = response[@"data"][@"username"];
            _securemobile = response[@"data"][@"securemobile"];
        } else {
            _forgetPasswordView.messageLabel.text = response[@"msg"];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)getNewPassowrd {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@/%@", YSDomain, getNewPasswordApi, _userName, _securemobile, _forgetPasswordView.captchaTextField.text];
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取新密码:%@", response);
        if ([response[@"code"] intValue] == 1) {
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"新密码已发送至%@，请注意查收！", _securemobile] preferredStyle:QMUIAlertControllerStyleAlert];
            [alertController addAction:action1];
            [alertController showWithAnimated:YES];
        } else {
            _forgetPasswordView.messageLabel.text = response[@"msg"];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

@end
