//
//  YSRightToLeftTransition.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/22.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRightToLeftTransition.h"
#import "YSRightToLeftAnimationTransition.h"
#import "YSRightToleftPresentationController.h"

static YSRightToLeftTransition *sharedYSTransition;

@implementation YSRightToLeftTransition

+ (instancetype)sharedYSTransition {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedYSTransition = [[YSRightToLeftTransition alloc]init];
    });
    return sharedYSTransition;
}
#pragma mark - <UIViewControllerTransitioningDelegate>
//返回展示样式
-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    
    return [[YSRightToleftPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}

//展示的动画
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    YSRightToLeftAnimationTransition *animation = [[YSRightToLeftAnimationTransition alloc]init];
    animation.presented = YES;
    return animation;
}

//关闭时的动画
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    YSRightToLeftAnimationTransition *animation = [[YSRightToLeftAnimationTransition alloc]init];
    animation.presented = NO;
    return animation;
}
@end
