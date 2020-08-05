//
//  YSSupplyListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/4.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"

typedef enum : NSUInteger {
    QualifiedSupplyInfo,
    AllSupplyInfo,
}SupplyType;

@interface YSSupplyListViewController : YSCommonListViewController

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) SupplyType SupplyType;

@end
