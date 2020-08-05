//
//  YSContactSelectPersonViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"

@interface YSContactSelectPersonViewController : YSCommonTableViewController

@property (nonatomic, assign) BOOL isRootDirectory;
@property (nonatomic, strong) NSString *pNum;
@property (nonatomic, strong) NSString *delFlag;//0-已删除，1-未删除
@property (nonatomic, strong) NSString *postStatus;//在岗状态 0 未到岗 1已在岗
@property (nonatomic, strong) NSString *status;//0-离职 1-在职
@property (nonatomic, assign) NSInteger isPublic;//0不显示 1/2/3 显示
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *jumpSourceStr;

@end
