//
//  YSNewsPageController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/29.
//

#import "YSNewsPageController.h"
#import "YSNewsListViewController.h"

@interface YSNewsPageController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *viewControllersArray;

@end

@implementation YSNewsPageController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"公告", @"新闻"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        YSNewsListViewController *noticeListViewController = [[YSNewsListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        noticeListViewController.newsType = YSNewsTypeNotice;
       
        if (self.refreshBlock) {
            noticeListViewController.refreshBlock = self.refreshBlock;
        }
       
        YSNewsListViewController *newsListViewController = [[YSNewsListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        newsListViewController.newsType = YSNewsTypeNews;
        if (self.refreshBlock) {
            newsListViewController.refreshBlock = self.refreshBlock;
        }
        _viewControllersArray = @[noticeListViewController, newsListViewController];
    }
    return _viewControllersArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.scrollEnable = NO;
        self.titleColorSelected = [UIColor blackColor];
        self.titleColorNormal = [UIColor grayColor];
        self.menuItemWidth = 50*kWidthScale;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 18;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [TalkingData trackPageBegin:@"新闻公告"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"新闻公告"];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 45, kNavigationBarHeight)];
    YSWeak;
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    NSString *imageName = YSThemeManagerShare.currentTheme.themeNavColor == [UIColor whiteColor]?@"返回":@"返回白";
    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
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
    menuView.superview.backgroundColor = YSThemeManagerShare.currentTheme.themeNavColor;
    CGFloat leftMargin = 20;
    CGFloat originY = kStatusBarHeight;
    return CGRectMake(leftMargin, originY, kSCREEN_WIDTH - 2*leftMargin, kNavigationBarHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT);
}
- (void)dealloc {
    DLog(@"YSNewsPageController");
}
@end
