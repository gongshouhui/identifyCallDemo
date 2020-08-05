//
//  YSDeptTreePointModel.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/23.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSDeptTreePointModel.h"

@implementation YSDeptTreePointModel
-(instancetype)initWithPointDic:(NSDictionary *)pointDic {
    self = [super init];
    if (self) {
        _point_id = [pointDic[@"id"] copy];
        _point_name = [pointDic[@"name"] copy];
        _point_pid = [pointDic[@"pid"] copy];
        _point_son1 = pointDic[@"children"];
        if (pointDic[@"children"]) {
            _point_son = @"1";
        }
    }
    return self;
}
@end
