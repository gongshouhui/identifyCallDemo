//
//  YSPMSPlanAddPhotoViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/29.
//

#import <UIKit/UIKit.h>
#import "YSPMSPlanListModel.h"
typedef enum :NSUInteger{
    YSPMSPlanTypeStarts,
    YSPMSPlanTypeTracking,
    YSPMSPlanTypeCompletion,
}YSPMSPlanType;

@interface YSPMSPlanAddPhotoViewController : UIViewController

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *taskStatus;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) YSPMSPlanType planType;
@property (nonatomic, strong) YSPMSPlanListModel *model;
@property (nonatomic, copy) void(^refreshPlanStart)();
@end
