//
//  YSTrackingPageViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/12/26.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSTrackingPageViewController.h"
#import "YSTrackingInfoViewController.h"
#import "YSTrackingOtherInfoViewController.h"

@interface YSTrackingPageViewController ()
@property (nonatomic,strong) NSArray *subViewControllers;
@property (nonatomic,strong) NSArray *subTitles;
@end

@implementation YSTrackingPageViewController
- (NSArray *)subViewControllers {
    if (!_subViewControllers) {
        YSTrackingInfoViewController *autotrophyInfoListViewController = [[YSTrackingInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
        autotrophyInfoListViewController.id = self.id;
       YSTrackingOtherInfoViewController *checkInfoListViewController = [[YSTrackingOtherInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
        checkInfoListViewController.id = self.id;
        _subViewControllers = @[autotrophyInfoListViewController, checkInfoListViewController];
    }
    return _subViewControllers;
}
- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"报备/评估详情", @"其他信息"];
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
    self.title = @"报备/评估详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"附件" position:QMUINavigationButtonPositionRight target:self action:@selector(attachment)];
}
- (void)attachment {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"attachment" object:nil userInfo:nil];
}
#pragma mark - wmPageView 代理方法
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.subViewControllers.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.subViewControllers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.subTitles[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 0, kSCREEN_WIDTH, 40*kHeightScale);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-50*kHeightScale);
}
- (void)dealloc {
    DLog(@"释放");
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
