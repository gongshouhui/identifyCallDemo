//
//  YSContactModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/8.
//Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactModel.h"

@implementation YSContactModel

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"pNum" : @0,
             @"isPublic" : @"0",
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSInteger sex = [dic[@"sex"] integerValue];
    // 1男性，2女性
    _sex = sex == 1 ? YES : NO;
    _userId = dic[@"no"];
    // 应DZDY要求，有默认头像，本地需截取重新拼接
    NSString *headImgString = dic[@"headImg"];
    if ([headImgString containsString:@"_L.jpg"]) {
        NSRange subRange = [headImgString rangeOfString:@"_L.jpg"];
        _headImg = [headImgString substringToIndex:subRange.location];
    }
    
    if ([dic[@"isPublic"] isEqual:[NSNull null]]) {
        _isPublic = @"0";
    }
    
    return YES;
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues {
//    return @{@"isSelected": @NO};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
