//
//  YSMineMyFolderViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSMineMyFolderViewController : YSCommonTableViewController
@property (nonatomic, assign) BOOL isAdd;//是否是添加文件界面跳转进入, 默认不是
@property(nonatomic,copy) void (^addMyFolderBlock)(NSArray *modelArray);

@end

NS_ASSUME_NONNULL_END
