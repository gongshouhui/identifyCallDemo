//
//  YSAssetsDetailViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"
#import "YSAssetsDetailListModel.h"

typedef enum : NSUInteger {
    AssetsTypeMine,
    AssetsTypeOther,
} AssetsType;

@interface YSAssetsDetailViewController : YSCommonViewController

@property (nonatomic, strong) YSAssetsDetailListModel *cellModel;
@property (nonatomic, assign) AssetsType assetsType;
@property (nonatomic, assign) BOOL history;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) int assetStates;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, copy) void(^ReturnBlock)(YSAssetsDetailListModel *cellModel);
@property (nonatomic, copy) void(^RefreshBlock)(NSString *stateStr);

@end
