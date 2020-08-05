//
//  YSCalendarEventView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/9.
//

#import <UIKit/UIKit.h>
#import "YSCalendarEventModel.h"

@class YSCalendarEventView;

typedef enum : NSUInteger {
    YSCalendarEventWeek,
    YSCalendarEventDay,
} YSCalendarEventViewType;

@protocol YSCalendarEventViewDataSource <NSObject>

@required
- (NSArray *)eventForCalendarEventView:(YSCalendarEventView *)calendarEventView;

@end

@protocol YSCalendarEventViewDelegate <NSObject>
@optional
- (void)didSelectedEvent:(YSCalendarEventModel *)calendarEventModel;
@end


@interface YSCalendarEventView : UIView

@property (nonatomic, strong) RACSubject *sendButtonSubject;
@property (nonatomic, assign) YSCalendarEventViewType calendarEventViewType;
@property (nonatomic, strong) id<YSCalendarEventViewDataSource>dataSource;
@property (nonatomic, strong) id<YSCalendarEventViewDelegate>delegate;
- (void)reloadData;

@end
