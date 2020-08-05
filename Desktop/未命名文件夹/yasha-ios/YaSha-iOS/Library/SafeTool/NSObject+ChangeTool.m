//
//  NSObject+ChangeTool.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "NSObject+ChangeTool.h"
#import <objc/runtime.h>

@implementation NSObject (ChangeTool)

+ (void)SwizzlingMethod:(NSString *)systemMethodString systemClassString:(NSString *)systemClassString toSafeMethodString:(NSString *)safeMethodString targetClassString:(NSString *)targetClassString {
    // 获取系统方法IMP
    Method sysMethod = class_getInstanceMethod(NSClassFromString(systemClassString), NSSelectorFromString(systemMethodString));
    // 自定义方法的IMP
    Method safeMethod = class_getInstanceMethod(NSClassFromString(targetClassString), NSSelectorFromString(safeMethodString));
    // IMP相互交换，方法的实现也就互相交换了
    method_exchangeImplementations(safeMethod,sysMethod);
}

@end
