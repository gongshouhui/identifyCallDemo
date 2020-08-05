//
//  YSNewsScrollView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/29.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSNewsScrollView.h"

@implementation YSNewsScrollView

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    
//    CGPoint translation = [gestureRecognizer locationInView:self];
//    CGFloat absX = fabs(translation.x);
//    CGFloat absY = fabs(translation.y);
//    
//    // 设置滑动有效距离
//    if (MAX(absX, absY) < 10)
//        return NO;
//    
//    
//    if (absX > absY ) {
//        
//        
//        if (translation.x<0) {
//            
//            //向左滑动
//        }else{
//            
//            //向右滑动
//        }
//        
//    } else if (absY > absX) {
//        
//        if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) {
//            return YES;
//        }
//        if (translation.y<0) {
//            
//            //向上滑动
//        }else{
//            
//            //向下滑动
//        }
//    }
//    
//    
//  
//    return NO;
//}

/**
 *   判断手势方向
 *
 *  @param translation translation description
 */
- (void)commitTranslation:(CGPoint)translation
{
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return;
    
    
    if (absX > absY ) {
      
        
        if (translation.x<0) {
            
            //向左滑动
        }else{
            
            //向右滑动
        }
        
    } else if (absY > absX) {
        
        if (translation.y<0) {
            
            //向上滑动
        }else{
            
            //向下滑动
        }
    }
    
    
}
@end
