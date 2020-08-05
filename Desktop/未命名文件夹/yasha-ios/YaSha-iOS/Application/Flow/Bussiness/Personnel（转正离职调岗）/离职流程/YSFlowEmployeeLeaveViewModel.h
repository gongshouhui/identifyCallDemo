//
//  YSFlowEmployeeLeaveViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/7.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBaseBussinessFlowViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSFlowEmployeeLeaveViewModel : YSBaseBussinessFlowViewModel

- (BOOL)isEditing;
- (void)editWithConsensus:(NSString *)consensus Comeplete:(fetchDataCompleteBlock)comepleteBlock failue:(fetchDataFailueBlock) failueBlock;

@end

NS_ASSUME_NONNULL_END
