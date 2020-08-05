//
//  NSObject+YSSwizzleMethod.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/9/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "NSObject+YSSwizzleMethod.h"

@implementation NSObject (YSSwizzleMethod)

/**
 *  对系统方法进行替换
 *
 *  @param systemSelector 被替换的方法
 *  @param swizzledSelector 实际使用的方法
 *  @param error            替换过程中出现的错误消息
 *
 *  @return 是否替换成功
 */
+ (BOOL)SystemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector error:(NSError *)error{
    
//    //获取交换后的实例方法方法
//    Method newMethod= class_getInstanceMethod([self class], systemSelector);
//    // 获取替换前的实例方法方法
//    Method method = class_getInstanceMethod([self class], swizzledSelector);
//    //交换方法
//    method_exchangeImplementations(newMethod, method);
        Method systemMethod = class_getInstanceMethod(self, systemSelector);
    
        if (!systemMethod) {
            return [[self class] unrecognizedSelector:systemSelector error:error];
        }
    
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        if (!swizzledMethod) {
    
            return [[self class] unrecognizedSelector:swizzledSelector error:error];
        }
    
       
        if (class_addMethod([self class], systemSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
    
            class_replaceMethod([self class], swizzledSelector, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            method_exchangeImplementations(systemMethod, swizzledMethod);
        }
    
    
    return YES;
}
+ (BOOL)unrecognizedSelector:(SEL)selector error:(NSError *)error{
    
    NSString *errorString = [NSString stringWithFormat:@"%@类没有找到%@", NSStringFromClass([self class]), NSStringFromSelector(selector)];
    
    error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorString}];
    
    return NO;
}

@end
