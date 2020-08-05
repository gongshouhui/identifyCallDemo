//
//  YSContactSelectOrgViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"

@interface YSContactSelectOrgViewController : YSCommonTableViewController

@property (nonatomic, assign) BOOL isRootDirectory;
@property (nonatomic, strong) NSString *pNum;
@property (nonatomic, strong) NSString *delFlag;//0-已删除，1-未删除
@property (nonatomic, strong) NSString *status;//0-离职 1-在职
@end
