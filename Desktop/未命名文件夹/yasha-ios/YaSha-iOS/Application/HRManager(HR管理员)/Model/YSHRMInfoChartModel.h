//
//  YSHRMInfoChartModel.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KQ;
@class PX;
@class JX;
@class ZC;

NS_ASSUME_NONNULL_BEGIN

@interface YSHRMInfoChartModel : NSObject

@property (nonatomic, strong) KQ *KQ;
@property (nonatomic, strong) PX *PX;
@property (nonatomic, strong) JX *JX;
@property (nonatomic, strong) ZC *ZC;


@end

@interface KQ : NSObject
//考勤
@property (nonatomic, assign) CGFloat shouldWorkday;//应出勤
@property (nonatomic, assign) CGFloat normalWorkday;//已出勤
@property (nonatomic, assign) CGFloat attendance;//出勤率
@property (nonatomic, assign) CGFloat moreAttendanceToOthers;//高于YASHAERS


@end

@interface PX : NSObject
//培训
@property (nonatomic, assign) CGFloat pxOfSecondSeason;//第二季度学时
@property (nonatomic, assign) CGFloat pxOfFirstSeason;//第一季度学时
@property (nonatomic, strong) NSDictionary *pxOfYear;
@property (nonatomic, assign) CGFloat pxOfThirdSeason;//第三季度学时
@property (nonatomic, assign) CGFloat pxOfFourthSeason;//第四季度学时

@end


@interface JX : NSObject
//绩效
@property (nonatomic, copy) NSString *halfYearPer;//半年度绩效
@property (nonatomic, copy) NSString *yearPer;//年度绩效



@end


@interface ZC : NSObject
// 绩效
@property (nonatomic, assign) int cfNumber;//责任资产硬件资产
@property (nonatomic, assign) int pfNumber;//个人资产硬件资产
@property (nonatomic, assign) int psNumber;//个人资产软件资产
@property (nonatomic, assign) int paNumber;//个人资产
@property (nonatomic, assign) int csNumber;//责任资产软件资产
@property (nonatomic, assign) int caNumber;//责任资产


@end


NS_ASSUME_NONNULL_END
