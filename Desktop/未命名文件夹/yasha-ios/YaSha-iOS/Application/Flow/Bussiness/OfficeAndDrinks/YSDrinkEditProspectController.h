//
//  YSDrinkEditProspectController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/11.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"
#import "YSFlowOfficeAndDrinkModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^EditProspectSuccessBlock)(NSString *money,NSInteger number);
@interface YSDrinkEditProspectController : YSCommonTableViewController
@property (nonatomic,strong) YSFlowOfficeAndDrinkModel *drinkdModel;
@property (nonatomic,strong) EditProspectSuccessBlock editSuccessBlock;
@end

NS_ASSUME_NONNULL_END
