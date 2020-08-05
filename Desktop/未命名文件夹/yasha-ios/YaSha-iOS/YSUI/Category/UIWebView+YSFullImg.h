//
//  UIWebView+YSFullImg.h
//  YaSha-iOS
//
//  Created by GZl on 2020/7/8.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWebView (YSFullImg)
- (void)imageRepresentation:(void(^)(UIImage * img))block;
@end

NS_ASSUME_NONNULL_END
