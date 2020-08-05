//
//  YSInfoSelfHelpModel.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRInfoSelfHelpModel.h"

@implementation YSHRInfoSelfHelpModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{ @"familys" : [YSHRFamilyModel class],
              @"langs" : [YSHRLanguageModel class],
              @"linkmans" : [YSHRLinkManModel class],
             };
}
@end
