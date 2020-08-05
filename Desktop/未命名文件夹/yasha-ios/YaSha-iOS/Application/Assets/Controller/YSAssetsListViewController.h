//
//  YSAssetsListViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/9.
//

#import "YSCommonListViewController.h"

typedef enum : NSUInteger {
    AssetsListDealing,
    AssetsListFinish,
} AssetsListType;

@interface YSAssetsListViewController : YSCommonListViewController

@property (nonatomic, assign) AssetsListType assetsListType;

@end
