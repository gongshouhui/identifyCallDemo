//
//  YSLawCaseModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/7.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSLawCaseModel.h"
#import "YSLawDepartModel.h"
@implementation YSLawCaseModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"lawsuitDeptList":[YSLawDepartModel class]};
}
@end
