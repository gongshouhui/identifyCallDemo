//
//  YSReactNativeModel.m
//  YaSha-iOS
//
//  Created by GZl on 2019/9/27.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReactNativeModel.h"
#import <React/RCTBridgeModule.h>

@implementation YSReactNativeModel

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(navigateBack){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YSModuleNavigateBack" object:nil];
    
}


RCT_EXPORT_METHOD(hiddenLoading){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YSModuleRNhiddenLoad" object:nil];
}

RCT_EXPORT_METHOD(pushWebViewInfo:(NSString*)url :(NSString*)urlShowType){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YSModuleRNToWebView" object:nil userInfo:@{@"url":url,@"urlShowType":urlShowType}];
    
}

/*
 // 可添加参数以指定 RN 访问 OC 的模块名，默认为类名
 // getVersionInfo 为 RN 中调用的方法名
 RCT_EXPORT_METHOD(getVersionInfo:(NSDictionary*)change :(RCTResponseSenderBlock)callback) {
 //change:RN中传过来的参数传过来
 NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
 
 NSString * appCurVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];//准备回调回去的数据
 
 callback(@[[NSNull null], appCurVersion]);
 
 }
 */

@end
