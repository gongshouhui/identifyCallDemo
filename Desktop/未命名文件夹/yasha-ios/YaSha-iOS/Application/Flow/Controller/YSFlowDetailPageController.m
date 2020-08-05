//
//  YSFlowDetailPageController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import "YSFlowDetailPageController.h"
#import "YSFlowFormListViewController.h"
#import "YSFlowMapViewController.h"
#import "YSFlowRecordPageController.h"
#import "YSFlowCustomDetailController.h"

#import "YSCommonFlowFormListViewController.h"

// 业务表单
#import "YSFlowExpressFormListViewController.h"    // 顺丰

@interface YSFlowDetailPageController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *viewControllersArray;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation YSFlowDetailPageController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"表单", @"流程"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        if (_cellModel.processType == 1 || _cellModel.processType == 5) {
            //自定义
            YSFlowFormListViewController *flowFormListViewController = [[YSFlowFormListViewController alloc] init];
//            YSFlowDetailsViewController *flowFormListViewController = [[YSFlowDetailsViewController alloc] init];
            flowFormListViewController.cellModel = self.cellModel;
            DLog(@"=======%@",self.cellModel.processInstanceId);
            flowFormListViewController.flowType = _flowType;
            YSFlowMapViewController *flowMapViewController = [[YSFlowMapViewController alloc] init];
            flowMapViewController.urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getApplyMapByIdForMobileApi, _cellModel.processInstanceId];
            
            _viewControllersArray = @[flowFormListViewController, flowMapViewController];
//            _viewControllersArray = @[flowFormListViewController];
        } else {
            //业务流程
            Class someClass = NSClassFromString(_flowModel.className);
            YSCommonFlowFormListViewController *commonFlowFormListViewController = [[someClass alloc] init];
            commonFlowFormListViewController.cellModel = _cellModel;
            // 流程状态已发，已办，待办
            commonFlowFormListViewController.flowType = _flowType;
            YSFlowMapViewController *flowMapViewController = [[YSFlowMapViewController alloc] init];
            flowMapViewController.urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getApplyMapByIdForMobileApi, _cellModel.processInstanceId];
            _viewControllersArray = @[commonFlowFormListViewController, flowMapViewController];
        }
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
    self.title = @"流程详情";
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"处理记录" position:QMUINavigationButtonPositionRight target:self action:@selector(handleHistory)];
}

#pragma mark - 发起流程
- (void)handleHistory {
    YSFlowRecordPageController *flowRecordPageController = [[YSFlowRecordPageController alloc] init];
    flowRecordPageController.cellModel = _cellModel;
    [self.navigationController pushViewController:flowRecordPageController animated:YES];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewControllersArray.count;
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
    return CGRectMake(0, kMenuViewHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kMenuViewHeight - kTopHeight);
}

@end
