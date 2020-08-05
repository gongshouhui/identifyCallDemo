//
//  YSAttendanceCalendarView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/25.
//
//

#import "YSAttendanceCalendarView.h"

@implementation YSAttendanceCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kThemeColor;
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    _calendar = [[FSCalendar alloc] initWithFrame:CGRects(0, 0, 375, 300)];
    _calendar.appearance.todayColor = [UIColor colorWithRed:35.0/255.0 green:128.0/255.0 blue:217.0/255.0 alpha:1.00];
    _calendar.appearance.headerTitleColor = [UIColor whiteColor];
    _calendar.appearance.weekdayTextColor = [UIColor whiteColor];
    _calendar.appearance.titleDefaultColor = [UIColor whiteColor];
    _calendar.appearance.titleSelectionColor = [UIColor whiteColor];
    _calendar.backgroundColor = YSThemeManagerShare.currentTheme.themeCalendarColor;
    [self addSubview:_calendar];
}

@end
