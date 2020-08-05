//
//  YSAssessmentViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/12/19.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAssessmentViewController.h"
#import "YSReportedViewController.h"
#import "YSTrackingViewController.h"

@interface YSAssessmentViewController ()

@end

@implementation YSAssessmentViewController
- (void)initSubviews {
    [super initSubviews];
    [self getDatasourceArray];
    self.title = @"CRM";
}
- (void)getDatasourceArray {
    BOOL reportResult = [YSUtility checkAuthoritySystemSn:@"crm" andModuleSn:@[@"pro_report_info"] andCompanyId:nil andPermissionValue:PermissionQueryValue];
    if (reportResult) {
        [self.dataSourceArray addObject:[YSApplicationModel yy_modelWithJSON:@{@"id": @"0",
                                                                               @"name": @"报备/评估",
                                                                               @"imageName": @"icon-评估报备",
                                                                               @"className": @"YSReportedViewController"}]];
    }
    
//    [self.dataSourceArray addObjectsFromArray:[YSDataManager getApplicationsData:@[@{@"id": @"0",
//                                                                                     @"name": @"报备/评估",
//                                                                                     @"imageName": @"icon-评估报备",
//                                                                                     @"className": @"YSReportedViewController"},

//                                                                                   @{@"id": @"1",
//                                                                                     @"name": @"项目跟踪",
//                                                                                     @"imageName": @"icon-跟踪",
//                                                                                     @"className": @"YSTrackingViewController"}


    self.imageName = @"banner-CRM";
    [self.collectionView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    Class someClass = NSClassFromString(model.className);
    UIViewController *viewController = [[someClass alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
