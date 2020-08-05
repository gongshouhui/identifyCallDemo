//
//  YSContactSelectOrgViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactSelectOrgViewController.h"
#import "YSContactModel.h"
//#import "YSContactCell.h"
#import "YSContactDetailViewController.h"
#import "YSContactSelectCell.h"


static NSString *cellIdentifier = @"ContactSelecCell";

@interface YSContactSelectOrgViewController ()

@property (nonatomic, strong) NSArray *currentDatasourceArray;


@end

@implementation YSContactSelectOrgViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"内部通讯录";
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"关闭" position:QMUINavigationButtonPositionRight target:self action:@selector(close)];
}

- (void)close {
   [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSContactSelectCell class] forCellReuseIdentifier:cellIdentifier];
    [self getContactData];
}

- (void)getContactData {

    NSPredicate *orgConditions = [NSPredicate predicateWithFormat:@"pNum = %@ AND delFlag = %@ AND status = %@ AND isPublic != '0'", self.pNum, self.delFlag, self.status];
    RLMResults *orgResults = [[YSDepartmentModel objectsWithPredicate:orgConditions] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];

    self.dataSource = @[orgResults];
    self.currentDatasourceArray = self.dataSource;
	[self.tableView reloadData];
}

- (instancetype)init {
    if (self = [super init]) {
        self.pNum = @"1";
        self.isRootDirectory = YES;
        self.delFlag = @"1";
        self.status = @"1";
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray = self.dataSource[section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSContactSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSContactSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *rowArray = self.dataSource[indexPath.section];
    YSDepartmentModel *model = rowArray[indexPath.row];
    cell.selectDepartModel = model;
    @weakify(self);
    [[[cell.selectButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self);
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        model.isSelected = YES;
        [realm commitWriteTransaction];
        [self confirmSelectedPerson];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowArray = self.dataSource[indexPath.section];
    YSDepartmentModel *model = rowArray[indexPath.row];
    YSContactSelectOrgViewController *contactSelectOrgViewController = [[YSContactSelectOrgViewController alloc] init];
    contactSelectOrgViewController.isRootDirectory = NO;
    contactSelectOrgViewController.pNum = model.num;
    [self.navigationController pushViewController:contactSelectOrgViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : ([self.dataSource[0] count] == 0 || [self.dataSource[1] count] == 0) ? 0.01 : 20.0;
}

/**
 搜索部门
 */
- (BOOL)shouldShowSearchBar {
    return YES;
}

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    if (searchString.length != 0) {
        DLog(@"searchString:%@--路径:%@", searchString, NSHomeDirectory());
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", searchString];
        RLMResults *results = [[YSDepartmentModel objectsWithPredicate:predicate] sortedResultsUsingKeyPath:@"num" ascending:YES];
        DLog(@"%@", results);
        self.dataSource = @[results];
        [self.searchController.tableView reloadData];
    }
}

/**
 搜索返回后数据源更改成原来的数据源
 */
- (void)didDismissSearchController:(QMUISearchController *)searchController {
    self.dataSource = self.currentDatasourceArray;
}

- (void)confirmSelectedPerson {
    RLMResults *results = [YSDepartmentModel objectsWhere:[NSString stringWithFormat:@"isSelected = YES"]];
    DLog(@"已选部门:%@", results);
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationPostSelectedOrg object:nil userInfo:@{@"selectedArray": results}];
    [self clearAllSelectedPerson];
    for (int i = 0; i < self.rt_navigationController.rt_viewControllers.count; i ++) {
        YSContactSelectOrgViewController *viewController = self.rt_navigationController.rt_viewControllers[i];
        if ([viewController isKindOfClass:[YSContactSelectOrgViewController class]]) {
            if (viewController.isRootDirectory) {
                UIViewController *popViewController = self.rt_navigationController.rt_viewControllers[i-1];
                [self.rt_navigationController popToViewController:popViewController animated:YES];
            }
        }
    }
}

/**
 清空选择
 */
- (void)clearAllSelectedPerson {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults *allResults = [YSDepartmentModel allObjects];
    for (YSDepartmentModel *model in allResults) {
        model.isSelected = NO;
    }
    [realm commitWriteTransaction];
}

@end
