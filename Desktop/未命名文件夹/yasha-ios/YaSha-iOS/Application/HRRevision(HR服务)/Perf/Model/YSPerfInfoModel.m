//
//  YSPerfInfoModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSPerfInfoModel.h"

@implementation YSPerfInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"examScoreVoList" : [YSPerfSubInfoModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"id" : @[@"scoreId", @"id"]};
}

@end

@implementation YSPerfSubInfoModel

@end
