//
//  YSPMSZSFunctionViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/25.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSZSFunctionViewController.h"

@interface YSPMSZSFunctionViewController ()

@end

@implementation YSPMSZSFunctionViewController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"装饰项目管理"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"装饰项目管理"];
}

- (void)initSubviews {
    self.title = @"项目管理";
    [super initSubviews];
    [self getDatasourceArray];
}

- (void)getDatasourceArray {
    [self.dataSourceArray addObjectsFromArray:[YSDataManager getApplicationsData:@[@{@"id": @"0",
                                                                                     @"name": @"项目信息管理",
                                                                                     @"imageName": @"ic_app_pm_info_zhuang",
                                                                                     @"className": @"YSPMSInfoPageViewController"},
                                                                                   @{@"id": @"1",
                                                                                     @"name": @"进度计划管理",
                                                                                     @"imageName": @"ic_app_pm_rate_zhuang",
                                                                                     @"className": @"YSPMSPlanListViewController"}
                                                                                   
                                                                                   ]]];
    
    
    BOOL zsResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSInfoManagementModel andCompanyId:ZScompanyId andPermissionValue:PermissionQueryValue];
    BOOL zsPlanaResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSPlanManagementModel andCompanyId:ZScompanyId andPermissionValue:PermissionQueryValue];

#if YASHA_DEBUG == 0
    if (!zsResults) {
        [self.dataSourceArray removeApplicationWithIds:@[@"0"]];
    }
    if (!zsPlanaResults) {
        [self.dataSourceArray removeApplicationWithIds:@[@"1"]];
    }
#endif
    self.imageName = @"移动端项目管理-banner-7";
    [self.collectionView reloadData];
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    Class someClass = NSClassFromString(model.className);
    UIViewController *viewController = [[someClass alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
