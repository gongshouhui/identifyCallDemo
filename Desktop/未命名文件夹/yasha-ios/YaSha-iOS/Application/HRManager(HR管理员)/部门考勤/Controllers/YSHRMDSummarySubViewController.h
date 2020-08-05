//
//  YSHRMDSummarySubViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSManagerHRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SummarySubVCType) {
    SummarySubVCHoliday,//请假
    SummarySubVCTypeBusiness,//出差
    SummarySubVCTypeOutWark,//因公外出
    SummarySubVCTypeLate,//迟到早退
    SummarySubVCTypeAbsenteeism,//旷工
    SummarySubVCTypeWork,//加班
};

@interface YSHRMDSummarySubViewController : YSManagerHRBaseViewController
@property (nonatomic, assign) SummarySubVCType titType;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *deptIds;


@end

NS_ASSUME_NONNULL_END
