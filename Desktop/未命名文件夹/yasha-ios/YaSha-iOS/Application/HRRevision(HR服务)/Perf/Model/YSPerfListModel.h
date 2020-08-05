//
//  YSPerfListModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/25.
//
//

#import <Foundation/Foundation.h>

@interface YSPerfListModel : NSObject

@property (nonatomic, strong) NSString *name;    // 绩效名
@property (nonatomic, strong) NSString *code;    // 方案编号
@property (nonatomic, strong) NSString *score;    // 评估总分
@property (nonatomic, strong) NSString *scoreStr;  //判断是否显示图片
@property (nonatomic, strong) NSString *grade;    //
@property (nonatomic, strong) NSString *flowStatusStr;    // 计划状态
@property (nonatomic, strong) NSString *id;    // 人员id
@property (nonatomic, strong) NSString *assessmentTime;    // 月份
@property (nonatomic, strong) NSString *assessmentType;

@end
