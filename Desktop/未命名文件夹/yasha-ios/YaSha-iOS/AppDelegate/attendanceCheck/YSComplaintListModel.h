//
//  YSComplaintListModel.h
//  YaSha-iOS
//
//  Created by GZl on 2019/12/25.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSComplaintListModel : NSObject

@property (nonatomic, copy) NSString *userNo;//工号
@property (nonatomic, copy) NSString *resultTypeMsg;//流程类型-翻译
@property (nonatomic, copy) NSString *startTimeStr;//下班打卡时间
@property (nonatomic, copy) NSString *resultType;//考勤结果翻译
@property (nonatomic, copy) NSString *weekStr;//周几
@property (nonatomic, copy) NSString *endTimeStr;//下班打卡时间
@property (nonatomic, copy) NSString *day;//日期 几号
@property (nonatomic, copy) NSString *applyTypeMsg;//考勤的处理状态翻译
@property (nonatomic, copy) NSString *applyType;//该天考勤的处理状态 zc 正常,wss 未申诉,ysd 已锁定,clz 处理中,ycl 已处理
@property (nonatomic, copy) NSString *flowTypeMsg;//流程类型-翻译
@property (nonatomic, copy) NSString *flowType;//流程类型
@property (nonatomic, copy) NSString *dayType;//日期类型 GZR 工作日，FDJJR 法定节假日，XXR 休息日，TX 调休
@property (nonatomic, copy) NSString *dateStr;//日期











@end

NS_ASSUME_NONNULL_END
