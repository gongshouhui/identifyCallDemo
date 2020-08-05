//
//  YSRightToLeftAnimationTransition.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/22.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRightToLeftAnimationTransition.h"
#import "UIView+Extension.h"
const CGFloat duration = 0.5f;

@implementation YSRightToLeftAnimationTransition


#pragma mark -<UIViewControllerAnimatedTransitioning>
//动画时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return duration;
}
//设置过渡动画（modal和dismiss的动画都需要在这里处理）
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // UITransitionContextToViewKey,
    // UITransitionContextFromViewKey.
    
    //出来的动画
    if (self.presented) {
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        //toView.y = -toView.height;  //设置动画从上往下进来
        toView.x = toView.width;      //设置动画从右往左进来
        
        //设置动画3D旋转
        //toView.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 1, 0);
        
        [UIView animateWithDuration:duration animations:^{
            
            //toView.y = 0;
            toView.x = 0;
            
            //toView.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            //动画完成后,视图上的事件才能处理
            [transitionContext completeTransition:YES];
        }];
    }
    //销毁的动画
    else
    {
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        fromView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:duration animations:^{
            
//            UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            //从上向下出去
            //fromView.y = -fromView.height;
            
//            fromView.x = -fromView.width;     //从右往左出去
            
            fromView.x = fromView.width;//从左往右出去
//            fromView.alpha = 0;
            //3D旋转出去
            //fromView.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 1, 0);
            
        } completion:^(BOOL finished) {
            
            //动画完成后,视图上的事件才能处理
            [transitionContext completeTransition:YES];
        }];
    }
    
}



@end
