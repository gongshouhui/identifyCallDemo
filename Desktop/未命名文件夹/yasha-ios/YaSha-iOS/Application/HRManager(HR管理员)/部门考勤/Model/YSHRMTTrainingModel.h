//
//  YSHRMTTrainingModel.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CourseDevelopModel;
@class TrainingCourseModel;
@class CompleteModel;
@class TrainingDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface YSHRMTTrainingModel : NSObject

@property (nonatomic, strong) CourseDevelopModel *courseDevelop;
@property (nonatomic, strong) TrainingCourseModel *trainingCourse;
@property (nonatomic, strong) CompleteModel *complete;

@end

@interface CourseDevelopModel : NSObject
//课程开发
@property (nonatomic, copy) NSString *quarterPlanNum;//计划开发（门）不知道是否为整型 用了字符串
@property (nonatomic, copy) NSString *actualQuarterNum;//实际开发（门)
@property (nonatomic, assign) CGFloat completionRate;//完成率

@end


@interface TrainingCourseModel : NSObject
//培训课程
@property (nonatomic, copy) NSString *planTrainCourse;//计划培训（门）
@property (nonatomic, copy) NSString *completeTrainCourse;//完成培训（门）
@property (nonatomic, copy) NSString *completeTrainOutCourse;//计划培训（门）
@property (nonatomic, assign) CGFloat completionRate;//完成率

@end

@interface CompleteModel : NSObject
//人均完成
@property (nonatomic, copy) NSString *averageHours;//年度计划（小时)
@property (nonatomic, copy) NSString *averageFinishClassHours;//必修学时（小时）
@property (nonatomic, copy) NSString *averageFinishElectiveHours;//选修学时（小时）
@property (nonatomic, copy) NSString *averageFinishShareHours;//分享学时（小时）
@property (nonatomic, copy) NSString *averageFinishTotalHours;//完成学时（小时)
@property (nonatomic, assign) CGFloat completionRate;//完成率

@end

@interface TrainingDetailModel : NSObject
// 培训详情
@property (nonatomic, copy) NSString *courseName;//课程名称
@property (nonatomic, copy) NSString *lectureTime;//授课时间
@property (nonatomic, copy) NSString *classHour;//课程学时
@property (nonatomic, copy) NSString *setupFlag;//计划课程类型


@end

NS_ASSUME_NONNULL_END
