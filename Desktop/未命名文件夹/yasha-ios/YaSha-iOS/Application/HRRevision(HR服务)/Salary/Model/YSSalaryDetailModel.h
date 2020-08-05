//
//  YSSalaryDetailModel.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/24.
//

#import <Foundation/Foundation.h>

@interface YSSalaryDetailModel : NSObject

/**
 个税
 */
@property (nonatomic, strong) NSString *pit;
/**
 工资总额
 */
@property (nonatomic, strong) NSString *grossPay;
@property (nonatomic, strong) NSString *creator;
/**
 应发合计
 */
@property (nonatomic, strong) NSString *shTotal;
@property (nonatomic, strong) NSString *id;
/**
 工号
 */
@property (nonatomic, strong) NSString *icode;
/**
 备注
 */
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *updator;
/**
 其他补贴
 */
@property (nonatomic, strong) NSString *otherSubsidy;
/**
 发放部门
 */
@property (nonatomic, strong) NSString *deptName;
/**
 绩效工资
 */
@property (nonatomic, strong) NSString *perfPay;
/**
 交通补贴
 */
@property (nonatomic, strong) NSString *trafficSubsidy;
/**
 
 */
@property (nonatomic, strong) NSString *fullTime;
/**
 高温补贴
 */
@property (nonatomic, strong) NSString *highTemSubsidy;
/**
 实发合计
 */
@property (nonatomic, strong) NSString *payTotal;
/**
 月份
 */
@property (nonatomic, strong) NSString *smonth;
/**
 社保
 */
@property (nonatomic, strong) NSString *socialSecurity;
@property (nonatomic, assign) NSInteger delFlag;
/**
 住房补贴
 */
@property (nonatomic, strong) NSString *housingSubsidy;
@property (nonatomic, assign) NSInteger updateTime;
/**
 公积金
 */
@property (nonatomic, strong) NSString *acctFund;
/**
 餐补
 */
@property (nonatomic, strong) NSString *mealAllowance;
/**
 应发补贴合计
 */
@property (nonatomic, strong) NSString *subTotal;
/**
 加班工资
 */
@property (nonatomic, strong) NSString *otPay;
/**
 补发/补扣
 */
@property (nonatomic, strong) NSString *reissueBuckle;
/**
 奖金
 */
@property (nonatomic, strong) NSString *bonus;
/**
 姓名
 */
@property (nonatomic, strong) NSString *iname;
/**
 基本工资
 */
@property (nonatomic, strong) NSString *basePay;
/**
 月基本工资
 */
@property (nonatomic, strong) NSString *mbasePay;
@property (nonatomic, strong) NSString *nameLike;
@property (nonatomic, assign) NSInteger createTime;
/**
 通讯补贴
 */
@property (nonatomic, strong) NSString *comtSubsidy;
/**
 其他代扣
 */
@property (nonatomic, strong) NSString *otherBuckle;
/**
 代扣合计
 */

@property (nonatomic, strong) NSString *pitTotal;
@property (nonatomic, strong) NSString *syear;
@property (nonatomic, strong) NSString *entryTime;
@property (nonatomic, strong) NSString *salaryRecordId;

/**
 月绩效工资
 */

@property (nonatomic, strong) NSString *mperfPay;
/**累计子女教育*/
@property (nonatomic,assign) CGFloat cumulativeChildEducation;
@property (nonatomic,assign) CGFloat cumulativeInterestOnHousingLoans;
@property (nonatomic,assign) CGFloat cumulativeHousingRent;
@property (nonatomic,assign) CGFloat cumulativeSupportForTheElderly;
@property (nonatomic,assign) CGFloat cumulativeContinuingEducation;
@property (nonatomic,assign) CGFloat afterTaxDebit;
@property (nonatomic,assign) CGFloat debitRemark;

//年终

@property (nonatomic, strong) NSString *fixedSalary;
@property (nonatomic, strong) NSString *personalEffectiveness;
@property (nonatomic, strong) NSString *noteFloatingSalary;

@property (nonatomic, strong) NSString *noteYearlySalary;
@property (nonatomic, strong) NSString *beforeTaxSalary;
@property (nonatomic, strong) NSString *incomeTax;
@property (nonatomic, strong) NSString *actualSalary;



@end
