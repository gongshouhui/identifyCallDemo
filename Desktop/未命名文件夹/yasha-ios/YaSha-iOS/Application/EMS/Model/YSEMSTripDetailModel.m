//
//  YSEMSTripDetailModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/15.
//

#import "YSEMSTripDetailModel.h"

@implementation YSEMSTripDetailModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _areaCompany = [dic[@"areaCompany"] intValue] == 0 ? @"否" : @"是";
    _startTime = [YSUtility formatTimestamp:dic[@"startTime"] Length:10];
    _endTime = [YSUtility formatTimestamp:dic[@"endTime"] Length:10];
    _proPerson = [dic[@"proPerson"] intValue] == 0 ? @"否": @"是";
    return YES;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"businessTripList" : [YSEMSTripDetailListModel class]};
}

@end

@implementation YSEMSTripDetailListModel : NSObject

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSInteger businessArea = [dic[@"businessArea"] integerValue];
    _businessAreaCode = businessArea;
    _businessArea = businessArea == 1 ? @"国内" : @"国外";
    _startTime = [YSUtility formatTimestamp:dic[@"startTime"] Length:10];
    _endCity = businessArea == 1 ? [NSString stringWithFormat:@"%@%@", dic[@"endProvince"], dic[@"endCity"]] : dic[@"address"];
    _startAddress = [NSString stringWithFormat:@"%@ | %@", dic[@"startProvince"], dic[@"startCity"]];
    _endAddress = businessArea == 1 ? [NSString stringWithFormat:@"%@ | %@", dic[@"endProvince"], dic[@"endCity"]] : dic[@"address"];
    _bookHotal = [dic[@"bookHotal"] intValue] == 0 ? @"否" : @"是";
    return YES;
}

@end

