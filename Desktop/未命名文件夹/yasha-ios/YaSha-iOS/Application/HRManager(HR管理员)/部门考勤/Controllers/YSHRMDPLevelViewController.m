//
//  YSHRMDPLevelViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMDPLevelViewController.h"
#import "YSHRMDPLevelHeaderView.h"
#import "YSHRMSSubAllTableViewCell.h"
#import "YSManagerHRBaseViewController.h"
#import "YSNetManagerCache.h"
#import "YSHRManagerInfoHGViewController.h"
#import "YSContactModel.h"
#import "YSTeamCompilePostModel.h"

@interface YSHRMDPLevelViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *paramDic;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) RefreshStateType refreshType;

@end

@implementation YSHRMDPLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deptId = @"";
    self.year = [NSString stringWithFormat:@"%ld", (long)[[[NSDate date] dateByAddingHours:8] year]-1];
    [self loadSubViews];
    [self.paramDic setObject:[NSString stringWithFormat:@"%ld", (long)[[[NSDate date] dateByAddingHours:8] year]-1] forKey:@"year"];
    [self getTeamPerfTotalNetwork];
    [self refreshDeptTeamPerforDataWith:(RefreshStateTypeHeader)];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"sreenDeptHRLevel" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self.paramDic setObject:[x.userInfo objectForKey:@"deptIds"] forKey:@"queryDeptIds"];
        YSHRMDPLevelHeaderView *headerView = [self.view viewWithTag:1556];
        headerView.titLab.text = [x.userInfo objectForKey:@"deptName"];
        [self getTeamPerfTotalNetwork];
        [self refreshDeptTeamPerforDataWith:(RefreshStateTypeHeader)];
    }];
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSHRMSSubAllTableViewCell class] forCellReuseIdentifier:@"levelreward"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kWidthScale);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kWidthScale);

    YSWeak;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        YSStrong;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [strongSelf refreshDeptTeamPerforDataWith:(RefreshStateTypeHeader)];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        YSStrong;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [strongSelf refreshDeptTeamPerforDataWith:(RefreshStateTypeFooter)];
    }];
}

- (void)layoutTableView {
    [super layoutTableView];
    self.tableView.frame = CGRectMake(0, 193*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-kTopHeight-193*kHeightScale-40*kHeightScale);
}

- (void)loadSubViews {
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    NSDictionary *deptTreeDic = @{@"name":@"亚厦集团"};
    if (0 != [[dataDic objectForKey:@"data"] count]) {
        deptTreeDic = [dataDic objectForKey:@"data"][0];
        [self.paramDic setObject:@"" forKey:@"queryDeptIds"];
    }
    YSHRMDPLevelHeaderView *headerView = [[YSHRMDPLevelHeaderView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 193*kHeightScale)) withType:1];
    [headerView.yearButton setTitle:self.year forState:(UIControlStateNormal)];
    headerView.tag = 1556;
    headerView.titLab.text = [deptTreeDic objectForKey:@"name"];
    YSWeak;
    headerView.selectYearBlock = ^(NSString * _Nonnull currentSelectedYear) {
        YSStrong;
        [strongSelf.paramDic setObject:currentSelectedYear forKey:@"year"];
        [strongSelf getTeamPerfTotalNetwork];
        [strongSelf refreshDeptTeamPerforDataWith:(RefreshStateTypeHeader)];
    };
    headerView.choseSequenceBlock = ^(NSInteger index) {
        YSStrong;
        //0~6 全部到E级别
        switch (index) {
            case 0:
                {// 全部
                    [strongSelf.paramDic removeObjectForKey:@"level"];
                }
                break;
            case 1:
            {// S级别
                [strongSelf.paramDic setObject:@"S" forKey:@"level"];
            }
                break;
            case 2:
            {// A
                [strongSelf.paramDic setObject:@"A" forKey:@"level"];
            }
                break;
            case 3:
            {// B
                [strongSelf.paramDic setObject:@"B" forKey:@"level"];
            }
                break;
            case 4:
            {// C
                [strongSelf.paramDic setObject:@"C" forKey:@"level"];
            }
                break;
            case 5:
            {// D
                [strongSelf.paramDic setObject:@"D" forKey:@"level"];
            }
                break;
            case 6:
            {// E
                [strongSelf.paramDic setObject:@"E" forKey:@"level"];
            }
                break;
            default:
                break;
        }
        
        [strongSelf refreshDeptTeamPerforDataWith:(RefreshStateTypeHeader)];
    };
    [self.view addSubview:headerView];
}

- (void)getTeamPerfTotalNetwork {
    [QMUITips showLoadingInView:self.view];
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.paramDic[@"queryDeptIds"] forKey:@"deptIds"];
    [paramDic setObject:[self.paramDic objectForKey:@"year"] forKey:@"year"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getTeamPerfTotal] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"部门绩效统计信息:%@", response);
        if (1 == [[response objectForKey:@"code"] integerValue]) {
            YSHRMDPLevelHeaderView *headerView = [self.view viewWithTag:1556];
            [headerView upLevelBtnViewdataWith:[response objectForKey:@"data"]];
        }
        
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}

- (void)doNetwork {
    [QMUITips showLoadingInView:self.view];
    [self.paramDic setObject:@(kPageSize) forKey:@"pageSize"];
    [self.paramDic setObject:@(self.pageNumber) forKey:@"pageNumber"];
    self.year = self.paramDic[@"year"];
    self.deptId = self.paramDic[@"queryDeptIds"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getDepartmentPerformanceInfo] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
        DLog(@"部门绩效-绩效等级:%@", response);
        [QMUITips hideAllToastInView:self.view animated:NO];
        [self.tableView scrollRectToVisible:(CGRectMake(0, 0, 0.1, 0.1)) animated:NO];
        if ([[response objectForKey:@"code"] integerValue] == 1) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[YSDataManager getTeamMyAllAuthorizedData:[response objectForKey:@"data"]]];
            [self handelDataAddModelImgWith:dataArray];
            if (self.refreshType == RefreshStateTypeHeader) {
                self.dataArray = [NSMutableArray arrayWithArray:dataArray];
            }else {
                [self.dataArray addObjectsFromArray:dataArray];
            }
            if (dataArray.count < kPageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}
// 增加头像
- (void)handelDataAddModelImgWith:(NSMutableArray* _Nonnull)dataArray {
    [dataArray enumerateObjectsUsingBlock:^(YSTeamCompilePostModel  * compileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", compileModel.code];
        RLMResults *results = [[YSContactModel objectsWithPredicate:predicate]  sortedResultsUsingKeyPath:@"userId" ascending:YES];
        if ([results count] != 0) {
            YSContactModel *resultsModel = results[0];
            compileModel.headImage = [NSString stringWithFormat:@"%@_S.jpg", resultsModel.headImg];
        }
    }];
    
}

- (void)refreshDeptTeamPerforDataWith:(RefreshStateType)type {
    self.refreshType = type;
    if (type == RefreshStateTypeHeader) {
        self.pageNumber = 1;
    }else {
        self.pageNumber = self.pageNumber + 1;
    }
    [self doNetwork];
}

#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48*kHeightScale;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHRMSSubAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"levelreward" forIndexPath:indexPath];
    // 更改布局
    cell.perforModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSTeamCompilePostModel *model = self.dataArray[indexPath.row];
    YSHRManagerInfoHGViewController *infoVC = [YSHRManagerInfoHGViewController new];
    infoVC.userNo = model.code;
    [self.navigationController pushViewController:infoVC animated:nil];
}

#pragma mark--setter&&getter
- (NSMutableDictionary *)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
