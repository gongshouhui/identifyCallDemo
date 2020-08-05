//
//  YSCalendarEventView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/9.
//

#import "YSCalendarEventView.h"
#import "YSCalendarEventViewCell.h"

@interface YSCalendarEventView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *eventArray;

@end

@implementation YSCalendarEventView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _sendButtonSubject = [RACSubject subject];
    _eventArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-(130+kTopHeight)) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[YSCalendarEventViewCell class] forCellReuseIdentifier:@"CalendarEventViewCell"];
    [self addSubview:_tableView];
}

- (void)reloadData {
    [_eventArray removeAllObjects];
    for (UIButton *button in [self.tableView subviews]) {
        if (button.tag) {
            [button removeFromSuperview];
        }
    }
    [_eventArray addObjectsFromArray:[_dataSource eventForCalendarEventView:self]];
    [self addEvent];
}

- (void)addEvent {
    for (YSCalendarEventModel *model in _eventArray) {
        NSInteger start_hour = [[model.start substringFromIndex:11] integerValue];
        NSInteger start_minute = [[model.start substringFromIndex:14] integerValue];
        NSInteger end_hour = [[model.end substringFromIndex:11] integerValue];
        NSInteger end_minute = [[model.end substringFromIndex:14] integerValue];
        NSArray *sameDayArray = [self numberOfSameDay:model];
        UIButton *button = [[UIButton alloc] init];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        BOOL overdue = [[[formatter dateFromString:model.end] dateByAddingHours:8] isLaterThan:[[NSDate date] dateByAddingHours:8]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = overdue ? [UIColor colorWithRed:0.74 green:0.92 blue:0.99 alpha:1.00] : [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        button.titleLabel.numberOfLines = 0;
        button.layer.borderWidth = 0.3;
        button.layer.borderColor = UIColorBlack.CGColor;
        button.tag = [_eventArray indexOfObject:model]+1;
        [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:model.title forState:UIControlStateNormal];
        [self.tableView addSubview:button];
        if (_calendarEventViewType == YSCalendarEventWeek) {
            if (start_hour == 0 && start_minute == 0 && end_hour == 23 && end_minute == 59) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.tableView.mas_top);
                    make.left.mas_equalTo(self.tableView.mas_left).offset(2+30*kWidthScale+(kSCREEN_WIDTH-60*kWidthScale-4)/7*model.week+(kSCREEN_WIDTH-60*kWidthScale-4)/7/sameDayArray.count*[sameDayArray indexOfObject:model]);
                    make.bottom.mas_equalTo(self.tableView.mas_top).offset(50*kHeightScale);
                    make.width.mas_equalTo((kSCREEN_WIDTH-60*kWidthScale-4)/7/sameDayArray.count);
                }];
            } else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.tableView.mas_top).offset(50*kHeightScale + start_hour*50*kHeightScale + start_minute*kHeightScale/60.0*50.0);
                    make.left.mas_equalTo(self.tableView.mas_left).offset(2+30*kWidthScale+(kSCREEN_WIDTH-60*kWidthScale-4)/7*model.week+(kSCREEN_WIDTH-60*kWidthScale-4)/7/sameDayArray.count*[sameDayArray indexOfObject:model]);
                    make.bottom.mas_equalTo(self.tableView.mas_top).offset(50*kHeightScale + end_hour*50*kHeightScale + end_minute*kHeightScale/60.0*50.0);
                    make.width.mas_equalTo((kSCREEN_WIDTH-60*kWidthScale-4)/7/sameDayArray.count);
                }];
            }
        } else {
            if (start_hour == 0 && start_minute == 0 && end_hour == 23 && end_minute == 59) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.tableView.mas_top);
                    make.left.mas_equalTo(self.tableView.mas_left).offset(2+30*kWidthScale+(kSCREEN_WIDTH-60*kWidthScale-4)/_eventArray.count*[_eventArray indexOfObject:model]);
                    make.bottom.mas_equalTo(self.tableView.mas_top).offset(50*kHeightScale);
                    make.width.mas_equalTo((kSCREEN_WIDTH-60*kWidthScale-4)/_eventArray.count);
                }];
            } else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.tableView.mas_top).offset(50*kHeightScale + start_hour*50*kHeightScale + start_minute*kHeightScale/60.0*50.0);
                    make.left.mas_equalTo(self.tableView.mas_left).offset(2+30*kWidthScale+(kSCREEN_WIDTH-60*kWidthScale-4)/_eventArray.count*[_eventArray indexOfObject:model]);
                    make.bottom.mas_equalTo(self.tableView.mas_top).offset(50*kHeightScale + end_hour*50*kHeightScale + end_minute*kHeightScale/60.0*50.0);
                    make.width.mas_equalTo((kSCREEN_WIDTH-60*kWidthScale-4)/_eventArray.count);
                }];
            }
        }
    }
}

- (void)clickedButton:(UIButton *)button {
    [_sendButtonSubject sendNext:button];
}

- (NSArray *)numberOfSameDay:(YSCalendarEventModel *)eventModel {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (YSCalendarEventModel *model in [_dataSource eventForCalendarEventView:self]) {
        if (eventModel.week == model.week) {
            [mutableArray addObject:model];
        }
    }
    return [mutableArray copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCalendarEventViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarEventViewCell"];
    cell = [[YSCalendarEventViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarEventViewCell"];
    [cell setTimeWithIndexPath:indexPath withLine:_calendarEventViewType == YSCalendarEventWeek ? YES : NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
