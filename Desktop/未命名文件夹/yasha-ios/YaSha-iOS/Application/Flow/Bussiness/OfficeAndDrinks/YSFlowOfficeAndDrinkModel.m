//
//  YSFlowOfficeAndDrinkModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowOfficeAndDrinkModel.h"
#import "YSNewsAttachmentModel.h"
@implementation YSFlowOfficeAndDrinkApplyInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"fileListFormMobile":[YSNewsAttachmentModel class],
             };
}
@end
@implementation YSFlowOfficeAndDrinkModel

@end
