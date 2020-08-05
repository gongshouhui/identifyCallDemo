//
//  YSPMSPlanListModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/30.
//

#import <Foundation/Foundation.h>

@interface YSPMSPlanListModel : NSObject

@property (nonatomic, strong) NSString *id;//任务id
@property (nonatomic, strong) NSString *proName;//项目名称
@property (nonatomic, strong) NSString *graphicProgress;//进度
@property (nonatomic, strong) NSString *proNatureStr;//项目类型
@property (nonatomic, strong) NSString *proManagerName;//项目经理
@property (nonatomic, strong) NSString *deptsInfo;//部门
@property (nonatomic, strong) NSString *proManagerId;//项目经理ID
@property (nonatomic, strong) NSString *personLiableCode;//责任人工号
@property (nonatomic, strong) NSString *personLiableName;
@property (nonatomic, strong) NSString *planStartDate;//开始时间
@property (nonatomic, strong) NSString *planEndDate;//结束时间
@property (nonatomic, strong) NSString *auditStatusStr;//项目状态
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *progressRatio; //百分比
@property (nonatomic, strong) NSString *consName; //几号楼
@property (nonatomic,strong) NSString *pileName;
@property (nonatomic,strong) NSString *areaName;
@property (nonatomic, strong) NSString *taskStatus; //状态,10未开工，20进行中，30已完工
@property (nonatomic, strong) NSString *actualEndDate;  //实际结束时间
@property (nonatomic, strong) NSString *actualStartDate;  //实际开始时间
@property (nonatomic, strong) NSString *taskStatusStr; //状态
@property (nonatomic, strong) NSString *outDayNumber;   //大于0表示剩余时间，小于0表示延期时间
@property (nonatomic, strong) NSString *taskDefineName;//名
@property (nonatomic, strong) NSString *taskDefineRemarks;
@property (nonatomic, strong) NSArray *progresses;//图片列表
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *completionRatio;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *thisTimeCompletion;
@property (nonatomic, strong) NSString *grandTotalCompletion;
@property (nonatomic, strong) NSArray *filePathStr;

@property (nonatomic, strong) NSString *actualComplet;//实际完工量
@property (nonatomic, strong) NSString *completRatio;//完工比例
@property (nonatomic, strong) NSString *quantity;//工程量
@property (nonatomic, strong) NSString *taskCategory;//关键控制点类别（gjkzd）
@property (nonatomic, assign) int unitPrice;//综合单价
@property (nonatomic, assign) int engineeringOutputValue;//工程产值

//幕墙前期准备进度新增字段
/**任务名字*/
@property (nonatomic, strong) NSString *name;
/**父节点名称*/
@property (nonatomic,strong) NSString *parentName;
/**主要负责人*/
@property (nonatomic,strong) NSString *mainPersonName;
/**主要负责人编号*/
@property (nonatomic,strong) NSString *mainPersonCode;
//planEndDate,planStartDate,auditStatusStr状态,形象进度graphicProgress
@end
