//
//  YSRetoredModifyGViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/6/11.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"
#import "YSReporetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSRetoredModifyGViewController : YSCommonTableViewController
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) YSReporetModel *model;
@property (nonatomic, strong) NSMutableDictionary *recordNoDic;// 有备案号情况下->基本信息界面 修改的 传递给 其他信息 界面

@end

NS_ASSUME_NONNULL_END
