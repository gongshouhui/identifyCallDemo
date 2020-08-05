//
//  YSHRCommonPageController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRCommonPageController.h"
#import "UIView+Extension.h"
@interface YSHRCommonPageController ()

@end

@implementation YSHRCommonPageController
- (instancetype)init {
    if (self = [super init]) {
        self.scrollEnable = NO;
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = [UIColor whiteColor];
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.progressColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.menuView setGradientBackgroundWithColors:@[[UIColor colorWithHexString:@"#546AFD"],[UIColor colorWithHexString:@"#2EC1FF"]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
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
