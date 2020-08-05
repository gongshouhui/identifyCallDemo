//
//  YSFlowFormModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import "YSFlowFormModel.h"

@implementation YSFlowFormModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"baseInfo": YSFlowFormHeaderModel.class,
             @"dataInfo" : [YSFlowFormListModel class]
//             @"transferList":[YSFlowTransferModel class],
//             @"examinationList":[YSFlowTransferModel class],
//             @"postscriptList":[YSFlowTransferModel class]
             };
}

@end

@implementation YSFlowFormHeaderModel

@end

@implementation YSFlowFormListModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *fieldType = dic[@"fieldType"];
    if ([fieldType isEqual:@"datetime"]) {
        NSString *value = [NSString stringWithFormat:@"%@", dic[@"value"]];
        _value = [YSUtility formatTimestamp:value Length:16];
    }
    return YES;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"values" : [YSFlowFormListModel class]};
}
@end
@implementation YSFlowTransferModel

@end

