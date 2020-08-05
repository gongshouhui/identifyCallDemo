//
//  YSContactSelectCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/9.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewCell.h"
#import "YSContactModel.h"
#import "YSDepartmentModel.h"
@interface YSContactSelectCell : YSCommonTableViewCell

@property (nonatomic, strong) YSContactModel *cellModel;
@property (nonatomic, strong) YSDepartmentModel *departmentModel;
@property (nonatomic, strong) QMUIButton *selectButton;

@property (nonatomic, strong) YSDepartmentModel *selectDepartModel;
/**
 部门选择树使用的模型(本地数据);
 */

@end
