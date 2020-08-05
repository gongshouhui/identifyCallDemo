//
//  YSRightToLeftTransition.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/22.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSRightToLeftTransition : NSObject<UIViewControllerTransitioningDelegate>
+ (instancetype)sharedYSTransition;
@end

NS_ASSUME_NONNULL_END
