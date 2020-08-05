//
//  YSSupplyFunctionViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/19.
//

#import "YSSupplyFunctionViewController.h"
#import "YSSupplyPageViewController.h"
#import "YSApplicationModel.h"
#import "YSSupplyMaterialListViewController.h"

@interface YSSupplyFunctionViewController ()

@end

@implementation YSSupplyFunctionViewController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"供应链"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"供应链"];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"供应链";
}

- (void)initSubviews {
    [super initSubviews];
    self.title = @"供应链";
    [self getDatasourceArray];
}

- (void)getDatasourceArray {
    [self.dataSourceArray addObjectsFromArray:
     [YSDataManager getApplicationsData:@[@{@"id": @"0",
                                            @"name": @"供应商库",
                                            @"imageName":  @"ic_app_scm_lib",
                                            @"className": @"YSSupplyPageViewController"},
                                          @{@"id": @"1",
                                            @"name": @"材料管理",
                                            @"imageName": @"ic_app_scm_material",
                                            @"className": @"YSSupplyMaterialListViewController"},
                                          @{@"id": @"2",
                                            @"name": @"招标管理",
                                            @"imageName": @"ic_app_scm_tender",
                                            @"className": @"YSSuppyBidInvitingListController"}]]];
    
    //供应商库权限
    BOOL libraryPermissions = [YSUtility checkDatabaseSystemSn:SupplySystem andModuleSn:SupplyModel andCompanyId:nil andPermissionValue:PermissionQueryValue];
    if (!libraryPermissions) {
        [self.dataSourceArray removeApplicationWithIds:@[@"0"]];
    }

    //招标管理权限
    BOOL tenderPermissions = [YSUtility checkDatabaseSystemSn:SupplySystem andModuleSn:TenderModel andCompanyId:nil andPermissionValue:PermissionQueryValue];
    if (!tenderPermissions) {
        [self.dataSourceArray removeApplicationWithIds:@[@"2"]];
    }
    self.imageName = @"移动端供应链-banner-6";
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    Class someClass = NSClassFromString(model.className);
    UIViewController *viewController = [[someClass alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
