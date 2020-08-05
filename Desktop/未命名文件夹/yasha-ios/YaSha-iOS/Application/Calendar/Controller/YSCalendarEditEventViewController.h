//
//  YSCalendarEditEventViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/7.
//

#import <UIKit/UIKit.h>
#import "YSCalendarEventModel.h"

@interface YSCalendarEditEventViewController : UITableViewController

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSString *receiveNo;
@property (nonatomic, strong) YSCalendarEventModel *model;
@property (nonatomic, copy) void(^ReturnBlock)(YSCalendarEventModel *model);

@end
