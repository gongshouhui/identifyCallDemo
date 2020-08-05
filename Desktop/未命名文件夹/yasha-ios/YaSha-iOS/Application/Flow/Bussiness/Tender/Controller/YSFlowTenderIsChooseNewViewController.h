//
//  YSFlowTenderIsChooseNewViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/4/25.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"
typedef enum : NSUInteger {
    middleMark = 10,
    unMiddleMark = 20,
} YSFlowTenderType;

@interface YSFlowTenderIsChooseNewViewController : YSCommonListViewController

@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, assign) YSFlowTenderType  flowTenderType;
@property (nonatomic, strong) NSString *id;

@end
