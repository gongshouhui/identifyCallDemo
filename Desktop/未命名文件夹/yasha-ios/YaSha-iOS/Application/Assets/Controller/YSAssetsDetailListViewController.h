//
//  YSAssetsDetailListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/9.
//

#import "YSCommonListViewController.h"
#import "YSAssetsListModel.h"
#import "YSAssetsListViewController.h"

@interface YSAssetsDetailListViewController : YSCommonListViewController

@property (nonatomic, strong) YSAssetsListModel *model;
@property (nonatomic, assign) AssetsListType assetsListType;

@end
