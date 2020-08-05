//
//  YSFlowDrinksEditController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"
#import "YSFlowOfficeAndDrinkModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^EditSuccessBlock)(NSString *acceptMode,NSString *receiveMoney);
@interface YSFlowDrinksEditController : YSCommonTableViewController
@property (nonatomic,strong) YSFlowOfficeAndDrinkModel *drinkdModel;
@property (nonatomic,strong) EditSuccessBlock editSuccessBlock;
@end

NS_ASSUME_NONNULL_END
