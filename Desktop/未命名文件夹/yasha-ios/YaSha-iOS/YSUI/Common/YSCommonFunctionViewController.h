//
//  YSCommonFunctionViewController.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"
#import "YSACLModel.h"
#import "YSApplicationModel.h"
#import "YSApplicationBannerView.h"
static NSString *const reuseIdentifierHeader = @"ApplicationCycleView";
static NSString *const reuseIdentifier = @"ApplicationCell";
@interface YSCommonFunctionViewController : YSCommonViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic,strong) YSApplicationBannerView *bannerView;
@end
