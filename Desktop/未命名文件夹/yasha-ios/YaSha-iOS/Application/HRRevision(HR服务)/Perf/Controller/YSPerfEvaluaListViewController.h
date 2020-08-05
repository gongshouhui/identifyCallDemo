//
//  YSPerfEvaluaListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/19.
//

#import "YSCommonListViewController.h"

typedef enum : NSUInteger {
    PerfSelfEvalua,
    PerfReEvalua,
} PerfEvaluaType;

@interface YSPerfEvaluaListViewController : YSCommonListViewController

@property (nonatomic, assign) PerfEvaluaType perfEvaluaType;

@end
