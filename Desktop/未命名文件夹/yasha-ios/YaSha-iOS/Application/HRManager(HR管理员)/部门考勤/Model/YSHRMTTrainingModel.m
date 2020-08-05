//
//  YSHRMTTrainingModel.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMTTrainingModel.h"

@implementation YSHRMTTrainingModel


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{ @"courseDevelop" : [CourseDevelopModel class],
              @"tTrainingCourse" : [TrainingCourseModel class],
              @"complete" : [CompleteModel class],
              };
}

@end


@implementation CourseDevelopModel




@end

@implementation TrainingCourseModel



@end

@implementation CompleteModel



@end

@implementation TrainingDetailModel



@end
