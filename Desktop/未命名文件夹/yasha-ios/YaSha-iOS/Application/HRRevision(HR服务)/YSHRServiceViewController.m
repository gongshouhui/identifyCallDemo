//
//  YSHRServiceViewController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRServiceViewController.h"
#import "YSAttendanceViewController.h"    // 考勤
#import "YSPerfFunctionViewController.h"    // 绩效
#import "YSSalaryLoginController.h"//工资登录
#import "YSHRInfoSelfHelpController.h"//信息自助
#import "YSSummaryViewController.h"
#import "YSAttendanceNewPageController.h" // 考勤
#import "YSWYQYManager.h"
//#import "QYSDK.h"
#import "YSApplicationCell.h"
#import "YSHRManaHomeGViewController.h" //我的团队
@interface YSHRServiceViewController ()<UIGestureRecognizerDelegate>

@end

@implementation YSHRServiceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"HR服务"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"HR服务"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HR服务";

    [self getDatasourceArray];
//    [self doNetworking];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tapGesture.delegate = self;
    tapGesture.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:tapGesture];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    DLog(@"输出=%@", NSStringFromClass([touch.view.superview class]));
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"YSApplicationCell"]) {
        return NO;
    }
    return YES;
    
}

- (void)getDatasourceArray {
    [self.dataSourceArray addObjectsFromArray:[YSDataManager getApplicationsData:@[
                                                                                           @{@"id": @"0",
                                                                                           @"name": @"考勤记录",
                                                                                           @"imageName": @"hr_check_Gicon",
                                                                                           @"className": @"YSAttendanceRecordGZLNViewController"},
//        @{@"id":@"0",
//          @"name":@"我的考勤",                      @"imageName":@"hr_check_Gicon_history",
//          @"className": @"YSAttendanceNewPageController"},
        @{@"id": @"1",
          @"name": @"我的绩效",
          @"imageName": @"hr_perfor_Gicon",
          @"className": @"YSPerfFunctionViewController"},
//        @{@"id": @"2",
//          @"name": @"我的培训",
//          @"imageName": @"hr_training_Gicon",
//          @"className": @"YSHRMyTrainController"},
        
        @{@"id":@"2",
          @"name":@"薪资条",                      @"imageName":@"hr_pay_Gicon",
          @"className": @"YSSalaryLoginController"},
        
        
        @{@"id":@"3",
          @"name":@"自助服务",                      @"imageName":@"hr_Help_Gicon",
          @"className": @"YSSelfHelpViewController"},
        @{@"id":@"4",
          @"name":@"年终奖",                      @"imageName":@"ico-年终奖",
          @"className": @"YSYearSakaryLoginController"},
        
//                                                                @{@"id":@"6",
//                                                                     @"name":@"历史考勤",                      @"imageName":@"hr_check_Gicon_history",
//                                                                @"className": @"YSAttendanceNewPageController"},
    ]]];
    
    
    
    self.imageName = @"HR";
    [self.collectionView reloadData];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    YSApplicationModel *cellModel = self.dataSourceArray[indexPath.row];
    cell.hrIconModel = cellModel;
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSApplicationModel *model = self.dataSourceArray[indexPath.row];
        Class someClass = NSClassFromString(model.className);
        UIViewController *viewController = [[someClass alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
  
}
/*
#pragma mark--我的团队相关
- (void)doNetworking {

    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, checkLeader] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"是否是领导:%@", response);
        if (1 == [[response objectForKey:@"code"] integerValue]) {
            if (1 == [[[response objectForKey:@"data"] objectForKey:@"isLeader"] integerValue]) {
                UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
                rightBtn.frame = CGRectMake(0, 0, 60, 44);
                [rightBtn setTitleColor:[[UIColor darkTextColor] colorWithAlphaComponent:0.7] forState:(UIControlStateNormal)];
                [rightBtn setTitle:@"我的团队" forState:(UIControlStateNormal)];
                rightBtn.titleLabel.font = [UIFont systemFontOfSize:Multiply(15)];
                [rightBtn addTarget:self action:@selector(clickedMyTeamAction) forControlEvents:(UIControlEventTouchUpInside)];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
            }
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];

}
// 点击我的团队
- (void)clickedMyTeamAction {
    YSHRManaHomeGViewController *managerVC = [[YSHRManaHomeGViewController alloc] init];
    [self.navigationController pushViewController:managerVC animated:YES];
}
*/

@end
