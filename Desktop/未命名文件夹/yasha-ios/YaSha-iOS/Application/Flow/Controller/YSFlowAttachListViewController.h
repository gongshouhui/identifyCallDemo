//
//  YSFlowAttachListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSCommonListViewController.h"
#import "YSFlowListModel.h"

typedef enum : NSUInteger {
    FlowAttachTypePS,
    FlowAttachTypeFile,
    FlowAttachTypeFlow,
} YSFlowAttachType;

@interface YSFlowAttachListViewController : YSCommonListViewController

@property (nonatomic, assign) YSFlowAttachType flowAttachType;
@property (nonatomic, strong) YSFlowListModel *cellModel;
@property (nonatomic, strong) NSArray *attachArray;
@property (nonatomic, strong) NSString *businessKey;


@end
