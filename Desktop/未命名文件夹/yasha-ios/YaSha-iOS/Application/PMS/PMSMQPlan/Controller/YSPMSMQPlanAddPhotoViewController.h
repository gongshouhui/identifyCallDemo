//
//  YSPMSMQPlanAddPhotoViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSPMSPlanListModel.h"
typedef enum :NSUInteger{
    YSPMSPlanTypeStarts,
    YSPMSPlanTypeTracking,
    YSPMSPlanTypeCompletion,
}YSPMSPlanType;

@interface YSPMSMQPlanAddPhotoViewController : UIViewController

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *taskStatus;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) YSPMSPlanType planType;
@property (nonatomic, strong) YSPMSPlanListModel *model;
@property (nonatomic, copy) void(^refreshPlanStart)();

@end
