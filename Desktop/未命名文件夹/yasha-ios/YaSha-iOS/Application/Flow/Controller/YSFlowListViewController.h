//
//  YSFlowListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/13.
//

#import "YSCommonListViewController.h"

//z项目中流程列表有三初，1、流程中心列表 2、关联流程列表 3、消息通知列表
@interface YSFlowListViewController : YSCommonListViewController

@property (nonatomic, assign) YSFlowType flowType;    // 待办类型

@end
