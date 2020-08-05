//
//  YSFlowDetailPageController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import "YSCommonPageController.h"
#import "YSFlowListViewController.h"
#import "YSFlowListModel.h"
#import "YSFlowModel.h"

@interface YSFlowDetailPageController : YSCommonPageController

@property (nonatomic, assign) YSFlowType flowType;    // 待办类型(待办，已办，已发）
@property (nonatomic, strong) YSFlowModel *flowModel;
@property (nonatomic, strong) YSFlowListModel *cellModel;


@end
