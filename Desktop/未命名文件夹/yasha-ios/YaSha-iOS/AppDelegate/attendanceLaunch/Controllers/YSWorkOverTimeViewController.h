//
//  YSWorkOverTimeViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/12/12.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"
#import "YSFlowLaunchListModel.h"

NS_ASSUME_NONNULL_BEGIN
//仅用于 考勤 加班/因公外出 流程申请
@interface YSWorkOverTimeViewController : YSCommonListViewController
@property (nonatomic, strong) YSFlowLaunchListModel *lanchModel;

@end

NS_ASSUME_NONNULL_END
