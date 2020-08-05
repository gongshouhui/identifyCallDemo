//
//  YSFlowFormModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import <Foundation/Foundation.h>

@class YSFlowFormModel, YSFlowFormHeaderModel, YSFlowFormListModel, YSFlowFormSubFormModel,YSFlowTransferModel;

@interface YSFlowFormModel : NSObject

@property (nonatomic, strong) YSFlowFormHeaderModel *baseInfo;
@property (nonatomic, strong) NSArray *dataInfo;//基础信息
@property (nonatomic, copy) NSDictionary *info;
@property (nonatomic, strong) NSArray *transferList;//转阅记录
@property (nonatomic, strong) NSArray *examinationList;//审批记录
@property (nonatomic, strong) NSArray *postscriptList;//附言记录
@property (nonatomic, copy) NSDictionary *applicantProbation;//试用期信息

@end

@interface YSFlowFormHeaderModel : NSObject

@property (nonatomic, strong) NSString *ownDeptName;
@property (nonatomic, strong) NSString *processDockingName;
@property (nonatomic, strong) NSString *processDockingNo;
@property (nonatomic, strong) NSString *sponsor;
@property (nonatomic, strong) NSString *sponsorNo;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *launchDepartment;
@property (nonatomic, strong) NSString *launchTime;

@end

@interface YSFlowFormListModel : NSObject

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *fieldType;
@property (nonatomic, strong) NSString *lableName;
@property (nonatomic, strong) NSString *fieldName;
@property (nonatomic, strong) NSArray *values;//子表单信息

@end

@interface YSFlowTransferModel:NSObject

////转阅,审批
//@property (nonatomic, strong) NSString *fullMsg;
//@property (nonatomic, strong) NSString *message;
//@property (nonatomic, strong) NSString *processInstanceId;
//@property (nonatomic, strong) NSString *taskId;
//@property (nonatomic, strong) NSString *taskName;
//@property (nonatomic, strong) NSString *time;
//@property (nonatomic, strong) NSString *type;
//@property (nonatomic, strong) NSString *typeName;
//@property (nonatomic, strong) NSString *userId;
//@property (nonatomic, strong) NSString *userName;
//@property (nonatomic, strong) NSString *userUrl;
//
////附言
//@property (nonatomic, strong) NSString *id;
//@property (nonatomic, strong) NSString *procFormId;
//@property (nonatomic, strong) NSString *procInstId;
//@property (nonatomic, strong) NSString *creator;
//@property (nonatomic, strong) NSString *createTime;

@end


