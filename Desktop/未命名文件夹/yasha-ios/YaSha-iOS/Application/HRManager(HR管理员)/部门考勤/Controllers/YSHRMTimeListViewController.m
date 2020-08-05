//
//  YSHRMTimeListViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

// 打卡时间
#import "YSHRMTimeListViewController.h"
#import "YSSwitchViewController.h"
#import "YSDataManager.h"
#import "YSAttendanceCell.h"
#import "YSAttendanceCalendarView.h"
#import "YSAttendanceModel.h"
#import "YSTodayEventCell.h"
#import "YSManagerPositionHeaderView.h"
#import "YSHRMAttendanceCalendarView.h"
#import "YSNetManagerCache.h"
#import "YSManagerHRBaseViewController.h"
#import "YSHRMAttendanceOtherTableViewCell.h"
#import "YSContactModel.h"
#import "YSNoMoreDataBottomView.h"


@interface YSHRMTimeListViewController ()<FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource, QMUINavigationTitleViewDelegate, QMUINavigationControllerDelegate>
@property (nonatomic, strong) YSHRMAttendanceCalendarView *monthCalendarView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) YSAttendanceModel *todayModel;
@property (nonatomic, strong) YSManagerPositionHeaderView *headerView;
@property (nonatomic, assign) RefreshStateType refreshType;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, assign) BOOL isClickdeShow;//非点击切换月份 不显示数据
@property (nonatomic, strong) YSNoMoreDataBottomView *noDataView;
@property (nonatomic, copy) NSString *monthDateStr;//整月的时间数据


@end

@implementation YSHRMTimeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCalendarView];
    [self creatTable];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (!self.deptId) {
        
        NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
        if (0 != [[dataDic objectForKey:@"data"] count]) {
            NSDictionary *deptTreeDic = [dataDic objectForKey:@"data"][0];
            self.deptId = @"";
            self.deptNameStr = [deptTreeDic objectForKey:@"name"];
        }
    }
    // 显示当天的前一天数据
    NSCalendar *calendar_change = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setDay:-1];
    NSDate *newdate = [calendar_change dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.dateStr = [dateFormatter stringFromDate:newdate];
    self.searchDateStr = [dateFormatter stringFromDate:newdate];
    //选中前一天
    [self.monthCalendarView.calendar selectDate:newdate];
    @weakify(self);
    // 选择更改部门之后
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:[NSString stringWithFormat:@"choseSreenCompanyHR%ldVC", self.navigationController.viewControllers.count] object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.deptId = [x.userInfo objectForKey:@"deptIds"];
        self.deptNameStr = [x.userInfo objectForKey:@"deptName"];
        [self refreshTeamRecordListDataWith:(RefreshStateTypeHeader)];
    }];
    [self refreshTeamRecordListDataWith:(RefreshStateTypeHeader)];
    [self.view addSubview:self.noDataView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"考勤"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [QMUITips hideAllToastInView:self.view animated:YES];
    [TalkingData trackPageEnd:@"考勤"];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"个人考勤";
    self.titleView.tintColor = UIColorWhite;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIImage *)navigationBarBackgroundImage {
    return [YSUtility generateImageWithColor:YSThemeManagerShare.currentTheme.themeCalendarColor];
}

- (void)creatTable {
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 300*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale-300*kHeightScale-kTopHeight-kBottomHeight) style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorInset = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 16*kWidthScale);
    [self.view addSubview:self.table];
    
    [self.table registerClass:[YSHRMAttendanceOtherTableViewCell class] forCellReuseIdentifier:@"hrmotherlistCEll"];
    
    UIView *headerBackView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 48*kHeightScale))];
    headerBackView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 7*kHeightScale))];
    lineLab.backgroundColor  = [UIColor colorWithHexString:@"#E6E6E6"];
    [headerBackView addSubview:lineLab];
    
    self.headerView = [[YSManagerPositionHeaderView alloc] initWithFrame:(CGRectMake(0, 15*kHeightScale, kSCREEN_WIDTH, 25*kHeightScale))];
    [headerBackView addSubview:self.headerView];
    self.table.tableHeaderView = headerBackView;
    self.table.tableFooterView = [[UIView alloc] initWithFrame:(CGRectZero)];
    YSWeak;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.table.mj_header endRefreshing];
        [weakSelf.table.mj_footer endRefreshing];
        [weakSelf refreshTeamRecordListDataWith:(RefreshStateTypeHeader)];
    }];
    self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.table.mj_header endRefreshing];
        [weakSelf.table.mj_footer endRefreshing];
        [weakSelf refreshTeamRecordListDataWith:(RefreshStateTypeFooter)];
    }];
}

- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:@(self.pageNumber) forKey:@"pageNumber"];
    [paramDic setObject:@kPageSize forKey:@"pageSize"];
    [paramDic setObject:self.deptId forKey:@"deptId"];
    [paramDic setObject:self.monthDateStr ? self.monthDateStr : self.dateStr forKey:@"dateStr"];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getDepartmentPunchRecords] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"考勤记录列表-%@", response);
        if (1==[[response objectForKey:@"code"] integerValue]) {
            NSMutableArray *dataArray = [[NSArray yy_modelArrayWithClass:[YSAttendanceModel class] json:[[response objectForKey:@"data"] objectForKey:@"rows"]] mutableCopy];
            [self handelDataAddModelImgWith:dataArray];
            self.headerView.numberLab.text = [NSString stringWithFormat:@"%ld", [[[response objectForKey:@"data"] objectForKey:@"total"] integerValue]];
            if (self.refreshType == RefreshStateTypeHeader) {
                self.dataArray = [NSMutableArray arrayWithArray:dataArray];
                [self.table scrollRectToVisible:(CGRectMake(0, 0, 0.1, 0.1)) animated:NO];
            }else {
                [self.dataArray addObjectsFromArray:dataArray];
            }
            if (dataArray.count < kPageSize) {
                [self.table.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.table.mj_footer resetNoMoreData];
            }
            [self.table reloadData];
        }
        if (self.dataArray.count != 0) {
            self.noDataView.hidden = YES;
        }else {
            self.noDataView.hidden = NO;
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        if (self.dataArray.count != 0) {
            self.noDataView.hidden = YES;
        }else {
            self.noDataView.hidden = NO;
        }
    } progress:nil];
}

// 增加头像
- (void)handelDataAddModelImgWith:(NSMutableArray* _Nonnull)dataArray {
    [dataArray enumerateObjectsUsingBlock:^(YSAttendanceModel  * compileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", compileModel.code];
        RLMResults *results = [[YSContactModel objectsWithPredicate:predicate]  sortedResultsUsingKeyPath:@"userId" ascending:YES];
        if ([results count] != 0) {
            YSContactModel *resultsModel = results[0];
            compileModel.headImage = [NSString stringWithFormat:@"%@_S.jpg", resultsModel.headImg];
        }
    }];
    
}

#pragma mark--refreshData
- (void)refreshTeamRecordListDataWith:(RefreshStateType)type {

    if (type == RefreshStateTypeHeader) {
        self.pageNumber = 1;
    }else {
        self.pageNumber++;
    }
    self.refreshType = type;
    [self doNetworking];
}


#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48*kHeightScale;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YSHRMAttendanceOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hrmotherlistCEll" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSAttendanceModel *model = self.dataArray[indexPath.row];
    cell.attentTimeModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark-- 添加日历视图控件
- (void)setupCalendarView {
    _monthCalendarView = [[YSHRMAttendanceCalendarView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300*kHeightScale)];
    [_monthCalendarView.calendar setFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300*kHeightScale)];
    _monthCalendarView.calendar.dataSource = self;
    _monthCalendarView.calendar.delegate = self;
    FSCalendarScope monthSelectedScope = FSCalendarScopeMonth;
    [_monthCalendarView.calendar setScope:monthSelectedScope animated:NO];
    [self.view addSubview:_monthCalendarView];
}

//日历的点击事件
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    self.monthDateStr = nil;
    _monthCalendarView.calendar.appearance.todayColor = [UIColor whiteColor];
    _monthCalendarView.calendar.appearance.titleTodayColor = [UIColor colorWithHexString:@"#191F25"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.dateStr = [dateFormatter stringFromDate:date];
    self.searchDateStr = [dateFormatter stringFromDate:date];
    DLog(@"所点日历上的时间字符串------%@",self.dateStr);
    [self refreshTeamRecordListDataWith:(RefreshStateTypeHeader)];

    // 跳转月份
    NSCalendar *calendar_change = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setMonth:0];
    NSDate *newdate = [calendar_change dateByAddingComponents:adcomps toDate:date options:0];
    _monthCalendarView.calendar.currentPage = newdate;
    
}

//切换当前月分的方法
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSString *newDataStr = [dateFormatter stringFromDate:calendar.currentPage];
    self.monthDateStr = nil;
    // 搜索页面使用
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *newdate = [dateFormatter dateFromString:self.dateStr];
    self.searchDateStr = newDataStr;

    if ([[self.dateStr substringToIndex:7] isEqualToString:newDataStr]) {
        //以前选中过的日期会出现
        [calendar selectDate:newdate];// 设置选中日期
    }else{
        //    整月月份数据不显示
        [calendar deselectDate:newdate];//取消选中日期
        self.monthDateStr = newDataStr;
    }
    [self refreshTeamRecordListDataWith:(RefreshStateTypeHeader)];
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (YSNoMoreDataBottomView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[YSNoMoreDataBottomView alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.monthCalendarView.frame), kSCREEN_WIDTH, CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.monthCalendarView.frame)))];
    }
    return _noDataView;
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
