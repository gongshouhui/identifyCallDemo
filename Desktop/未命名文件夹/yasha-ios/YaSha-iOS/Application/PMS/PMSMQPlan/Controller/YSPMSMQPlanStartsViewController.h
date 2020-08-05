//
//  YSPMSMQPlanStartsViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"
//计划详情
@interface YSPMSMQPlanStartsViewController : YSCommonListViewController

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *proManagerId;

@property (nonatomic, copy) void(^refreshPlanInfoBlock)();

@end
