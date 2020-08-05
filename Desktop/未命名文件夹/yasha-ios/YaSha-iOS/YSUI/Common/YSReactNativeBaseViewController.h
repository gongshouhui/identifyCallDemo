//
//  YSReactNativeBaseViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/9/17.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSReactNativeBaseViewController : UIViewController
/**
 传递到React Native的参数
 */
@property (nonatomic, strong) NSDictionary * initialProperty;

/**
 React Native界面名称
 */
@property (nonatomic, copy) NSString * pageName;

+ (instancetype)RNPageWithName:(NSString*)pageName initialProperty:(NSDictionary*)initialProperty;

- (instancetype)initWithPageName:(NSString*)pageName initialProperty:(NSDictionary*)initialProperty;
@end

NS_ASSUME_NONNULL_END
