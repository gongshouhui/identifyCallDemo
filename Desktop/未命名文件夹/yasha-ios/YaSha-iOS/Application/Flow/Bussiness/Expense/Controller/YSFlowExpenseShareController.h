//
//  YSFlowExpenseShareController.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"
typedef void(^modifySuccessBlock)();
@interface YSFlowExpenseShareController : YSCommonTableViewController
@property (nonatomic,copy) modifySuccessBlock modifySuccessBlock;
@end
