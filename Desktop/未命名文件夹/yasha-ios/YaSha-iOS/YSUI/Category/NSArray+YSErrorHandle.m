//
//  NSArray+YSErrorHandle.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/9/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "NSArray+YSErrorHandle.h"
#import <objc/runtime.h>
#import "NSObject+YSSwizzleMethod.h"

@implementation NSArray (YSErrorHandle)

+(void)load{
    [super load];
    //无论怎样 都要保证方法只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换NSArray中的objectAtIndex方法
        [objc_getClass("__NSArrayI") SystemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(sxy_objectAtIndex:) error:nil];
        //交换NSArray中的objectAtIndexedSubscript方法
        [objc_getClass("__NSArrayI") SystemSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(sxy_objectAtIndexedSubscript:) error:nil];
    });
}

- (id)sxy_objectAtIndexedSubscript:(NSUInteger)idx{
    if (idx < self.count) {
        return [self sxy_objectAtIndexedSubscript:idx];
    }else{
		
        return nil;
    }
}

- (id)sxy_objectAtIndex:(NSUInteger)index{
    if (index < self.count) {
        return [self sxy_objectAtIndex:index];
    }else{
        
        
        return nil;
    }
}

@end
