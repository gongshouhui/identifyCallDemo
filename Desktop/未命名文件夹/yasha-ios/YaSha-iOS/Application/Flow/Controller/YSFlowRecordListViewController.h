//
//  YSFlowRecordListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSCommonListViewController.h"
#import "YSFlowListModel.h"

typedef enum : NSUInteger {
    FlowRecordTypeHandle,
    FlowRecordTypeTrans,
} YSFlowRecordType;

@interface YSFlowRecordListViewController : YSCommonListViewController

@property (nonatomic, strong) YSFlowListModel *cellModel;
@property (nonatomic, assign) YSFlowRecordType flowRecordType;

@end
