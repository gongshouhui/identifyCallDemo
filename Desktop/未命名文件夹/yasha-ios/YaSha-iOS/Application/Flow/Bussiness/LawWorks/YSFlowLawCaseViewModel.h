//
//  YSFlowLawCaseViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/7.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBaseBussinessFlowViewModel.h"
#import "YSLawCaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSFlowLawCaseViewModel : YSBaseBussinessFlowViewModel
@property (nonatomic,strong) YSLawCaseModel *caseModel;
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
