//
//  YSCRMDepartTreeViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/6/17.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSCRMDepartTreeViewController : YSCommonTableViewController
@property (nonatomic, strong) NSArray *departArray;// 部门树
@property(nonatomic,copy) void (^choseCRMDeptTreeBlock)(NSArray *modelArray);//两个值(第一值所选部门所在的公司,第二个是所选的部门)

@end

NS_ASSUME_NONNULL_END
