//
//  YSNewsDetailViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"
#import "YSNewsListViewController.h"
#import "YSNewsListModel.h"

@interface YSNewsDetailViewController : YSCommonViewController

@property (nonatomic, assign) YSNewsType newsType;
@property (nonatomic, strong) YSNewsListModel *cellModel;

@property (nonatomic, copy) void(^SaveVisitRecordBlock)(BOOL visited);
@end
