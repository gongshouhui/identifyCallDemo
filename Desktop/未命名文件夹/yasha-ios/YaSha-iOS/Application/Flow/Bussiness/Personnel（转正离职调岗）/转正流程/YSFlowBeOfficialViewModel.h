//
//  YSFlowBeOfficialViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/6.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBaseBussinessFlowViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSFlowBeOfficialViewModel : YSBaseBussinessFlowViewModel
- (void)editComeplete:(fetchDataCompleteBlock)comepleteBlock failue:(fetchDataFailueBlock) failueBlock;
@end

NS_ASSUME_NONNULL_END
