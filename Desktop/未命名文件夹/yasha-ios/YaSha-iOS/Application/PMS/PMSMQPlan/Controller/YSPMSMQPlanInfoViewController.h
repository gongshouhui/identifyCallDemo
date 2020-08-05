//
//  YSPMSMQPlanInfoViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCommonTableViewController.h"

typedef NS_ENUM(NSInteger, YSConstructionProgressType) {
    YSConstructionProgressNomal = 0,                         // 正常
    YSConstructionProgressControlDelay = 8,
    YSConstructionProgressStartDelay = 1,
    YSConstructionProgressCompeleteDelay = 3,
};

@interface YSPMSMQPlanInfoViewController : YSCommonTableViewController

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *proManagerId;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, copy) void(^refreshPlanListBlock)();

@end
