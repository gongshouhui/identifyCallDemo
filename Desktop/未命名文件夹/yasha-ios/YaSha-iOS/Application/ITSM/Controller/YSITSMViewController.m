//
//  YSITSMViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/6/21.
//
//

#import "YSITSMViewController.h"
#import "YSITSMUntreatedViewController.h"
#import "YSITSMProcessedViewController.h"
#import "YSPMSPlanSearchView.h"

@interface YSITSMViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) YSPMSPlanSearchView *PlanSearchView;


@end

@implementation YSITSMViewController

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH / 4 - 15*kWidthScale;
    }
    
    return self;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 40*kWidthScale, kSCREEN_WIDTH, 40*kHeightScale);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 80*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-80*kHeightScale);
}

- (void)viewDidLoad {
    _titleArray = @[@"待处理", @"已完成"];
    self.title = @"历史记录";
    _PlanSearchView = [[YSPMSPlanSearchView alloc] init];
    [self.view addSubview:_PlanSearchView];
    [_PlanSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(40*kHeightScale);
    }];
    [self monitorSearchBar];
    [super viewDidLoad];
    
}

/** 监控搜索框 */
- (void)monitorSearchBar {
    [_PlanSearchView.searchSubject subscribeNext:^(NSString *searchString) {
        DLog(@"searchString:%@", searchString);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchITSM" object:nil userInfo:@{@"name": searchString}];
    }];
}
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return _titleArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController
               viewControllerAtIndex:(NSInteger)index {
    YSITSMUntreatedViewController *untreatedViewController = [[YSITSMUntreatedViewController alloc] initWithStyle:UITableViewStyleGrouped];
    YSITSMProcessedViewController *processedViewController = [[YSITSMProcessedViewController alloc] initWithStyle:UITableViewStyleGrouped];
    NSArray *viewControllers = @[untreatedViewController, processedViewController];
    return viewControllers[index];
}

- (NSString *)pageController:(WMPageController *)pageController
               titleAtIndex:(NSInteger)index {
    self.pageIndex = index;
    return _titleArray[index];
}



@end
