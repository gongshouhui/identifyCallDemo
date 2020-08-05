//
//  YSPMSMQListViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/2/7.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"

typedef enum : NSUInteger {
    AutotrophyInfoOne,
    AutotrophyInfoTwo,
    CheckInfo,
} PMSMQType;

@interface YSPMSMQListViewController : YSCommonListViewController

@property (nonatomic, assign) PMSMQType PMSMQType;

@end
