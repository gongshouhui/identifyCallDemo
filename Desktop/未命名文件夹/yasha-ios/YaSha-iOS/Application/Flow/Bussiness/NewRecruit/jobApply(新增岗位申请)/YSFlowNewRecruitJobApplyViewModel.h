//
//  YSFlowNewRecruitJobApplyViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/12/13.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBaseBussinessFlowViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSFlowNewRecruitJobApplyViewModel : YSBaseBussinessFlowViewModel
/**实现cell展开和收起数据源转换*/
- (void)tableViewCellButtonClick:(NSIndexPath *)indexPath ExtendState:(BOOL)extend Complete:(void(^)())completeBlock;
@end

NS_ASSUME_NONNULL_END
