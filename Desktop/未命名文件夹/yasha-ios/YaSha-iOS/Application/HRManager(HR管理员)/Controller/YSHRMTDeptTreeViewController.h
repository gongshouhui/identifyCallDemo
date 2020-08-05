//
//  YSHRMTDeptTreeViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/19.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonListViewController.h"
#import "YSDeptTreePointModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSHRMTDeptTreeViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *deptArray;
@property(nonatomic,copy) void (^choseDeptTreeBlock)(YSDeptTreePointModel *model);

@end

NS_ASSUME_NONNULL_END
