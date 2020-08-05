//
//  YSTeamCompilePostModel.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSTeamCompilePostModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *deptId;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *no;//人员编号
@property (nonatomic, copy) NSString *name;//姓名
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *classification;
@property (nonatomic, copy) NSString *fromSystem;
@property (nonatomic, copy) NSString *isIncorporated;
@property (nonatomic, copy) NSString *positionName;//职称
@property (nonatomic, copy) NSString *level;//职级
@property (nonatomic, copy) NSString *postname;//岗位
@property (nonatomic, copy) NSString *enterTimeStr;//入职时间
@property (nonatomic, copy) NSString *leaveTimeStr;//离职时间
@property (nonatomic, copy) NSString *headImage;

@property (nonatomic, copy) NSString *orgName;//公司
@property (nonatomic, copy) NSString *deptName;
@property (nonatomic, copy) NSString *postName;

@property (nonatomic, assign) NSInteger countPsndoc;//现有人数
@property (nonatomic, assign) NSInteger totalNum;//编制人数
@property (nonatomic, copy) NSString *pkDept;//部门Id
@property (nonatomic, copy) NSString *jobgradeCode;//职级
@property (nonatomic, copy) NSString *employcode;//工号
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *dname;
@property (nonatomic, copy) NSString *subTypeStr;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *sdate;
@property (nonatomic, copy) NSString *typeTime;
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *absenteeismTime;
@property (nonatomic, copy) NSString *absenteeismDay;
@property (nonatomic, copy) NSString *personCode;


@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *endRwork;
@property (nonatomic, copy) NSString *startRwork;
@property (nonatomic, copy) NSString *billCode;




#pragma mark-- 部门绩效使用
@property (nonatomic, copy) NSString *halfYearPer;//半年度绩效
@property (nonatomic, copy) NSString *yearPer;//年度绩效
@property (nonatomic, copy) NSString *code;//编号


@end

NS_ASSUME_NONNULL_END
