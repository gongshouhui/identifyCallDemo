//
//  YSPerfEvaluaListModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/19.
//

#import "YSPerfEvaluaListModel.h"

@implementation YSPerfEvaluaListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @[@"planName", @"name"]};
}

@end
