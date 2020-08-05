//
//  YSHRMyPerformanceController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMyPerformanceController.h"
#import "YSHRPerformanceGradeController.h"
#import "YSHRPerformanceRewardController.h"
@interface YSHRMyPerformanceController ()
@property (nonatomic,strong) NSArray *viewControllerArray;
@property (nonatomic,strong) NSArray *subTitles;
@end

@implementation YSHRMyPerformanceController

- (NSArray *)viewControllerArray {
    if (!_viewControllerArray) {
        YSHRPerformanceGradeController *gradeVC = [[YSHRPerformanceGradeController alloc] initWithStyle:UITableViewStyleGrouped];
        YSHRPerformanceRewardController *rewardVC = [[YSHRPerformanceRewardController alloc] initWithStyle:UITableViewStyleGrouped];
     
        
        _viewControllerArray = @[gradeVC, rewardVC];
    }
    return _viewControllerArray;
}
- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"等级",@"简历"];
    }
    return _subTitles;
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH / 2 - 15*kWidthScale;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的绩效";
    
}
#pragma mark - wmpageView 代理方法
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewControllerArray.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    return self.viewControllerArray[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.subTitles[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0,0, kSCREEN_WIDTH, 40*kHeightScale);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-80*kHeightScale);
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
