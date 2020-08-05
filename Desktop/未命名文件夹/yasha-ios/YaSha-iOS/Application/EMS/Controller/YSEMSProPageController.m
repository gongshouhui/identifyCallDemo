//
//  YSEMSProPageController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/2/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSEMSProPageController.h"
#import "YSEMSProListViewController.h"

@interface YSEMSProPageController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *viewControllersArray;

@end

@implementation YSEMSProPageController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"装饰",@"幕墙"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        YSEMSProListViewController *ZSEMSProListViewController = [[YSEMSProListViewController alloc]initWithStyle:UITableViewStyleGrouped];
        ZSEMSProListViewController.EMSProType = YSEMSProTypeZS;
		ZSEMSProListViewController.projectInfoBlock = self.projectInfoBlock;//block传递
        
        YSEMSProListViewController *MQEMSProListViewController = [[YSEMSProListViewController alloc]initWithStyle:UITableViewStyleGrouped];
        MQEMSProListViewController.EMSProType = YSEMSProTypeMQ;
        MQEMSProListViewController.projectInfoBlock = self.projectInfoBlock;//block传递
        _viewControllersArray = @[ZSEMSProListViewController,MQEMSProListViewController];
    }
    return _viewControllersArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = (kSCREEN_WIDTH-30) / 2.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择项目";
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewControllersArray[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titleArray[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, kSCREEN_WIDTH, kMenuViewHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, kMenuViewHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kMenuViewHeight);
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
