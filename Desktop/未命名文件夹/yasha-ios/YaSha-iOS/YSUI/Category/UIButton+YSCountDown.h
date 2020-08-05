//
//  UIButton+YSCountDown.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/28.
//

#import <UIKit/UIKit.h>

@interface UIButton (YSCountDown)


/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的子名字，如时、分
 *  @param mColor   还没倒计时的颜色
 *  @param color    倒计时中的颜色
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;

@end
