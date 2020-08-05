//
//  YSFlowExpressFormModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/4.
//

#import "YSFlowExpressFormModel.h"

@implementation YSFlowExpressFormModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"baseInfo": YSFlowFormHeaderModel.class,
             @"info" : YSFlowExpressListModel.class};
}

@end

@implementation YSFlowExpressListModel

@end
