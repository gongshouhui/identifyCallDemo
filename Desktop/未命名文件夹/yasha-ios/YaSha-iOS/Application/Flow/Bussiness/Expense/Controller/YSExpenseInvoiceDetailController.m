//
//  YSExpenseInvoiceDetailController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseInvoiceDetailController.h"
#import "YSExpenseInfoController.h"
#import "YSExpenseInvoiceBaseInfoController.h"
@interface YSExpenseInvoiceDetailController ()
@property (nonatomic,strong) NSMutableArray *subViewControllers;
@property (nonatomic,strong) NSArray *subTitles;
@end

@implementation YSExpenseInvoiceDetailController
- (NSArray *)subViewControllers {
    if (!_subViewControllers) {
        _subViewControllers = [NSMutableArray array];
        YSExpenseInvoiceBaseInfoController *vc = [[YSExpenseInvoiceBaseInfoController alloc]init];
        vc.detailID = self.detailID;
        YSExpenseInfoController *otherVC = [[YSExpenseInfoController alloc]init];
        otherVC.detailID = self.detailID;
        [_subViewControllers addObject:vc];
        [_subViewControllers addObject:otherVC];
        
    }
    return _subViewControllers;
}
- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"基本信息",@"费用信息"];
    }
    return _subTitles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票详情";
    // Do any additional setup after loading the view.
}
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
     return self.subViewControllers.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.subViewControllers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.subTitles[index];
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
