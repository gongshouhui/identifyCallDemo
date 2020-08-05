//
//  YSReporetModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/12/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSReporetInfoModel,YSAssessmentInfoModel,YSAssessmentOtherModel;

NS_ASSUME_NONNULL_BEGIN

@interface YSReporetModel : NSObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *projectName;//项目名称
@property (nonatomic,strong) NSString *bizStatus;//项目阶段 10-备案阶段 20-评估阶段 30-报名资审 40-投标阶段 50-结束
@property (nonatomic,strong) NSString *bizStatusStr;
@property (nonatomic,strong) NSString *flowStatus;//项目状态 10-未提交 20-审批中 30-输入中 40-驳回 50-终止 60-已审批
@property (nonatomic,strong) NSString *flowStatusStr;
@property (nonatomic,strong) NSString *programmeType;//工程类别
@property (nonatomic,strong) NSString *programmeTypeStr;
@property (nonatomic,strong) NSString *projectType;//项目类型
@property (nonatomic,strong) NSString *projectTypeStr;
@property (nonatomic,strong) NSString *tenderType;//招标方式
@property (nonatomic,strong) NSString *tenderTypeStr;
@property (nonatomic,strong) NSString *tenderContent;//招标内容
@property (nonatomic,strong) NSString *tenderContentStr;
@property (nonatomic,strong) NSString *tenderExpectDate;//预计招标日期
@property (nonatomic,strong) NSString *projectCost;//工程造价
@property (nonatomic,strong) NSString *projectArea;//工程面积
@property (nonatomic,strong) NSString *proProvinceName;//省
@property (nonatomic,strong) NSString *proCityName;//市
@property (nonatomic,strong) NSString *proAreaName;//区
@property (nonatomic,strong) NSString *proAddress;//地址
@property (nonatomic,strong) NSString *firstPartyCompany;//甲方单位
@property (nonatomic,strong) NSString *firstPartyUser;//甲方项目对接人
@property (nonatomic,strong) NSString *firstPartyUserLink;//甲方项目对接人联系方式
@property (nonatomic,strong) NSString *firstPartyUserPost;//甲方项目对接人职务
@property (nonatomic,strong) NSString *isGiveUp; //是否放弃
@property (nonatomic,strong) NSString *deptName;//项目所属区域/团队
@property (nonatomic,strong) NSString *deptLeader;//所属团队负责人
@property (nonatomic,strong) NSString *proTrackName;//项目跟踪人
@property (nonatomic,strong) NSString *proTrackMobile;//项目跟踪人联系方式
@property (nonatomic,strong) NSString *pickUpUserName;//对接人
@property (nonatomic,strong) NSString *projectSelfGrade;//项目自评级
@property (nonatomic,strong) NSString *projectSelfGradeStr;
@property (nonatomic,strong) NSString *preWinnDate;//预计中标日期
@property (nonatomic,strong) NSString *preWinnMoney;//预计中标金额
@property (nonatomic,strong) NSString *projectProgressRemark;//项目推进情况
@property (nonatomic,strong) NSString *questionSupportRemark;//问题与支持
@property (nonatomic,strong) NSString *originalType;//是否含有工业化装配式
@property (nonatomic,strong) NSString *industryConfArea;//工业装配式体量
@property (nonatomic,strong) NSString *industryConfPrice;//工业化装配式单方造价体量
@property (nonatomic,strong) NSString *assessmentResult;
@property (nonatomic,strong) NSString *planCompleteDate;//预计竣工日期
@property (nonatomic,strong) NSString *orderCount;//订单总套数
@property (nonatomic,strong) NSString *orderApartmentCount;//订单户型个数
@property (nonatomic,strong) NSArray *fileVos;
@property (nonatomic,strong) NSString *recordNo;
@property (nonatomic,strong) NSString *preWinnMoneyCurrencyStr;
@property (nonatomic,strong) YSReporetInfoModel *proReportInfo;
@property (nonatomic,strong) YSAssessmentInfoModel *proAssessmentInfo;
@property (nonatomic, strong) NSString *creator;//创建人工号


@end

@interface YSReporetInfoModel : NSObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *projectName;//项目名称
@property (nonatomic,strong) NSString *bizStatus;//项目阶段 10-备案阶段 20-评估阶段 30-报名资审 40-投标阶段 50-结束
@property (nonatomic,strong) NSString *bizStatusStr;
@property (nonatomic,strong) NSString *flowStatus;//项目状态 10-未提交 20-审批中 30-输入中 40-驳回 50-终止 60-已审批
@property (nonatomic,strong) NSString *flowStatusStr;
@property (nonatomic,strong) NSString *programmeType;//工程类别
@property (nonatomic,strong) NSString *programmeTypeStr;
@property (nonatomic,strong) NSString *projectType;//项目类型
@property (nonatomic,strong) NSString *projectTypeStr;
@property (nonatomic,strong) NSString *tenderType;//招标方式
@property (nonatomic,strong) NSString *tenderTypeStr;
@property (nonatomic,strong) NSString *tenderContent;//招标内容
@property (nonatomic,strong) NSString *tenderContentStr;
@property (nonatomic,strong) NSString *tenderExpectDate;//预计招标日期
@property (nonatomic,strong) NSString *trackState;//跟踪动态
@property (nonatomic,strong) NSString *trackStateStr;//跟踪动态
@property (nonatomic,strong) NSString *isGiveUp; //是否放弃
@property (nonatomic,strong) NSString *projectCost;//工程造价
@property (nonatomic,strong) NSString *projectCostCurrencyStr;
@property (nonatomic,strong) NSString *projectArea;//工程面积
@property (nonatomic,strong) NSString *proProvinceName;//省
@property (nonatomic,strong) NSString *proCityName;//市
@property (nonatomic,strong) NSString *proAreaName;//区
@property (nonatomic,strong) NSString *proAddress;//地址
@property (nonatomic,strong) NSString *firstPartyCompany;//甲方单位
@property (nonatomic,strong) NSString *firstPartyUser;//甲方项目对接人
@property (nonatomic,strong) NSString *firstPartyUserLink;//甲方项目对接人联系方式
@property (nonatomic,strong) NSString *firstPartyUserPost;//甲方项目对接人职务
@property (nonatomic,strong) NSString *deptName;//项目所属区域/团队
@property (nonatomic,strong) NSString *deptLeader;//所属团队负责人
@property (nonatomic,strong) NSString *proTrackName;//项目跟踪人
@property (nonatomic,strong) NSString *proTrackMobile;//项目跟踪人联系方式
@property (nonatomic,strong) NSString *pickUpUserName;//对接人
@property (nonatomic,strong) NSString *projectSelfGrade;//项目自评级
@property (nonatomic,strong) NSString *projectSelfGradeStr;
@property (nonatomic,strong) NSString *preWinnDate;//预计中标日期
@property (nonatomic, copy) NSString *preWinnDateStr;

@property (nonatomic,strong) NSString *preWinnMoney;//预计中标金额
@property (nonatomic,strong) NSString *preWinnMoneyCurrencyStr;
@property (nonatomic,strong) NSString *projectProgressRemark;//项目推进情况
@property (nonatomic,strong) NSString *isIndustryConf;//是否含有工业化装配式
@property (nonatomic,strong) NSString *isManagementLinkage;//是否工管联动
@property (nonatomic, strong) NSString *isNeedIntelligentSupport;//是否需要智能化支持

@property (nonatomic,strong) NSString *questionSupportRemark;//问题与支持
@property (nonatomic,strong) NSString *originalType;//是否含有工业化装配式
@property (nonatomic,strong) NSString *industryConfArea;//工业装配式体量
@property (nonatomic,strong) NSString *industryConfPrice;//工业化装配式单方造价体量
@property (nonatomic,strong) NSString *industryConfPriceCurrencyStr;
@property (nonatomic,strong) NSString *planCompleteDate;//预计竣工日期
@property (nonatomic, copy) NSString *planCompleteDateStr;

@property (nonatomic,strong) NSString *orderCount;//订单总套数
@property (nonatomic,strong) NSString *orderApartmentCount;//订单户型个数
@property (nonatomic,strong) NSString *advanceChargeProportion;
@property (nonatomic,strong) YSAssessmentInfoModel *proAssessmentInfo;
@property (nonatomic,strong) YSAssessmentOtherModel *proAssessmentOther;
@property (nonatomic, strong) NSString *companyName;//所属区域/团队所在公司
@property (nonatomic, strong) NSString *billCode;//单据编号
@property (nonatomic, strong) NSString *projectCostCurrency;//工程造价金额类型
@property (nonatomic, strong) NSString *deptId;//所属区域/团队（部门ID)
@property (nonatomic, copy) NSString *companyId;//所属区域/团队所在公司id
@property (nonatomic, copy) NSString *pickUpUserNo;//对接人工号
@property (nonatomic, copy) NSString *proTrackNo;//跟踪人工号
@property (nonatomic, copy) NSString *preWinnMoneyCurrency;//预计中标金额类型
@property (nonatomic, copy) NSString *industryConfPriceCurrency;//工业化装配式单方造价金额类型
@property (nonatomic, copy) NSString *tenderExpectDateStr;//预计招标日期
@property (nonatomic, copy) NSString *proProvinceCode;//工程地址省编码
@property (nonatomic, copy) NSString *proCityCode;//工程地址市名称
@property (nonatomic, copy) NSString *proAreaCode;//工程地址区名称

@property (nonatomic, strong) NSArray *crmProFilesList;//附件数组

//预计完成时间
@property (nonatomic, copy) NSString *planFinishDate;
//预计进场时间
@property (nonatomic, copy) NSString *planEnterDate;




@end

@interface YSAssessmentInfoModel : NSObject
@property (nonatomic,strong)NSString *assessmentResult;
@property (nonatomic,strong)NSString *recordNo;//备案号
@property (nonatomic,strong)NSString *passDate;
@property (nonatomic,strong)NSString *reportDate;
@property (nonatomic,strong)NSString *isCooperation;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic, strong) NSString *processInstId;//流程实例ID
@property (nonatomic, strong) NSString *formCode;//表单编码方案

@end

@interface YSAssessmentOtherModel : NSObject
@property (nonatomic,strong)NSString *isCapitalAudit;//是否资审
@property (nonatomic,strong)NSString *capitalAuditDate;//报名/资审日期
@property (nonatomic,strong)NSString *capitalAuditResult;//报名/资审结果
@property (nonatomic,strong)NSString *preReviewDate;//标前评审日期
@property (nonatomic,strong)NSString *bidDate;//投标日期
@property (nonatomic,strong)NSString *bondMoney;//保证金金额(万元)
@property (nonatomic,strong)NSString *bondType;//保证金类型
@property (nonatomic,strong)NSString *bondTypeStr;
@property (nonatomic,strong)NSString *isPerformance;//是否转履约
@property (nonatomic,strong)NSString *bidManager;//投标项目经理
@property (nonatomic,strong)NSString *isGiveUp;
@property (nonatomic,strong)NSString *trackStateStr;
@property (nonatomic,strong)NSString *isOut;
@property (nonatomic,strong)NSString *outDate;
@property (nonatomic,strong)NSString *businessStandard;
@property (nonatomic,strong)NSString *technologyStandard;
@property (nonatomic,strong)NSString *creditworthinessStandard;
@property (nonatomic,strong)NSString *otherCoordination;
@property (nonatomic,strong)NSString *isHaveFeedback;
@property (nonatomic,strong)NSString *bidOpenResultStr;
@property (nonatomic,strong)NSString *winBidDate;
@property (nonatomic,strong)NSString *winBidMoney;
@property (nonatomic,strong)NSString *isHaveNotice;
@property (nonatomic,strong)NSString *contractProManager;
@property (nonatomic,strong)NSString *contractSignedDate;
@property (nonatomic, strong) NSString *qualityRequirement;//质量要求

@end

NS_ASSUME_NONNULL_END
