//
//  YSPerfInfoModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import <Foundation/Foundation.h>

@interface YSPerfInfoModel : NSObject

@property (nonatomic, strong) NSString *workItem;    // 工作项目
@property (nonatomic, strong) NSString *weight;    // 权重
@property (nonatomic, strong) NSString *contentWeight;
@property (nonatomic, strong) NSString *achieveGoal;    // 达成目标
@property (nonatomic, strong) NSString *scoreRemark;
@property (nonatomic, strong) NSString *selfRating;    // 自评分
@property (nonatomic, strong) NSArray *examScoreVoList;    // 评估人
@property (nonatomic, strong) NSArray *examContent;
@property (nonatomic, strong) NSDictionary *examContentForPortal;
@property (nonatomic, strong) NSDictionary *planPerson;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *scoreId;

@end

@interface YSPerfSubInfoModel : NSObject

@property (nonatomic, strong) NSString *evaluatorName;    // 评估人
@property (nonatomic, strong) NSString *weight;    // 权重
@property (nonatomic, strong) NSString *score;    // 评分
@property (nonatomic, strong) NSString *scoreRemark;    // 评分说明

@end
