//
//  YSSupplyBidInvitingDetailController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/2.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSupplyBidInvitingDetailController.h"
#import "YSSupplyBidInvitingBaseInfoController.h"
#import "YSSupplyBidInvitingInfoController.h"
@interface YSSupplyBidInvitingDetailController ()
@property (nonatomic,strong) NSArray *viewControllersArray;
@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation YSSupplyBidInvitingDetailController
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"基本信息", @"投标信息"];
    }
    return _titleArray;
}
- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        YSSupplyBidInvitingBaseInfoController *baseInfoVC = [[YSSupplyBidInvitingBaseInfoController alloc]init];
        baseInfoVC.bidID = self.bidID;
        baseInfoVC.type = self.type;
        YSSupplyBidInvitingInfoController *bidInfoVC = [[YSSupplyBidInvitingInfoController alloc]init];
        bidInfoVC.bidID = self.bidID;
        _viewControllersArray = @[baseInfoVC,bidInfoVC];
    }
    return _viewControllersArray;
}
- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = (kSCREEN_WIDTH-30) / 3.0;
        [self titleArray];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"投标详情";
   
    
    // Do any additional setup after loading the view.
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return _titleArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    return self.viewControllersArray[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return _titleArray[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, kSCREEN_WIDTH, kMenuViewHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, kMenuViewHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kMenuViewHeight - kTopHeight);
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
