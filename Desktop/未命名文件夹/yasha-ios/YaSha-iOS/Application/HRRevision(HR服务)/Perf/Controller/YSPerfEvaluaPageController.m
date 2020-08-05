//
//  YSPerfEvaluaPageController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/19.
//

#import "YSPerfEvaluaPageController.h"
#import "YSPerfEvaluaListViewController.h"

@interface YSPerfEvaluaPageController ()

@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *viewControllersArray;

@end

@implementation YSPerfEvaluaPageController

- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"自评", @"复评"];
    }
    return _titlesArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        YSPerfEvaluaListViewController *perfSelfEvaluaListViewController = [[YSPerfEvaluaListViewController alloc] init];
        perfSelfEvaluaListViewController.perfEvaluaType = PerfSelfEvalua;
        YSPerfEvaluaListViewController *perfReEvaluaListViewController = [[YSPerfEvaluaListViewController alloc] init];
        perfReEvaluaListViewController.perfEvaluaType = PerfReEvalua;
        _viewControllersArray = @[perfSelfEvaluaListViewController, perfReEvaluaListViewController];
    }
    return _viewControllersArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH / 3 - 15*kWidthScale;
    }
    return self;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 0, kSCREEN_WIDTH, 40*kHeightScale);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale);
}

- (void)viewDidLoad {
    [self titlesArray];
    [self viewControllersArray];
    self.title = @"绩效评估";
    [super viewDidLoad];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return _titlesArray.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return _viewControllersArray[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return _titlesArray[index];
}

@end
