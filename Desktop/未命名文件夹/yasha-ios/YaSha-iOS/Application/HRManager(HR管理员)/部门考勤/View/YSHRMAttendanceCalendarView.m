//
//  YSHRMAttendanceCalendarView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMAttendanceCalendarView.h"

@implementation YSHRMAttendanceCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    _calendar = [[FSCalendar alloc] initWithFrame:CGRects(0, 0, kSCREEN_WIDTH, 300*kHeightScale)];
    // 今日日期的背景色
    _calendar.appearance.todayColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#1890FF"];
    //今日日期的标题色
    _calendar.appearance.titleTodayColor = [UIColor colorWithHexString:@"#191F25"];//[UIColor whiteColor];
    
    _calendar.appearance.headerTitleColor = [[UIColor colorWithHexString:@"#191F25"] colorWithAlphaComponent:0.8];
    _calendar.appearance.weekdayTextColor = [[UIColor colorWithHexString:@"#1890FF"] colorWithAlphaComponent:0.5];
    
    // 默认的日期标题颜色
    _calendar.appearance.titleDefaultColor = [UIColor colorWithHexString:@"#191F25"];
    // 选中的日期的颜色
    _calendar.appearance.titleSelectionColor = [UIColor whiteColor];
    //选中的日期的背景色
    _calendar.appearance.selectionColor = [UIColor colorWithHexString:@"#1890FF"];

    _calendar.backgroundColor = [UIColor whiteColor];
    [self addSubview:_calendar];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
