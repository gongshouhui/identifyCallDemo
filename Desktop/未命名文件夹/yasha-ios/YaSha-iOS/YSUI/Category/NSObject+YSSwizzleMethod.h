//
//  NSObject+YSSwizzleMethod.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/9/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YSSwizzleMethod)
/**
 *  对系统方法进行替换(交换实例方法)
 *
 *  @param systemSelector 被替换的方法
 *  @param swizzledSelector 实际使用的方法
 *  @param error            替换过程中出现的错误消息
 *
 *  @return 是否替换成功
 */
+ (BOOL)SystemSelector:(SEL)systemSelector swizzledSelector:(SEL)swizzledSelector error:(NSError *)error;
@end
