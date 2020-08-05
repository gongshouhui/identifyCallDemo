//
//  YSConstants.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2016/11/17.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSConstants : NSObject
//流程任务节点常量，因为后台返回的是字符串
extern NSString *const FlowTaskZH;
extern NSString *const FlowTaskSP;
extern NSString *const FlowTaskBSP;
extern NSString *const FlowTaskXT;
extern NSString *const FlowTaskPS;
extern NSString *const FlowTaskSPZ;



extern NSString *const YSDomain;
extern NSString *const YSImageDomain;
extern NSString *const YSUpdateDomain;
extern NSString *const YSDownloadDomain;
extern NSString *const YSRechargeDomain;
extern NSString *const YSTemplateDomain;//考评模板
extern NSString *const YSCheckTemplateDomain;//复核考核模板

#define QYAPPKEY @"22e71348aa1e281e94ce61c493e891c8"

#define kPageSize 15

#pragma mark - 登录接口

#define loginApi @"login/login"    // 登录
#define modifyPassword @"idm/modifyPassword"    // 修改密码
#define getCaptchaApi @"idm/sendValidCode"    // 获取验证码
#define getNewPasswordApi @"idm/verifyValidCode"    // 获取新密码
#define addUserSuggest @"common/addUserSuggest"    // 提交反馈
#define getUserACLApi @"idm/getUserAclForMobile"    // 获取权限
#define getTimestampApi @"idm/getTimestamp"    // 刷新时间戳
#define getPropertyAndEMSAuthority @"idm/getIdmPermission"    // 获取资产和EMS权限
#define addLog @"log/loginLog/addLog"    // 日志记录
#define getAPPVersionAPI @"common/version"    // 检查新版本



#pragma mark - 公用查询

#define getArea @"common/getArea"    // 获取地址json树
#define submitComplaint @"erp/complaintRecords/saveRecord" //提交投诉信息
#define getCornerMarkApi @"common/homePage/getCornerMark"    // 获取消息未读数
#define updateReadingStatus @"flowCenter/mis/updateReadingStatus" //更新状态
#define patchApi @"common/patch"  //热更新
#define getFileViewPath @"common/getFileViewPath"//获取文件预览地址

#pragma mark - IM群组

#define groupApi @"im/group"
#define queryGroupmember @"im/chat/queryGroupmember"    // 获取群组成员
#define syncGroup @"im/syncGroup"    // 查询某一用户所加入的所有群组
#define groupInfo @"im/groupInfo"
#define quitGroup @"im/chat/quitGroup"    // 退出群组
#define getNotificationNoReadNumber @"flowCenter/mis/getNotificationNoReadNumber"   //消息列表未读数
#define getNotificationList @"flowCenter/mis/getNotificationList"   //消息通知列表
#define getClockNoReadNumber @"/flowCenter/mis/getClockNoReadNumber" //消息列表 打卡消息未读数
#define getClockNotificationList @"/flowCenter/mis/getClockNotificationList" //消息列表 打卡消息列表
#define updateReadingStatus @"flowCenter/mis/updateReadingStatus"  //更新消息状态



#pragma mark - 待办模块接口

#define getNoticeList @"flowcenter/getApprovingTaskVos"    // 获取待办列表
#define getApprovedTaskVos @"flowcenter/getApprovedTaskVos"    // 获取已办列表
#define getMyFlow @"flowcenter/getMyFlow" //获取已发列表
#define getApplyByIdForMobile @"flowcenter/getApplyByIdForMobile"    // 获取待办详情
#define getCommentsByProcessInstanceId @"flowcenter/getCommentsByProcessInstanceId"    // 获得审批意见
#define saveSp @"flowcenter/saveSp"    // 审批操作
#define getApplyMapByIdForMobile @"flowcenter/getApplyMapByIdForMobile"    // 流程图接口
#define getEditAble @"flowcenter/getEditAble"    // 是否可编辑接口
#define updateIfPurchase @"flowcenter/updateIfPurchase"    // 提交编辑的数据



#pragma mark - 流程中心接口（新）

#define getFlowListApi @"flowCenter/getFlowList"    // 获取流程列表
#define getUserDefineDetailApi @"flowCenter/userDefine/getUserDefineDetail"    // 自定义流程获取详情
#define getPositionPostByIdApi @"flowCenter/recruit/getPositionPostById" //获取新增岗位申请详情
#define getNewPositionPostByIdApi @"flowCenter/newRecruit/getPositionPostById" //获取新增岗位申请详情
#define getAdjustOriginalByIdApi @"flowCenter/recruit/getAdjustOriginalById"
#define getNewAdjustOriginalByIdApi @"flowCenter/newRecruit/getAdjustOriginalById"
//获取编制调整申请详情
#define getPersonnelRecruitByIdApi @"flowCenter/recruit/getPersonnelRecruitById/"
#define getNewPersonnelRecruitByIdApi @"flowCenter/newRecruit/getPersonnelRecruitById/"//获取离职/调岗/编制内补员申请详情
#define getRecruitTaskChangeByIdApi @"flowCenter/newRecruit/reduceTasksApply/"//招聘任务调整申请详情
#define getOfferApplyApi @"flowCenter/recruit/getOfferApply" //获取offer发放申请详情
#define getNewOfferApplyApi @"flowCenter/newRecruit/getOfferApply" //获取offer发放申请详情
#define getUserDefineDetailNewApi @"flowCenter/userDefine/getUserDefineDetailNew" //自定义流程新接口获取详情
#define getApplyMapByIdForMobileApi @"flowCenter/getApplyMapByIdForMobile"    // 获取流程图
#define getCommentsByProcessInstanceIdApi @"flowCenter/getCommentsByProcessInstanceId"    // 审批记录查询
#define getPostscriptListApi @"flowCenter/getPostscriptList"    // 获取提交者附言列表
#define getAttachmentApi @"flowCenter/getAttachment"    // 获取关联文档列表
#define flowProcessApi @"flowCenter/doWith"    // 流程处理
#define getBackNodes @"flowCenter/getBackNodes"//获取驳回流程节点
#define getExpressByNoForMobileApi @"flowCenter/express/getExpressByNoForMobile"    // 获取顺丰流程详情
#define getBusinessInfoByCodeApi @"flowCenter/trip/getBusinessInfoByCode"    // 获取出差单流程详情

#define getRelateFlowVo @"flowCenter/getRelateFlowVo" //获取关联流程

#define getProcessListApi @"flowCenter/userDefine/getProcessList"    // 获取发起流程列表
#define getFormDesInfoApi @"flowCenter/userDefine/getFormDesInfo"    // 获取自定义表单数据
#define addFormDesApi @"flowCenter/userDefine/addFormDes"    // 提交流程
#define uploadAnnexApi @"flowCenter/userDefine/uploadAnnex"   // 文件上传
#define getProjectListByUserNo @"/flowCenter/atds/getProjectListByUserNo" //项目调休 获取其所在的项目

// 新的考勤流程提交 2019-12
#define saveFlowData @"flowCenter/atds/saveFlowData"
// 考勤流程查看
#define getFlowDataForMobile @"flowCenter/atds/getFlowDataForMobile"
// 考勤查询人员职级
#define getUserDataForMobile @"flowCenter/atds/getUserDataForMobile"
// 异常申诉
#define getAppealFlowDataForMobile @"flowCenter/atds/getAppealFlowDataForMobile"

//查看月度考勤记录
#define getAtdsMonthForMobile @"flowCenter/atds/getAtdsMonthForMobile/"
// 计算带薪小时假的结束时间
#define calculateEndTime @"flowCenter/atds/calculateEndTime/"

//根据流程类型获取流程列表
#define getFlowDataByType @"/flowCenter/atds/getFlowDataByType/"
// 查看修正流程详情
#define getProcessDataForMobile @"flowCenter/atds/getProcessDataForMobile/"
//提交 修正流程
#define submitProcessData @"/flowCenter/atds/submitProcessData/"

#define getApplyByIdForMobileApi @"flowCenter/assets/getApplyByIdForMobile"    // 获取资产待办详情
#define getFranAdmitFlowInfoApi @"flowCenter/srm/getFranAdmitFlowInfo"    //供应商准入待办详情
#define getFranCheckInfoApi @"flowCenter/srm/getFranCheckInfo"    //获取供应商复核考察信息
#define getFranCheckScoreInfoApi @"flowCenter/srm/getFranCheckScoreInfo"    //获取复核考察评分信息

#define getTenderBidInfoApi @"flowCenter/srm/getTenderBidInfo"        //材料招标流程
#define getTenderBidFranOpenAjaxApi @"flowCenter/srm/getTenderBidFranOpenAjax"     //是否中标
#define getMeetingroomApplyDetailApi @"flowCenter/meetingroom/getMeetingroomApplyDetail"     //获取会议室申请流程详情

#define getLawsuitInfo @"/flowCenter/lawsuit/getLawsuitInfo"//获取诉讼案件流程详情
#define updatePexpShareDetailForFlow @"/flowCenter/lawsuit/updatePexpShareDetailForFlow"  //修改诉讼案件信息表单信息
#define getOfficeAndDrinksInfo @"flowCenter/assets/getOfficeAndDrinksInfo"  //获取办公用品以及酒水表单信息
#define saveOfficeAndDrinks @"flowCenter/assets/saveOfficeAndDrinks"  //修改办公用品和酒水表单
#define getGoodsCategory @"flowCenter/assets/getGoodsCategory"    // 物资申请单

#pragma mark - 计价软件申请流程
#define getValuationApplysp @"flowCenter/valuation/getApplysp"  //计价软件个人申请表单信息
#define saveValuationGRXZsp @"flowCenter/valuation/saveGRXZsp"  //修改计价软件个人申请表单信息
#define saveValuationZRXZsp @"flowCenter/valuation/saveZRXZsp"  //修改计价软件责任申请表单信息

#pragma mark - 报销单流程接口
#define getExpAccountInfoApi @"flowCenter/expense/getExpAccountInfoByCode"     //获取获取费用报销单信息
#define getAllExpInvoiceDetaiListApi @"flowCenter/expense/getAllExpDetaiInvoiceList"     //获取发票信息

#define getAllPexpInvoDetaiListApi @"/flowCenter/expense/getAllPexpInvoDetaiList"     //获取费用信息
#define getExpAccountDetailApi @"flowCenter/expense/getExpAccountDetailByexpAccountInfoId"     //报销单详情
#define getLoanInfoByCodeApi @"flowCenter/expense/getLoanInfoByCode"   //备用金

#pragma mark - 个人费用查询功能
#define getMyExpReport @"/ems/myExpReport/getMyExpReport"   //个人费用查询


#define approveJoinApi @"flowCenter/cshr/approveJoin" //入职申请
#define approveNormDismsApi @"flowCenter/cshr/approveNormDisms"//正常离职
#define approveAbNormDismsApi @"flowCenter/cshr/approveAbNormDisms"//非正常离职
#define approveAdjustClassApi @"flowCenter/cshr/approveAdjustClass"//人员调班
#define approveCheckWorkApi @"flowCenter/cshr/approveCheckWork"//考勤补录
#define  approveBusinessApi @"flowCenter/cshr/approveBusiness"//出差补录
#define approveAdjustSalaryApi @"flowCenter/cshr/approveAdjustSalary"//调薪
#define approveNissinApi @"flowCenter/cshr/approveNissin"//点工日清
#define getBusinessInfoExtraByCodeApi @"flowCenter/trip/extra/getBusinessInfoExtraByCode"//出差单变更流程
#define getIntercourseFlowDetailApi @"flowCenter/certificate/getIntercourseFlowDetail"
#define getMQPersonApplyRequireFlowDetail @"flowCenter/mqpms/getMQPersonApplyRequireFlowDetail" //获取幕墙人员需求申请流程详情
#define getProReportInfoApi @"flowCenter/marketing/getProReportInfo"//营销报备/评估详情
#define getMQPersonAllotFlowDetail @"flowCenter/mqpms/getMQPersonAllotFlowDetail" //获取幕墙人员调派申请流程详情
#define getBorrowingDetailApi @"flowCenter/certificate/getBorrowingDetail"   //证书借用
#define getSealOfContractInfoApi @"flowCenter/srm/getSealOfContractInfo" //获取采购合同盖章表单信息


#define updateFinaExpAccountInfoApi @"flowCenter/expense/updatePexpShareDetailForFlow"     //业务招待报销单中的营销综合管理部审批弹窗接口;

#pragma mark - 发文流程
#define getNotiText @"flowCenter/noticeApply/getProNoticeByCode"     //获取发文申请流程详详情



#pragma mark - 个人信息模块接口

#define updateUser @"idm/updateUser"    // 编辑个人信息
#define getPersonInfo @"person/getPersonInfo"    // 个人信息详情

#pragma mark - 员工信息自助接口
#define selfHelpDetails @"hrService/selfMessage/profile" //自助信息详情
#define checkLeader @"/hrService/selfMessage/checkLeader"//判断是否是领导
#define selfMessageDept @"/hrService/selfMessage/getTopDept"//HR管理者 查询管理部门或者所在部门
#define getDeptList @"/hrService/selfMessage/getDeptList" // HR管理者 查询子部门
#define selfMessageAllPerson @"/hrService/selfMessage/getAllPerson"//查询部门人员

#define getHRInfo @"/hrService/selfMessage/getHRInfo"//查询员工资料(培训、考勤、培训、资产)

#pragma mark - 通讯录模块接口

#define outerPersons @"person/contacts/getOuterPersons"    // 外部联系人列表
#define getCommonPersons @"person/contacts/getCommonPersons"    // 常用联系人
#define getInnerAndOuterPersons @"person/contacts/getInnerAndOuterPersons"    // 内部联系人列表
#define updateOrAddOuter @"person/contacts/updateOrAddOuter"    // 外部联系人添加
#define addCommonPerson @"person/contacts/addCommonPerson"    // 常用联系人从手机通讯录里添加
#define addOuterPersonToCommonPerson @"person/contacts/addOuterPersonToCommonPerson"    // 外部联系人添加到常用
#define delCommonOrOuterPersons @"person/contacts/delCommonOrOuterPersons"    // 外部联系人删除
#define getOrganizationTree @"person/contacts/getOrganizationTree"    // 内部人员组织架构
#define getOrganizationTreeByOrgTree @"person/contacts/getOrganizationTreeByOrgTree"
/*等人员选择器完善后会废弃掉 */
#define getDepartmentMembers @"person/contacts/getDepartmentMembers"    // 内部人员信息
#define getInnerPersons @"person/contacts/getInnerPersons"    // 内部人员信息
#define getCommonOrOuterPersons @"person/contacts/getCommonOrOuterPersons"    // 外部和常用人员信息
#define addInnerPersonToCommonPerson @"person/contacts/addInnerPersonToCommonPerson"    // 从内部添加人员到常用


#pragma mark - 通讯录模块接口（新）

#define getContactUpdateConfig @"common/contact/updateConfig"    // 用户在登录时请求接口 /common/contact/updateConfig 检查是否有权限数据等更新 如果是则使用全量请求本接口，否则使用增量请求(传入contactsTimestamp参数)
#define getAllOrgTreeApi @"person/contacts/getAllDeptAndPersonForMobile"    // 离线获取通讯录
#define getOuterPersonsApi @"person/contacts/getOuterPersons"    // 获取外部通讯录
#define getCommonPersonsApi @"person/contacts/getCommonPersons"    // 获取常用联系人

#define getNamePhonesApi @"common/getNamePhones"    // 获取电话识别库



#pragma mark - 日程

#define getAllSchedule @"schedule/getAllSchedule"    // 获取日程
#define deleteSchedule @"schedule/delSchedule"    // 删除日程
#define getScheduleGrant @"schedule/getScheduleGrant"    // 获取授权人员
#define saveScheduleGrant @"schedule/saveScheduleGrant"    // 修改授权
#define deleteScheduleGrant @"schedule/delScheduleGrant"    // 删除授权
#define getScheduleDetail @"schedule/getScheduleDetail"    // 获取日程详情
#define addScheduleEvent @"schedule/addSchedule"    // 新增日程
#define editScheduleEvent @"schedule/editSchedule"    // 修改日程



#pragma mark - 公文模块

#define getBulletins @"bulletin/getBulletins"    // 获得公文列表
#define getBulletinDetail @"bulletin/getBulletinDetail"    // 获得公文列表详情
#define saveVisitRecord @"bulletin/saveVisitRecord"    // 修改公文状态


#define getNewsListApi @"bulletin/getBulletins"    // 获取新闻公告列表
//#define getNewsDetailApi @"bulletin/getBulletinDetail"
#define getNewsDetailApi @"bulletin/getNewBulletinDetail"// 获取新闻详情
//#define getNewsDetailApi @"bulletin/getBulletinDetail"    // 获取新闻详情（废弃）
#define getNewBulletinDetailApi @"bulletin/getNewBulletinDetail"    // 获取新闻详情
#define saveVisitRecordApi @"bulletin/saveVisitRecord"    // 保存查看记录
#define getNewsFileApi @"bulletin/getNewsnoticeFile"    // 获取新闻公告附件
#pragma mark - HR人员管理模块
#define getTrainingSummary @"hrService/train/getTrainingSummary"
#define getTrainDetail @"hrService/train/getTrainDetail"
#define getPersonYearPerformance @"hrService/performance/getPersonYearPerformance"
#define getDictionary @"/hrService/selfMessage/getDictionary"

#pragma mark - 考勤模块接口

#define ajaxListNew @"hrService/atds/ajaxListNew"    //考勤列表
#define unusualList @"hrService/atds/unusualList"    //当天考勤
#define addFlowData @"hrService/atds/addFlowData"    //进行申诉
#define getDicInfo @"common/oa/getDicInfo"    //获得申诉的map数据
#define upImage @"hrService/atds/uploadImageFile"    //上传证明材料
#define getPersonAtdYearRecord @"hrService/atds/getPersonAtdYearRecord" //获取员工年度考勤信息记录
#define getPersonAtdDetailsByType @"hrService/atds/getPersonAtdDetailsByType"  //请假,因公外出,出差考勤详情信息
#define getClock @"hrService/atds/getClock" //打卡时间
#define getFlowInfo @"hrService/atds/getFlowInfo" //查看考情详情
#define selfMessageHeader @"hrService/selfMessage/selfMessageHeader" //头部自助信息
// HR管理者模块
#define getDeptTree @"/hrService/selfMessage/getDeptTree" // 查询管辖部门树

// HR管理者模块
#define getUserTeamSummaryAttendance @"hrService/atds/getUserTeamSummaryAttendance"//考勤汇总
#define getSubDepartmentsData @"hrService/atds/getSubDepartmentsData"//考勤汇总--下属部门(平均工时)
#define getManagementData @"hrService/atds/getManagementData"//考勤汇总--部门管理人员(平均工时)
#define getMonthlyStatisticsData @"hrService/atds/getMonthlyStatisticsData"//考勤汇总--月度统计(平均工时)
#define getUserTeamLeaveDetails @"hrService/atds/getUserTeamLeaveDetails"//考勤汇总--请假详情
#define getUserTeamBusinessTripDetail @"hrService/atds/getUserTeamBusinessTripDetail" //考勤汇总--出差详情
#define getUserTeamBusinessTrip @"hrService/atds/getUserTeamBusinessTrip"//考勤汇总--因公外出详情
#define getUserTeamLateAbsenteeism @"hrService/atds/getUserTeamLateAbsenteeism"//考勤汇总--迟到早退详情
#define getUserTeamAbsenteeism @"hrService/atds/getUserTeamAbsenteeism"//考勤汇总--旷工详情
#define getUserTeamWorkOvertimeDetail @"hrService/atds/getUserTeamWorkOvertimeDetail"//考勤汇总--加班详情
#define getDepartmentPunchRecords @"hrService/atds/getDepartmentPunchRecords"//考勤汇总/记录-获取团队考勤记录以及团队考勤打卡时间
#pragma mark - 绩效
#define getTeamPerfTotal @"hrService/performance/getTeamPerfTotal"//获取部门绩效的统计
#define getDepartmentPerformanceInfo @"hrService/performance/getDepartmentPerformanceInfo"//获取部门绩效
#define getMyPerfInfoListApi @"hrService/performance/getMyPerfInfoListApp"    // 获取我的绩效
#define getMyPerfInfoApi @"hrService/performance/getMyPerfInfoApp"    // 获取绩效详情
#define getOptRecordsAppApi @"hrService/performance/getOptRecordsApp"    // 获取审批记录
#define planPersonSocoreListApi @"hrService/performance/planPersonSocoreList"    // 获取自评列表
#define getReEvaluationListApi @"hrService/performance/getReEvaluationList"    // 获取复评列表
#define planPersonSocoreInfoApi @"hrService/performance/planPersonSocoreInfo"    // 获取自评详情
#define updateSelfEvaluationApi @"hrService/performance/updateSelfEvaluation"    // 提交自评
#define getReEvaluationInfoApi @"hrService/performance/getReEvaluationInfo"    // 获取复评详情
#define updateLeaderScoreApi @"hrService/performance/updateLeaderScore"    // 提交复评
#define getPlanExamineConttentListApi @"hrService/performance/getPlanExamineConttentList"    // 计划审核列表
#define getPlanExamineConttentInfoApi @"hrService/performance/getPlanExamineConttentInfo"    // 计划审核详情
#define updatePlanRebackApi @"hrService/performance/updatePlanReback"    // 计划退回
#define updatePlanConfirmApi @"hrService/performance/updatePlanConfirm"    // 计划生效

#define getSalaryDetailApi @"hrService/salary/getSalaryInfo"          //获取工资条信息
#define getYearSalaryDetailApi @"hrService/salary/queryYearSalary"        //获取年终奖


#pragma mark--HR管理者模块 培训
#define getTrainForTeam @"hrService/train/getTrainForTeam"//获取团队培训信息

#define getAuthorizedStrengthList @"hrService/train/getAuthorizedStrengthList"//获取团队编制列表
#define getAuthorizedStrengthTotal @"hrService/train/getAuthorizedStrengthTotal"//获取团队编制详情统计
#define getAuthorizedStrengthDetails @"hrService/train/getAuthorizedStrengthDetails"//获取团队编制详情
#define gePostInfoList @"hrService/train/gePostInfoList"//获取团队在岗信息列表
#define getAnnualList @"hrService/train/getAnnualList"// 团队入/离职列表


#pragma mark - 固定资产模块

#define getAjaxListDealing @"assets/check/ajaxListDealing"    // 盘点清册列表
#define getAjaxListInventory @"assets/check/ajaxListInventory"    // 盘点清册/记录子列表
#define getUpdateMachineAccountUse @"/assets/check/updateMachineAccountUse"   //领用确认
#define getAjaxListFinish @"assets/check/ajaxListFinish"    // 盘点记录列表
#define getMachineByNo @"assets/check/getMachineByNo"    // 通过No查询资产详情
#define getScanAccount @"assets/check/scanAccount"    // 通过二维码扫描查询资产详情
#define updateCheckInventory @"assets/check/updateCheckInventory"    // 更新资产盘点状态
#define getMachineByQuery @"assets/check/getMachineByQuery"    // 查询资产
#define getMyAssets @"assets/check/getPagerModel"    // 查询我的资产列表



#pragma mark - ITSM模块

#define getProblemClass @"itsm/getProblemClass"    // 获取全部问题分类
#define getProblemDesc  @"itsm/getProblemDesc"    // 获得问题说明
#define getFeedBackHistory @"itsm/getFeedBackHistory"    // 获得历史记录
#define compRevoke @"itsm/compRevoke"    // 撤销和投诉接口
#define getServiceRating @"itsm/getServiceRating"    // 查看评价接口
#define saveServiceRating @"itsm/saveServiceRating"    // 提交服务评价
#define saveFeedBack @"itsm/saveFeedBack"    // 提交自助报障



#pragma mark - 装饰项目信息管理

#define getBaseInfoListApp @"projectInfo/getBaseInfoListApp"    // 查询我的项目列表
#define getBaseInfoDeatilApp @"projectInfo/getBaseInfoDeatilApp"    // 查询我的项目信息详情
#define getCompanysListApp @"projectInfo/getCompanysListApp"    // 单位信息列表查询
#define getPersonsListApp @"projectInfo/getPersonsListApp"    // 人员信息列表查询
#define getFinanceListApp @"projectInfo/getFinanceListApp"    // 财务信息列表查询
#define getFileListApp @"projectInfo/getFileListApp"    // 附件信息列表查询
#define getChangeRecordListApp @"projectInfo/getChangeRecordListApp"    // 变更历史信息列表查询
#define updatePersonExit @"projectInfo/updatePersonExit"    // 人员退场
 #define getAreaTree @"common/getAreaTree"    // 获取省市区信息

#pragma mark - 幕墙信息管理
#define getBaseInfoListAppMQ @"mqProjectInfo/getBaseInfoListApp"
#define getBaseInfoDeatilAppMQ @"mqProjectInfo/getBaseInfoDeatilApp"
#define getCompanysListAppMQ @"mqProjectInfo/getCompanysListApp"
//#define getPersonsListAppMQ @"mqProjectInfo/getPersonsListApp"
#define getPersonsListAppMQ @"mqProjectInfo/getPersonsListAppNew"
#define getFinanceListAppMQ @"mqProjectInfo/getFinanceListApp"
#define getFileListAppMQ @"mqProjectInfo/getFileListApp"
#define getChangeRecordListAppMQ @"mqProjectInfo/getChangeRecordListApp"
#define updatePersonExitMQ @"mqProjectInfo/updatePersonExit"
#pragma mark - 幕墙流程
#define getMaterialDemandFlowDetail @"flowCenter/mqpms/getMaterialDemandFlowDetail"//幕墙材料需求
#define getMQContractInfo @"flowCenter/mqpms/getMQContractInfo"//获取合同信息详情
#define updateMQContractInfo @"flowCenter/mqpms/updateMQContractInfo"//修改幕墙合同流程信息
#define getMQContractFilingInfo @"flowCenter/mqpms/getMQContractFilingInfo"//获取备案合同信息详情
#define getMQContractCheckDealInfo @"flowCenter/mqpms/getMQContractCheckDealInfo"//获取幕墙考核协议
#define getMQContractSupervisionInfo @"/flowCenter/mqpms/getMQContractSupervisionInfo"//获取幕墙管理合同表单信息





#pragma mark - 装饰项目计划管理

#define getPlanInfolistApp @"planInfo/getPlanInfolistApp" //进度计划管理列表
#define getPlanInfoDetail @"planInfo/getPlanInfoDetail" //进度计划详情
#define getPlanTaskList @"planInfo/getPlanTaskList"   //进度计划子任务
#define getPlanGraphicProgressList @"planInfo/getPlanGraphicProgressList"  //查看形象进度列表
#define getPlanTaskDetail @"planInfo/getPlanTaskDetailForMobile/" //详情
#define updatePlanTask  @"planInfo/updatePlanTask"
#define updatePlanGraphicProgress @"planInfo/updatePlanGraphicProgress"


#pragma mark - 幕墙项目计划管理

#define getPlanInfolistAppMQ @"mqPlanInfo/getPlanInfolistApp" //进度计划管理列表
#define getPlanInfoDetailMQ @"mqPlanInfo/getPlanInfoDetail" //进度计划详情
#define getPlanTaskListMQ @"mqPlanInfo/getPlanTaskList"   //进度计划子任务
#define getPlanTaskDetailMQ @"mqPlanInfo/getPlanTaskDetail" //详情
#define getPlanGraphicProgressListMQ @"mqPlanInfo/getPlanGraphicProgressList"  //查看形象进度列表
#define updatePlanTaskMQ  @"mqPlanInfo/updatePlanTask"
#define updatePlanGraphicProgressMQ @"mqPlanInfo/updatePlanGraphicProgress"

//幕墙前期进度计划
#define getEarlyPrepareInfo @"mqPlanInfo/prepareTaskStatistics"//幕墙前期准备详情
#define getMqPlanPrepareList @"mqPlanInfo/getMqPlanPrepareList"//幕墙子列表
#define getPlanPreapreDeatil @"mqPlanInfo/getPlanPreapreDeatil"//幕墙前期准备任务详情
#define updatePlanPrepareProgress @"mqPlanInfo/updatePlanPrepareProgress"//更新前期准备任务阶段信息


#pragma mark - 报备营销
#define getPageProReportListApi @"marketing/getPageProReportList"   //工程报备/评估列表
#define getProReportInfoByIdApi @"marketing/getProReportInfoById" //评估详情
#define getPageProTrackApi @"marketing/getPageProTrack" //项目跟踪

#define saveProReportApi @"marketing/saveProReport"//报备评估-保存
#define submitProReportApi @"marketing/submitProReport"//报备评估-提交
#define uploadFileApi @"marketing/uploadFile"// 上传附件
#define getDicTypeEnumApi @"marketing/getDicTypeEnum"//报备评估-获取枚举字典
#define delProReport @"marketing/delProReport"//删除评估
#define getDeptTreeApi @"marketing/getDeptTree"//获取部门树
#define getDeptLeaderAndPickerByIdApi @"marketing/getDeptLeaderAndPickerById"//报备评估-添加团队信息获取团队负责人和对接人信息





#pragma mark - 供应链

#define getFranInfoListApp @"supplier/getFranInfoListApp" //供应商列表
#define getFranInfoDetailApp @"supplier/getFranInfoDetailApp" //供应商详情
#define getFranPersonDetailApp @"supplier/getFranPersonDetailApp" //供应商联系人列表
#define getFranFranAddressDetailApp @"supplier/getFranFranAddressDetailApp" //供应商地址信息
#define getFranBlankDetailApp @"supplier/getFranBlankDetailApp" //供应商银行信息
#define getFranRelateDetailApp @"supplier/getFranRelateDetailApp" //关联供应商
#define getFranCategoryAndFranRegion @"supplier/getFranCategoryAndFranRegion"  //供应商供货地址

#pragma mark - 招标管理
#define getBidManagerListDataAPI @"tenderBid/getPagerModelByQueryInfo"  //获取招标管理列表数据
#define getBidInvitingDetailAPI @"tenderBid/getTenderBidInfoByIdApp"  //根据招标id获取该招标的基本详情信息
#define getBidDetailAPI @"tenderBid/getTenderBidFranByIdInfo"  //根据招标基本信息的id获取投标信息

#pragma mark 材料管理
#define getMaterialInfoListApp @"/material/getMtrlListApp" //获取材料信息列表
#define getMaterialDetailInfoApp @"/material/getMtrlInfoDetailApp" //获取材料信息详情
#define getMaterialFixDetailApp @"/material/getMtrlInfoFixDetailApp" //获取材料信息议价详情

#pragma mark - EMS
#define getPostNameByNo @"ems/trip/getPostNameByNo"    // 获取职务
#define getMyTripListApi @"ems/trip/getMyTripList"    // 获取我的出差列表
#define getMyTripDetailApi @"ems/trip/getMyTripDetail"    // 获取我的出差详情
#define getProListApi @"common/pms/getChild"    // 获取项目列表
#define applyTripApi @"ems/trip/applyTrip"    // 申请出差
#define applyCheckTripApi @"ems/trip/getIsExistByBusinessTime"    // 查看是否存在重复的

//人事流程
#define queryPersonnelPositive @"flowCenter/personnelAllot/queryPersonnelPositive"    // 转正流程详情



#pragma mark - 公用查询

#define getDicInfoApi @"common/oa/getDicInfo"    // 获取OA字典信息
#define getOneCardSignatureApi @"logistics/makeSignature"    // 获取一卡通签名
//颜色
#define approvalDetailColor @"0505FF"
#define flowRightColor @"0000FF"
@end
