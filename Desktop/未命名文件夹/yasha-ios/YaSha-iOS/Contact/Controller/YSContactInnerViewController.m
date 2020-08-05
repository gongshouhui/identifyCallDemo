//
//  YSContactInnerViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/3/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactInnerViewController.h"
#import "YSContactModel.h"
#import "YSDepartmentModel.h"
#import "YSContactCell.h"
#import "YSContactDetailViewController.h"
#import "AppDelegate.h"
#import "AppDelegate+YSSetupAPP.h"
#import "YSContactHeaderView.h"
static NSString *cellIdentifier = @"ContactCell";

@interface YSContactInnerViewController ()<YSContactHeaderViewDelegate>
@property (nonatomic,strong)  NSArray *searchResultArray;
@property (nonatomic, strong) NSMutableArray *headerOrgMutableArray;
@property (nonatomic, strong) NSString *identificationStr;
@property (nonatomic,strong) RLMNotificationToken *token;
@property (nonatomic,assign) NSInteger totalPerson;
@property (nonatomic,strong) YSContactHeaderView *sectionHeaderView;
@end

@implementation YSContactInnerViewController
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
- (instancetype)init {
    if (self = [super init]) {
        self.pNum = @"1";
        self.isRootDirectory = YES;
        self.delFlag = @"1";
        self.postStatus = @"1";
        self.status = @"1";
        self.isPublic = 0;  //0 不显示，1/2/3 显示
    }
    return self;
}
//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"内部通讯录"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"内部通讯录"];
    
}



- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"内部通讯录";
    //导航栏按钮
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"关闭" position:QMUINavigationButtonPositionRight target:self action:@selector(close)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isRootDirectory) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getContactFailure) name:@"updateAllContactFailure" object:nil];//监听工作台请求通讯录接口失败的情况，留给用户点击重新拉取的机会
    }
}
- (void)initTableView {
    [super initTableView];
    self.title = @"内部通讯录";
    RLMResults *results = [YSContactModel allObjects];
    //数据库开始写入时回调一次，写入完成时回调一次,改动时也会调用一次
    YSWeak;
    self.token = [results addNotificationBlock:^(RLMResults<YSDepartmentModel *> *results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        YSStrong;
        if (!change || error || ![results count]) {
            return ;
        }
        [strongSelf getContactData];//数据写入成功的时候会换一次数据源，注意不要和搜索后换数据源冲突，在数据没有存储完的时候禁止搜索
        //数据m每一次改动后都要刷新tableView ，不然就会出现数据源和界面不一致的情况，特别是realm数据库数据减少会出现数组越界
        //realm数据库有改动已经查询的数据是直接改变的，当用户进入通讯录界面，并展示数据成功，当用户点击的时候（通讯录有有更新全量或增量导致数据库发生变化，如果全量更新，先删除通讯录数据事务，这时候还没回调界面未刷新），数据源有变化引起奔溃
    }];
    [self.tableView registerClass:[YSContactCell class] forCellReuseIdentifier:cellIdentifier];
    [self getContactData];
}
#pragma mark - 返回按钮点击事件
- (void)close {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)getContactData {
    
    [self.headerOrgMutableArray removeAllObjects];
    self.searchResultArray = nil;//当处于搜索结果页面时，如果收到数据库变动的通知，需要置空数据，刷新结果集控制器
    [self.searchController.tableView reloadData];//如果没有搜索操作，self.searchController.tableView为空，给空对象发消息什么都不做
    self.dataSource = nil;//无论是在通讯录页面还是搜索结果页面，数据库有变动都要把以前的查询结果置空，然后重新查询并刷新tabView，因为realm数据库和查询结果变化是实时更新的，而页面显示的数据就会和数据源不在一一对应了
    NSPredicate *orgConditions = [NSPredicate predicateWithFormat:@"pNum = %@ AND delFlag = %@ AND status = %@ AND isPublic != '0'", self.pNum, self.delFlag, self.status];
    NSPredicate *personConditions = [NSPredicate predicateWithFormat:@"pNum = %@ AND isOrg = NO AND delFlag = %@ AND postStatus = %@ AND status = %@ AND isPublic != '0'", self.pNum, self.delFlag,self.postStatus,self.status];
    DLog(@"查询条件====%@----%@",orgConditions,personConditions);
    RLMResults *orgResults = [[YSDepartmentModel objectsWithPredicate:orgConditions] sortedResultsUsingKeyPath:@"sortNo" ascending:YES];
    RLMResults *personResults = [[[YSContactModel objectsWithPredicate:personConditions] sortedResultsUsingKeyPath:@"userId" ascending:YES] sortedResultsUsingKeyPath:@"sortNo" ascending:NO];
    if (orgResults.count > 0 || personResults.count > 0) {
        
        //[self.token invalidate];//如果第一次进来数据库有值，通知监听取消，界面出现，当工作台开始的通讯录更新完成这里也没有刷新了，而realm是直接变化的，会导致数据源和界面对不上导致越界闪退，所以决定不取消监听
        [QMUITips hideAllTipsInView:self.view];
        // 根目录只有公司
        self.dataSource = self.isRootDirectory ? @[orgResults] : @[personResults, orgResults];
        
        // //获取区头数据
        [self getHeaderOrgWithPNum:_pNum];
        /** 数组倒序 */
        NSArray *headerOrgArray = [[self.headerOrgMutableArray reverseObjectEnumerator] allObjects];
        [self.sectionHeaderView setHeaderArray:headerOrgArray];
        [self.tableView reloadData];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            //获取人数
//            [self getCurrentDepartMentAndSubNumWith:_pNum];
//            //重c组区头数据
//            NSString *departWithNum = [NSString stringWithFormat:@"%@（%ld人）",headerOrgArray.lastObject,self.totalPerson];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                  [self.sectionHeaderView setlastDepartMentButtonWithTitle:departWithNum];
//            });
//        });
    }else{
        AppDelegate *delegae = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (self.isRootDirectory) {//通讯录第一个界面展示加载动画，这个时候数据可能还没有展示完全
            [QMUITips showLoading:@"正在努力拉取中..." inView:self.view];
            if (delegae.getContactFailure) {//如果是工作台拉取失败，当用户进入通讯录才重新拉取
                [self doNetworking];
            }
            
        }
    }
}

#pragma mark - tableViewDelete
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
    YSContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (tableView == self.tableView) {
        YSContactModel *model = self.dataSource[indexPath.section][indexPath.row];
        if ([model isKindOfClass:[YSContactModel class]]) {//人员
            [cell setCellModel:model];
        }else{//部门
            [cell setDepartmentModel:model];
        }
    }else{//搜索tabView(搜索结果都是人)
        YSContactModel *model = self.searchResultArray[indexPath.section][indexPath.row];
        [cell setCellModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        YSContactModel *model = self.dataSource[indexPath.section][indexPath.row];
        if ([model isKindOfClass:[YSContactModel class]]) {//人员
            YSContactDetailViewController *contactDetailViewController = [[YSContactDetailViewController alloc] init];
            contactDetailViewController.contactModel = model;
            [self.navigationController pushViewController:contactDetailViewController animated:YES];
        }else{//部门
            YSContactInnerViewController *contactInnerViewController = [[YSContactInnerViewController alloc] init];
            contactInnerViewController.isRootDirectory = NO;
            contactInnerViewController.pNum = model.num;
            [self.navigationController pushViewController:contactInnerViewController animated:YES];
        }
    }else{//搜索tabView(搜索结果都是人)
        YSContactModel *model = self.searchResultArray[indexPath.section][indexPath.row];
        YSContactDetailViewController *contactDetailViewController = [[YSContactDetailViewController alloc] init];
        contactDetailViewController.contactModel = model;
        [self.navigationController pushViewController:contactDetailViewController animated:YES];
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
- (void)getCurrentDepartMentAndSubNumWith:(NSString *)num{
    //计算当前页及子部门总人数
    NSPredicate *orgConditions = [NSPredicate predicateWithFormat:@"pNum = %@ AND delFlag = %@ AND status = %@ AND isPublic != '0'", num, self.delFlag, self.status];
    NSPredicate *personConditions = [NSPredicate predicateWithFormat:@"pNum = %@ AND isOrg = NO AND delFlag = %@ AND postStatus = %@ AND status = %@ AND isPublic != '0'", num, self.delFlag,self.postStatus,self.status];
    DLog(@"查询条件====%@----%@",orgConditions,personConditions);
    RLMResults *orgResults = [YSDepartmentModel objectsWithPredicate:orgConditions];
    RLMResults *personResults = [YSContactModel objectsWithPredicate:personConditions];
    self.totalPerson += personResults.count;
    if (orgResults.count) {
     for (YSDepartmentModel *model in orgResults) {
         [self getCurrentDepartMentAndSubNumWith:model.num];
     }
    }
}
/**
 搜索人员
 */
- (BOOL)shouldShowSearchBar {
    return YES;
}
- (BOOL)shouldHideSearchBarWhenEmptyViewShowing {
    return YES;
}
//在数据没有存储完的时候禁止搜索
- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    
    if (searchString.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(companyName CONTAINS[c] %@ || deptName CONTAINS[c] %@ || email CONTAINS %@ || name CONTAINS[c] %@ || userId CONTAINS %@ || shortPhone CONTAINS %@ || shortWorkPhone CONTAINS %@ || mobile CONTAINS %@ || phone CONTAINS %@) AND isOrg = NO AND delFlag = '1' AND postStatus = '1' AND status = '1' AND isPublic != '0'", searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString, searchString];
        DLog(@"查询语句:%@", predicate);
        RLMResults *results = [[YSContactModel objectsWithPredicate:predicate]  sortedResultsUsingKeyPath:@"userId" ascending:YES];
        self.searchResultArray = @[(NSArray *)results];
        [self.searchController.tableView reloadData];
        
    }
    /** 谓词查询NSPredicate ，比用s[NSString stringWithFormait:]g更安全*********/
    //realm 官方查询写法，
    // Query using a predicate string
    //    RLMResults<Dog *> *tanDogs = [Dog objectsWhere:@"color = 'tan' AND name BEGINSWITH 'B'"];
    //
    //    // Query using an NSPredicate
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"color = %@ AND name BEGINSWITH %@",
    //                         @"tan", @"B"];
    //    tanDogs = [Dog objectsWithPredicate:pred];
}

/**
 搜索返回后数据源更改成原来的数据源
 */

- (void)didDismissSearchController:(QMUISearchController *)searchController {
    self.searchResultArray = nil;
    [self.tableView reloadData];
}

- (void)getContactFailure {
    [QMUITips hideAllTipsInView:self.view];
    [self ys_reloadData];
}
- (void)doNetworking {
    [QMUITips showLoading:@"正在努力拉取中..." inView:self.view];
    AppDelegate *delegae = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegae saveContactWithAll:YES];
}

#pragma mark - 通讯录头部点击视图代理方法
- (void)contactHeaderViewDepartmentButton:(UIButton *)departmentButton
{
//	if(departmentButton.tag -100 == 2){//点击亚厦控股
//		//点击亚厦控股的效果和点击内部通讯录的效果一样
//		[self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//	}else
//	if(departmentButton.tag -100 <= 1){//最前面两个button 联系人 内部通讯录
//		 [self.navigationController popToViewController:self.navigationController.viewControllers[departmentButton.tag - 100] animated:YES];
//	}else{//在亚厦控股后面按钮
		 [self.navigationController popToViewController:self.navigationController.viewControllers[departmentButton.tag - 100] animated:YES];
//	}
	
}

- (void)dealloc {
    DLog(@"通讯录释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.token invalidate];
}

@end
