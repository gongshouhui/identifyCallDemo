//
//  NSMutableDictionary+Safe.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import <objc/runtime.h>
#import "NSObject+ChangeTool.h"

@implementation NSMutableDictionary (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self SwizzlingMethod:@"st_removeObjectForKey:" systemClassString:@"NSMutableDictionary" toSafeMethodString:@"removeObjectForKey:" targetClassString:@"__NSDictionaryM"];
        [self SwizzlingMethod:@"st_setObject:forKey:" systemClassString:@"NSMutableDictionary" toSafeMethodString:@"setObject:forKey:" targetClassString:@"__NSDictionaryM"];
    });
}

- (void)st_removeObjectForKey:(id)key {
    if (!key) {
        return;
    }
    [self st_removeObjectForKey:key];
}

- (void)st_setObject:(id)obj forKey:(id <NSCopying>)key {
    if (!obj) {
        return;
    }
    if (!key) {
        return;
    }
    [self st_setObject:obj forKey:key];
}

@end
