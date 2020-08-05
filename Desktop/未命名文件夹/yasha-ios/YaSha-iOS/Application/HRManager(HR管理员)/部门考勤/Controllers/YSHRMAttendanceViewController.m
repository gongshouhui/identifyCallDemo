//
//  YSHRMAttendanceViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMAttendanceViewController.h"
#import "YSHRMRecordViewController.h"//记录
#import "YSHRMSummaryViewController.h"//汇总
#import "YSHRMTimeListViewController.h"//打卡时间
#import "YSHRMTDeptTreeViewController.h"
#import "YSRightToLeftTransition.h"
#import "YSDeptTreePointModel.h"
#import "YSNetManagerCache.h"
#import "YSHRManagerSearchSGViewController.h"



@interface YSHRMAttendanceViewController ()
@property (nonatomic,strong) NSArray *subViewControllers;
@property (nonatomic,strong) NSArray *subTitles;
@property (nonatomic, strong) NSString *dateStr;

@end

@implementation YSHRMAttendanceViewController
- (NSArray *)subViewControllers {
    if (!_subViewControllers) {
        YSHRMSummaryViewController *summaryViewController = [[YSHRMSummaryViewController alloc]init];
        summaryViewController.deptId = self.deptId;
        summaryViewController.deptNameStr = self.deptNameStr;
        
        YSHRMRecordViewController *attendanceViewController = [[YSHRMRecordViewController alloc]init];
        attendanceViewController.deptId = self.deptId;
        attendanceViewController.deptNameStr = self.deptNameStr;
        
        YSHRMTimeListViewController *clockTimeViewController = [[YSHRMTimeListViewController alloc]init];
        clockTimeViewController.deptNameStr = self.deptNameStr;
        clockTimeViewController.deptId = self.deptId;
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
    self.title = @"部门考勤";
    self.view.backgroundColor = [UIColor whiteColor];
    //修改滚动条宽度
    self.progressWidth = kSCREEN_WIDTH/3+8;
    
    // 修改menu标题属性
    [self changeMenuTitleWithStr:@"汇总" withIndex:0];
    [self changeMenuTitleWithStr:@"记录" withIndex:1];
    [self changeMenuTitleWithStr:@"打卡时间" withIndex:2];
    
    self.navigationItem.rightBarButtonItems = @[[self lt_customBackItemWithTarget:self action:@selector(clickedScreenBarAction) withImgName:@"screenYSHGR"]];
    
    @weakify(self);
    // 汇总页面 月度统计 跳转 记录
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:[NSString stringWithFormat:@"YSHRTMonth%ldVCJump", self.navigationController.viewControllers.count] object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.selectIndex = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"YSHRTMonth%ldVCJumpDetail", self.navigationController.viewControllers.count] object:nil userInfo:x.userInfo];
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
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-40*kHeightScale-kTopHeight-kBottomHeight);
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    DLog(@"切换子控制的信息:%@", info);
    switch ([[info objectForKey:@"index"] integerValue]) {
        case 0:
            {//汇总页面
                
                self.navigationItem.rightBarButtonItems = @[[self lt_customBackItemWithTarget:self action:@selector(clickedScreenBarAction) withImgName:@"screenYSHGR"]];

            }
            break;
        case 1:
            {// 记录页面
                self.navigationItem.rightBarButtonItems = @[[self lt_customBackItemWithTarget:self action:@selector(clickedSeachBarAction) withImgName:@"searchYSHG"], [self lt_customBackItemWithTarget:self action:@selector(clickedScreenBarAction) withImgName:@"screenYSHGR"]];
                

            }
            break;
        case 2:
            {//打卡时间
                self.navigationItem.rightBarButtonItems = @[[self lt_customBackItemWithTarget:self action:@selector(clickedSeachBarAction) withImgName:@"searchYSHG"], [self lt_customBackItemWithTarget:self action:@selector(clickedScreenBarAction) withImgName:@"screenYSHGR"]];

            }
            break;
        default:
            break;
    }
}

// 修改 menu标题属性
- (void)changeMenuTitleWithStr:(NSString*)titleStr withIndex:(NSInteger)index {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)]}];
    [self updateAttributeTitle:attributedString atIndex:index];
}

// 导航条
- (UIBarButtonItem *)lt_customBackItemWithTarget:(id)target action:(SEL)action withImgName:(NSString*)imgName{
    UIImage *image =UIImageMake(imgName) ;
    UIImage *backImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:target action:action];
}
#pragma mark--导航条按钮
- (void)clickedSeachBarAction {
    YSHRManagerSearchSGViewController *searchVC = [YSHRManagerSearchSGViewController new];

    switch (self.selectIndex) {
        case 1:
            {//记录
                YSHRMRecordViewController *recordVC = self.subViewControllers[self.selectIndex];
                self.dateStr = recordVC.searchDateStr;
                searchVC.searchVCType = TeamHRSearchTypeAttendRecord;
            }
            break;
        case 2:
        {//打卡时间
            YSHRMTimeListViewController *listrVC = self.subViewControllers[self.selectIndex];
            self.dateStr = listrVC.searchDateStr;
            searchVC.searchVCType = TeamHRSearchTypeAttendList;
        }
            break;
        default:
            break;
    }
    
    searchVC.placeholderStr = @"请输入姓名/工号";
    searchVC.searchURLStr = getDepartmentPunchRecords;
    searchVC.searchParamStr = @"keyWord";
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.deptId forKey:@"deptId"];
    [paramDic setObject:self.dateStr forKey:@"dateStr"];
    searchVC.paramDic = paramDic;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)clickedScreenBarAction {
    
    NSDictionary *dataDic = [YSNetManagerCache ys_httpCacheWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getDeptTree] parameters:nil];
    if (0 == [[dataDic objectForKey:@"data"] count]) {
        [QMUITips showInfo:@"无部门可选" inView:self.view hideAfterDelay:0.5];
        return;
    }
    YSHRMTDeptTreeViewController *deptVC = [YSHRMTDeptTreeViewController new];
    deptVC.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    //    deptVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    // 自定义的模态动画
    deptVC.modalPresentationStyle = UIModalPresentationCustom;
    deptVC.transitioningDelegate = [YSRightToLeftTransition sharedYSTransition];
    
    deptVC.deptArray = [NSMutableArray arrayWithArray:[dataDic objectForKey:@"data"]];
    YSWeak;
    deptVC.choseDeptTreeBlock = ^(YSDeptTreePointModel * _Nonnull model) {
        // 对未加载的页面 更换部门id
        YSHRMRecordViewController *recordVC = (YSHRMRecordViewController*)weakSelf.subViewControllers[1];
        recordVC.deptId = model.point_id;
        
        YSHRMTimeListViewController *timeVC = (YSHRMTimeListViewController*)weakSelf.subViewControllers[2];
        timeVC.deptId = model.point_id;
        
        weakSelf.deptId = model.point_id;
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"choseSreenCompanyHR%ldVC", weakSelf.navigationController.viewControllers.count] object:nil userInfo:@{@"deptIds":model.point_id, @"deptName":model.point_name}];
    };
    [self presentViewController:deptVC animated:YES completion:nil];
}

- (void)dealloc {
    [YSNetManager ys_cancelAllRequest];
    DLog(@"释放");
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
