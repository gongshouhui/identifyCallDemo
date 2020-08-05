//
//  YSFlowOfficeAndDrinksViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBaseBussinessFlowViewModel.h"
#import "YSFlowOfficeAndDrinkModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSFlowOfficeAndDrinksViewModel : YSBaseBussinessFlowViewModel
/**可变变量 受理方式 ，用于kvo监听*/
@property (nonatomic,strong) NSString *acceptMode;
/**预估金额，用于监听*/
@property (nonatomic,strong) NSString *prospectMoney;
@property (nonatomic,strong) YSFlowOfficeAndDrinkModel *drinkModel;
- (void)editOfficeAndDrinksComeplete:(fetchDataCompleteBlock)comepleteBlock failue:(fetchDataFailueBlock) failueBlock;
@end

NS_ASSUME_NONNULL_END
