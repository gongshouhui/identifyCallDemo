//
//  UIButton+RepetitionDisable.h
//  NormalClickButton
//
//  Created by 龚守辉 on 2018/6/22.
//  Copyright © 2018年 mianduijifengba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#define DefaultIntervalTime 0.5//默认时间间隔
@interface UIButton (RepetitionDisable)
//分类不能添加属性，添加了属性是不能生成实例变量的，需要我们写set get方法
@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔
@property(nonatomic,assign) BOOL isIgnoreEvent;//YES不允许点击NO允许点击
@end
