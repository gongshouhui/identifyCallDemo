//
//  YSFlowTripFormModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/6.
//

#import "YSFlowTripFormModel.h"

@implementation YSFlowTripFormModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"baseInfo": YSFlowFormHeaderModel.class};
}

@end

@implementation YSFlowTripFormListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"businessTripList" : [YSFlowBusinessTripListModel class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _areaCompany = [dic[@"areaCompany"] intValue] == 0  ? @"否" : @"是";
    _proPerson = [dic[@"proPerson"] intValue] == 0 ? @"否" : @"是";
    return YES;
}

@end

@implementation YSFlowBusinessTripListModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _bookHotal = [dic[@"bookHotal"] intValue] == 0 ? @"否" : @"是";
    return YES;
}

@end
