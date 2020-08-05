//
//  YSEMSMyTripListModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/14.
//

#import "YSEMSMyTripListModel.h"

@implementation YSEMSMyTripListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"businessTripList": YSEMSMyTripSubListModel.class};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _createTime = [YSUtility formatTimestamp:dic[@"createTime"] Length:16];
    _startTime = [YSUtility formatTimestamp:dic[@"startTime"] Length:10];
    _endTime = [YSUtility formatTimestamp:dic[@"endTime"] Length:10];
    
    return YES;
}

@end


@implementation YSEMSMyTripSubListModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _businessArea = [dic[@"businessArea"] intValue] == 1 ? @"国内" : @"国外";
    
    return YES;
}

@end
