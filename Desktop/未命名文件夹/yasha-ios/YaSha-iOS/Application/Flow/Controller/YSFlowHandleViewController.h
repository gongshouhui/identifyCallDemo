//
//  YSFlowHandleViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSCommonViewController.h"
#import "YSFlowListViewController.h"
#import "YSFlowListModel.h"



@interface YSFlowHandleViewController : YSCommonViewController

@property (nonatomic, assign) YSFlowType flowType;
@property (nonatomic, assign) YSFlowHandleType flowHandleType;
@property (nonatomic, strong) YSFlowListModel *cellModel;
@property (nonatomic, strong) NSString *outWarningMessage;
@property (nonatomic,strong) NSString *additionMessage;

@end
