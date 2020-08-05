//
//  YSAssetsFunctionViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/17.
//

#import "YSAssetsFunctionViewController.h"
#import "YSAssetsSearchViewController.h"    // 资产查询
#import "YSAssetsPageController.h"    // 资产盘点
#import "YSAssetsMineListViewController.h"    // 我的资产

@interface YSAssetsFunctionViewController ()

@end

@implementation YSAssetsFunctionViewController
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"固定资产"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"固定资产"];
}
- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"固定资产";
}

- (void)initSubviews {
    [super initSubviews];
    [self getDatasourceArray];
    self.title = @"固定资产";
}

- (void)getDatasourceArray {
    [self.dataSourceArray addObjectsFromArray:[YSDataManager getApplicationsData:@[@{@"id": @"0",
                                                                                     @"name": @"资产查询",
                                                                                     @"imageName": @"资产查询",
                                                                                     @"className": @"YSAssetsSearchViewController"},
                                                                                   @{@"id": @"1",
                                                                                     @"name": @"资产盘点",
                                                                                     @"imageName": @"资产盘点",
                                                                                     @"className": @"YSAssetsPageController"},
                                                                                   @{@"id": @"2",
                                                                                     @"name": @"我的资产",
                                                                                     @"imageName": @"我的资产",
                                                                                     @"className": @"YSAssetsMineListViewController"}]]];
    RLMResults *results = [YSACLModel objectsWhere:@"systemSn = 'assets' AND moduleSn = 'check' AND permissionValue = 0"];
    if (results.count == 0) {
        [self.dataSourceArray removeApplicationWithIds:@[@"1"]];
    }
    self.imageName = @"资产查询banner";
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    Class someClass = NSClassFromString(model.className);
    UIViewController *viewController = [[someClass alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
