//
//  YSPMSMQEarlyPreTaskController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/23.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"
#import "YSPMSPlanListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSPMSMQEarlyPreTaskController : YSCommonListViewController
@property (nonatomic,strong) YSPMSPlanListModel *engineeringModel;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic,strong) void(^refreshPrePlanBlock)();
@end

NS_ASSUME_NONNULL_END
