//
//  YSFlowAssetsApplyFormModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/13.
//

#import <Foundation/Foundation.h>
#import "YSFlowFormModel.h"
#import "YSFlowExpensePexpShareModel.h"

@class YSFlowModel, YSFlowAssetsApplyFormListModel;

@interface YSFlowAssetsApplyFormModel : NSObject

@property (nonatomic, strong) YSFlowFormHeaderModel *baseInfo;
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *apply;
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *info;



@end


@interface YSFlowAssetsApplyFormListModel : NSObject

@property (nonatomic, strong) NSString *applyNo;    // 申请单号
@property (nonatomic,strong) NSString *registerDate;//注册日期
@property (nonatomic, strong) NSString *receiveManName;// 接受人
@property (nonatomic, strong) NSString *useManName;    // 使用人
@property (nonatomic, strong) NSString *receiveJobStation; // 接受岗位
@property (nonatomic, strong) NSString *useManLevel;    // 使用岗位
@property (nonatomic, strong) NSString *useDept;    // 使用部门
@property (nonatomic, strong) NSString *receiveDept; //接受部门
@property (nonatomic, strong) NSString *useCompany;    // 使用公司
@property (nonatomic, strong) NSString *receiveCompany; //接受公司
@property (nonatomic, strong) NSString *ownProject;    // 项目名称
@property (nonatomic, strong) NSString *managerName;  //项目经理
@property (nonatomic, strong) NSString *proNature; //项目属性
@property (nonatomic, strong) NSString *remark;  //备注
@property (nonatomic,assign) CGFloat targetCastPrice;//目标成本价
@property (nonatomic,assign) CGFloat limitPrice;//限价价
@property (nonatomic, strong) NSString *payRemark;
@property (nonatomic, strong) NSString *reason; //申请原因
@property (nonatomic, strong) NSString *returnMsg; // 转移说明
@property (nonatomic, strong) NSString *receiveMsg; //转移说明
@property (nonatomic, strong) NSString *assetsNo;//资产编码
@property (nonatomic, strong) NSString *goodsName;//资产名称
@property (nonatomic, strong) NSString *proModel;//规格
@property (nonatomic, assign) BOOL ifAreaCompany;//是否为区域公司
@property (nonatomic, strong) NSString *itsmNo;//ITSM单号
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSArray *applyInfos;
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) NSArray *handleDetails;



//备用金
@property (nonatomic, strong) NSString *loanType;//备用金类型
@property (nonatomic, strong) NSString *loanName;//申请人(收款方)
@property (nonatomic, strong) NSString *loanDeptName;//所属部门
//@property (nonatomic, strong) NSString *jobLevelStr;//职务级别
@property (nonatomic, strong) NSString *proNameStr; //工程项目名称
//@property (nonatomic, strong) NSString *entryCompName; //入账公司
@property (nonatomic, strong) NSString *loanMoney;//申请金额
@property (nonatomic, strong) NSString *planRetDate;//预计还款时间
//@property (nonatomic, strong) NSString *remark;//业务说明


//入职信息,调薪
@property (nonatomic, strong) NSString *projectName;//项目名称
@property (nonatomic, strong) NSString *projectManagerName;//项目经理
@property (nonatomic, strong) NSArray *employees;//人员信息数组
@property (nonatomic, strong) NSArray *dayWorkItems;
@property (nonatomic, strong) NSString *dailYwageNew;//日薪


//离职
@property (nonatomic, strong) NSString *leaveReason;//离职原因
@property (nonatomic, strong) NSString *type;//离职类型
@property (nonatomic, strong) NSString *leaveDate;//离职日期

//调班
@property (nonatomic, strong) NSString *oldTeamsName;//原班组
@property (nonatomic, strong) NSString *teamsNameNew;//新班组
@property (nonatomic, strong) NSString *effectiveDate;//调班生效日期

//证书管理
@property (nonatomic, strong) NSString *staffNo;//工号
@property (nonatomic, strong) NSString *staffName;//移除人员
@property (nonatomic, strong) NSDictionary *dealTime;//时间
@property (nonatomic, strong) NSString *company;//隶属公司
//@property (nonatomic, strong) NSString *copyDept;//抄送部门
@property (nonatomic, copy) NSString *companyDept;
@property (nonatomic, strong) NSString *sendDept;//发送部门

//证书借用
@property (nonatomic, strong) NSString *projectClass;//项目分类
@property (nonatomic, strong) NSString *borrowTime;//借用日期
@property (nonatomic, strong) NSString *expectreturnTime;//预计归还日期
@property (nonatomic, strong) NSString *purpose;//用途
@property (nonatomic, strong) NSArray *zsjylb;//证书借用列表
@property (nonatomic, strong) NSArray *zsjyfj;//附件列表
@property (nonatomic, strong) NSString *isMortgage;//是否押证
@property (nonatomic, strong) NSString *staffCompony;//项目所属公司
@property (nonatomic, strong) NSString *projectDept;//项目所属部门


//考勤,出差
@property (nonatomic, strong) NSString *subProjectManager;////标段项目经理
@property (nonatomic, strong) NSString *subProjectGeneralManager;//所属标段工管公司
@property (nonatomic, strong) NSString *subProjectDirector;//标段项目总监
@property (nonatomic, strong) NSString *workDate;//补录日期
@property (nonatomic, strong) NSString *subProjectCostAccounting;//所属标段成本核算
@property (nonatomic, strong) NSString *teamsName;//班组
@property (nonatomic, strong) NSString *phaseName;//标段名称
@property (nonatomic, strong) NSString *subPhaseHrName;//所属标段HR

//幕墙材料信息
@property (nonatomic, strong) NSString *threeTypeName;//三级类别
@property (nonatomic, strong) NSString *proOrder;//项目指令
@property (nonatomic, strong) NSString *eidtDate;//编辑时间
@property (nonatomic, strong) NSString *receiverName;//收货人
@property (nonatomic, strong) NSString *receiverMobile;//收货人联系电话
@property (nonatomic, strong) NSString *feedReason;//补料原因
@property (nonatomic, strong) NSString *isSupply;//是否甲供材 （枚举 1是 0否）
@property (nonatomic, strong) NSArray *files;//附件
@property (nonatomic, strong) NSString *requireTypeStr;// 需求类别




/***********************报销单************************************/
//报销单(字典)("travelCategory","businessCategory","personCategory"分别对应"差旅报销单","业务招待报销单","个人报销单")
/**出差单号*/
@property (nonatomic,strong) NSString *businessCode;
/**报销单类型*/
@property (nonatomic,strong) NSString *categoryStr;
/**申请日期*/
@property (nonatomic,strong) NSString *applyDate;
/**申请人*/
@property (nonatomic,strong) NSString *expensesName;
/**所属部门,费用归属部门*/
@property (nonatomic,strong) NSString *expensesDeptName;
/**职务级别*/
@property (nonatomic,strong) NSString *jobLevelStr;
/**是否项目经理审批*/
@property (nonatomic,assign) BOOL proPerson;
/**项目经理审批*/
@property (nonatomic,strong) NSString *proPersonStr;
/**项目名称*/
@property (nonatomic,strong) NSString *proName;
/**项目经理名称*/
@property (nonatomic,strong) NSString *proManagerName;
/**费用承担人*/
@property (nonatomic,strong) NSString *expensePayerName;
/**是否营销综合管理部审批*/
@property (nonatomic,assign) BOOL areaCompany;
/**营销综合管理部审批*/
@property (nonatomic,strong) NSString *areaCompanyStr;
/**经营性费用*/
@property (nonatomic,assign) CGFloat operateCost;
/**非经营性费用*/
@property (nonatomic,assign) CGFloat noOperateCost;
/**固定补贴费用*/
@property (nonatomic,assign) CGFloat fixedSubsidy;
/**公司承担费用*/
@property (nonatomic,assign) CGFloat compBear;
/**入账公司*/
@property (nonatomic,strong) NSString *entryCompName;
/**申请金额*/
@property (nonatomic,assign)  CGFloat applyMoney;
/**交通费用*/
@property (nonatomic,assign) CGFloat tranSum;
/**交通超标*/
@property (nonatomic,strong) NSString *tranWarningMsgTran;
/**住宿费用*/
@property (nonatomic,assign) CGFloat putUpSum;
/**住宿超标*/
@property (nonatomic,strong) NSString *putUpWarningMsg;
/**补助*/
@property (nonatomic,assign) CGFloat subsidySum;
/**补助超标*/
@property (nonatomic,strong) NSString *subsidyWarningMsg;
/**业务招待报销单中的营销综合管理部审批，判断是否有编辑权限*/
@property (nonatomic,assign) BOOL editMarket;
//改
/**是否为出场费(枚举 是：1，否0)*/
@property (nonatomic,assign) NSInteger appearFee;
/**收款方*/
@property (nonatomic,strong) NSString *payee;
/**付款金额*/
@property (nonatomic,assign) CGFloat payMoney;
/**冲账金额*/
@property (nonatomic,assign) CGFloat writeOffMoney;
/**张数*/
@property (nonatomic,assign) NSInteger invoiceNum;
/**附件*/
@property (nonatomic,strong) NSArray *mobileFiles;
/**合同附件*/
@property (nonatomic,strong) NSArray *mobileFilesList;
/**全品合同附件*/
@property (nonatomic,strong) NSArray *mobileFilesQpList;

/**分摊详情*/
@property (nonatomic,strong) NSArray *pexpShareList;
/**营销费用 分摊详情*/
@property (nonatomic,strong) NSArray *marketPexpShareList;
/**是否取消出差*/
@property (nonatomic,strong) NSString *cancel;
/**出差实际开始时间*/
@property (nonatomic,strong) NSString *actualStartTime;
/**出差实际结束时间*/
@property (nonatomic,strong) NSString *actualEndTime;
@property (nonatomic,strong) NSString *businessInfoCode;
@property (nonatomic,strong) NSString *processInstanceId;
@property (nonatomic,strong) NSString *businessInfoId;
@property (nonatomic,strong) NSString *businessInfoProcessId;



//供应商Model
@property (nonatomic, strong) NSString *no;//临时编号
@property (nonatomic, strong) NSString *name;//供应商名称
@property (nonatomic,strong) NSString *franName;//供应商名称
@property (nonatomic, strong) NSString *comCategory;//公司分类
@property (nonatomic, strong) NSString *shortName;//供应商简称
@property (nonatomic, strong) NSString *franCategory;//供应商分类
@property (nonatomic, strong) NSString *license;//营业执照
@property (nonatomic, strong) NSString *organ;//组织机构代码证
@property (nonatomic, strong) NSString *createTime;//注册日期
@property (nonatomic, strong) NSString *taxNo;//税务登记号
@property (nonatomic, strong) NSString *province;//省
@property (nonatomic, strong) NSString *city;//市
@property (nonatomic, strong) NSString *area;//区
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *registerMoney;//注册资金
@property (nonatomic, strong) NSString *legalPerson;//法人代表
@property (nonatomic, strong) NSString *saleModel;//销售模式
@property (nonatomic, strong) NSString *comNature;//企业性质
@property (nonatomic, strong) NSString *admitLevel;//准入评级
@property (nonatomic, strong) NSString *openSource;//开拓来源
@property (nonatomic, strong) NSString *busScope;//经营范围
@property (nonatomic, strong) NSArray *admitPersons;//联系人
@property (nonatomic, strong) NSArray *scores;//考评评分

@property (nonatomic, strong) NSArray *admitElectrons;//电子资料
@property (nonatomic, strong) NSArray *represents;//代表项目
@property (nonatomic, strong) NSArray *operates;//企业经营情况
@property (nonatomic, strong) NSArray *categorys;//供货类别
@property (nonatomic, strong) NSArray *admitScoreCounts;//计算的分数




//材料招标
@property (nonatomic, strong) NSString *code;//招标编码
/**报销单ID*/
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *bidMtrl;//招标材料
@property (nonatomic, strong) NSString *proCode;//项目名称
@property (nonatomic, strong) NSString *modelStr;//采购模式
@property (nonatomic, strong) NSString *isKey;//是否重点项目
@property (nonatomic, strong) NSString *contractCount;//合同盖章份数
/**全品是否盖章*/
@property (nonatomic,strong) NSString *useSealUnit;
@property (nonatomic, strong) NSString *contractTypeStr;//采购合同版本
@property (nonatomic, strong) NSString *managerModel;//项目性质
@property (nonatomic, strong) NSString *pmoney;//工程造价
@property (nonatomic, strong) NSArray *bidFranList;//
@property (nonatomic, assign) BOOL isBid;//是否重点项目
@property (nonatomic, strong) NSString *money;

//会议室
@property (nonatomic, strong) NSString *meetingroomName;//会议室名称
@property (nonatomic, strong) NSString *applyType;//申请类型
@property (nonatomic, strong) NSString *startDateStr;//使用时间
@property (nonatomic, strong) NSString *endDateStr;
@property (nonatomic, strong) NSString *startTimeStr;//开始时段
@property (nonatomic, strong) NSString *endTimeStr;//结束时段
@property (nonatomic, strong) NSString *weekDays;
//复核考核
/**复核考察类型*/
@property (nonatomic,strong) NSString *checkTypeStr;
/**供应商编号*/
@property (nonatomic,strong) NSString *franNo;
//供应商名称name，简称shortname
/**联系人*/
@property (nonatomic,strong) NSString *personName;
/**手机*/
@property (nonatomic,strong) NSString *mobile;
/**供货类别*/
@property (nonatomic,strong) NSArray *franCategoryString;
/**准入日期*/
@property (nonatomic,strong) NSString *auditDateStr;
/**考核评分*/
@property (nonatomic,assign) CGFloat score;
/**供应商信息id*/
@property (nonatomic,strong) NSString *franInfoId;

@property (nonatomic,strong) NSString *statusStr;

@property (nonatomic,strong) YSFlowAssetsApplyFormListModel *mqPersonApply;
@property (nonatomic,strong) YSFlowAssetsApplyFormListModel *baseInfo;
@property (nonatomic,strong) YSFlowAssetsApplyFormListModel *mqPersonAllot;
@property (nonatomic,strong) YSFlowAssetsApplyFormListModel *ObaseInfo;
@property (nonatomic,strong) YSFlowAssetsApplyFormListModel *IbaseInfo;

@property (nonatomic,strong) NSArray *personApplyRequire;

@property (nonatomic, strong) NSString *proDeptName;//所属部门
@property (nonatomic, strong) NSString *proNatureName;//项目性质
@property (nonatomic, strong) NSString *contPrice;//合同价
@property (nonatomic, strong) NSString *applyNatureStr;//申请性质
@property (nonatomic, strong) NSString *proGeneralManager;
@property (nonatomic, strong) NSString *currentPersonCount;//现有人员数量
@property (nonatomic, strong) NSString *projectCount;//负责项目数量
@property (nonatomic, strong) NSString *requireCount;//申请人员数量

@property (nonatomic, strong) NSString *transferTypeStr;//调动类型
@property (nonatomic, strong) NSString *deptName;//所属部门
@property (nonatomic, strong) NSString *allotType;//调派原因
@property (nonatomic, strong) NSString *enterDate;//到岗日期
@property (nonatomic, strong) NSString *calloutTypeStr;//调出类型
@property (nonatomic, strong) NSString *callinTypeStr;//调出类型
@property (nonatomic, strong) NSString *oproName;//调出项目名字
@property (nonatomic, strong) NSString *calloutDeptName;//所属部门
@property (nonatomic, strong) NSString *proManName;//执行经理
@property (nonatomic, strong) NSString *duty;//项目任职
@property (nonatomic, strong) NSString *calloutRemark;//调出项目部备注
@property (nonatomic, strong) NSString *iproName;//调入项目名称
@property (nonatomic, strong) NSString *callinDeptName;//调入部门名称
@property (nonatomic, strong) NSString *projectProposal;//项目拟任职
@property (nonatomic, strong) NSString *callinPost;//调入岗位
@property (nonatomic, strong) NSString *callinAssessmentManager;//考核总监
@property (nonatomic, strong) NSString *calloutAssessmentManager;//调出考核总监
@property (nonatomic, strong) NSString *shareName;//费用分摊人
@property (nonatomic, strong) NSString *conterName;//工作联系人
@property (nonatomic, strong) NSString *calloutTerritory;//负责区域
@property (nonatomic, strong) NSString *callinTerritory;



@end

//资产申请明细信息模型
@interface YSFlowAssetsApplyFormApplyInfosModel : NSObject

@property (nonatomic, strong) NSString *thirdCate;    // 明细类
@property (nonatomic, strong) NSString *assetsCount;//资产数
@property (nonatomic, strong) NSString *goodsLevelName;    // 物品等级
@property (nonatomic, strong) NSString *goodsLevelRemark;    // 等级说明
@property (nonatomic, strong) NSString *totalNum;    // 在用资产数
@property (nonatomic, strong) NSString *applyReason;    // 申请理由


@property (nonatomic, strong) NSString *goodsName;    // 物品名称
@property (nonatomic, strong) NSString *applyNumber;    // 数量
@property (nonatomic, strong) NSString *buyUnit;    // 单位
@property (nonatomic, strong) NSString *refPrice;    // 参考价格
@property (nonatomic, strong) NSString *totalRate;//税额
//@property (nonatomic, strong) NSString *totalNum;

@property (nonatomic, strong) NSString *proModel; //规格型号
@property (nonatomic, strong) NSString *remark;  //备注

@property (nonatomic, strong) NSString *assetsNo; //资产编码
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *handleMode; //处理方式
@property (nonatomic, strong) NSString *handleReason; //处理原因
@property (nonatomic, strong) NSString *handleFee;//处理金额
@property (nonatomic, strong) NSString *descriptions;//物品说明

@property (nonatomic, assign) BOOL ifBattery;//是否电池
@property (nonatomic, assign) BOOL if4gModel;//是否4G模块



//供应商准入
@property (nonatomic, strong) NSString *oneTypeName;//一级别类别名称
@property (nonatomic, strong) NSString *twoTypeName;//二级类别名称
@property (nonatomic, strong) NSString *threeTypeName;//三级类别名称
@property (nonatomic, strong) NSString *fourTypeName;//四级别类别名称


@property (nonatomic, strong) NSString *name;//联系人姓名
@property (nonatomic, strong) NSString *mobile;//联系人电话
@property (nonatomic, strong) NSString *sdate;//年份
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *svalue;//值
@property (nonatomic, strong) NSString *statusStr;//是否有效
@property (nonatomic, strong) NSString *longName;//全称
@property (nonatomic, strong) NSString *score;//分数


@property (nonatomic, strong) NSString *weight;//权重
@property (nonatomic, strong) NSString *content;//综合评估
@property (nonatomic, strong) NSString *templateName;//考评模板名称

@property (nonatomic, strong) NSString *mobileId;
@property (nonatomic, strong) NSArray *mobileFiles;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *viewPath;
@property (nonatomic, assign) NSInteger fileType;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, assign) CGFloat fileSize;


@property (nonatomic, strong) NSString *station;//申请岗位
@property (nonatomic, strong) NSString *postStr;//申请原因
@property (nonatomic, strong) NSString *existingCount;//现有数量
@property (nonatomic, strong) NSString *enterDate;//到岗日期
@property (nonatomic, strong) NSString *partTime;//项目兼职
@property (nonatomic, strong) NSString *relName;//建议人员
@property (nonatomic, strong) NSString *requireCount;//申请人员数量
//@property (nonatomic, strong) NSString *remark;



@end

//考勤机申请明细信息模型
@interface YSFlowSupplyListInfoModel : NSObject



@end


