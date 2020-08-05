//
//  YSFlowRecordPageController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSFlowRecordPageController.h"
#import "YSFlowRecordListViewController.h"

@interface YSFlowRecordPageController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *viewControllersArray;

@end

@implementation YSFlowRecordPageController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"审批记录", @"转阅记录"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        YSFlowRecordListViewController *flowHandleRecordListViewController = [[YSFlowRecordListViewController alloc] init];
        flowHandleRecordListViewController.flowRecordType = FlowRecordTypeHandle;
        flowHandleRecordListViewController.cellModel = _cellModel;
        YSFlowRecordListViewController *flowTransRecordListViewController = [[YSFlowRecordListViewController alloc] init];
        flowTransRecordListViewController.flowRecordType = FlowRecordTypeTrans;
        flowTransRecordListViewController.cellModel = _cellModel;
        _viewControllersArray = @[flowHandleRecordListViewController, flowTransRecordListViewController];
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
    self.title = @"处理记录";
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
    return CGRectMake(0, 0, kSCREEN_WIDTH, 40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40, kSCREEN_WIDTH, kSCREEN_HEIGHT-40);
}

@end
