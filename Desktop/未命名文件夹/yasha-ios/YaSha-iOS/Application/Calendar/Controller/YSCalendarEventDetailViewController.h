//
//  YSCalendarEventDetailViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/7.
//

#import <UIKit/UIKit.h>
#import "YSCalendarEventModel.h"

@interface YSCalendarEventDetailViewController : UIViewController

@property (nonatomic, assign) BOOL hasAuth;
@property (nonatomic, strong) YSCalendarEventModel *model;
@property (nonatomic, copy) void(^DeleteBlock)(YSCalendarEventModel *model);

@end
