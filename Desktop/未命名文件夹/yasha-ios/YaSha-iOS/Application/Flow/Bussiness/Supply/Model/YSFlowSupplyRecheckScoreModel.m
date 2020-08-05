//
//  YSFlowSupplyRecheckScoreModel.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2017/12/28.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowSupplyRecheckScoreModel.h"

@implementation YSFlowSupplyRecheckScoreModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"admitScoreList":[YSFlowSupplyRecheckScoreListModel class]};
}

@end
@implementation YSFlowSupplyRecheckScoreListModel
@end
