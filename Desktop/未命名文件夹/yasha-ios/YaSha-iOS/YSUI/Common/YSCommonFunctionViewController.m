//
//  YSCommonFunctionViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonFunctionViewController.h"
#import "YSApplicationCell.h"
#import "YSApplicationBannerView.h"

@interface YSCommonFunctionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation YSCommonFunctionViewController

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(87*kWidthScale, 87*kHeightScale);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, (kSCREEN_WIDTH-(87*kWidthScale*4))/4, 8, 8);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 147*(kSCREEN_WIDTH/375.0));
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}
- (YSApplicationBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[YSApplicationBannerView alloc]init];
        _bannerView.imageView.image = [UIImage imageNamed:@"benner"];
    }
    return _bannerView;
}
- (void)initSubviews {
    [super initSubviews];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [self.collectionView registerClass:[YSApplicationBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader];
    [self.collectionView registerClass:[YSApplicationCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    YSApplicationModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YSApplicationBannerView *applicationBannerView = (YSApplicationBannerView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        
        applicationBannerView.imageView.image = [UIImage imageNamed:!_imageName ? @"benner" : _imageName];
        
        supplementaryView = applicationBannerView;
    }
    return supplementaryView;
}

@end
