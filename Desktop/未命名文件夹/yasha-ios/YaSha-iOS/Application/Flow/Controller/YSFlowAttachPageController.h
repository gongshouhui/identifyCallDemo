//
//  YSFlowAttachPageController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSCommonPageController.h"
#import "YSFlowListModel.h"

@interface YSFlowAttachPageController : YSCommonPageController

@property (nonatomic, strong) YSFlowListModel *cellModel;
@property (nonatomic, strong) NSArray *attachArray;

@end
