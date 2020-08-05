//
//  YSAssetsPageController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import "YSAssetsPageController.h"
#import "YSAssetsListViewController.h"

@interface YSAssetsPageController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation YSAssetsPageController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"资产盘点"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"资产盘点"];
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH / 2 - 15*kWidthScale;
    }
    return self;
}



- (void)viewDidLoad {
    
    _dataArray = @[@"盘点清册", @"盘点记录"];
    self.title = @"资产盘点";
    
    [super viewDidLoad];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return _dataArray.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    YSAssetsListViewController *assetsDealingListViewController = [[YSAssetsListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    assetsDealingListViewController.assetsListType = AssetsListDealing;
    YSAssetsListViewController *assetsFinishListViewController = [[YSAssetsListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    assetsFinishListViewController.assetsListType = AssetsListFinish;
    NSArray *viewControllers = @[assetsDealingListViewController, assetsFinishListViewController];
    
    return viewControllers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return _dataArray[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 0, kSCREEN_WIDTH, kMenuViewHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, kMenuViewHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kMenuViewHeight);
}
@end
