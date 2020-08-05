//
//  YSPMSMQEarlyPreHandleController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/25.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"
#import "YSPMSPlanListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,PrePareStatus){
    PrePareStatusStart = 1,//开工
    PrePareStatusStartHold,//跟踪
    PrePareStatusStartComplete,//完工
};
@interface YSPMSMQEarlyPreHandleController : YSCommonListViewController
@property (nonatomic,assign) PrePareStatus status;
@property (nonatomic,strong) YSPMSPlanListModel *model;
@property (nonatomic,strong) void(^refreshEarlyPreBlock)();
@end

NS_ASSUME_NONNULL_END
