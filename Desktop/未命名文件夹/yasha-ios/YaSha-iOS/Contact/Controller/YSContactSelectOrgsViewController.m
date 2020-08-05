//
//  YSContactSelectOrgsViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactSelectOrgsViewController.h"
#import "YSContactModel.h"
#import "YSContactSelectCell.h"
#import "YSContactDetailViewController.h"
#import "YSContactSelectOrgsBottomView.h"

static NSString *cellIdentifier = @"ContactSelectCell";

@interface YSContactSelectOrgsViewController ()

@property (nonatomic, strong) NSArray *currentDatasourceArray;
@property (nonatomic, strong) YSContactSelectOrgsBottomView *contactSelectOrgsBottomView;
@property (nonatomic, strong) NSMutableArray *selectPeopleMutableArray;

@end

@implementation YSContactSelectOrgsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (YSContactModel *model in self.dataSource) {
        [self getSubSelectedStatusWithContactModel:model];
    }
    [realm commitWriteTransaction];
    [_contactSelectOrgsBottomView updateSelectCountWithpNum:self.pNum];
    [self.tableView reloadData];
}

- (instancetype)init {
    if (self = [super init]) {
        self.pNum = @"1";
        self.isRootDirectory = YES;
    }
    return self;
}

- (NSMutableArray *)selectPeopleMutableArray {
    if (!_selectPeopleMutableArray) {
        _selectPeopleMutableArray = [NSMutableArray array];
        RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"isSelected = YES AND isOrg = YES"]];
        [_selectPeopleMutableArray addObjectsFromArray:results];
    }
    return _selectPeopleMutableArray;
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"内部通讯录";
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"关闭" position:QMUINavigationButtonPositionRight target:self action:@selector(close)];
}

- (void)close {
    // 关闭清空选择
    [self clearAllSelectedPeople];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSContactSelectCell class] forCellReuseIdentifier:cellIdentifier];
    _contactSelectOrgsBottomView = [[YSContactSelectOrgsBottomView alloc] init];
    [_contactSelectOrgsBottomView.sendConfirmSubject subscribeNext:^(id x) {
        [self confirmSelectedPeople];
    }];
    [self.view addSubview:self.contactSelectOrgsBottomView];
    [self monitorSelectAllAction];
    [self getContactData];
}

// 全选操作
- (void)monitorSelectAllAction {
    [_contactSelectOrgsBottomView.sendSelectAllSubject subscribeNext:^(QMUIButton *button) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (YSContactModel *model in self.dataSource) {
            [self getPersonModelAndOrgModel:model isSelected:button.selected];
        }
        [self checkSelectedOrg];
        [realm commitWriteTransaction];
        [_contactSelectOrgsBottomView updateSelectCountWithpNum:self.pNum];
        [self.tableView reloadData];
    }];
}

- (void)getContactData {
    NSString *orgConditions = [NSString stringWithFormat:@"pNum = '%@' AND isOrg = YES", self.pNum];
    RLMResults *orgResults = [[YSContactModel objectsWhere:orgConditions] sortedResultsUsingKeyPath:@"num" ascending:YES];
    // 根目录只有公司
    self.dataSource = orgResults;
    self.currentDatasourceArray = self.dataSource;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_contactSelectOrgsBottomView updateSelectCountWithpNum:self.pNum];
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSContactSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSContactSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSContactModel *model = self.dataSource[indexPath.row];
    [cell setDepartmentModel:(YSDepartmentModel*)model];
    
    NSDictionary *postDic = @{
                              @"tableView": tableView,
                              @"indexPath": indexPath,
                              @"model": model
                              };
    
    objc_setAssociatedObject(cell.selectButton, "postDic", postDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell.selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)selectAction:(QMUIButton *)button {
    NSDictionary *postDic = objc_getAssociatedObject(button, "postDic");
    UITableView *tableView = postDic[@"tableView"];
    NSIndexPath *indexPath = postDic[@"indexPath"];
    YSContactModel *model = postDic[@"model"];
    // 部门下的数据递归操作
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [self getPersonModelAndOrgModel:model isSelected:!model.isSelected];
    [self checkSelectedOrg];
    [realm commitWriteTransaction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView == self.tableView ? self.tableView : self.searchController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_contactSelectOrgsBottomView updateSelectCountWithpNum:self.pNum];
    });
}

- (void)getPersonModelAndOrgModel:(YSContactModel *)orgModel isSelected:(BOOL)isSelected {
    orgModel.isSelected = isSelected;
    RLMResults *orgResults = [YSContactModel objectsWhere:[NSString stringWithFormat:@"pNum = '%@' AND isOrg = YES", orgModel.num]];
    if (orgResults.count == 0) {
        return;
    } else {
        for (YSContactModel *subModel in orgResults) {
            [self getPersonModelAndOrgModel:subModel isSelected:isSelected];
        }
    }
}

// 查询当前子部门目录下是否有选中的状态
- (void)getSubSelectedStatusWithContactModel:(YSContactModel *)contactModel {
    RLMResults *subResults = [YSContactModel objectsWhere:[NSString stringWithFormat:@"pNum = '%@' AND isOrg = YES", contactModel.num]];
    if (subResults.count != 0) {
        for (YSContactModel *subModel in subResults) {
            if (subModel.isSelected) {
                contactModel.isSelected = YES;
                [self getSubSelectedStatusWithContactModel:subModel];
            } else {
                contactModel.isSelected = NO;
                return;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSContactModel *model = self.dataSource[indexPath.row];
    RLMResults *subOrgResults = [YSContactModel objectsWhere:[NSString stringWithFormat:@"pNum = '%@' AND isOrg = YES", model.num]];
    if (subOrgResults.count != 0) {
        YSContactSelectOrgsViewController *contactSelectOrgsViewController = [[YSContactSelectOrgsViewController alloc] init];
        contactSelectOrgsViewController.isRootDirectory = NO;
        contactSelectOrgsViewController.pNum = model.num;
        [self.navigationController pushViewController:contactSelectOrgsViewController animated:YES];
    } else {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        model.isSelected = !model.isSelected;
        [self checkSelectedOrg];
        [realm commitWriteTransaction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView == self.tableView ? self.tableView : self.searchController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_contactSelectOrgsBottomView updateSelectCountWithpNum:self.pNum];
        });
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50*kHeightScale;
}

/**
 搜索部门
 */
- (BOOL)shouldShowSearchBar {
    return YES;
}

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    if (searchString.length != 0) {
        RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"(name CONTAINS '%@') AND isOrg = YES", searchString]];
        self.dataSource = results;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchController.tableView reloadData];
        });
    }
}

/**
 搜索返回后数据源更改成原来的数据源
 */
- (void)didDismissSearchController:(QMUISearchController *)searchController {
    self.dataSource = self.currentDatasourceArray;
    // 如果搜索的人员在当前页，则相应的更改当前页的数据
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (YSContactModel *model in self.dataSource) {
        [self getSubSelectedStatusWithContactModel:model];
    }
    [realm commitWriteTransaction];
    [_contactSelectOrgsBottomView updateSelectCountWithpNum:self.pNum];
    [self.tableView reloadData];
}

/**
 当前页面都没选择时更改父部门的选择状态
 */
- (void)checkSelectedOrg {
    if (!self.isRootDirectory) {
        for (YSContactModel *model in self.dataSource) {
            if (model.isSelected) {
                return;
            } else {
                RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"num = '%@' AND isOrg = YES", model.pNum]];
                YSContactModel *orgContactModel = results[0];
                orgContactModel.isSelected = NO;
            }
        }
    }
}

- (void)confirmSelectedPeople {
    RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"isSelected = YES AND isOrg = YES"]];
    DLog(@"已选部门:%@", results);
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationPostSelectedMoreOrgs object:nil userInfo:@{@"selectedArray": results}];
    [self clearAllSelectedPeople];
    for (int i = 0; i < self.rt_navigationController.rt_viewControllers.count; i ++) {
        YSContactSelectOrgsViewController *viewController = self.rt_navigationController.rt_viewControllers[i];
        if ([viewController isKindOfClass:[YSContactSelectOrgsViewController class]]) {
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
- (void)clearAllSelectedPeople {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults *allResults = [YSContactModel allObjects];
    for (YSContactModel *model in allResults) {
        model.isSelected = NO;
    }
    [realm commitWriteTransaction];
}

@end
