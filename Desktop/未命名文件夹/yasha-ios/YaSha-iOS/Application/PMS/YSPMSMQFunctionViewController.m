//
//  YSPMSMQFunctionViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/25.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQFunctionViewController.h"
#import "YSPMSMQPlanListViewController.h"

@interface YSPMSMQFunctionViewController ()

@end

@implementation YSPMSMQFunctionViewController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"幕墙项目管理"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"幕墙项目管理"];
}

- (void)initSubviews {
    self.title = @"项目管理";
    [super initSubviews];
    [self getDatasourceArray];
}

- (void)getDatasourceArray {
    [self.dataSourceArray addObjectsFromArray:[YSDataManager getApplicationsData:@[@{@"id": @"0",
                                                                                     @"name": @"项目信息管理",
                                                                                     @"imageName": @"项目信息管理",
                                                                                     @"className": @"YSPMSMQPageViewController"},
                                                                                   @{@"id": @"1",
                                                                                     @"name": @"进度计划管理",
                                                                                     @"imageName": @"项目进度管理",
                                                                                     @"className": @"YSPMSMQPlanListViewController"}
                                                                                   ]]];
  
    
    

    BOOL mqResults = [YSUtility checkDatabaseSystemSn:MQInfomanagement andModuleSn:MQModuleIdentification andCompanyId:MQcompanyId andPermissionValue:PermissionQueryValue];
    
    BOOL mqPlanaResults = [YSUtility checkDatabaseSystemSn:MQInfomanagement andModuleSn:MQPlanManagementModel andCompanyId:MQcompanyId andPermissionValue:PermissionQueryValue];
    
//    if (!mqResults) {
//        [self.dataSourceArray removeApplicationWithIds:@[@"0"]];
//    }
//    if (!mqPlanaResults) {
//       [self.dataSourceArray removeApplicationWithIds:@[@"1"]];
//   }

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
