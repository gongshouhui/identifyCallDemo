//
//  YSReactNativeManager.m
//  YaSha-iOS
//
//  Created by GZl on 2019/9/17.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReactNativeManager.h"

@implementation YSReactNativeManager
static YSReactNativeManager *_instance = nil;

+ (instancetype)shareInstance{
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}

-(instancetype)init{
    if (self = [super init]) {
        _bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
    }
    return self;
}

#pragma mark - RCTBridgeDelegate
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
/*
    //debug
    return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"
                                                          fallbackResource:nil];*/
    //测试
//    return [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];//localhost 10.20.30.79 192.168.31.25
    
    //发布
    return [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"bundle/index.ios.jsbundle" ofType:nil]];
}



@end
