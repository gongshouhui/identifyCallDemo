//
//  YSChangePasswordViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSChangePasswordViewController.h"
#import "YSChangePasswordViewCell.h"
#import "AppDelegate.h"

@interface YSChangePasswordViewController ()<QMUITextFieldDelegate>

@property (nonatomic, strong) QMUIButton *saveButton;
@property (nonatomic, strong) UITextField *oldTextField;
@property (nonatomic, strong) UITextField *xinTextField;
@property (nonatomic, strong) UITextField *verifyTextField;

@end

@implementation YSChangePasswordViewController

static NSString *changeCellIdentifier = @"ChangePasswordViewCell";

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"修改密码";
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSChangePasswordViewCell class] forCellReuseIdentifier:changeCellIdentifier];
}

- (void)doNetworking {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSChangePasswordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:changeCellIdentifier];
    cell = [[YSChangePasswordViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:changeCellIdentifier];
    cell.textField.delegate = self;
    [cell.textField addTarget:self action:@selector(editingChanged) forControlEvents:UIControlEventEditingChanged];
    [cell setStyle:indexPath.row];
    
    return cell;
}

- (void)editingChanged {
    _oldTextField = (UITextField *)[self.tableView viewWithTag:100];
    _xinTextField = (UITextField *)[self.tableView viewWithTag:101];
    _verifyTextField = (UITextField *)[self.tableView viewWithTag:102];
    if (_oldTextField.text.length > 0 && _xinTextField.text.length > 0 && _verifyTextField.text.length > 0) {
        [_saveButton setBackgroundColor:kThemeColor];
    } else {
        [_saveButton setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100*kHeightScale)];
    _saveButton = [YSUIHelper generateDarkFilledButton];
    [_saveButton setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_saveButton];
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
    }];
    
    return footerView;
}

- (void)save {
    if (_oldTextField.text.length == 0 || _xinTextField.text.length == 0 || _verifyTextField.text.length == 0) {
        [QMUITips showError:@"请输入密码" inView:self.view hideAfterDelay:1];
    } else if (![_xinTextField.text isEqual:_verifyTextField.text]) {
        [QMUITips showError:@"两次新密码不一致" inView:self.view hideAfterDelay:1];
    } else if ([_oldTextField.text isEqual:_xinTextField.text]) {
        [QMUITips showError:@"新密码不能和原密码相同，请重新输入！" inView:self.view hideAfterDelay:1];
    } else {
        [QMUITips showLoading:@"修改中..." inView:self.view];
        NSString *url = [NSString stringWithFormat:@"%@%@", YSDomain, modifyPassword];
        NSDictionary *dic = @{
                              @"oldPwd": _oldTextField.text,
                              @"newPwd": _verifyTextField.text
                              };
        [YSNetManager ys_request_POSTWithUrlString:url isNeedCache:NO parameters:dic successBlock:^(id response) {
            [QMUITips hideAllToastInView:self.view animated:YES];
            if ([response[@"data"] integerValue] == 0) {
                
            } else {
                
                [YSUserDefaults setObject:@"No" forKey:@"ogin"];
                [YSUserDefaults setBool:NO forKey:@"isLogin"];
                AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate setLoginControllerWithAlert:YES];
            }
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
        } progress:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*kHeightScale;
}

@end
