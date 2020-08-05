//
//  YSCalendarViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/25.
//
//

#import "YSCalendarViewController.h"
#import "YSCalendarGrantViewController.h"
#import "YSCalendar.h"
#import "YSCalendarEventView.h"
#import "YSCalendarBottomView.h"
#import "YSCalendarEventDetailViewController.h"
#import "YSCalendarEditEventViewController.h"

#import "YSCalendarEventModel.h"
#import "YSCalendarMonthCell.h"
#import "YSCalendarGrantPeopleModel.h"

@interface YSCalendarViewController ()<FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, QMUINavigationTitleViewDelegate, QMUINavigationControllerDelegate, CYLTableViewPlaceHolderDelegate, YSCalendarEventViewDataSource, YSCalendarEventViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) YSCalendarBottomView *bottomView;
@property (nonatomic, strong) QMUIPopupMenuView *popupMenuView;
@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UITableView *monthTableView;
@property (nonatomic, strong) YSCalendarEventView *weekCalendarEventView;
@property (nonatomic, strong) YSCalendarEventView *dayCalendarEventView;

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *monthDataSourceArray;
@property (nonatomic, strong) NSMutableArray *weekDataSourceArray;
@property (nonatomic, strong) NSArray *grantPeopleArray;

@property (nonatomic, strong) NSString *todayString;
@property (nonatomic, strong) NSString *receiveNo;
@property (nonatomic, strong) YSCalendarGrantPeopleModel *grantPeopleModel;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;

@end

@implementation YSCalendarViewController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"日程"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"日程"];
}

- (void)initSubviews {
    [super initSubviews];
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    _dateFormatter.dateFormat = @"yyyy-MM-dd";
    _todayString = [_dateFormatter stringFromDate:[NSDate date]];
    _receiveNo = [YSUtility getUID];
    NSDate *today = [[NSDate date] dateByAddingHours:8];
    _startDate = [_dateFormatter stringFromDate:[today dateBySubtractingDays:[today day]-1]];
    _endDate = [_dateFormatter stringFromDate:[[today dateBySubtractingDays:[today day]-1] dateByAddingDays:[today daysInMonth]-1]];
    
    _dateArray = [NSMutableArray array];
    _monthDataSourceArray = [NSMutableArray array];
    _weekDataSourceArray = [NSMutableArray array];
    
    [self initUI];
    
    [self getScheduleGrantPeople];
    [self getSchedule];
    [self getScheduleEventWithDate:_todayString];
    [self getScheduleEventWithWeek:_todayString];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCalendarEvent) name:@"CalendarEditEvent" object:nil];
}

// 修改事件后重新请求数据
- (void)changeCalendarEvent {
    [self getSchedule];
    [self getScheduleEventWithDate:_todayString];
    [self getScheduleEventWithWeek:_todayString];
}

- (void)initUI {
    self.titleView.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleView.titleLabel.textColor = [UIColor whiteColor];
    self.titleView.userInteractionEnabled = YES;
    self.titleView.accessoryType = QMUINavigationTitleViewAccessoryTypeDisclosureIndicator;
    self.title = @"我的日程";
    self.titleView.delegate = self;
    
    [self addRightPopupMenuView];
    
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"点点点（黑）")  position:QMUINavigationButtonPositionRight target:self action:@selector(rightBarButtonAction:event:)];
   
    self.view.backgroundColor = YSThemeManagerShare.currentTheme.themeCalendarColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 130+kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-(130+kTopHeight)-kNavigationBarHeight);
    _scrollView.backgroundColor = YSThemeManagerShare.currentTheme.themeCalendarColor;
    _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*3, kSCREEN_HEIGHT-kTopHeight);
    _scrollView.scrollEnabled = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _calendar = [[YSCalendar alloc] init];
    [_calendar selectDate:[NSDate date]];
    [_calendar setScope:FSCalendarScopeMonth animated:YES];
    _calendar.dataSource = self;
    _calendar.delegate = self;
    [self.view addSubview:_calendar];
    
    _monthTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, kSCREEN_WIDTH, kSCREEN_HEIGHT-300-kTopHeight) style:UITableViewStyleGrouped];
    _monthTableView.dataSource = self;
    _monthTableView.delegate = self;
    [_monthTableView registerClass:[YSCalendarMonthCell class] forCellReuseIdentifier:@"CalendarMonthCell"];
    [_scrollView addSubview:_monthTableView];
    
    _weekCalendarEventView = [[YSCalendarEventView alloc] init];
    _weekCalendarEventView.calendarEventViewType = YSCalendarEventWeek;
    _weekCalendarEventView.dataSource = self;
    _weekCalendarEventView.delegate = self;
    [self monitorWeekAndDayEventClicked:_weekCalendarEventView];
    [_scrollView addSubview:_weekCalendarEventView];
    [_weekCalendarEventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).offset(kSCREEN_WIDTH);
        make.top.mas_equalTo(_scrollView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT-194));
    }];
    
    _dayCalendarEventView = [[YSCalendarEventView alloc] init];
    _dayCalendarEventView.calendarEventViewType = YSCalendarEventDay;
    _dayCalendarEventView.dataSource = self;
    _dayCalendarEventView.delegate = self;
    [self monitorWeekAndDayEventClicked:_dayCalendarEventView];
    [_scrollView addSubview:_dayCalendarEventView];
    [_dayCalendarEventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).offset(kSCREEN_WIDTH*2);
        make.top.mas_equalTo(_scrollView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT-194));
    }];
    
    _bottomView = [[YSCalendarBottomView alloc] init];
    [self monitorBottomButton];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - QMUINavigationTitleViewDelegate

- (UIColor *)titleViewTintColor {
    return [UIColor whiteColor];
}

#pragma mark - QMUINavigationControllerDelegate
#pragma mark - <QMUINavigationControllerDelegate>

- (BOOL)shouldSetStatusBarStyleLight {
    return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (UIImage *)navigationBarBackgroundImage {
    return [YSUtility generateImageWithColor:YSThemeManagerShare.currentTheme.themeCalendarColor];
}

- (void)initPopupContainerViewIfNeeded {
    if (!self.popupMenuView) {
        __weak __typeof(self)weakSelf = self;
        
        self.popupMenuView = [[QMUIPopupMenuView alloc] init];
        self.popupMenuView.automaticallyHidesWhenUserTap = YES;
        self.popupMenuView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
        self.popupMenuView.maximumWidth = 150*kWidthScale;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (YSCalendarGrantPeopleModel *grantPeopleModel in _grantPeopleArray) {
            NSString *title = [NSString stringWithFormat:@"%@%@", grantPeopleModel.grantPersonName, grantPeopleModel.grantType == 1 ? @"(修改)": @"(查询)"];
            if (grantPeopleModel.grantType == 2) {
                title = grantPeopleModel.grantPersonName;
            }
            QMUIPopupMenuItem *popupMenuItem = [QMUIPopupMenuItem itemWithImage:UIImageMake(@"") title:title handler:^{
                self.title = grantPeopleModel.grantPersonName;
                _receiveNo = grantPeopleModel.grantPersonNo;
                _grantPeopleModel = grantPeopleModel;
                [self getSchedule];
                [self getScheduleEventWithDate:_todayString];
                [self reloadRightPopupMenuView];
                grantPeopleModel.grantType == 0 ? [_rightButton setHidden:YES] : [_rightButton setHidden:NO];
                [weakSelf.popupMenuView hideWithAnimated:YES];
            }];
            [mutableArray addObject:popupMenuItem];
        }
        YSCalendarGrantPeopleModel *grantPeopleModel = [[YSCalendarGrantPeopleModel alloc] init];
        grantPeopleModel.grantPersonName = @"我的日程";
        grantPeopleModel.grantType = 2;
        grantPeopleModel.grantPersonNo = [YSUtility getUID];
        _grantPeopleModel = grantPeopleModel;
        QMUIPopupMenuItem *popupMenuItem = [QMUIPopupMenuItem itemWithImage:UIImageMake(@"") title:grantPeopleModel.grantPersonName handler:^{
            self.title = @"我的日程";
            _receiveNo = grantPeopleModel.grantPersonNo;
            _grantPeopleModel = grantPeopleModel;
            [self getSchedule];
            [self getScheduleEventWithDate:_todayString];
            [self reloadRightPopupMenuView];
            grantPeopleModel.grantType == 0 ? [_rightButton setHidden:YES] : [_rightButton setHidden:NO];
            [weakSelf.popupMenuView hideWithAnimated:YES];
        }];
        [mutableArray insertObject:popupMenuItem atIndex:0];
        self.popupMenuView.items = [mutableArray copy];
        self.popupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            weakSelf.titleView.active = NO;
        };
    }
}

- (void)addRightPopupMenuView {
    if (!self.rightPopupMenuView) {
        __weak __typeof(self)weakSelf = self;
        
        self.rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        self.rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        self.rightPopupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
        self.rightPopupMenuView.maximumWidth = 120*kWidthScale;
        self.rightPopupMenuView.shouldShowItemSeparator = YES;
        self.rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, self.rightPopupMenuView.padding.left, 0, self.rightPopupMenuView.padding.right);
        self.rightPopupMenuView.items = @[
                                          [QMUIPopupMenuItem itemWithImage:UIImageMake(@"calendar_add") title:@"新建事项" handler:^{
                                              YSCalendarEditEventViewController *calendarEditEventViewController = [[YSCalendarEditEventViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                              calendarEditEventViewController.receiveNo = _receiveNo;
                                              calendarEditEventViewController.model = [YSCalendarEventModel initWithEmpty];
                                              [self.navigationController pushViewController:calendarEditEventViewController animated:YES];
                                              [calendarEditEventViewController setReturnBlock:^(YSCalendarEventModel *model) {
                                                  model.start = [model.start substringToIndex:10];
                                                  [_dateArray addObject:model.start];
                                                  [self.calendar reloadData];
                                                  [self getScheduleEventWithDate:_todayString];
                                                  [self getScheduleEventWithWeek:_todayString];
                                              }];
                                              [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                          }],
                                          [QMUIPopupMenuItem itemWithImage:UIImageMake(@"calendar_auth") title:@"授权管理" handler:^{
                                              YSCalendarGrantViewController *calendarGrantViewController = [[YSCalendarGrantViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                              [self.navigationController pushViewController:calendarGrantViewController animated:YES];
                                              [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                          }]
                                          ];
        
        self.rightPopupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
    }
}

- (void)reloadRightPopupMenuView {
     __weak __typeof(self)weakSelf = self;
    if (_grantPeopleModel.grantType == 2) {
        self.rightPopupMenuView.items = @[
                                          [QMUIPopupMenuItem itemWithImage:UIImageMake(@"calendar_add") title:@"新建事项" handler:^{
                                              YSCalendarEditEventViewController *calendarEditEventViewController = [[YSCalendarEditEventViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                              calendarEditEventViewController.receiveNo = _receiveNo;
                                              calendarEditEventViewController.model = [YSCalendarEventModel initWithEmpty];
                                              [self.navigationController pushViewController:calendarEditEventViewController animated:YES];
                                              [calendarEditEventViewController setReturnBlock:^(YSCalendarEventModel *model) {
                                                  model.start = [model.start substringToIndex:10];
                                                  [_dateArray addObject:model.start];
                                                  [self.calendar reloadData];
                                                  [self getScheduleEventWithDate:_todayString];
                                                  [self getScheduleEventWithWeek:_todayString];
                                              }];
                                              [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                          }],
                                          [QMUIPopupMenuItem itemWithImage:UIImageMake(@"calendar_auth") title:@"授权管理" handler:^{
                                              YSCalendarGrantViewController *calendarGrantViewController = [[YSCalendarGrantViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                              [self.navigationController pushViewController:calendarGrantViewController animated:YES];
                                              [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                          }]
                                          ];
    } else {
        self.rightPopupMenuView.items = @[
                                          [QMUIPopupMenuItem itemWithImage:UIImageMake(@"calendar_add") title:@"新建事项" handler:^{
                                              YSCalendarEditEventViewController *calendarEditEventViewController = [[YSCalendarEditEventViewController alloc] initWithStyle:UITableViewStyleGrouped];
                                              calendarEditEventViewController.receiveNo = _receiveNo;
                                              calendarEditEventViewController.model = [YSCalendarEventModel initWithEmpty];
                                              [self.navigationController pushViewController:calendarEditEventViewController animated:YES];
                                              [calendarEditEventViewController setReturnBlock:^(YSCalendarEventModel *model) {
                                                  model.start = [model.start substringToIndex:10];
                                                  [_dateArray addObject:model.start];
                                                  [self.calendar reloadData];
                                                  [self getScheduleEventWithDate:_todayString];
                                                  [self getScheduleEventWithWeek:_todayString];
                                              }];
                                              [weakSelf.rightPopupMenuView hideWithAnimated:YES];
                                          }]
                                          ];
    }
}

- (void)viewDidLayoutSubviews {
    [self.rightPopupMenuView layoutWithTargetView:_rightButton];
}

- (void)getSchedule {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getAllSchedule];
    NSDictionary *payload = @{
                              @"start": _startDate,
                              @"end": _endDate,
                              @"receiveNo": _receiveNo
                              };
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"获取月日程:%@", response);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_dateArray removeAllObjects];
            [_dateArray addObjectsFromArray:[YSDataManager getCalendarEventDate:response]];
            self.dataSource = [YSDataManager getCalendarEventData:response];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_calendar reloadData];
                [_weekCalendarEventView reloadData];
            });
        });
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)getScheduleEventWithDate:(NSString *)date {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getAllSchedule];
    NSDictionary *payload = @{
                              @"start": date,
                              @"end": date,
                              @"receiveNo": _receiveNo
                              };
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"获取指定日程:%@", response);
        [_monthDataSourceArray removeAllObjects];
        [_monthDataSourceArray addObjectsFromArray:[YSDataManager getCalendarEventData:response]];
        [_monthTableView cyl_reloadData];
        [_dayCalendarEventView reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)getScheduleEventWithWeek:(NSString *)date {
    NSDate *todayDate = [[NSDate dateWithString:date formatString:@"yyyy-MM-dd"] dateByAddingHours:8];
    NSDate *srartDate = [todayDate dateBySubtractingDays:[todayDate weekday]-1];
    NSDate *endDate = [todayDate dateByAddingDays:7-[todayDate weekday]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getAllSchedule];
    NSDictionary *payload = @{
                              @"start": [_dateFormatter stringFromDate:srartDate],
                              @"end": [_dateFormatter stringFromDate:endDate],
                              @"receiveNo": _receiveNo
                              };
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"获取周日程:%@", response);
        [_weekDataSourceArray removeAllObjects];
        [_weekDataSourceArray addObjectsFromArray:[YSDataManager getCalendarEventData:response]];
        [_weekCalendarEventView reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)getScheduleGrantPeople {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/2", YSDomain, getScheduleGrant];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取授权人员:%@", response);
        _grantPeopleArray = [YSDataManager getCalendarGrantPeopleData:response];
        [self initPopupContainerViewIfNeeded];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)monitorBottomButton {
    [_bottomView.sendButtonSubject subscribeNext:^(UIButton *button) {
        for (UIButton *button in _bottomView.subviews) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        [_calendar setScope:(button.tag == 0 ? FSCalendarScopeMonth : FSCalendarScopeWeek) animated:NO];
        [_scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH*button.tag, 0) animated:NO];
        [_calendar mas_updateConstraints:^(MASConstraintMaker *make) {
            _calendar.frame = CGRectMake(30*kWidthScale+2, kTopHeight, kSCREEN_WIDTH-60*kWidthScale-4, button.tag == 0 ? 300 : 130);
        }];
        [_calendar layoutIfNeeded];
    }];
}

- (void)monitorWeekAndDayEventClicked:(YSCalendarEventView *)calendarEventView {
    [calendarEventView.sendButtonSubject subscribeNext:^(UIButton *button) {
        YSCalendarEventDetailViewController *calendarEventDetailViewController = [[YSCalendarEventDetailViewController alloc] init];
        YSCalendarEventModel *cellModel = calendarEventView == _weekCalendarEventView ? _weekDataSourceArray[button.tag-1] : _monthDataSourceArray[button.tag-1];
        calendarEventDetailViewController.model = cellModel;
        _grantPeopleModel.grantType != 0 ? calendarEventDetailViewController.hasAuth = YES : NO;
        [self.navigationController pushViewController:calendarEventDetailViewController animated:YES];
        [calendarEventDetailViewController setDeleteBlock:^(YSCalendarEventModel *model) {
            for (YSCalendarEventModel *deleteModel in _weekDataSourceArray) {
                if ([deleteModel.id isEqual:model.id]) {
                    [_weekDataSourceArray removeObject:deleteModel];
                }
            }
            [_monthDataSourceArray removeObject:model];
            if (_monthDataSourceArray.count == 0) {
                model.start = [model.start substringToIndex:10];
                [_dateArray removeObject:model.start];
                [_calendar reloadData];
            }
            [_monthTableView cyl_reloadData];
            [_weekCalendarEventView reloadData];
            [_dayCalendarEventView reloadData];
            [QMUITips showSucceed:@"成功删除日程" inView:self.view hideAfterDelay:1];
        }];
    }];
}

#pragma mark - YSCalendarEventViewDataSource

- (NSArray *)eventForCalendarEventView:(YSCalendarEventView *)calendarEventView {
    return calendarEventView == _weekCalendarEventView ? _weekDataSourceArray : _monthDataSourceArray;
}

#pragma mark - QMUINavigationTitleViewDelegate

- (void)didChangedActive:(BOOL)active forTitleView:(QMUINavigationTitleView *)titleView {
    if (active) {
        [self.popupMenuView layoutWithTargetView:self.titleView];
        [self.popupMenuView showWithAnimated:YES];
    }
}

#pragma mark - FSCalendarDataSource

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    return [_dateArray containsObject:[_dateFormatter stringFromDate:date]] ? 1 : 0;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    DLog(@"选择的日期:%@", [_dateFormatter stringFromDate:date]);
    [self getScheduleEventWithDate:[_dateFormatter stringFromDate:date]];
    [self getScheduleEventWithWeek:[_dateFormatter stringFromDate:date]];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    _startDate = [_dateFormatter stringFromDate:calendar.currentPage];
    _endDate = [_dateFormatter stringFromDate:[calendar.currentPage dateByAddingDays:[calendar.currentPage daysInMonth]-1]];
    [self getSchedule];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _monthDataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCalendarMonthCell *cell = [_monthTableView dequeueReusableCellWithIdentifier:@"CalendarMonthCell"];
    cell = [[YSCalendarMonthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarMonthCell"];
    YSCalendarEventModel *cellModel = _monthDataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    if (_grantPeopleModel.grantType != 0) {
        cell.rightUtilityButtons = [self rightButtons];
    }
    cell.delegate = self;
    return cell;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    
    return rightUtilityButtons;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    [QMUITips showLoading:@"删除中..." inView:self.view];
    NSIndexPath *indexPath = [_monthTableView indexPathForCell:cell];
    YSCalendarEventModel *calendarEventModel = _monthDataSourceArray[indexPath.row];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, deleteSchedule];
    NSDictionary *payload = @{
                              @"id": calendarEventModel.id
                              };
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"删除日程:%@", response);
        if ([response[@"code"] intValue] == 1) {
            YSCalendarEventModel *model = _monthDataSourceArray[indexPath.row];
            for (YSCalendarEventModel *deleteModel in _weekDataSourceArray) {
                if ([deleteModel.id isEqual:model.id]) {
                    [_weekDataSourceArray removeObject:deleteModel];
                    break;
                }
            }
            [_monthDataSourceArray removeObjectAtIndex:indexPath.row];
            [_monthTableView cyl_reloadData];
            [_weekCalendarEventView reloadData];
            [_dayCalendarEventView reloadData];
            
            [QMUITips hideAllToastInView:self.view animated:YES];
            [QMUITips showSucceed:@"成功删除日程" inView:self.view hideAfterDelay:1];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCalendarEventDetailViewController *calendarEventDetailViewController = [[YSCalendarEventDetailViewController alloc] init];
    YSCalendarEventModel *cellModel = _monthDataSourceArray[indexPath.row];
    calendarEventDetailViewController.model = cellModel;
    _grantPeopleModel.grantType != 0 ? calendarEventDetailViewController.hasAuth = YES : NO;
    [self.navigationController pushViewController:calendarEventDetailViewController animated:YES];
    [calendarEventDetailViewController setDeleteBlock:^(YSCalendarEventModel *model) {
        for (YSCalendarEventModel *deleteModel in _weekDataSourceArray) {
            if ([deleteModel.id isEqual:model.id]) {
                [_weekDataSourceArray removeObject:deleteModel];
            }
        }
        [_monthDataSourceArray removeObject:model];
        if (_monthDataSourceArray.count == 0) {
            model.start = [model.start substringToIndex:10];
            [_dateArray removeObject:model.start];
            [_calendar reloadData];
        }
        [_monthTableView cyl_reloadData];
        [_weekCalendarEventView reloadData];
        [_dayCalendarEventView reloadData];
        [QMUITips showSucceed:@"成功删除日程" inView:self.view hideAfterDelay:1];
    }];
}

- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"暂无安排"];
}
#pragma mark - rightBarButtonAction
- (void)rightBarButtonAction:(UIBarButtonItem *)sender event:(UIEvent *) event {
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:touch.window]; //返回触摸点在视图中的当前坐标
    CGRect rect = [touch.view convertRect:touch.view.frame toView:touch.window];
    [self.rightPopupMenuView layoutWithTargetRectInScreenCoordinate:rect];
    [self.rightPopupMenuView showWithAnimated:YES];
    
}
@end
