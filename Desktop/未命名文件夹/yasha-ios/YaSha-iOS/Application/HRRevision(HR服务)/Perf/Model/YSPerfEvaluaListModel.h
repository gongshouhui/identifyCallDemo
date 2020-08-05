//
//  YSPerfEvaluaListModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/19.
//

#import <Foundation/Foundation.h>

@interface YSPerfEvaluaListModel : NSObject

@property (nonatomic, strong) NSString *name;    // 绩效名
@property (nonatomic, strong) NSString *planCode;    // 方案编号
@property (nonatomic, strong) NSString *personName;    // 被考核人
@property (nonatomic, strong) NSString *flowStatusStr;    // 计划状态
@property (nonatomic, strong) NSString *id;    // 人员id
@property (nonatomic, strong) NSString *planId;    // 计划id

@end
