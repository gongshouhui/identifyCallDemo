//
//  YSConstants.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2016/11/17.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSConstants.h"

@implementation YSConstants

#if YASHA_DEBUG == 1  //暂时分为 YASHA_DEBUG == 1测试环境   YASHA_DEBUG == 0 生产环境，分别对应相应的debug和release版本

NSString *const YSDomain = @"https://imapitest.chinayasha.com/yahu-rest/";
NSString *const YSImageDomain = @"http://10.10.20.204";
NSString *const YSUpdateDomain = @"https://imapitest.chinayasha.com";
NSString *const YSDownloadDomain = @"https://imapitest.chinayasha.com/download/app.html";
NSString *const YSRechargeDomain = @"http://www.weihouqin.cn/agent/app/index.php?i=45&c=entry&do=index&m=maihu_yktservice";
//考评模板
NSString *const YSTemplateDomain = @"http://hometest.chinayasha.com:8880/t/";
//复核考核模板
NSString *const YSCheckTemplateDomain = @"http://hometest.chinayasha.com:8880/c/";

#else

NSString *const YSDomain = @"https://imapi.chinayasha.com/yahu-rest/";
NSString *const YSImageDomain = @"http://file.chinayasha.com";
NSString *const YSUpdateDomain = @"https://imapi.chinayasha.com";
NSString *const YSDownloadDomain = @"https://imapi.chinayasha.com/download/app.html";
NSString *const YSRechargeDomain = @"http://www.weihouqin.cn/agent/app/index.php?i=45&c=entry&do=index&m=maihu_yktservice";
NSString *const YSTemplateDomain = @"http://scs.chinayasha.com/t/";
NSString *const YSCheckTemplateDomain = @"http://scs.chinayasha.com/c/";

#endif




NSString *const FlowTaskZH = @"知会";
NSString *const FlowTaskSP = @"审批";
NSString *const FlowTaskBSP = @"不审批";
NSString *const FlowTaskXT = @"协同";
NSString *const FlowTaskPS = @"评审";
NSString *const FlowTaskSPZ = @"审批中";



@end
