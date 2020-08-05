//
//  NSObject+ChangeTool.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ChangeTool)

/**
 *  交换两个函数实现指针  参数均为NSString类型
 *
 *  @param systemMethodString 系统方法名string
 *  @param systemClassString  系统实现方法类名string
 *  @param safeMethodString   自定义hook方法名string
 *  @param targetClassString  目标实现类名string
 */
+ (void)SwizzlingMethod:(NSString *)systemMethodString systemClassString:(NSString *)systemClassString toSafeMethodString:(NSString *)safeMethodString targetClassString:(NSString *)targetClassString;

@end
