//
//  YSHRTrainDetailModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSHRTrainDetailModel : NSObject
@property (nonatomic,assign) BOOL isExtend;
/**课程名称*/
@property (nonatomic,strong) NSString *courseName;
/**课程状态*/
@property (nonatomic,strong) NSString *courseStatus;//课程状态(1 待授课，2 已授课，3 取消授课)
/**讲师*/
@property (nonatomic,strong) NSString *lecturerName;
/**授课时间*/
@property (nonatomic,strong) NSString *lectureTime;
  // 0 必修 1 选修 2 分享
/**课程属性*/
@property (nonatomic,strong) NSString *courseAttributes;
/**课时*/
@property (nonatomic,strong) NSString *classHour;
/**授课地点*/
@property (nonatomic,strong) NSString *lecturePlace;
/**考核结果*/
@property (nonatomic,strong) NSString *checkResults;
/**课程分数*/
@property (nonatomic,strong) NSString *couresScores;

@end

NS_ASSUME_NONNULL_END
