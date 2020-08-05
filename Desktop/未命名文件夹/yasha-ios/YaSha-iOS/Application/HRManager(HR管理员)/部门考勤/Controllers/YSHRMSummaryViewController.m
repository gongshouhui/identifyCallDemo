//
//  YSHRMSummaryViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

// 汇总
#import "YSHRMSummaryViewController.h"
#import "YSHRMSummaryHeaderView.h"
#import "YSHRMSummarySectionheaderrView.h"
#import "YSHRMSummaryTableViewCell.h"
#import "QMUITableView.h"
#import "YSHRMDSummarySubViewController.h"
#import "YSSummaryModel.h"
#import "YSHRMTSummaryModel.h"
#import "YSHRMAttendanceViewController.h"
#import "YSNetManagerCache.h"
#import "YSHRMTDeptTreeViewController.h"//部门树
#import "YSRightToLeftTransition.h"//动画
#import "YSHRManagerInfoHGViewController.h"//Ta的资料
#import "YSAttendanceNewPageController.h"//个人考勤

@interface YSHRMSummaryViewController ()<YSHRMSummaryHeaderDelegate>

@property (nonatomic, strong) YSHRMSummaryHeaderView *headerView;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, strong) YSSummaryModel *model;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger optionBtnIndex;//下属部门~月度统计
@property (nonatomic, assign) RefreshStateType refreshType;
@property (nonatomic, strong) NSMutableDictionary *paramDic;
@property (nonatomic, assign) NSInteger pageNumber;


@end


@implementation YSHRMSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor whiteColor];
    self.timeStr = [NSString stringWithFormat:@"%ld-%ld",[[[NSDate date] dateByAddingHours:0] year],[[[NSDate date] dateByAddingHours:0] month]];
    self.pageNumber = 1;
    if (!self.deptId) {
        NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
        if (0 != [[dataDic objectForKey:@"data"] count]) {
            NSDictionary *deptTreeDic = [dataDic objectForKey:@"data"][0];
            self.deptId = @"";
            self.deptNameStr = [deptTreeDic objectForKey:@"name"];
        }
    }
    self.urlStr = [NSString stringWithFormat:@"%@%@", YSDomain, getManagementData];
    self.optionBtnIndex = 2;
    
    @weakify(self);
    // 选择时间之后
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"selectPerfYear" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.timeStr = [x.userInfo objectForKey:@"time"];
        [self loadData];
    }];
    // 下属部门~月度统计
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"teamSummaryBtn" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.optionBtnIndex = [[x.userInfo objectForKey:@"index"] integerValue]+1;
        [self changeUrlStrWithIndex:self.optionBtnIndex];
        [self refreshBottomViewData:(RefreshStateTypeHeader)];
    }];
    // 选择更改部门之后
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:[NSString stringWithFormat:@"choseSreenCompanyHR%ldVC", self.navigationController.viewControllers.count] object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.deptId = [x.userInfo objectForKey:@"deptIds"];
        self.deptNameStr = [x.userInfo objectForKey:@"deptName"];
        [self changeUrlStrWithIndex:self.optionBtnIndex];
        [self loadData];
    }];
    [self loadData];
    
}



- (void)initTableView {
    [super initTableView];
    _headerView = [[YSHRMSummaryHeaderView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 339*kHeightScale))];
    _headerView.delegate = self;
    self.tableView.tableHeaderView = _headerView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[YSHRMSummarySectionheaderrView class] forHeaderFooterViewReuseIdentifier:@"managerSumHeaderID"];
    [self.tableView registerClass:[YSHRMSummaryTableViewCell class] forCellReuseIdentifier:@"managerSummCEID"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kWidthScale);
    
    YSWeak;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf refreshBottomViewData:(RefreshStateTypeHeader)];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf refreshBottomViewData:(RefreshStateTypeFooter)];
    }];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)loadData {
    [QMUITips showLoadingInView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *paramDic = [NSMutableDictionary new];
        [paramDic setObject:self.timeStr forKey:@"time"];
        [paramDic setObject:self.deptId forKey:@"deptIds"];
        [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getUserTeamSummaryAttendance] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
            dispatch_group_leave(group);
            DLog(@"考勤统计个数:%@", response);
            if (![response[@"data"] isEqual:[NSNull null]]) {
                self.model = [YSSummaryModel yy_modelWithJSON:response[@"data"]];
                // 更新顶部视图
                self.model.typeName = self.deptNameStr;
                [self.headerView upSubViewDataWith:self.model];
            }
        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group);
        } progress:nil];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.paramDic setObject:@(self.pageNumber) forKey:@"pageNumber"];
        [self.paramDic setObject:@(kPageSize) forKey:@"pageSize"];
        [self.paramDic setObject:self.deptId forKey:@"deptId"];
        [self.paramDic setObject:self.timeStr forKey:@"time"];
        
        [YSNetManager ys_request_GETWithUrlString:self.urlStr isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
            dispatch_group_leave(group);
            DLog(@"返回的数据:%@\n下属部门等---%@", response, response[@"data"]);
            if (![response[@"data"] isEqual:[NSNull null]]) {
                
                NSArray *responseData = [YSDataManager getTeamAllAttendanceData:[response objectForKey:@"data"]];
                
                if (self.refreshType == RefreshStateTypeHeader) {
                    self.dataArray = [NSMutableArray arrayWithArray:responseData];
                }else {
                    [self.dataArray addObjectsFromArray:responseData];
                }
                if ([responseData count] < kPageSize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.dataArray removeAllObjects];
            }
            [self.tableView reloadData];
        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group);
        } progress:nil];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [QMUITips hideAllToastInView:self.view animated:YES];
    });
}

- (void)doNetworking {
    
    [QMUITips showLoadingInView:self.view];
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.timeStr forKey:@"time"];
    [paramDic setObject:self.deptId forKey:@"deptIds"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getUserTeamSummaryAttendance] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        DLog(@"考勤汇总统计数据:%@", response[@"data"]);
        if (![response[@"data"] isEqual:[NSNull null]]) {
            [QMUITips hideAllToastInView:self.view animated:YES];
            self.model = [YSSummaryModel yy_modelWithJSON:response[@"data"]];
            // 更新顶部视图
            self.model.typeName = self.deptNameStr;
            [self.headerView upSubViewDataWith:self.model];
        }
    } failureBlock:^(NSError *error) {
        
        [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];
}

- (void)changeUrlStrWithIndex:(NSInteger)index {
    // index 1~3
    [self.dataArray removeAllObjects];
    switch (index-1) {
        case 0:
        {
            self.urlStr = [NSString stringWithFormat:@"%@%@", YSDomain, getSubDepartmentsData];
        }
            break;
        case 1:
        {
            self.urlStr = [NSString stringWithFormat:@"%@%@", YSDomain, getManagementData];
        }
            break;
        case 2:
        {
            self.urlStr = [NSString stringWithFormat:@"%@%@", YSDomain, getMonthlyStatisticsData];
            
        }
            break;
        default:
            break;
    }
}

- (void)getSubDeptDataNetwork {

    
    [QMUITips showLoadingInView:self.view];
    [self.paramDic setObject:@(self.pageNumber) forKey:@"pageNumber"];
    [self.paramDic setObject:@(kPageSize) forKey:@"pageSize"];
    [self.paramDic setObject:self.deptId forKey:@"deptId"];
    [self.paramDic setObject:self.timeStr forKey:@"time"];
    
    [YSNetManager ys_request_GETWithUrlString:self.urlStr isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        DLog(@"返回的数据:%@\n下属部门等---%@", response, response[@"data"]);
        if (![response[@"data"] isEqual:[NSNull null]]) {
            
            NSArray *responseData = [YSDataManager getTeamAllAttendanceData:[response objectForKey:@"data"]];
            
            if (self.refreshType == RefreshStateTypeHeader) {
                self.dataArray = [NSMutableArray arrayWithArray:responseData];
            }else {
                [self.dataArray addObjectsFromArray:responseData];
            }
            if ([responseData count] < kPageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
        [QMUITips hideAllToastInView:self.view animated:YES];
    } progress:nil];
}

#pragma mark--refreshData
- (void)refreshBottomViewData:(RefreshStateType)type {
    self.refreshType = type;
    if (type == RefreshStateTypeHeader) {
        self.pageNumber = 1;
    }else {
        self.pageNumber++;
    }
    [self getSubDeptDataNetwork];
}

#pragma mark--tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47*kHeightScale;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHRMSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"managerSummCEID" forIndexPath:indexPath];
    cell.summaryModel = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSHRMTSummaryModel *model = self.dataArray[indexPath.row];
    switch (self.optionBtnIndex) {
        case 1:
            {//下属部门 跳转到对应公司或部门考勤汇总页面
                YSHRMAttendanceViewController *attendanceVC = [YSHRMAttendanceViewController new];
                attendanceVC.deptId = [self.dataArray[indexPath.row] deptId];
                attendanceVC.deptNameStr = model.name;
                [self.navigationController pushViewController:attendanceVC animated:YES];
            }
            break;
        case 2:
            {//部门管理人员 跳转到对应员工考勤汇总页面
                
                YSAttendanceNewPageController *infoVC = [YSAttendanceNewPageController new];
                infoVC.teamDic = @{@"no":model.no, @"year":self.timeStr};
                [self.navigationController pushViewController:infoVC animated:YES];
                /*
                YSHRManagerInfoHGViewController *infoVC = [YSHRManagerInfoHGViewController new];
                infoVC.userNo = model.no;
                [self.navigationController pushViewController:infoVC animated:YES];
                 */
            }
            break;
        case 3:
            {//月度统计 进入部门考勤记录对应月份页面
                NSArray *timeArray = @[@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy";
                NSString *yearStr = [self.timeStr substringToIndex:4];
                NSInteger month = [timeArray indexOfObject:model.name]+1;
                NSString *timeStr = [NSString stringWithFormat:@"%@-%02ld", yearStr, month];
                // 也可以考虑 使用childVC获得父VC
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"YSHRTMonth%ldVCJump", self.navigationController.viewControllers.count] object:nil userInfo:@{@"time":timeStr}];
            }
            break;
        default:
            break;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSHRMSummarySectionheaderrView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"managerSumHeaderID"];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 130*kHeightScale;
}

//点击导航条上的组织筛选按钮
- (void)clickedScreenBarAction {
    
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    if (0 == [[dataDic objectForKey:@"data"] count]) {
        [QMUITips showInfo:@"无部门可选" inView:self.view hideAfterDelay:0.5];
        return;
    }
    YSHRMTDeptTreeViewController *deptVC = [YSHRMTDeptTreeViewController new];
    deptVC.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    deptVC.modalPresentationStyle = UIModalPresentationCustom;
    deptVC.transitioningDelegate = [YSRightToLeftTransition sharedYSTransition];
    
    deptVC.deptArray = [NSMutableArray arrayWithArray:[dataDic objectForKey:@"data"]];
    YSWeak;
    deptVC.choseDeptTreeBlock = ^(YSDeptTreePointModel * _Nonnull model) {
        YSHRMAttendanceViewController *attendanceVC = [YSHRMAttendanceViewController new];
        attendanceVC.deptId = model.point_id;
        [weakSelf.navigationController pushViewController:attendanceVC animated:YES];
    };
    [self presentViewController:deptVC animated:YES completion:nil];
}
#pragma mark--headerViewDelegate
- (void)choseBtnActionType:(NSInteger)index {
    // @[@"请假(次)",@"出差(次)", @"加班(次)",@"因公外出(次)",@"迟到早退(次)",@"旷工(次)"] 从0开始
    YSHRMDSummarySubViewController *subViewVC = [YSHRMDSummarySubViewController new];
    if (index == 2) {
        subViewVC.titType = SummarySubVCTypeWork;
    }else if (index > 2) {
        subViewVC.titType = index-1;
    }else {
        subViewVC.titType = index;
    }
    
    subViewVC.timeStr = self.timeStr;
    subViewVC.deptIds = self.deptId;
    [self.navigationController pushViewController:subViewVC animated:YES];
}


#pragma mark--setter&&getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (NSMutableDictionary *)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
}
- (void)dealloc {
  
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
