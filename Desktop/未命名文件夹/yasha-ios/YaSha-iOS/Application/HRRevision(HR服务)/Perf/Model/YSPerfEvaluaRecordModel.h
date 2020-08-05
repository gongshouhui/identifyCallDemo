//
//  YSPerfEvaluaRecordModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/21.
//

#import <Foundation/Foundation.h>

@interface YSPerfEvaluaRecordModel : NSObject

@property (nonatomic, strong) NSString *typeStr;    // 记录状态
@property (nonatomic, strong) NSString *optName;    // 审批者
@property (nonatomic, strong) NSString *remark;    // 记录
@property (nonatomic, assign) NSInteger type;    // 记录类型
@property (nonatomic, strong) NSString *createTime;    // 创建时间
@property (nonatomic, strong) NSString *rebackReason;    // 原因说明

@end
