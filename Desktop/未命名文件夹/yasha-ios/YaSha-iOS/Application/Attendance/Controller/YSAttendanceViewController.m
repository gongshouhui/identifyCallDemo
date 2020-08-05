//
//  YSAttendanceViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAttendanceViewController.h"
#import "YSSwitchViewController.h"
#import "YSDataManager.h"
#import "YSAttendanceCell.h"
#import "YSAttendanceCalendarView.h"
#import "YSAttendanceModel.h"
#import "YSTodayEventCell.h"

@interface YSAttendanceViewController ()<FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource, QMUINavigationTitleViewDelegate, QMUINavigationControllerDelegate>

@property (nonatomic, strong) YSAttendanceCalendarView *monthCalendarView;
@property (nonatomic, strong) NSMutableArray * monthEventDateArray;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *dataAllArray;
@property (nonatomic, strong) NSMutableArray *allData;
@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, strong) YSAttendanceModel *todayModel;
@property (nonatomic, strong) UIView *imgView;
@property (nonatomic, assign) int stateNum;
@property (nonatomic, assign) BOOL isNotice;//申诉成功之后使用
@property (nonatomic, strong) NSString *todayDateStr;//申诉成功之后使用

@end

@implementation YSAttendanceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self doNetworking];
    self.isToday = NO;
    self.allData = [NSMutableArray arrayWithCapacity:100];
    self.monthEventDateArray = [NSMutableArray arrayWithCapacity:100];
    [TalkingData trackPageBegin:@"考勤"];
    if (self.isNotice) {
        self.isToday = YES;
    }
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

- (void)initSubviews {
    [super initSubviews];
    [self setupCalendarView];
    [self creatTable];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    @weakify(self);
    // 点击旷工cell 跳转详情
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"YSJumpAttendanceDetail" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if ([[x.userInfo objectForKey:@"YSChoseTime"] isEqual:[NSNull null]] || [x.userInfo objectForKey:@"YSChoseTime"] == nil) {
            return ;
        }
        NSTimeInterval _interval = [[x.userInfo objectForKey:@"YSChoseTime"] doubleValue] / 1000.0;
        NSDate *date_interval = [NSDate dateWithTimeIntervalSince1970:_interval];
        self.monthCalendarView.calendar.currentPage = date_interval;
        
    }];
    // 申诉提交之后
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"complaintNotice" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.isNotice = YES;
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIImage *)navigationBarBackgroundImage {
    return [YSUtility generateImageWithColor:YSThemeManagerShare.currentTheme.themeCalendarColor];
}

- (void)creatTable {
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 300*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale-300*kHeightScale-kTopHeight-kBottomHeight) style:UITableViewStyleGrouped];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.table];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isToday == YES) {
        return self.allData.count;
    } else {
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isToday == YES) {
        return 1;
    }else{
        NSArray *arr = [NSArray array];
        arr = self.allData[section];
        return arr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isToday == YES) {
        return 89*kHeightScale;
    }else{
        return 52*kHeightScale;
    }
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isToday) {
        static NSString *inde = @"cell";
        YSAttendanceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[YSAttendanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YSAttendanceModel *model1 = self.dataArray[indexPath.section];
        if (indexPath.row == 0) {
            if (model1.flowDataList != nil && ![model1.monNotPunch isEqual:@"1"] && ![model1.aftNotPunch isEqual:@"1"]) {
                NSDictionary *dic = model1.flowDataList[0];
                DLog(@"=====%@",dic[@"day"]);
                if ([dic[@"type"] intValue] == 10) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"请假"];
                }else if ([dic[@"type"] intValue] == 20) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"出差"];
                }else if ([dic[@"type"] intValue] == 30) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"因公外出"];
                }
                else if ([dic[@"type"] intValue] == 40) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"加班"];
                }
                else if ([dic[@"type"] intValue] == 50) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"忘记打卡"];
                }else{
                    cell.contentLabel.text = [NSString stringWithFormat:@"其他"];
                }
                
                [cell.dealWithButton removeFromSuperview];
                [cell.pointView removeFromSuperview];
            }
            if ([model1.lateStatus isEqual:@"1"]) {
                cell.contentLabel.text = @"迟到";
                cell.dealWithButton.tag = 70;
                if ([model1.monAbnormalFlow isEqual:@"1"]) {
//                    [cell.dealWithButton setTitle:@"申诉" forState:UIControlStateNormal];
//                    cell.dealWithButton.backgroundColor = kThemeColor;
                    cell.dealWithButton.hidden = YES;
                }else{
                    [cell.dealWithButton setTitle:model1.monFlowStatus forState:UIControlStateNormal];
                    [cell.dealWithButton setTitleColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                }
            }if ([model1.monNotPunch isEqual:@"1"] ) {
                cell.contentLabel.text = @"上班打卡异常";
                if ([model1.monAbnormalFlow isEqual:@"1"]) {
                    cell.pointView.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:128.0/255.0 blue:217.0/255.0 alpha:1.00];
//                    [cell.dealWithButton setTitle:@"申诉" forState:UIControlStateNormal];
//                    cell.dealWithButton.backgroundColor = kThemeColor;
                    cell.dealWithButton.hidden = YES;
                }else{
                    [cell.dealWithButton setTitle:model1.monFlowStatus forState:UIControlStateNormal];
                    cell.dealWithButton.backgroundColor = [UIColor whiteColor];
                    cell.dealWithButton.userInteractionEnabled = NO;
                    [cell.dealWithButton setTitleColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                }
                
                cell.dealWithButton.tag = 140;
            }else  if ([model1.aftNotPunch isEqual:@"1"] ) {
                cell.contentLabel.text = @" 下班打卡异常";
                if ([model1.aftAbnormalFlow isEqual:@"1"]) {
                    cell.pointView.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:128.0/255.0 blue:217.0/255.0 alpha:1.00];
//                    [cell.dealWithButton setTitle:@"申诉" forState:UIControlStateNormal];
//                    cell.dealWithButton.backgroundColor = kThemeColor;
                    cell.dealWithButton.hidden = YES;
                }else{
                    [cell.dealWithButton setTitle:model1.aftFlowStatus forState:UIControlStateNormal];
                    cell.dealWithButton.backgroundColor = [UIColor whiteColor];
                    cell.dealWithButton.userInteractionEnabled = NO;
                    [cell.dealWithButton setTitleColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                }
                cell.dealWithButton.tag = 150;
            }
        }
        if (indexPath.row == 1 ) {
            if ([model1.lateStatus isEqual:@"1"]) {
                cell.contentLabel.text = @"早退";
            }
            if ([model1.aftNotPunch isEqual:@"1"] ) {
                cell.contentLabel.text = @"下班打卡异常";
            }
            if ([model1.aftAbnormalFlow isEqual:@"1"]) {
                cell.pointView.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:128.0/255.0 blue:217.0/255.0 alpha:1.00];
//                cell.dealWithButton.tag = 150;
//                [cell.dealWithButton setTitle:@"申诉" forState:UIControlStateNormal];
//                [cell.dealWithButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                cell.dealWithButton.backgroundColor = kThemeColor;
                cell.dealWithButton.hidden = YES;
            }else{
                [cell.dealWithButton setTitle:model1.aftFlowStatus forState:UIControlStateNormal];
                cell.dealWithButton.backgroundColor = [UIColor whiteColor];
                cell.dealWithButton.userInteractionEnabled = NO;
                [cell.dealWithButton setTitleColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
        
        [cell.dealWithButton addTarget:self action:@selector(dealWithEvent:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else{
        static NSString *inde = @"cell";
        YSTodayEventCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[YSTodayEventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            if (self.todayModel.flowDataList != nil && ![self.todayModel.monNotPunch isEqual:@"1"] && ![self.todayModel.aftNotPunch isEqual:@"1"]) {
                DLog(@"---------%@",self.todayModel.flowDataList);
                NSDictionary *dic = self.todayModel.flowDataList[0];
                if ([dic[@"type"] intValue] == 10) {
                    cell.conterLabel.text = @"请假";
                    cell.timeLabel.text = [NSString stringWithFormat:@"%@--%@",[dic[@"startTime"] substringToIndex:16] ,[dic[@"endTime"] substringToIndex:16] ];
                }else if ([dic[@"type"] intValue] == 20) {
                    cell.conterLabel.text = @"出差";
                    cell.timeLabel.text = @"-- :--";
                }else if ([dic[@"type"] intValue] == 30) {
                    cell.conterLabel.text = @"因公外出";
                    cell.timeLabel.text = @"-- :--";
                }else if ([dic[@"type"] intValue] == 40) {
                    cell.conterLabel.text = @"加班";
                    cell.timeLabel.text = @"-- :--";
                }else if ([dic[@"type"] intValue] == 50) {
                    cell.conterLabel.text = @"忘记打卡";
                    cell.timeLabel.text = @"-- :--";
                }else {
                    cell.conterLabel.text = @"其他";
                    cell.timeLabel.text = @"-- :--";
                }
                [cell.dealButton removeFromSuperview];
            }else{
                if ([self.todayModel.monNotPunch isEqual:@"1"]) {
                    cell.conterLabel.text = @"上班打卡异常";
                    cell.timeLabel.text = [NSString stringWithFormat:@"%@ --:-- ",[self.todayModel.sdate substringToIndex:10]];
                    if ([self.todayModel.monAbnormalFlow isEqual:@"1"]) {
//                        cell.dealButton.tag = 140;
//                        [cell.dealButton setTitle:@"申诉" forState:UIControlStateNormal];
//                        [cell.dealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                        cell.dealButton.backgroundColor = kThemeColor;
                        cell.dealButton.hidden = YES;
                    }else{
                        if ([self.todayModel.monNotPunch isEqual:@"1"] ) {
                            [cell.dealButton setTitle:self.todayModel.monFlowStatus forState:UIControlStateNormal];
                        }
                        cell.dealButton.backgroundColor = [UIColor whiteColor];
                        cell.dealButton.userInteractionEnabled = NO;
                        [cell.dealButton setTitleColor:kUIColor(204, 204, 204, 1.0) forState:UIControlStateNormal];
                    }
                }else if ([self.todayModel.aftNotPunch isEqual:@"1"]) {
                    cell.conterLabel.text = @"下班打卡异常";
                    cell.timeLabel.text = [NSString stringWithFormat:@"%@ --:-- ",[self.todayModel.sdate substringToIndex:10]];
                    if ([self.todayModel.aftAbnormalFlow isEqual:@"1"]) {
//                        cell.dealButton.tag = 150;
//                        [cell.dealButton setTitle:@"申诉" forState:UIControlStateNormal];
//                        [cell.dealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                        cell.dealButton.backgroundColor = kThemeColor;
                        cell.dealButton.hidden = YES;
                    }else{
                        if ([self.todayModel.aftNotPunch isEqual:@"1"]) {
                            [cell.dealButton setTitle:self.todayModel.aftFlowStatus forState:UIControlStateNormal];
                        }if ([self.todayModel.monNotPunch isEqual:@"1"] ) {
                            [cell.dealButton setTitle:self.todayModel.monFlowStatus forState:UIControlStateNormal];
                        }
                        
                        cell.dealButton.backgroundColor = [UIColor whiteColor];
                        cell.dealButton.userInteractionEnabled = NO;
                        [cell.dealButton setTitleColor:kUIColor(204, 204, 204, 1.0) forState:UIControlStateNormal];
                    }
                }else if ([self.todayModel.lateStatus isEqual:@"1"]) {
                    cell.conterLabel.text = [NSString stringWithFormat:@"上午迟到%@分钟",self.todayModel.staticDayList[0][@"typeTime"]];
                    cell.timeLabel.text = [NSString stringWithFormat:@"%@ 迟到", self.todayModel.staticDayList[0][@"startRwork"]] ;
                    if ([self.todayModel.monAbnormalFlow isEqual:@"1"]) {
//                        [cell.dealButton setTitle:@"申诉" forState:UIControlStateNormal];
//                        cell.dealButton.tag = 70;
//                        cell.dealButton.userInteractionEnabled = YES;
//                        cell.dealButton.backgroundColor = kThemeColor;
                        cell.dealButton.hidden = YES;
                    }else{
                        [cell.dealButton setTitle:self.todayModel.monFlowStatus forState:UIControlStateNormal];
                        cell.dealButton.backgroundColor = [UIColor whiteColor];
                        cell.dealButton.userInteractionEnabled = NO;
                        [cell.dealButton setTitleColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    }
                }
            }
            [cell.dealButton addTarget:self action:@selector(dealWithEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.section == 1) {
            if ([self.todayModel.aftNotPunch isEqual:@"1"]) {
                cell.conterLabel.text = @"下班打卡异常";
                cell.timeLabel.text = [NSString stringWithFormat:@"%@ --:-- ",[self.todayModel.sdate substringToIndex:10]];
            }
            if ([self.todayModel.aftAbnormalFlow isEqual:@"1"]) {
                cell.dealButton.tag = 150;
//                [cell.dealButton setTitle:@"申诉" forState:UIControlStateNormal];
//                [cell.dealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                cell.dealButton.backgroundColor = kThemeColor;
                cell.dealButton.hidden = YES;
            }else{
                [cell.dealButton setTitle:self.todayModel.aftFlowStatus forState:UIControlStateNormal];
                cell.dealButton.backgroundColor = [UIColor whiteColor];
                cell.dealButton.userInteractionEnabled = NO;
                [cell.dealButton setTitleColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            if ([self.todayModel.lateStatus isEqual:@"1"]) {
                cell.conterLabel.text = @"下午早退";
                cell.timeLabel.text = [NSString stringWithFormat:@"%@ 早退", self.todayModel.staticDayList[0][@"startRwork"]] ;
            }
            [cell.dealButton addTarget:self action:@selector(dealWithEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}

#pragma mark - 申诉按钮处理
- (void)dealWithEvent : (UIButton *) btn{
    
    UITableViewCell *cell = (UITableViewCell *)[[btn superview] superview];
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    dispatch_async(dispatch_get_main_queue(), ^{
        YSSwitchViewController *complaint = [[YSSwitchViewController alloc]init];
        if (!self.isToday){
            complaint.model  = self.dataArray[indexPath.section];
        }else{
            complaint.model = self.todayModel;
        }
        complaint.type = [NSString stringWithFormat:@"%ld",(long)btn.tag];
        [self.navigationController pushViewController:complaint animated:YES];
    });
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isToday == YES) {
        return 0.01;
    }else{
        return 33*kHeightScale;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.isToday == YES) {
        return 15*kHeightScale;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.isToday) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 33*kHeightScale)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        YSAttendanceModel *model1 = self.dataArray[section];
        timeLabel.text = [model1.sdate substringToIndex:10] ;
        [view addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(12);
            make.left.mas_equalTo(view.mas_left).offset(27);
            make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 13*kHeightScale));
        }];
        return view;
        
    }else{
        
        return nil;
    }
}

//添加日历视图控件
- (void)setupCalendarView {
    _monthCalendarView = [[YSAttendanceCalendarView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300*kHeightScale)];
    [_monthCalendarView.calendar setFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300*kHeightScale)];
    _monthCalendarView.calendar.dataSource = self;
    _monthCalendarView.calendar.delegate = self;
    FSCalendarScope monthSelectedScope = FSCalendarScopeMonth;
    [_monthCalendarView.calendar setScope:monthSelectedScope animated:NO];
    [self.view addSubview:_monthCalendarView];
}

//日历上添加的图片
- (nullable UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:date];
    for (NSDictionary *dic in _monthEventDateArray) {
        if ([dic[@"time"] isEqual:dateString] &&[dic[@"state"] isEqual:@"30"]) {
            UIImage *image = [UIImage imageNamed:@"异常"];
            return image;
        }
        if ([dic[@"time"] isEqual:dateString] &&[dic[@"state"] isEqual:@"20"]) {
            UIImage *image = [UIImage imageNamed:@"请假点"];
            return image;
        }
    }
    return nil;
}

//日历的点击事件
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    _monthCalendarView.calendar.appearance.selectionColor = kUIColor(100, 172, 236, 1.0);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.todayDateStr = dateString;
    DLog(@"所点日历上的时间字符串------%@",dateString);
    for (NSDictionary *dic in _monthEventDateArray) {
        if ([dic[@"time"] isEqual:dateString] &&[dic[@"state"] isEqual:@"30"]) {
            _monthCalendarView.calendar.appearance.selectionColor = kUIColor(255, 84, 44, 1.0);
            [self todayEventData:dateString];
            break;
        }else if ([dic[@"time"] isEqual:dateString] &&[dic[@"state"] isEqual:@"20"]) {
            _monthCalendarView.calendar.appearance.selectionColor = kUIColor(255, 210, 0, 1.0);
            [self todayEventData:dateString];
            break;
        }else if ([dic[@"time"] isEqual:dateString] && [dic[@"state"] isEqual:@"40"]) {
            [self showImage:@"休息日！"];
            break;
        }
        else if ([dic[@"time"] isEqual:dateString] && [dic[@"state"] isEqual:@"10"]) {
            [self showImage:@"考勤正常"];
            break;
        }else{
            [self showImage:@"还没到时间哦！"];
        }
    }
    
    NSCalendar *calendar_change = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setMonth:0];
    NSDate *newdate = [calendar_change dateByAddingComponents:adcomps toDate:date options:0];
    _monthCalendarView.calendar.currentPage = newdate;
}
//点击日历当天数据处理
- (void)todayEventData:(NSString *)dateString {
    self.isToday = YES;
    [_imgView removeFromSuperview];
    for (YSAttendanceModel *model  in self.dataArray) {
        if ([dateString isEqual:[model.sdate substringToIndex:10]]) {
            self.todayModel = model;
            self.allData = [NSMutableArray arrayWithCapacity:100];
            if ([model.monNotPunch isEqual:@"1"]) {
                [self.allData addObject:model.monNotPunch];
            }
            if ([model.aftNotPunch isEqual:@"1"]) {
                [self.allData addObject:model.aftNotPunch];
            }
            if ([model.lateStatus isEqual:@"1"]) {
                [self.allData addObject:model.lateStatus];
            }
            if (model.flowDataList != nil && [model.monNotPunch isEqual:@"0"] && [model.aftNotPunch isEqual:@"0"] && [model.lateStatus isEqual:@"0"]) {
                [self.allData addObject:@"1"];
            }
            break;
        }else{
            [self.allData removeAllObjects];
        }
    }
    if (self.allData.count > 0) {
        [self.table reloadData];
    }
}

//当前月的方法
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
    //在此方法里面请求数据
    self.isToday = NO;
    self.allData = [NSMutableArray arrayWithCapacity:100];
    self.monthEventDateArray = [NSMutableArray arrayWithCapacity:100];
    [self doNetworking ];
}

- (void)doNetworking {
    [_imgView removeFromSuperview];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:_monthCalendarView.calendar.currentPage];
    NSString *year = [dateString substringToIndex:4];
    NSString *month = [dateString substringWithRange:NSMakeRange(5,2)];
    NSDictionary *paramDic = [NSDictionary new];
    if (self.teamDic) {
        // 暂时不更改时间 跟安卓保持一致 更改时间 需要更改日历 以及从汇总第一次跳转本页面的判断(因为通知)
//        year = [[self.teamDic objectForKey:@"year"] substringToIndex:4];
//        month = [[self.teamDic objectForKey:@"year"] substringFromIndex:5];
        paramDic = @{@"no":[self.teamDic objectForKey:@"no"]};
    }
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, ajaxListNew,year,month] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        NSArray *arr = response[@"data"];
        self.dataArray = [YSDataManager getAttendanceData:response];
        self.dataAllArray = [YSDataManager getAllAttendanceData:response];
        for (YSAttendanceModel *model  in self.dataAllArray ) {
            NSMutableDictionary *diction = [NSMutableDictionary dictionaryWithCapacity:100];
            [diction setValue:[model.sdate substringToIndex:10]  forKey:@"time"];
            [diction setValue:model.type forKey:@"state"];
            [self.monthEventDateArray addObject: diction];
        }
        for (YSAttendanceModel *model  in self.dataArray) {
            NSMutableArray *temporaryArray = [NSMutableArray arrayWithCapacity:100];
            if ([model.monNotPunch isEqual:@"1"]) {
                [temporaryArray addObject:model.monNotPunch];
            }
            if ([model.aftNotPunch isEqual:@"1"]) {
                [temporaryArray addObject:model.aftNotPunch];
            }
            if ([model.lateStatus isEqual:@"1"]) {
                [temporaryArray addObject:model.lateStatus];
            }
            if (model.flowDataList != nil && [model.monNotPunch isEqual:@"0"] && [model.aftNotPunch isEqual:@"0"] && [model.lateStatus isEqual:@"0"]) {
                [temporaryArray addObject:@"1"];
            }
            [self.allData addObject:temporaryArray];
        }
        if (arr.count > 0 ) {
            self.stateNum = 10;
        }else{
            self.stateNum = 50;
        }
        [self.monthCalendarView.calendar reloadData];
        if (self.isNotice) {
            self.isNotice = NO;
            [self todayEventData:self.todayDateStr];
        }
        [self.table cyl_reloadData];
        [QMUITips hideAllToastInView:self.view animated:YES];
    } failureBlock:^(NSError *error) {
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

- (UIView *)makePlaceHolderView {
    if (self.stateNum == 10) {
        return [YSUtility NoDataView:@"考勤正常"];
    }else{
        return [YSUtility NoDataView:@"还没到时间哦！"];
    }
    
}
//无数据显示图片
- (void)showImage:(NSString *)imageName{
    [_imgView removeFromSuperview];
    _imgView = [[UIView alloc]initWithFrame:CGRectMake(0, 300*BIZ, 375*BIZ, (667-320)*BIZ -64)];
    _imgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imgView];
    UIImageView *img = [[UIImageView alloc]init];
    if ([imageName isEqualToString:@"还没到时间哦！"]) {
        img.frame = CGRects(149, 60, 76, 105);
    }else{
        img.frame = CGRects(155, 60, 64, 126);
    }
    img.image = [UIImage imageNamed:imageName];
    [_imgView addSubview:img];
}

@end
