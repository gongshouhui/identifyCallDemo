//
//  YSEMSMyTripPageController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/14.
//

#import "YSEMSMyTripPageController.h"
#import "YSEMSMyTripListViewController.h"

@interface YSEMSMyTripPageController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *viewControllersArray;

@end

@implementation YSEMSMyTripPageController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"待审批", @"已审批", @"全部"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        YSEMSMyTripListViewController *EMSMyTripTodoListViewController = [[YSEMSMyTripListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        EMSMyTripTodoListViewController.EMSMyTripType = YSEMSMyTripTypeTodo;
        YSEMSMyTripListViewController *EMSMyTripDoneListViewController = [[YSEMSMyTripListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        EMSMyTripDoneListViewController.EMSMyTripType = YSEMSMyTripTypeDone;
        YSEMSMyTripListViewController *EMSMyTripAllListViewController = [[YSEMSMyTripListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        EMSMyTripAllListViewController.EMSMyTripType = YSEMSMyTripTypeAll;
        _viewControllersArray = @[EMSMyTripTodoListViewController, EMSMyTripDoneListViewController, EMSMyTripAllListViewController];
    }
    return _viewControllersArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = (kSCREEN_WIDTH-30) / 3.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的出差";
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

@end
