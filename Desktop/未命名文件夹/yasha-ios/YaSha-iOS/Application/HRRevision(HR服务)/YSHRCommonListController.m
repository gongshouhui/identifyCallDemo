//
//  YSHRCommonListController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRCommonListController.h"

@interface YSHRCommonListController ()

@end

@implementation YSHRCommonListController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleView.titleLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage gradientImageWithBounds:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight) andColors:@[[UIColor colorWithHexString:@"#546AFD"],[UIColor colorWithHexString:@"#2EC1FF"]] andGradientType:1]  forBarMetrics:UIBarMetricsDefault];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
