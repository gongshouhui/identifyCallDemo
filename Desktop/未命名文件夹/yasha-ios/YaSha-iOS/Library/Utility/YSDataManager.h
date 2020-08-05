//
//  YSDataManager.h
//  YaSha-iOS
//
//  Created by mHome on 2016/12/10.
//
//

#import <Foundation/Foundation.h>

typedef void (^GetDiscussMembersCompletionBlock)(NSArray *array);

@interface YSDataManager : NSObject

#pragma mark - 应用及权限
/** 获取应用 */
+ (NSArray *)getApplicationsData:(id)response;
/** 保存用户权限 */
+ (void)saveUserACLDB:(id)response;
/** 保存应用授权 */
+ (void)saveACLDB:(id)response;
/** 保存项目管理授权 */
+ (void)savePMSACLDB:(id)response;
/** 清空权限数据库 */
+ (void)deleteACLDB;





#pragma mark - 公用查询
/** 获取省市区数据 */
+ (NSArray *)getAreaData:(id)response;
/** 设置角标 */
+ (void)getApplicationsWithBadgeWithDatasource:(NSArray *)datasource andResponse:(id)response;//替换数组角标数据


#pragma mark - IM
/** 获取群组成员UserId列表 */
+ (NSArray *)getGroupMembersUserIdList:(id)response;
/** 获取群组成员列表 */
+ (NSArray *)getGroupMembersList:(id)response;
/** 获取群组成员列表（除群主） */
+ (NSArray *)getGroupMembersList:(id)response withoutOperatorId:(NSString *)operatorId;
/** 查询某一用户所加入的所有群组 */
+ (NSArray *)getGroupListData:(id)response;





#pragma mark - 通讯录
/** 获取外部联系人列表 */
+ (NSArray *)getExternalData:(id)response;
/** 获取外部联系人详情 */
+ (NSArray *)getExternalDetailsData:(id)response;
/** 获取内部联系人列表 */
+ (NSArray *)getInternallData:(id)response;
/** 获取人员信息 */
+ (NSArray *)getPeopleData:(id)response;

+ (NSArray *)getInternPeopleMemberData:(id)response;
/** 获取内部联系人列表 */
+ (NSArray *)getInternallMemberData:(id)response;

+ (NSArray *)getInternallistData:(id)response;
/** 获取内部人员详情 */
+ (NSArray *)getInternalDetailsData:(id)response;
/** 获取选择内部人员 */
+ (NSArray *)getChoosegetExternalData:(id)response;



#pragma mark - 通讯录（新）

/** 保存内部通讯录公司、人员 */
+ (void)saveContactDB:(id)response isAll:(BOOL)isall;
/** 清空通讯录 */
+ (void)clearContact;

#pragma mark - 新流程中心
/** 获取流程列表 */
+ (NSArray *)getFlowListData:(id)response;
/** 获取处理记录列表 */
+ (NSArray *)getFlowRecordListData:(id)response;
+ (NSMutableArray *)getFlowRecordListNewData:(NSArray *)response;
/** 获取发起者附言 */
+ (NSArray *)getFlowAttachPSListData:(id)response;
+ (NSMutableArray *)getFlowAttachPSListNewData:(NSArray *)response;
/** 获取关联文档 */
+ (NSArray *)getFlowAttachFileListData:(id)response;
+ (NSArray *)getFlowFormDocumentationListData:(NSArray *)response;
+ (NSArray *)getFlowAttachFileListAndPSListData:(id)response;
/** 获取表单列表中的文档 */
+ (NSArray *)getFlowFormAttachFileListData:(id)response;

#pragma mark - 新流程中心（发起）
/** 获取单选数据源 */
+ (NSArray *)getFlowLaunchOptionsData:(id)response;

/** 获取发起流程列表 */
+ (NSArray *)getFlowLaunchListData:(id)response;

#pragma mark - 新闻公告
/** 获取新闻公告banner */
+ (NSArray *)getNewsBannerListData:(id)response;
/** 获取新闻公告列表 */
+ (NSArray *)getNewsListData:(id)response;
/** 获取附件列表 */
+ (NSArray *)getNewsAttachmentListData:(id)response;


#pragma mark - 资产
/** 获取盘点列表 */
+ (NSArray *)getAssetsListData:(id)response;
/** 获取盘点详情列表 */
+ (NSArray *)getAssetsDetailListData:(id)response;
/** 获取资产申请详情列表 */
+ (NSArray *)getAssetsResultListData:(id)response;
/** 获取我的资产列表 */
+ (NSArray *)getMyAssetsListData:(id)response;


#pragma mark - 考勤
/** 获取考勤数据列表 */
+ (NSArray *)getAttendanceData:(id)response;
/** 获得所有考勤信息 */
+ (NSArray *)getAllAttendanceData:(id)response;
/** 获得请假，出差等详情 */
+ (NSArray *)getAttendanceDetailData:(id)response;


// 管理者模块
/** 获取考勤汇总列表 */
+ (NSArray *)getTeamAllAttendanceData:(id)response;
/** 获取我的团队部门树 */
+ (NSArray *)getTeamAllDeptTreeData:(id)response;
#pragma marrk - HR管理者培训
/** 获取我的团队 团队编制详情 */
+ (NSArray*)getTeamMyAllAuthorizedData:(id)response;

#pragma mark-- 部门培训
+ (NSArray*)getTeamMyAllTrainingData:(id)response;


#pragma mark - ITSM
/** 获得未处理列表 */
+ (NSArray *)getAlllistData:(id)response;

#pragma mark - 营销报备
+ (NSArray *)getReporedlistData:(id)response;
+ (NSArray *)getTrackinglistData:(id)response;
+ (NSArray *)getReporedInfoData:(id)response;





#pragma mark - 日程
/** 获取日程 */
+ (NSArray *)getCalendarEventData:(id)response;
/** 获取当月有日程的天 */
+ (NSArray *)getCalendarEventDate:(id)response;
/** 获取授权人员 */
+ (NSArray *)getCalendarGrantPeopleData:(id)response;





#pragma mark - 绩效
/** 获取月、季、年绩效列表 */
+ (NSArray *)getPerfListData:(id)response;
/** 获取绩效详情列表 */
+ (NSArray *)getPerfInfoListData:(id)response;
/** 获取审批记录列表 */
+ (NSArray *)getPerfEvalueRecordListData:(id)response;
/** 获取绩效评估列表 */
+ (NSArray *)getPerfEvaluaListData:(id)response;


#pragma mark - 项目管理PMS
/** 获取项目信息管理自营考核列表 */
+ (NSArray *)getPMSInfoListData:(id)response;
/** 获取单位信息列表 */
+ (NSArray *)getPMSUnitInfoData:(id)response;
/** 获得人员信息列表 */
+ (NSArray *)getPMSPeopleInfoData:(id)response;
/** 获得变更历史信息 */
+ (NSArray *)getPMSHistoryInfoData:(id)response;
/** 获得地址数组 */
+ (NSArray *)getAddressData:(id)response;
/** 获得财务信息 */
+ (NSArray *)getPMSFinanceData:(id)response;


#pragma mark - 供应商
/** 获取供应商列表 */
+ (NSArray *)getSupplyListData:(id)response;
/** 获取供应商详情 */
+ (NSArray *)getSupplyDetailsData:(id)response;
/** 获取供应商联系人详情 */
+ (NSArray *)getSupplyPersonListData:(id)response;
/** 获取供应商银行信息 */
+ (NSArray *)getSupplyBankData:(id)response;
/** 获取关联供应商信息 */
+ (NSArray *)getSupplySupplierData:(id)response;



#pragma mark - EMS
/** 获取我的出差列表 */
+ (NSArray *)getEMSMyTripListData:(id)response;
+ (NSArray *)getEMSProListData:(id)response;


#pragma mark - 消息通知
+ (NSArray *)getMessageListData:(id)response;

/**更新号码识别库*/
+(void)updateContactIDentPhone;

@end


