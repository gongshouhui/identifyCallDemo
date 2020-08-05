//
//  YSContactSelectOrgsViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"

@interface YSContactSelectOrgsViewController : YSCommonTableViewController

@property (nonatomic, assign) BOOL isRootDirectory;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSString *pNum;

@end
