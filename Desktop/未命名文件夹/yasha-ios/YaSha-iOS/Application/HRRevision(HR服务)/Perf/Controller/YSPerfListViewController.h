//
//  YSPerfListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSCommonListViewController.h"

typedef enum : NSUInteger {
    MonthPerf,
    QtlyPerf,
    YearPerf,
} PerfType;

@interface YSPerfListViewController : YSCommonListViewController

@property (nonatomic, assign) PerfType perfType;

@end
