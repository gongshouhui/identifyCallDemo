//
//  YSFlowLawSuitEditDepartController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"
#import "YSLawDepartModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^EditSuccessBlock)();
@interface YSFlowLawSuitEditDepartController : YSCommonTableViewController
@property (nonatomic,strong) YSLawDepartModel *departModel;
@property (nonatomic,strong) NSString *bussinessKey;
@property (nonatomic,strong) EditSuccessBlock editBlock;
@end

NS_ASSUME_NONNULL_END
