//
//  YSRightToleftPresentationController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/22.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRightToleftPresentationController.h"

@implementation YSRightToleftPresentationController
//过渡即将开始时的处理
- (void)presentationTransitionWillBegin
{
    self.presentedView.frame = self.containerView.frame;
    [self.containerView addSubview:self.presentedView];
}


- (void)presentationTransitionDidEnd:(BOOL)completed
{
    
}
- (void)dismissalTransitionWillBegin
{
    
}

//过渡消失时的处理
- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    [self.presentedView removeFromSuperview];
}
@end
