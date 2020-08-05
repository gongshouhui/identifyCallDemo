//
//  YSHRTrainSummyModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSHRTrainSummyModel : NSObject

/**计划分享学时*/
@property (nonatomic, assign) CGFloat planClassHoursShare;
/**完成率*/
@property (nonatomic, strong) NSString *completionRate;
/**完成选修学时*/
@property (nonatomic, assign) CGFloat realClassHoursElective;
/**完成必修学时*/
@property (nonatomic, assign) CGFloat realClassHoursObligatory;
/** 计划必修学时*/
@property (nonatomic, assign) CGFloat planClassHoursObligatory;
/**完成分享学时*/
@property (nonatomic, assign) CGFloat realClassHoursShare;
/**培训次数*/
@property (nonatomic, assign) NSInteger trainNum;
/**计划选修学时*/
@property (nonatomic, assign) CGFloat planClassHoursElective;
@end

NS_ASSUME_NONNULL_END
