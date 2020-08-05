//
//  YSHRMTDeptTreeModel.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/11.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMTDeptTreeModel.h"

@implementation YSHRMTDeptTreeModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{ @"leader" : [LeaderModel class],
              };
}
@end

@implementation LeaderModel



@end
