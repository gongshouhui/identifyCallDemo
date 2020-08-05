//
//  YSSddressBookViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSddressBookViewController.h"
#import "YSPhoneAddressBookViewController.h"
#import "YSExternalViewController.h"
#import "YSInterViewController.h"
#import "YSDingDingHeader.h"
#import "YSIdentPhoneModel.h"

#import "YSIdentPhoneViewController.h"
#import "YSContactTableViewController.h"
#import "YSContactDetailViewController.h"
#import "YSContactSelectPersonViewController.h"
#import "YSContactSelectPeopleViewController.h"
#import "YSContactSelectOrgViewController.h"
#import "YSContactSelectOrgsViewController.h"
#import "YSContactAddressBookViewController.h"
#import "YSContactOuterViewController.h"
#import <PPGetAddressBook.h>

@interface YSSddressBookViewController ()

@end

@implementation YSSddressBookViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"通讯录";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@{@"title": @"内部通讯录",
                          @"imageName": @"内部icon"},
                        @{@"title": @"外部通讯录",
                          @"imageName": @"外部icon"},
                        @{@"title": @"手机通讯录",
                          @"imageName": @"手机icon"},
                        @{@"title": @"常用联系人",
                          @"imageName": @"常用icon"},
                        @{@"title": @"号码识别",
                          @"imageName": @"号码识别"},
                        @{@"title": @"内部通讯录（新）",
                          @"imageName": @"内部icon"},
                        @{@"title": @"跳转到指定用户详情页",
                          @"imageName": @"内部icon"},
                        @{@"title": @"人员选择器（单选）",
                          @"imageName": @"内部icon"},
                        @{@"title": @"人员选择器（多选）",
                          @"imageName": @"内部icon"},
                        @{@"title": @"部门选择器（单选）",
                          @"imageName": @"内部icon"},
                        @{@"title": @"部门选择器（多选）",
                          @"imageName": @"内部icon"},
                        @{@"title": @"手机通讯录",
                          @"imageName": @"内部icon"},
                        @{@"title": @"外部通讯录",
                          @"imageName": @"内部icon"}
                        ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelected:) name:KNotificationPostSelectedPerson object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelected:) name:KNotificationPostSelectedPeolple object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelected:) name:KNotificationPostSelectedOrg object:nil];
}

- (void)showSelected:(NSNotification *)notification {
    NSArray *array = notification.userInfo[@"selectedArray"];
    NSMutableString *mutableString = [NSMutableString string];
    for (YSContactModel *model in array) {
        [mutableString appendString:[NSString stringWithFormat:@"%@、", model.name]];
    }
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
    contentView.backgroundColor = UIColorWhite;
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[mutableString copy] attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    CGSize labelSize = [label sizeThatFits:CGSizeMake(contentLimitWidth, CGFLOAT_MAX)];
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, labelSize.height);
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 UIWindow 的形式来展示
    [modalViewController showWithAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = kUIColor(51, 51, 51, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    NSDictionary *rowDic = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = rowDic[@"title"];
    cell.imageView.image = [UIImage imageNamed:rowDic[@"imageName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            YSInterViewController *internal = [[YSInterViewController alloc]init];
            internal.title = @"内部通讯录";
            internal.str = @"首页";
            [[YSDingDingHeader shareHelper].titleList removeAllObjects];
            [[YSDingDingHeader shareHelper].titleList addObject:@"联系人"];
            [self.navigationController pushViewController:internal animated:YES];
//            YSInterAdressBookController *internal = [[YSInterAdressBookController alloc]init];
//            internal.title = @"内部通讯录";
//            [[YSDingDingHeader shareHelper].titleList addObject:@"联系人"];
//            [self.navigationController pushViewController:internal animated:YES];
            break;
        }
        case 1:{
            YSExternalViewController *external = [[YSExternalViewController alloc]init];
            external.numberCon = 1;
            [self.navigationController pushViewController:external animated:YES];
            break;
        }
        case 2:{
            YSPhoneAddressBookViewController *phone = [[YSPhoneAddressBookViewController alloc]init];
            [self.navigationController pushViewController:phone animated:YES];
            break;
        }
        case 3:{
            YSExternalViewController *external = [[YSExternalViewController alloc]init];
            external.string = @"联系人";
            external.numberCon = 2;
            [self.navigationController pushViewController:external animated:YES];
            break;
        }
        case 4 :{
            if ([[UIDevice currentDevice] systemVersion].floatValue < 11.0) {
                [QMUITips showInfo:@"此功能暂不支持iOS 11 以下版本\n建议升级你的系统" inView:self.view hideAfterDelay:1.5];
            } else {
                YSIdentPhoneViewController *identPhoneViewController = [[YSIdentPhoneViewController alloc] init];
                [self.navigationController pushViewController:identPhoneViewController animated:YES];
            }
            break;
        }
        case 5:
        {
            YSContactTableViewController *contactTableViewController = [[YSContactTableViewController alloc] init];
            [self.navigationController pushViewController:contactTableViewController animated:YES];
            break;
        }
        case 6:
        {
            [YSUtility pushToContactDetailViewControllerWithuserId:[YSUtility getUID]];
            break;
        }
        case 7:
        {
            YSContactSelectPersonViewController *contactSelectPersonViewController = [[YSContactSelectPersonViewController alloc] init];
            [self.navigationController pushViewController:contactSelectPersonViewController animated:YES];
            break;
        }
        case 8:
        {
            YSContactSelectPeopleViewController *contactSelectPeopleViewController = [[YSContactSelectPeopleViewController alloc] init];
            [self.navigationController pushViewController:contactSelectPeopleViewController animated:YES];
            break;
        }
        case 9:
        {
            YSContactSelectOrgViewController *contactSelectOrgViewController = [[YSContactSelectOrgViewController alloc] init];
            [self.navigationController pushViewController:contactSelectOrgViewController animated:YES];
            break;
        }
        case 10:
        {
            YSContactSelectOrgsViewController *contactSelectOrgsViewController = [[YSContactSelectOrgsViewController alloc] init];
            [self.navigationController pushViewController:contactSelectOrgsViewController animated:YES];
            break;
        }
        case 11:
        {
            [YSUtility checkAddressBookEnableStatus:^(BOOL enable) {
                if (enable) {
                    YSContactAddressBookViewController *contactAddressBookViewController = [[YSContactAddressBookViewController alloc] init];
                    [self.navigationController pushViewController:contactAddressBookViewController animated:YES];
                }
            }];
            break;
        }
        case 12:
        {
            YSContactOuterViewController *contactOuterViewController = [[YSContactOuterViewController alloc] init];
            [self.navigationController pushViewController:contactOuterViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
