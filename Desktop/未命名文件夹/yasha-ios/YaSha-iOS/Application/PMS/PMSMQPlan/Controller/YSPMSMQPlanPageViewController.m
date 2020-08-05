//
//  YSPMSMQPlanPageViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/5.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQPlanPageViewController.h"
#import "YSPMSMQPlanInfoViewController.h"
#import "YSPMSMQEarilyPrePlanController.h"
#import "YSPMSMQConstructionPlanInfoViewController.h"
#import "YSPMSMQFinishingViewController.h"

@interface YSPMSMQPlanPageViewController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *viewControllersArray;
@end

@implementation YSPMSMQPlanPageViewController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"基本",@"前期",@"施工",@"收尾"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        //基本
        YSPMSMQPlanInfoViewController *basisPMSMQPlanInfoViewController = [[YSPMSMQPlanInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
        basisPMSMQPlanInfoViewController.refreshPlanListBlock = self.refreshPlanListBlock;
        basisPMSMQPlanInfoViewController.code = _model.code;
        basisPMSMQPlanInfoViewController.id = _model.id;
        basisPMSMQPlanInfoViewController.proManagerId = _model.proManagerId;
        basisPMSMQPlanInfoViewController.titleName = _model.proName;
        
        //前期
        YSPMSMQEarilyPrePlanController *earlyPMSMQPlanInfoViewController = [[YSPMSMQEarilyPrePlanController alloc]initWithStyle:UITableViewStyleGrouped];
        earlyPMSMQPlanInfoViewController.refreshPlanListBlock = self.refreshPlanListBlock;
        earlyPMSMQPlanInfoViewController.engineeringModel = _model;
        //施工
        YSPMSMQConstructionPlanInfoViewController *constructionPMSMQPlanInfoViewController = [[YSPMSMQConstructionPlanInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
        constructionPMSMQPlanInfoViewController.refreshPlanListBlock = self.refreshPlanListBlock;
        constructionPMSMQPlanInfoViewController.code = _model.code;
        constructionPMSMQPlanInfoViewController.id = _model.id;
        constructionPMSMQPlanInfoViewController.proManagerId = _model.proManagerId;
        constructionPMSMQPlanInfoViewController.titleName = _model.proName;
        
        //收尾
        YSPMSMQFinishingViewController *finishingPMSMQPlanInfoViewController = [[YSPMSMQFinishingViewController alloc]initWithStyle:UITableViewStyleGrouped];
        
        _viewControllersArray = @[basisPMSMQPlanInfoViewController,earlyPMSMQPlanInfoViewController,constructionPMSMQPlanInfoViewController,finishingPMSMQPlanInfoViewController];
    }
    return  _viewControllersArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = (kSCREEN_WIDTH-30)/4.0;
    }
    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _model.proName;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
