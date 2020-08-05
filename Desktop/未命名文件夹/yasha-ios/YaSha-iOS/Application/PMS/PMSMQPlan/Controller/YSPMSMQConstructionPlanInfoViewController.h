//
//  YSPMSMQConstructionPlanInfoViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/5.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"



@interface YSPMSMQConstructionPlanInfoViewController : YSCommonListViewController

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *proManagerId;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, copy) void(^refreshPlanListBlock)();

@end
