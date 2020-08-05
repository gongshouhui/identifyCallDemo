//
//  YSWYQYManager.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/12/10.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSWYQYManager.h"
//#import "QYSDK.h"
#import "YSContactModel.h"
@interface YSWYQYManager()
@end
@implementation YSWYQYManager

//+(void)setUpCurrentUserInfo {
//    RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"userId = '%@'", [YSUtility getUID]]];
//    if (!results.count) {
//        return;
//    }
//    YSContactModel *userModel = results.firstObject;
//    //修改f访客头像
//    QYCustomUIConfig *config = [[QYSDK sharedSDK] customUIConfig];
//    config.customerHeadImageUrl = [NSString stringWithFormat:@"%@_M.jpg", userModel.headImg];
//    //修改对话框系统头像
//    config.serviceHeadImage = [UIImage imageNamed:@"logo"];
//    
//    //输入用户信息
//    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
//    userInfo.userId = userModel.userId;
//    NSString *name = userModel.name;
//    NSMutableArray *array = [NSMutableArray new];
//    NSMutableDictionary *dictRealName = [NSMutableDictionary new];
//    [dictRealName setObject:@"real_name" forKey:@"key"];
//    [dictRealName setObject:name forKey:@"value"];
//    [array addObject:dictRealName];
//    NSMutableDictionary *dictAvatar = [NSMutableDictionary new];
//    [dictAvatar setObject:@"avatar" forKey:@"key"];
//    [dictAvatar setObject:[NSString stringWithFormat:@"%@_M.jpg", userModel.headImg] forKey:@"value"];
//    [array addObject:dictAvatar];
//    NSMutableDictionary *dictMobilePhone = [NSMutableDictionary new];
//    [dictMobilePhone setObject:@"mobile_phone" forKey:@"key"];
//    [dictMobilePhone setObject:userModel.phone forKey:@"value"];
//    [dictMobilePhone setObject:@(NO) forKey:@"hidden"];
//    [array addObject:dictMobilePhone];
////    NSMutableDictionary *dictEmail = [NSMutableDictionary new];
////    [dictEmail setObject:@"email" forKey:@"key"];
////    [dictEmail setObject:@"bianchen@163.com" forKey:@"value"];
////    [array addObject:dictEmail];
////    NSMutableDictionary *dictAuthentication = [NSMutableDictionary new];
////    [dictAuthentication setObject:@(0) forKey:@"index"];
////    [dictAuthentication setObject:@"authentication" forKey:@"key"];
////    [dictAuthentication setObject:@"实名认证" forKey:@"label"];
////    [dictAuthentication setObject:@"已认证" forKey:@"value"];
////    [array addObject:dictAuthentication];
////    NSMutableDictionary *dictBankcard = [NSMutableDictionary new];
////    [dictBankcard setObject:@(1) forKey:@"index"];
////    [dictBankcard setObject:@"bankcard" forKey:@"key"];
////    [dictBankcard setObject:@"绑定银行卡" forKey:@"label"];
////    [dictBankcard setObject:@"622202******01116068" forKey:@"value"];
////    [array addObject:dictBankcard];
////
//    NSData *data = [NSJSONSerialization dataWithJSONObject:array
//                                                   options:0
//                                                     error:nil];
//    if (data)
//    {
//        userInfo.data = [[NSString alloc] initWithData:data
//                                              encoding:NSUTF8StringEncoding];
//    }
//     [[QYSDK sharedSDK] setUserInfo:userInfo];
//}
@end
