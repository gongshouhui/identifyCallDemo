//
//  YSContactCell.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewCell.h"
#import "YSContactModel.h"
#import "YSDepartmentModel.h"
#import <PPPersonModel.h>
#import "YSTeamCompilePostModel.h"

@interface YSContactCell : YSCommonTableViewCell

/** 联系人模型 */
@property (nonatomic, strong) YSContactModel *cellModel;
/** 联系人模型 */
@property (nonatomic, strong) YSDepartmentModel *departmentModel;
/** 内部通讯录模型 */
@property (nonatomic, strong) PPPersonModel *personModel;

/** 团队在岗列表模型 **/
@property (nonatomic, strong) YSTeamCompilePostModel *deptModel;

@end
