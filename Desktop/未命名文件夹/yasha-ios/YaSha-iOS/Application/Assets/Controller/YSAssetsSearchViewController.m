//
//  YSAssetsSearchViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAssetsSearchViewController.h"
#import "YSAssetsSearchCell.h"
#import "YSAssetsScanViewController.h"
#import "YSAssetsResultListViewController.h"

@interface YSAssetsSearchViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) QMUIButton *searchButton;
@property (nonatomic, strong) NSMutableDictionary *payload;

@end

@implementation YSAssetsSearchViewController

static NSString *cellIdentifier = @"AssetsSearchCell";

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"资产查询"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"资产查询"];
}

- (void)initTableView {
    [super initTableView];
    self.title = @"资产查询";
    _payload = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                 @"assetsNoTmp": @"",
                                                                 @"goodsNameTmp": @"",
                                                                 @"proModel": @"",
                                                                 @"useManTmp": @"",
                                                                 @"useDeptTmp": @"",
                                                                 @"ownCompanyTmp": @"",
                                                                 @"chargeManTmp": @""
                                                                 }];
    self.dataSource = @[
                        @{@"name": @"资产编码", @"placeholder": @"请输入15位资产编码"},
                        @{@"name": @"资产名称", @"placeholder": @"请输入资产名称"},
                        @{@"name": @"规格型号", @"placeholder": @"请输入规格型号"},
                        @{@"name": @"使用人", @"placeholder": @"请输入使用人"},
                        @{@"name": @"使用部门", @"placeholder": @"请输入使用部门"},
                        @{@"name": @"所属部门", @"placeholder": @"请输入所属部门"},
                        @{@"name": @"责任人", @"placeholder": @"请输入责任人"}
                        ];
    
    [self.tableView registerClass:[YSAssetsSearchCell class] forCellReuseIdentifier:cellIdentifier];
    
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"scan")  position:QMUINavigationButtonPositionRight target:self action:@selector(scan)];
}

- (void)scan {
    if ([YSUtility checkCameraAuth]) {
        YSAssetsScanViewController *AssetsScanViewController = [[YSAssetsScanViewController alloc] init];
        AssetsScanViewController.isCheck = YES;
        [self.navigationController pushViewController:AssetsScanViewController animated:YES];
    }
}

- (void)searchProperty {
    if ([_payload[@"assetsNoTmp"] isEqual:@""] && [_payload[@"goodsNameTmp"] isEqual:@""] && [_payload[@"proModel"] isEqual:@""] && [_payload[@"useManTmp"] isEqual:@""] && [_payload[@"useDeptTmp"] isEqual:@""] && [_payload[@"ownCompanyTmp"] isEqual:@""] && [_payload[@"chargeManTmp"] isEqual:@""]) {
        
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"请填写搜索内容" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController showWithAnimated:YES];
    } else {
        for (int i = 0; i < self.dataSource.count; i ++) {
            YSAssetsSearchCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell.textField resignFirstResponder];
        }
        YSAssetsResultListViewController *assetsResultListViewController = [[YSAssetsResultListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        assetsResultListViewController.payload = _payload;
        [self.navigationController pushViewController:assetsResultListViewController animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAssetsSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSAssetsSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setCellWithIndexPath:indexPath config:self.dataSource[indexPath.row]];
    cell.textField.delegate = self;
    [cell.textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchProperty];
    return YES;
}

- (void)textFieldChange:(UITextField *)textField {
    NSArray *keyArray = @[@"assetsNoTmp",
                          @"goodsNameTmp",
                          @"proModel",
                          @"useManTmp",
                          @"useDeptTmp",
                          @"ownCompanyTmp",
                          @"chargeManTmp"];
    [_payload setObject:textField.text forKey:keyArray[textField.tag]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSCREEN_HEIGHT-64-7*44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    _searchButton = [YSUIHelper generateDarkFilledButton];
    [_searchButton setTitle:@"查询" forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(searchProperty) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_searchButton];
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView);
        make.bottom.mas_equalTo(footerView.mas_bottom).offset(-(30*kHeightScale+kBottomHeight));
        make.width.mas_equalTo(300*kWidthScale);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    
    return footerView;
}

@end
