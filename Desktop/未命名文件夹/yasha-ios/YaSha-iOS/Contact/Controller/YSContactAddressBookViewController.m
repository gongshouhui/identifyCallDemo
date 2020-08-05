//
//  YSContactAddressBookViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/19.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactAddressBookViewController.h"
#import <PPGetAddressBook.h>
#import <SCIndexView.h>
#import <UITableView+SCIndexView.h>
#import "YSContactCell.h"
#import "YSContactDetailViewController.h"

static NSString *cellIdentifier = @"ContactCell";

@interface YSContactAddressBookViewController ()
@property (nonatomic, strong) NSDictionary *contactPeopleDict;
@property (nonatomic, strong) NSArray *nameKeys;
@property (nonatomic, strong) NSDictionary *currentContactPeopleDict;
@property (nonatomic, strong) NSArray *currentNameKeys;

@end

@implementation YSContactAddressBookViewController


- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"手机通讯录";
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSContactCell class] forCellReuseIdentifier:cellIdentifier];
    //索引相关设置
    SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
    self.tableView.sc_indexViewConfiguration = indexViewConfiguration;
    
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        self.tableView.sc_indexViewDataSource = nameKeys;
        _contactPeopleDict = addressBookDict;
        _nameKeys = nameKeys;
        _currentContactPeopleDict = addressBookDict;
        _currentNameKeys = nameKeys;
        [self.tableView reloadData];
    } authorizationFailure:^{
        [YSUtility checkAddressBookEnableStatus:^(BOOL enable) {
            
        }];
    }];
}

/**
 搜索人员
 */
- (BOOL)shouldShowSearchBar {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _nameKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = _nameKeys[section];
    NSArray *rowArray = _contactPeopleDict[key];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *key = _nameKeys[indexPath.section];
    NSArray *rowArray = _contactPeopleDict[key];
    PPPersonModel *model = rowArray[indexPath.row];
    [cell setPersonModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView == self.tableView ? 30 : 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return tableView == self.tableView ? [NSString stringWithFormat:@"  %@", _nameKeys[section]] : @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = _nameKeys[indexPath.section];
    NSArray *rowArray = _contactPeopleDict[key];
    PPPersonModel *personModel = rowArray[indexPath.row];
    YSContactModel *contactModel = [[YSContactModel alloc] init];
    contactModel.name = personModel.name;
    if (personModel.mobileArray.count > 0) {
        contactModel.mobilePhone = personModel.mobileArray[0];
    }
    YSContactDetailViewController *contactDetailViewController = [[YSContactDetailViewController alloc] init];
    contactDetailViewController.contactModel = contactModel;
    contactDetailViewController.contactDetailType = YSContactDetailAddress;
    [self.navigationController pushViewController:contactDetailViewController animated:YES];
}

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    NSMutableArray *mutableArray = [NSMutableArray array];
    if (searchString.length != 0) {
        for (NSArray *array in [_currentContactPeopleDict allValues]) {
            for (PPPersonModel *model in array) {
                if ([model.name containsString:searchString]) {
                    [mutableArray addObject:model];
                }
            }
        }
        _contactPeopleDict = @{@"A": [mutableArray copy]};
        _nameKeys = @[@"A"];
        [self.searchController.tableView reloadData];
    }
}

/**
 搜索返回后数据源更改成原来的数据源
 */
- (void)didDismissSearchController:(QMUISearchController *)searchController {
    _contactPeopleDict = _currentContactPeopleDict;
    _nameKeys = _currentNameKeys;
}

@end
