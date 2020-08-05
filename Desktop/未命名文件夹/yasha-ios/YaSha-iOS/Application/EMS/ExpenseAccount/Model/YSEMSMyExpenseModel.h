//
//  YSEMSMyExpenseModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/6.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSEMSExpenseDetailModel.h"
@interface YSEMSMyExpenseModel : NSObject
/**备用金*/
@property (nonatomic,strong) YSEMSExpenseDetailModel *myLoan;
/**我的报销单*/
@property (nonatomic,strong) YSEMSExpenseDetailModel *myPexp;
/**对公报销*/
@property (nonatomic,strong) YSEMSExpenseDetailModel *pubPexp;
/**备用金余额*/
@property (nonatomic,strong) YSEMSExpenseDetailModel *myLoanAmount;
@end
