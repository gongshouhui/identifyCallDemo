//
//  YSCalendar.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/25.
//
//

#import "YSCalendar.h"

@implementation YSCalendar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(30*kWidthScale+2, kTopHeight, kSCREEN_WIDTH-60*kWidthScale-4, 300);
        self.appearance.todayColor = [UIColor colorWithRed:0.44 green:0.76 blue:0.93 alpha:1.00];
        self.appearance.headerTitleColor = [UIColor whiteColor];
        self.appearance.weekdayTextColor = [UIColor whiteColor];
        self.appearance.titleDefaultColor = [UIColor whiteColor];
        self.appearance.titleSelectionColor = [UIColor whiteColor];
        self.appearance.selectionColor = [UIColor colorWithRed:1.00 green:0.79 blue:0.39 alpha:1.00];
        self.appearance.eventSelectionColor = [UIColor colorWithRed:0.58 green:0.82 blue:0.95 alpha:1.00];
        self.appearance.eventDefaultColor = [UIColor colorWithRed:0.58 green:0.82 blue:0.95 alpha:1.00];
        self.backgroundColor = YSThemeManagerShare.currentTheme.themeCalendarColor;
    }
    return self;
}

@end
