//
//  YSReporetModel.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/12/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReporetModel.h"
#import "YSNewsAttachmentModel.h"

@implementation YSReporetModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"fileVos":[YSNewsAttachmentModel class],
             @"proReportInfo":[YSReporetInfoModel class],
             @"proAssessmentInfo":[YSAssessmentInfoModel class]
             };
    
}
@end

@implementation YSReporetInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"proAssessmentInfo":[YSAssessmentInfoModel class],
             @"proAssessmentOther":[YSAssessmentOtherModel class]
             };
    
}
@end

@implementation YSAssessmentInfoModel

@end

@implementation YSAssessmentOtherModel


@end
