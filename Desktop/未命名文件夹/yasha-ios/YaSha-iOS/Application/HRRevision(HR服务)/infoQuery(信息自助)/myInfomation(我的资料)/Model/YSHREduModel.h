//
//  YSEduModel.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSHREduModel : NSObject

/**
 学位
 */
@property (nonatomic, strong) NSString *degree;
/**
 专业
 */
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *school;
/**
 学制
 */
@property (nonatomic, strong) NSString *edusystem;
@property (nonatomic, strong) NSString *firsteducation;
/**
 学历
 */
@property (nonatomic, strong) NSString *education;
/**
 毕业时间
 */
@property (nonatomic, strong) NSString *enddate;
@property (nonatomic, strong) NSString *lasteducation;
/**
 学习方式
 */
@property (nonatomic, strong) NSString *studymode;

@end
