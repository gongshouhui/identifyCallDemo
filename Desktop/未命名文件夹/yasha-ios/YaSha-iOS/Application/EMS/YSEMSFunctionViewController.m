//
//  YSEMSFunctionViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSEMSFunctionViewController.h"
#import "YSEMSMyTripPageController.h"    // 我的出差
#import "YSEMSApplyTripViewController.h"    // 出差申请
#import "ShowAnimationView.h"
#import "YSEMSExpenseAccountController.h"
#import "YSEMSPettyCashController.h"
#import "YSEMSPublicExpenseController.h"

@interface YSEMSFunctionViewController ()


@end

@implementation YSEMSFunctionViewController

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"EMS";
}


- (void)initSubviews {
    
    [super initSubviews];
    [self getDatasourceArray];
    //    NSUserDefaults *userdefaults =[NSUserDefaults standardUserDefaults];
    //    BOOL isFirst = [userdefaults boolForKey:@"isFirst"];
    //    if (!isFirst){
    //        [self addShowView];
    //        [userdefaults setBool:YES forKey:@"isFirst"];
    //        [userdefaults synchronize];
    //    }
}

//- (void)addShowView {
//    ShowAnimationView *showView = [[ShowAnimationView alloc]init];
//    showView.frame = [UIScreen mainScreen].bounds;
//    [showView.enterSubject subscribeNext:^(NSString *str) {
//        DLog(@"========%@",str);
//        if ([str isEqualToString:@"back"]) {
//            [showView.bgView removeFromSuperview];
//            [showView removeFromSuperview];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{            
//            [showView.bgView removeFromSuperview];
//            [showView removeFromSuperview];
//        }
//    }];
//    [self.view addSubview:showView];
//}

- (void)getDatasourceArray {
    [self.dataSourceArray addObjectsFromArray:[YSDataManager getApplicationsData:@[
//                                               @{
//                                                                                       @"id": @"0",
//                                                                                       @"name": @"出差申请",
//                                                                                       @"imageName": @"出差申请",
//                                                                                       @"className": @"YSEMSApplyTripViewController"},
                                                                                   @{@"id": @"1",
                                                                                     @"name": @"我的出差",
                                                                                     @"imageName": @"我的出差",
                                                                                     @"className": @"YSEMSMyTripPageController"},
                                                                                   @{@"id": @"2",
                                                                                     @"name": @"我的报销单",
                                                                                     @"imageName": @"ico-我的报销单",
                                                                                     @"className": @"YSEMSExpenseAccountController"},
                                                                                   @{@"id": @"1",
                                                                                     @"name": @"对公报销",
                                                                                     @"imageName": @"ico-对公报销",
                                                                                     @"className": @"YSEMSPublicExpenseController"},
                                                                                   @{@"id": @"1",
                                                                                     @"name": @"备用金",
                                                                                     @"imageName": @"ico-备用金",
                                                                                     @"className": @"YSEMSPettyCashController"}
                                                                                   ]]];
    self.imageName = @"形状1";
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
    Class someClass = NSClassFromString(model.className);
    UIViewController *viewController = [[someClass alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
