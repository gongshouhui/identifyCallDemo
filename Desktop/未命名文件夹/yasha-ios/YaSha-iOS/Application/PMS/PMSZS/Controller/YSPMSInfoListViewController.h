//
//  YSPMSInfoListViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/26.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"

typedef enum : NSUInteger {
    AutotrophyInfo,
    CheckInfo,
    CooperationInfo,
} PMSInfoType;

@interface YSPMSInfoListViewController : YSCommonListViewController

@property (nonatomic, assign) PMSInfoType PMSInfoType;

@end
