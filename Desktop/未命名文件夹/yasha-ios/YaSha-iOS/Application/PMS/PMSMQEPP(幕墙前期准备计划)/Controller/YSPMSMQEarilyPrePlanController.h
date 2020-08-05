//
//  YSPMSMQEarilyPrePlanController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/18.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"
#import "YSPMSPlanListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,MQTaskType){
    MQExecuteTaskWithinThreeDay = 1,//3日内执行任务
    MQNotStartTask = 2,//未开工任务
    MQIsDoingTask = 3,//进行中任务
    MQCompletedTask = 4,//已完工任务
    MQStartDelayNormalTask = 5,//开工延期 正常任务
    MQStartDelayProgressFifteenDelay = 6,//开工延期0~15天
    MQStartDelayProgressThirtyDelay = 7,//开工延期15~30天
    MQStartDelayProgressMoreThirtyDelay  = 8,//开工延期大于30天
    MQCompletedDelayNormalTask = 9,//完工延期 正常任务
    MQCompletedDelayProgressFifteenDelay = 10,//完工延期0~15天
    MQCompletedDelayProgressThirtyDelay = 11,//完工延期15~30天
    MQCompletedDelayProgressMoreThirtyDelay  = 12,//完工延期大于30天
};
//一般view层（C、V） 持有p层，p层刷新view的时候可通过代理绑定p,v
@interface YSPMSMQEarilyPrePlanController : YSCommonListViewController
@property (nonatomic,strong) YSPMSPlanListModel *engineeringModel;
@property (nonatomic, copy) void(^refreshPlanListBlock)();
@end

NS_ASSUME_NONNULL_END
