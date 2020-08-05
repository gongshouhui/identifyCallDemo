//
//  KJPoint.m
//  TreeTableView
//
//  Created by mHome on 2017/7/4.
//  Copyright © 2017年 yixiang. All rights reserved.
//

#import "KJPoint.h"

@implementation KJPoint

-(instancetype)initWithPointDic:(NSDictionary *)pointDic{
    self = [super init];
    if (self) {
        _point_id = [pointDic[@"classCode"] copy];
//        _point_depth = [pointDic[@"depth"] copy];
        _point_knowid = [pointDic[@"id"] copy];
        _point_name = [pointDic[@"name"] copy];
        _point_pid = [pointDic[@"parentFlag"] copy];
//        _point_pidA = [pointDic[@"pidA"] copy];
//        _point_url = [pointDic[@"url"] copy];
        _point_qNum = [pointDic[@"linkCode"] copy];
        _point_son = [pointDic[@"sonFlag"] copy];
        _point_son1 = pointDic[@"son"];
    }
    return self;
}

@end
