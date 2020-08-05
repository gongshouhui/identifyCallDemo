
//  YSContactSelectPeopleViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/9.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactSelectPeopleViewController.h"
#import "YSContactModel.h"
#import "YSContactSelectCell.h"
#import "YSContactDetailViewController.h"
#import "YSContactSelectPeopleBottomView.h"
#import "YSContactHeaderView.h"
static NSString *cellIdentifier = @"ContactSelectCell";

@interface YSContactSelectPeopleViewController ()<YSContactHeaderViewDelegate>
@property (nonatomic,strong)  NSArray *searchResultArray;
@property (nonatomic, strong) NSArray *currentDatasourceArray;
@property (nonatomic, strong) YSContactSelectPeopleBottomView *contactSelectPeopleBottomView;
@property (nonatomic, strong) YSContactSelectPeopleBottomView *inputAccessoryView;
@property (nonatomic, strong) NSMutableArray *headerOrgMutableArray;
@property (nonatomic, strong) NSString *identificationStr; // 判别是否是搜索状态
@property (nonatomic,strong) YSContactHeaderView *sectionHeaderView;
@end

@implementation YSContactSelectPeopleViewController
- (YSContactHeaderView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[YSContactHeaderView alloc]init];
        _sectionHeaderView.delegate = self;
    }
    return _sectionHeaderView;
}
// 懒加载
- (NSMutableArray *)headerOrgMutableArray {
    if (!_headerOrgMutableArray) {
        _headerOrgMutableArray = [NSMutableArray array];
    }
    return _headerOrgMutableArray;
}
- (YSContactSelectPeopleBottomView *)contactSelectPeopleBottomView {
    if (!_contactSelectPeopleBottomView) {
        _contactSelectPeopleBottomView = [[YSContactSelectPeopleBottomView alloc]init];
        YSWeak;
        [_contactSelectPeopleBottomView.sendConfirmSubject subscribeNext:^(id x) {
            [weakSelf confirmSelectedPeople];
        }];
    }
    return  _contactSelectPeopleBottomView;
}
- (instancetype)init {
    if (self = [super init]) {
        self.pNum = @"1";
        self.isRootDirectory = YES;
        self.delFlag = @"1";
        self.postStatus = @"1";
        self.status = @"1";
        self.isPublic = 0;
    }
    return self;
}
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSContactSelectCell class] forCellReuseIdentifier:cellIdentifier];
    [self getContactData];
    [self addBottomView];
    [self monitorAction];//监听全选
}

// 查询当前界面部门或公司的子级是否是全选状态
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (NSArray *rowArray in self.dataSource) {
        for (YSDepartmentModel *model in rowArray) {
            [self getSubSelectedStatusWithContactModel:model];
        }
    }
    [realm commitWriteTransaction];
    [self.tableView reloadData];
    [self addBottomView];
    [self.contactSelectPeopleBottomView updateSelectCountWithpDatasourceArray:self.dataSource andIsRootView:self.isRootDirectory];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.contactSelectPeopleBottomView removeFromSuperview];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"内部通讯录";
}

// 全选操作
- (void)monitorAction {
    YSWeak;
    [self.contactSelectPeopleBottomView.sendSelectAllSubject subscribeNext:^(QMUIButton *button) {
        YSStrong;
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        // 在通讯录的根目录
        if (strongSelf.isRootDirectory) {
            if ([strongSelf.identificationStr isEqualToString:@"搜索"]) {
                for (YSContactModel *model in strongSelf.searchResultArray[0]) {
                    model.isSelected = !model.isSelected;
                }
            }
        }else{  //子目录
            for (YSContactModel *model in strongSelf.dataSource[0]) {
                model.isSelected = button.isSelected;
            }
        }
        [realm commitWriteTransaction];
        [strongSelf.contactSelectPeopleBottomView updateSelectCountWithpDatasourceArray:strongSelf.dataSource andIsRootView:strongSelf.isRootDirectory];
        [strongSelf.tableView reloadData];
        [strongSelf.searchController.tableView reloadData];
        [(YSContactSelectPeopleBottomView *)strongSelf.searchController.searchBar.inputAccessoryView updateSelectCountWithpDatasourceArray:strongSelf.dataSource andIsRootView:strongSelf.isRootDirectory];
    }];
    
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
    //    self.currentDatasourceArray = self.dataSource;
    [self getHeaderOrgWithPNum:_pNum];
    /** 数组倒序 */
    NSArray *headerOrgArray = [[self.headerOrgMutableArray reverseObjectEnumerator] allObjects];
    [self.sectionHeaderView setHeaderArray:headerOrgArray];
    [self.tableView reloadData];
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
    YSContactSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSContactSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *postDic;
    if (tableView == self.tableView) {
        YSContactModel *model = self.dataSource[indexPath.section][indexPath.row];
        if ([model isKindOfClass:[YSContactModel class]]) {
            [cell setCellModel:model];
        }else{
            [cell setDepartmentModel:(YSDepartmentModel *)model];
        }
        postDic = @{
                    @"indexPath": indexPath,
                    @"model": model
                    };
    }else{
        YSContactModel *model = self.searchResultArray[indexPath.section][indexPath.row];
        [cell setCellModel:model];
        postDic = @{
                    @"indexPath": indexPath,
                    @"model": model
                    };
    }
    cell.selectButton.userInteractionEnabled = NO;
    //    objc_setAssociatedObject(cell.selectButton, "postDic", postDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //    [cell.selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSArray *rowArray = self.dataSource[indexPath.section];
    YSContactModel *model = tableView == self.tableView ? self.dataSource[indexPath.section][indexPath.row] : self.searchResultArray[indexPath.section][indexPath.row];
    if (self.isRootDirectory) {
        if ([self.identificationStr isEqualToString:@"搜索"]) {
            YSContactSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectButton.selected = !cell.selectButton.selected;
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            model.isSelected = !model.isSelected;
            [realm commitWriteTransaction];
            [ self.contactSelectPeopleBottomView updateSelectCountWithpDatasourceArray:self.dataSource andIsRootView:self.isRootDirectory];
        }else{
            YSContactSelectPeopleViewController *contactSelectPeopleViewController = [[YSContactSelectPeopleViewController alloc] init];
            contactSelectPeopleViewController.isRootDirectory = NO;
            contactSelectPeopleViewController.pNum = model.num;
            [self.navigationController pushViewController:contactSelectPeopleViewController animated:YES];
        }
    } else {
        if (indexPath.section == 0) {
            YSContactSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectButton.selected = !cell.selectButton.selected;
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            model.isSelected = !model.isSelected;
            [realm commitWriteTransaction];
            [ self.contactSelectPeopleBottomView updateSelectCountWithpDatasourceArray:self.dataSource andIsRootView:self.isRootDirectory];
        }else {
            YSContactSelectPeopleViewController *contactSelectPeopleViewController = [[YSContactSelectPeopleViewController alloc] init];
            contactSelectPeopleViewController.isRootDirectory = NO;
            contactSelectPeopleViewController.pNum = model.num;
            [self.navigationController pushViewController:contactSelectPeopleViewController animated:YES];
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? 50*kHeightScale : _isRootDirectory ? 50*kHeightScale : 0.01 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.tableView == tableView && section == 0) {
        return self.sectionHeaderView;
    }else{
        return nil;
    }
}
#pragma mark -  点击选择按钮响应事件
- (void)selectAction:(QMUIButton *)button {
    button.selected = !button.selected;
    NSDictionary *postDic = objc_getAssociatedObject(button, "postDic");
    NSIndexPath *indexPath = postDic[@"indexPath"];
    YSDepartmentModel *model = postDic[@"model"];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if (self.isRootDirectory) {
        // 部门下的数据递归操作
        if (indexPath.section == 0) {
            [self getPersonModelAndOrgModel:model isSelected:!model.isSelected];
            [realm commitWriteTransaction];
            [ self.contactSelectPeopleBottomView updateSelectCountWithpDatasourceArray:self.dataSource andIsRootView:self.isRootDirectory];
        }
    }else {
        if (indexPath.section == 0) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            model.isSelected = !model.isSelected;
            [realm commitWriteTransaction];
            [ self.contactSelectPeopleBottomView updateSelectCountWithpDatasourceArray:self.dataSource andIsRootView:self.isRootDirectory];
        }else{
            [self getPersonModelAndOrgModel:model isSelected:!model.isSelected];
            [realm commitWriteTransaction];
            [ self.contactSelectPeopleBottomView updateSelectCountWithpDatasourceArray:self.dataSource andIsRootView:self.isRootDirectory];
        }
    }
}
#pragma mark - 数据处理
- (void)getPersonModelAndOrgModel:(YSDepartmentModel *)orgModel isSelected:(BOOL)isSelected {
    orgModel.isSelected = isSelected;
    NSString *personConditions = [NSString stringWithFormat:@"pNum = '%@' AND isOrg = NO AND delFlag = '%@' AND postStatus = '%@' AND status = '%@' AND isPublic != '%ld'", orgModel.num, self.delFlag,self.postStatus,self.status,self.isPublic];
    RLMResults *personResults = [[YSContactModel objectsWhere:personConditions] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];
    
    NSString *orgConditions = [NSString stringWithFormat:@"pNum = '%@' AND delFlag = '%@' AND status = '%@' AND isPublic != '%ld'", orgModel.num, self.delFlag, self.status, (long)self.isPublic];
    RLMResults *orgResults = [[YSDepartmentModel objectsWhere:orgConditions] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];
    for (YSContactModel *personModel in personResults) {
        personModel.isSelected = isSelected;
    }
    for (YSDepartmentModel *subModel in orgResults) {
        subModel.isSelected = isSelected;
        [self getPersonModelAndOrgModel:subModel isSelected:isSelected];
        
        
    }
}

// 查询当前子部门目录下是否有选中的状态
- (void)getSubSelectedStatusWithContactModel:(YSDepartmentModel *)contactModel {
    RLMResults *subResults = [YSDepartmentModel objectsWhere:[NSString stringWithFormat:@"pNum = '%@'", contactModel.num]];
    for (YSDepartmentModel *subModel in subResults) {
        if (subModel.isSelected) {
            contactModel.isSelected = YES;
            [self getSubSelectedStatusWithContactModel:subModel];
        } else {
            contactModel.isSelected = NO;
        }
    }
    NSString *personConditions = [NSString stringWithFormat:@"pNum = '%@' AND isOrg = NO AND delFlag = '%@' AND postStatus = '%@' AND status = '%@' AND isPublic != '%ld'", contactModel.num, self.delFlag,self.postStatus,self.status,self.isPublic];
    RLMResults *personResults = [[YSContactModel objectsWhere:personConditions] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];
    for (YSContactModel *subModel in personResults) {
        if (subModel.isSelected) {
            contactModel.isSelected = YES;
            return;
        } else {
            contactModel.isSelected = NO;
        }
    }
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

//清空选择
- (void)clearAllSelectedPeople {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults *allResults = [YSContactModel allObjects];
    RLMResults *depAllResults = [YSDepartmentModel allObjects];
    for (YSContactModel *model in allResults) {
        model.isSelected = NO;
    }
    for (YSDepartmentModel *model in depAllResults) {
        model.isSelected = NO;
    }
    [realm commitWriteTransaction];
}

#pragma mark - 键盘监听
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [self.contactSelectPeopleBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50*kHeightScale);
        make.bottom.mas_equalTo(-height);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.contactSelectPeopleBottomView layoutIfNeeded];
    }];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.contactSelectPeopleBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50*kHeightScale);
        make.bottom.mas_equalTo(-kBottomHeight);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        
    }];
    
}
#pragma mark - 搜索代理方法
- (BOOL)shouldShowSearchBar {
    return YES;
}

/**
 搜索返回后数据源更改成原来的数据源
 */
- (void)didDismissSearchController:(QMUISearchController *)searchController {

    self.searchResultArray = nil;
    self.identificationStr = nil;//取消搜索置空，
    // 如果搜索的人员在当前页，则相应的更改当前页的数据
    [self.contactSelectPeopleBottomView updateSelectCountWithpDatasourceArray:self.dataSource andIsRootView:self.isRootDirectory];
    [self.tableView reloadData];
}

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    if (searchString.length != 0) {
        DLog(@"searchString:%@", searchString);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(companyName CONTAINS[c]%@ || deptName CONTAINS[c] %@ || email CONTAINS %@ || name CONTAINS[c] %@ || userId CONTAINS %@ || shortPhone CONTAINS %@ || shortWorkPhone CONTAINS %@ || mobile CONTAINS %@ || phone CONTAINS %@) AND isOrg = NO AND delFlag = '1' AND postStatus = '1' AND status = '1' AND isPublic != '0'", searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString];
        DLog(@"查询语句:%@", predicate);
        RLMResults *results = [YSContactModel objectsWithPredicate:predicate];
        self.identificationStr = @"搜索";
        self.searchResultArray = @[results];
        
        [self.searchController.tableView reloadData];
    }
}

#pragma mark - contactSelectPeopleBottomView 确定按钮点击事件
- (void)confirmSelectedPeople {
    RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"isSelected = YES AND isOrg = NO"]];
    DLog(@"已选人员:%@", results);
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationPostSelectedPeolple object:nil userInfo:@{@"selectedArray": results}];
    [self clearAllSelectedPeople];
    for (int i = 0; i < self.rt_navigationController.rt_viewControllers.count; i ++) {
        YSContactSelectPeopleViewController *viewController = self.rt_navigationController.rt_viewControllers[i];
        if ([viewController isKindOfClass:[YSContactSelectPeopleViewController class]]) {
            if (viewController.isRootDirectory) {
                UIViewController *popViewController = self.rt_navigationController.rt_viewControllers[i-1];
                [self.rt_navigationController popToViewController:popViewController animated:YES];
            }
        }
    }
}

- (void)addBottomView {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.contactSelectPeopleBottomView];
    //self.contactSelectPeopleBottomView.frame = CGRectMake(0, kSCREEN_HEIGHT-50*kHeightScale-kBottomHeight, kSCREEN_WIDTH, 50*kHeightScale+kBottomHeight);
    [self.contactSelectPeopleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50*kHeightScale);
        make.bottom.mas_equalTo(-kBottomHeight);
    }];
}
#pragma mark - 通讯录头部点击视图代理方法
- (void)contactHeaderViewDepartmentButton:(UIButton *)departmentButton
{
    UIViewController *viewController = self.rt_navigationController.rt_viewControllers[departmentButton.tag - 100 + 3];
    [self.rt_navigationController popToViewController:viewController animated:YES];
}
- (void)dealloc {
    if (self.isRootDirectory == YES) {
        [self clearAllSelectedPeople];//如果担心这个视图控制器内存泄漏，可以重写pop方法，清空选择的数据
    }
    
    DLog(@"释放");
}
@end
