//
//  YSPMSPlanInfoViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/12/13.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"

typedef NS_ENUM(NSInteger, YSConstructionProgressType) {
    YSConstructionProgressNomal = 0,                         // 正常
    YSConstructionProgressControlDelay = 8,
    YSConstructionProgressStartDelay = 1,
    YSConstructionProgressCompeleteDelay = 3,
    YSConstructionProgressFifteenDelay = 9,
    YSConstructionProgressThirtyDelay = 10,
    YSConstructionProgressMoreThirtyDelay = 11
};

@interface YSPMSPlanInfoViewController : YSCommonTableViewController

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *proManagerId;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, copy) void(^refreshPlanListBlock)();
@end
