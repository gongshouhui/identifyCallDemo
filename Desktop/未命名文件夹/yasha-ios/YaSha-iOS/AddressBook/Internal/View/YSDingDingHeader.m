//
//  YSDingDingHeader.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/7.
//
//

#import "YSDingDingHeader.h"

@implementation YSDingDingHeader

+ (YSDingDingHeader *)shareHelper {
    static YSDingDingHeader *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [YSDingDingHeader new];
        helper.titleList = @[].mutableCopy;
        
    });
    return helper;
}

@end
