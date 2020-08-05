//
//  YSPMSMQPlanProgressViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"

typedef void(^refreshPlanInfoBlock)();

@interface YSPMSMQPlanProgressViewController : YSCommonListViewController

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, copy) refreshPlanInfoBlock refreshBlock;

@end
