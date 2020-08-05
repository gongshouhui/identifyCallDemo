
//
//  YSContactSelectPersonViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

/*
 单人员选择功能
 */

#import "YSContactSelectPersonViewController.h"
#import "YSContactModel.h"
#import "YSContactCell.h"
#import "YSContactDetailViewController.h"
#import "YSContactHeaderView.h"
static NSString *cellIdentifier = @"ContactCell";

@interface YSContactSelectPersonViewController ()<YSContactHeaderViewDelegate>
@property (nonatomic,strong)  NSArray *searchResultArray;
@property (nonatomic, strong) NSArray *currentDatasourceArray;
@property (nonatomic, strong) NSString *identificationStr;
@property (nonatomic, strong) NSMutableArray *headerOrgMutableArray;
@property (nonatomic,strong) YSContactHeaderView *sectionHeaderView;
@end

@implementation YSContactSelectPersonViewController
- (YSContactHeaderView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[YSContactHeaderView alloc]init];
        _sectionHeaderView.delegate = self;
    }
    return _sectionHeaderView;
}
- (NSMutableArray *)headerOrgMutableArray {
    if (!_headerOrgMutableArray) {
        _headerOrgMutableArray = [NSMutableArray array];
    }
    return _headerOrgMutableArray;
}

//导航栏设置
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"内部通讯录";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self clearAllSelectedPerson];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSContactCell class] forCellReuseIdentifier:cellIdentifier];
    [self getContactData];
}

//本地数据库中查找数据
- (void)getContactData {
    [self.headerOrgMutableArray removeAllObjects];
    self.searchResultArray = nil;
    [self.searchController.tableView reloadData];
    NSString *orgConditions = [NSString stringWithFormat:@"pNum = '%@' AND delFlag = '%@' AND status = '%@' AND isPublic != '%ld'", self.pNum, self.delFlag, self.status, (long)self.isPublic];
    //查询条件
    NSString *personConditions = [NSString stringWithFormat:@"pNum = '%@' AND isOrg = NO AND delFlag = '%@' AND postStatus = '%@' AND status = '%@' AND isPublic != '%ld'", self.pNum, self.delFlag,self.postStatus,self.status,self.isPublic];
    RLMResults *orgResults = [[YSDepartmentModel objectsWhere:orgConditions] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];
    RLMResults *personResults = [[YSContactModel objectsWhere:personConditions] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];
    // 根目录只有公司
    self.dataSource = self.isRootDirectory ? @[orgResults] : @[personResults, orgResults];
    [self getHeaderOrgWithPNum:_pNum];
    /** 数组倒序 */
    NSArray *headerOrgArray = [[self.headerOrgMutableArray reverseObjectEnumerator] allObjects];
    [self.sectionHeaderView setHeaderArray:headerOrgArray];
    [self.tableView reloadData];
}

- (instancetype)init {
    if (self = [super init]) {
        self.pNum = @"1";
        self.isRootDirectory = YES;
        self.delFlag = @"1";
        self.postStatus = @"1";
        self.status = @"1";
        self.isPublic = 0;}
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableView) {
        return self.dataSource.count;
    }else{//搜索
        return self.searchResultArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [self.dataSource[section] count];
    }else{
        return [self.searchResultArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (tableView == self.tableView) {
        YSContactModel *model = self.dataSource[indexPath.section][indexPath.row];
        if ([model isKindOfClass:[YSContactModel class]]) {//人员
            [cell setCellModel:model];
        }else{//部门
            [cell setDepartmentModel:(YSDepartmentModel*)model];
        }
    }else{
        //搜索tabView(搜索结果都是人)
        YSContactModel *model = self.searchResultArray[indexPath.section][indexPath.row];
        [cell setCellModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView ==self.tableView) {
        YSContactModel *model = self.dataSource[indexPath.section][indexPath.row];
        if ([model isKindOfClass:[YSContactModel class]]) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            model.isSelected = YES;
            [realm commitWriteTransaction];
            [self confirmSelectedPerson];
        }else{
            YSContactSelectPersonViewController *contactInnerViewController = [[YSContactSelectPersonViewController alloc] init];
            contactInnerViewController.isRootDirectory = NO;
            contactInnerViewController.pNum = model.num;
            contactInnerViewController.indexPath = self.indexPath;
            contactInnerViewController.jumpSourceStr = self.jumpSourceStr;
            [self.navigationController pushViewController:contactInnerViewController animated:YES];
        }
    }else{
        YSContactModel *model = self.searchResultArray[indexPath.section][indexPath.row];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        model.isSelected = YES;
        [realm commitWriteTransaction];
        [self confirmSelectedPerson];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        switch (section) {
            case 0:
                return 50*kHeightScale + 20.0;
                break;
            default:
                return 20;
                break;
        }
    }else {//a搜索tabView
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.tableView == tableView && section == 0) {
        return self.sectionHeaderView;
    }else{
        return nil;
    }
}


/**
 搜索人员
 */
- (BOOL)shouldShowSearchBar {
    return YES;
}

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    if (searchString.length != 0) {
        DLog(@"searchString:%@", searchString);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(companyName CONTAINS[c]%@ || deptName CONTAINS[c] %@ || email CONTAINS %@ || name CONTAINS[c] %@ || userId CONTAINS %@ || shortPhone CONTAINS %@ || shortWorkPhone CONTAINS %@ || mobile CONTAINS %@ || phone CONTAINS %@) AND isOrg = NO AND delFlag = '1' AND postStatus = '1' AND status = '1' AND isPublic != '0'", searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString];
        DLog(@"查询语句:%@", predicate);
        RLMResults *results = [YSContactModel objectsWithPredicate:predicate];
        self.identificationStr = @"搜索";
        self.searchResultArray = @[(NSArray *)results];
        [self.searchController.tableView reloadData];
    }
}

/**
 搜索返回后数据源更改成原来的数据源
 */
- (void)didDismissSearchController:(QMUISearchController *)searchController {
    self.searchResultArray = nil;
    self.identificationStr = nil;//取消搜索置空，
    [self.tableView reloadData];
}

- (void)getHeaderOrgWithPNum:(NSString *)pNum {
    
    RLMResults *orgResults = [YSDepartmentModel objectsWhere:[NSString stringWithFormat:@"num = '%@'", pNum]];//当前页所属部门,
    if ([pNum integerValue] == 1) {//第一页标题固定
        [self.headerOrgMutableArray addObjectsFromArray:@[@"内部通讯录", @"联系人"]];
		
    } else {
        YSDepartmentModel *orgModel = orgResults[0];
        if ([orgModel.num isEqualToString:@"1"]) {//根目录页标题不添加进去
            
        }else{
            [self.headerOrgMutableArray addObject:orgModel.name];
        }
       
        DLog(@"header----%@ pNum----%@",self.headerOrgMutableArray,orgModel.pNum);
        [self getHeaderOrgWithPNum:orgModel.pNum];
    }
}

- (void)confirmSelectedPerson {
    NSString *personConditions = [NSString stringWithFormat:@"isSelected = YES AND delFlag = '%@' AND postStatus = '%@' AND status = '%@' AND isPublic != '%ld'",self.delFlag,self.postStatus,self.status,self.isPublic];
    RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"%@", personConditions]];
    
    DLog(@"已选人员:%@", results);
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationPostSelectedPerson object:nil userInfo:@{@"selectedArray": results,@"selectIndexPath":self.indexPath}];
    [self clearAllSelectedPerson];
    for (int i = 0; i < self.rt_navigationController.rt_viewControllers.count; i ++) {
        YSContactSelectPersonViewController *viewController = self.rt_navigationController.rt_viewControllers[i];
        if ([viewController isKindOfClass:[YSContactSelectPersonViewController class]]) {
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
    RLMResults *allResults = [YSContactModel allObjects];
    for (YSContactModel *model in allResults) {
        model.isSelected = NO;
    }
    [realm commitWriteTransaction];
}
#pragma mark - 通讯录头部点击视图代理方法
- (void)contactHeaderViewDepartmentButton:(UIButton *)departmentButton
{
        if ([self.jumpSourceStr isEqualToString:@"EMS"] ||[self.jumpSourceStr isEqual:@"日程"]) {
            UIViewController *viewController = self.rt_navigationController.rt_viewControllers[departmentButton.tag - 100 + 2];
            [self.rt_navigationController popToViewController:viewController animated:YES];
        }else if ([self.jumpSourceStr isEqualToString:@"ITSM"]){
            UIViewController *viewController = self.rt_navigationController.rt_viewControllers[departmentButton.tag - 100 + 2];
            [self.rt_navigationController popToViewController:viewController animated:YES];
        }else if ([self.jumpSourceStr isEqualToString:@"flowLaunch"]){
            UIViewController *viewController = self.rt_navigationController.rt_viewControllers[departmentButton.tag - 100 + 3];
            [self.rt_navigationController popToViewController:viewController animated:YES];
        }else if([self.jumpSourceStr isEqualToString:@"flowChange"]){
            UIViewController *viewController = self.rt_navigationController.rt_viewControllers[departmentButton.tag - 100 + 4];
            [self.rt_navigationController popToViewController:viewController animated:YES];
        }
}
- (void)dealloc {
   
}
@end
