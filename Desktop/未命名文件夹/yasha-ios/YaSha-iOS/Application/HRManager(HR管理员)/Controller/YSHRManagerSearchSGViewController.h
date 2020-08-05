//
//  YSHRManagerSearchSGViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRCommonListController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TeamHRSearchType) {
    TeamHRSearchTypeDefint,//我的团队--总览
    TeamHRSearchTypeCompile,//我的团队-编制
    TeamHRSearchTypeCompileDetail,//我的团队-编制详情
    TeamHRSearchTypePosition,//我的团队-入/离职
    TeamHRSearchTypeAttendRecord,//考勤-记录 (考勤-记录上面不能再增加type值了,记录需要从4开始,其他地方有用)
    TeamHRSearchTypeAttendList,//考勤-打卡时间
    TeamHRSearchTypeAttendHoliday,//考勤-汇总-请假
    TeamHRSearchTypeAttendBusiness,//考勤-汇总-出差
    TeamHRSearchTypeAttendOutWark,//考勤-汇总-因公外出
    TeamHRSearchTypeAttendLate,//考勤-汇总-迟到早退
    TeamHRSearchTypeAttendAbsenteeism,//考勤-汇总-旷工
    TeamHRSearchTypeAttendWork,//考勤-汇总-加班
    TeamHRSearchTypePerformance,//绩效等级
    TeamHRSearchTypeWork,//我的团队-在岗
};


@interface YSHRManagerSearchSGViewController : YSHRCommonListController
@property (nonatomic, copy) NSString *placeholderStr;
@property (nonatomic, copy) NSString *searchURLStr;
@property (nonatomic, strong) NSMutableDictionary *paramDic;
@property(nonatomic,copy) void (^searchVCBlock)(NSDictionary *choseDic);
@property (nonatomic, assign) TeamHRSearchType searchVCType;
@property (nonatomic, copy) NSString *searchParamStr;


@end

NS_ASSUME_NONNULL_END
