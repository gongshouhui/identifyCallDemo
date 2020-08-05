//
//  YSAttendanceNewPageController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/9.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAttendanceNewPageController.h"
#import "YSSummaryViewController.h"  //汇总
#import "YSClockTimeViewController.h"  //打卡时间
#import "YSAttendanceViewController.h"  //考勤

@interface YSAttendanceNewPageController ()
@property (nonatomic,strong) NSArray *subViewControllers;
@property (nonatomic,strong) NSArray *subTitles;
@end

@implementation YSAttendanceNewPageController
- (NSArray *)subViewControllers {
    if (!_subViewControllers) {
        YSSummaryViewController *summaryViewController = [[YSSummaryViewController alloc]init];
        summaryViewController.teamDic = self.teamDic;
        YSAttendanceViewController *attendanceViewController = [[YSAttendanceViewController alloc]init];
        attendanceViewController.teamDic = self.teamDic;
        YSClockTimeViewController *clockTimeViewController = [[YSClockTimeViewController alloc]init];
        clockTimeViewController.teamDic = self.teamDic;
        _subViewControllers = @[summaryViewController,attendanceViewController,clockTimeViewController];
    }
    return _subViewControllers;
}
- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"汇总", @"记录",@"打卡时间"];
    }
    return _subTitles;
}
- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH / 3 - 15*kWidthScale;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的考勤";
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.teamDic) {
        // 非团队跳转进来的 要首先显示记录页面
        self.selectIndex = 1;
    }
    //修改滚动条宽度
    self.progressWidth = kSCREEN_WIDTH/3+8;
    
    // 修改menu标题属性
    [self changeMenuTitleWithStr:@"汇总" withIndex:0];
    [self changeMenuTitleWithStr:@"记录" withIndex:1];
    [self changeMenuTitleWithStr:@"打卡时间" withIndex:2];
    @weakify(self);
   
    // 汇总页面 迟到早退 跳转 打卡时间页面
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"YSJumpClockTimeVC" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.selectIndex = 2;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YSChoseClockTime" object:nil userInfo:x.userInfo];
    }];
    // 汇总页面 旷工 跳转 记录
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"YSAttendanceVC" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.selectIndex = 1;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YSJumpAttendanceDetail" object:nil userInfo:x.userInfo];
        });

    }];
}
#pragma mark - wmPageView 代理方法
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
    menuView.backgroundColor = [UIColor whiteColor];
    return CGRectMake(0, 0, kSCREEN_WIDTH, 40*kHeightScale);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale-kBottomHeight-kTopHeight);
}

// 修改 menu标题属性
- (void)changeMenuTitleWithStr:(NSString*)titleStr withIndex:(NSInteger)index {
    YSWeak;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)]}];
    [weakSelf updateAttributeTitle:attributedString atIndex:index];
}

- (void)dealloc {
    DLog(@"释放");
}
@end
