//
//  YSFlowListModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/25.
//

#import <Foundation/Foundation.h>

@interface YSFlowListModel : NSObject

@property (nonatomic, strong) NSString *approverName;    // 流程处理者
@property (nonatomic, strong) NSString *approverNo;// 流程处理者工号
@property (nonatomic, strong) NSString *businessKey;    //
/**
 流程状态
 SPZ("1", "审批中"), BH("2", "驳回"), CH("3", "撤回"),ZC("4", "暂存"),BJ("5", "办结"),ZZ("6", "终止"), PS("7","评审")
 */
@property (nonatomic, assign) FlowHandleStatusType flowStatus;    // 流程状态
/**ZC("1", "正常"), ZH("2", "知会"), BH("3", "提交人")【未使用】,ZY("4","转阅")【未使用】,BSP("5","不审批"),XT("6","协同"),PS("7","评审")*/
/**任务节点，不同的人拥有不同的节点权限（不同的处理权限）比如在知会节点只有转阅权限，*/
/**流程常量
extern NSString *const FlowTaskZH;
extern NSString *const FlowTaskSP;
extern NSString *const FlowTaskBSP;
extern NSString *const FlowTaskXT;
extern NSString *const FlowTaskPS;
extern NSString *const FlowTaskSPZ;
 */
@property (nonatomic, strong) NSString *taskType;//任务节点
/**任务跟踪，（提交人，中心副总等）*/
@property (nonatomic,strong) NSString *taskName;
@property (nonatomic, strong) NSString *flowStatusName;    // 流程状态
@property (nonatomic, strong) NSString *fromName;    // 流程名
@property (nonatomic, strong) NSString *processDefinitionKey;    // 流程定义key
@property (nonatomic, strong) NSString *processInstanceId;    // 流程实例id
@property (nonatomic, assign) NSInteger processType;    // 1为 自定义表单 5为业务转自定义  为空或者其他值为业务表单
@property (nonatomic, strong) NSString *startPersonName;    // 流程发起者
@property (nonatomic, assign) NSInteger stayHour;    // 停留时间
@property (nonatomic, strong) NSString *taskId;    // 任务id
@property (nonatomic, assign) NSInteger total;    // 总条数
@property (nonatomic, strong) NSString *businessUrl;    // businessUrl 针对资产旧流程
@property (nonatomic, assign) BOOL turnRead;    // 是否转阅类型


//@property (nonatomic, strong) NSString *businessKey;//表单编号
@property (nonatomic, strong) NSString *content;//消息内容
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *noticeType;//消息类型(1流程知会，2流程消息，3系统提醒，4系统待办)
@property (nonatomic, strong) NSString *processDefinitionId;//流程定义的id
//@property (nonatomic, strong) NSString *processDefinitionKey;//流程定义key
@property (nonatomic, strong) NSString *title;//消息主题
@property (nonatomic, strong) NSString *createTime;//创建时间
@property (nonatomic, strong) NSString *status;//是否已读
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSString *systemName;
@end
