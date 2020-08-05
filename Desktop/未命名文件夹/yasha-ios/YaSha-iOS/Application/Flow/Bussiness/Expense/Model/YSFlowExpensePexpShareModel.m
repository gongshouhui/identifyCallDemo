//
//  YSFlowExpensePexpShareModel.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/14.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowExpensePexpShareModel.h"

@implementation YSFlowExpensePexpShareModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"dShareDetailList":[YSFlowExpenseShareDetailModel class],
             @"marketShareDetailList":[YSFlowExpenseShareDetailModel class]
             };
}
@end
@implementation YSFlowExpenseShareDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"detailItem":[YSFlowExpenseDetailItemModel class]};
}
@end
@implementation YSFlowExpenseDetailItemModel

@end

