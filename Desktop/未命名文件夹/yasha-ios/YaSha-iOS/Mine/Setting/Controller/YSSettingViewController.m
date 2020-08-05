//
//  YSSettingViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/2/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSettingViewController.h"
#import "YSApplicationModel.h"

@interface YSSettingViewController ()

@end

@implementation YSSettingViewController

NSString *const settingCellIdentifier = @"Cell";

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"设置";
}

- (void)initTableView {
    [super initTableView];
    self.dataSource = @[[YSDataManager getApplicationsData:@[
//                                                            @{@"id": @"0",
//                                                              @"name": @"修改密码",
//                                                              @"className": @"YSChangePasswordViewController"},
                                                             @{@"id": @"1",
                                                               @"name": @"安全登录"},
                                                             @{@"id": @"2",
                                                               @"name": @"关于",
                                                               @"className": @"YSAboutViewController"}
                                                            ]]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray = [self.dataSource objectAtIndex:section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellIdentifier];
    }
    
    NSArray *rowArray = [self.dataSource objectAtIndex:indexPath.section];
    YSApplicationModel *model = [rowArray objectAtIndex:indexPath.row];
    if ([model.id isEqual:@"1"]) {
        UISwitch *safeSwitch = [[UISwitch alloc] init];
        NSUserDefaults *userDefaults = YSUserDefaults;
        [safeSwitch setOn:[userDefaults boolForKey:@"safeLogin"]];
        [[safeSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
            [userDefaults setBool:![userDefaults boolForKey:@"safeLogin"] forKey:@"safeLogin"];
            if ([userDefaults boolForKey:@"safeLogin"]) {
               
                QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"开启安全登录后，启动亚厦门户时将进行指纹/面容解锁" preferredStyle:QMUIAlertControllerStyleAlert];
                QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                }];
                [alertController addAction:action0];
                [alertController showWithAnimated:YES];
            }
        }];
        cell.accessoryView = safeSwitch;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    [cell addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(cell);
        make.height.mas_equalTo(1);
    }];
    
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowArray = [self.dataSource objectAtIndex:indexPath.section];
    YSApplicationModel *model = [rowArray objectAtIndex:indexPath.row];
    if (![model.id isEqual:@"1"]) {
        Class someClass = NSClassFromString(model.className);
        UIViewController *viewController = [[someClass alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
