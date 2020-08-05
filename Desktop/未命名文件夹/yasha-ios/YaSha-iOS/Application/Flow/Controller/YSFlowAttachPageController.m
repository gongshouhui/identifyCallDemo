//
//  YSFlowAttachPageController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSFlowAttachPageController.h"
#import "YSFlowAttachListViewController.h"

@interface YSFlowAttachPageController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *viewControllersArray;

@end

@implementation YSFlowAttachPageController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"提交者附言", @"关联文档",@"关联流程"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        YSFlowAttachListViewController *flowAttachPSListViewController = [[YSFlowAttachListViewController alloc] init];
        flowAttachPSListViewController.flowAttachType = FlowAttachTypePS;
        flowAttachPSListViewController.cellModel = _cellModel;
        YSFlowAttachListViewController *flowAttachFileListViewController = [[YSFlowAttachListViewController alloc] init];
        flowAttachFileListViewController.flowAttachType = FlowAttachTypeFile;
        flowAttachFileListViewController.attachArray = _attachArray;
        flowAttachFileListViewController.cellModel = _cellModel;
        YSFlowAttachListViewController *flowAttachFlowListViewController = [[YSFlowAttachListViewController alloc] init];
        flowAttachFlowListViewController.flowAttachType = FlowAttachTypeFlow;
        flowAttachFlowListViewController.cellModel = _cellModel;
        _viewControllersArray = @[flowAttachPSListViewController, flowAttachFileListViewController, flowAttachFlowListViewController];
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
//    _titleArray = [self titleArray];
//    _viewControllersArray = [self viewControllersArray];
    [super viewDidLoad];
    self.title = @"流程附件";
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
