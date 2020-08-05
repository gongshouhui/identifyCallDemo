//
//  YSFlowRecordListModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import <Foundation/Foundation.h>

@interface YSFlowRecordListModel : NSObject

@property (nonatomic, strong) NSString *userUrl;    // 头像
@property (nonatomic, strong) NSString *userName;    // 处理人
@property (nonatomic, strong) NSString *userId;    // 工号
@property (nonatomic, strong) NSString *creator;
//AGREE("审批"), DISAGREE("驳回"), REVOCATION("撤回"), TEMPORARY("暂存"), SYSAGREE("系统执行"), FLOWCREATE("提交"), REEDITFROM("重新提交"), FLOWEND("审批结束"), END("流程终止"), LETPERSON("知会"), TURNREAD("转阅"), HAVEREAD("已阅"), TURNTASK("转办"), ADDSIGN("加签")
@property (nonatomic, strong) NSString *type;    // type
@property (nonatomic, strong) NSString *typeName;    // type转义
@property (nonatomic, strong) NSString *time;    // 时间戳
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *message;    // 处理信息
@property (nonatomic, strong) NSString *massage;
@property (nonatomic, strong) NSArray *mobileFileVos;//附件数组

@end
