//
//  YSReactNativeManager.h
//  YaSha-iOS
//
//  Created by GZl on 2019/9/17.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSReactNativeManager : NSObject<RCTBridgeDelegate>

+ (instancetype)shareInstance;

// 全局唯一的bridge
@property (nonatomic, readonly, strong) RCTBridge *bridge;

@end

NS_ASSUME_NONNULL_END
