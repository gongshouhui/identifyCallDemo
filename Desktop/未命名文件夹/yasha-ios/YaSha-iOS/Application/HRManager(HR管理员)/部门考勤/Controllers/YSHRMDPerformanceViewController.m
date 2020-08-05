//
//  YSHRMDPerformanceViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMDPerformanceViewController.h"
#import "YSHRMDRewardViewController.h"
#import "YSHRMDPLevelViewController.h"
#import "YSHRMTDeptTreeViewController.h"
#import "YSRightToLeftTransition.h"
#import "YSDeptTreePointModel.h"
#import "YSNetManagerCache.h"
#import "YSHRManagerSearchSGViewController.h"

@interface YSHRMDPerformanceViewController ()
@property (nonatomic,strong) NSArray *subViewControllers;
@property (nonatomic,strong) NSArray *subTitles;
@property (nonatomic, copy) NSString *deptNameStr;

@end

@implementation YSHRMDPerformanceViewController

- (NSArray *)subViewControllers {
    if (!_subViewControllers) {
        YSHRMDPLevelViewController *levelViewController = [[YSHRMDPLevelViewController alloc]init];
        YSHRMDRewardViewController *rewardViewController = [[YSHRMDRewardViewController alloc]init];
        rewardViewController.deptNameStr = _deptNameStr;
        _subViewControllers = @[levelViewController,rewardViewController];
    }
    return _subViewControllers;
}
- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"绩效等级",@"奖励信息"];
    }
    return _subTitles;
}
- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = kSCREEN_WIDTH / 2 - 15*kWidthScale;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"部门绩效";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //修改滚动条宽度
    self.progressWidth = kSCREEN_WIDTH/2+8;
    
    // 修改menu标题属性
    [self changeMenuTitleWithStr:@"绩效等级" withIndex:0];
    [self changeMenuTitleWithStr:@"奖励信息" withIndex:1];
    
    self.navigationItem.rightBarButtonItems = @[[self lt_customBackItemWithTarget:self action:@selector(clickedSeachBarAction) withImgName:@"searchYSHG"], [self lt_customBackItemWithTarget:self action:@selector(clickedScreenBarAction) withImgName:@"screenYSHGR"]];
    
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
    switch ([[info objectForKey:@"index"] integerValue]) {
        case 0:
        {//绩效等级
            
            self.navigationItem.rightBarButtonItems = @[[self lt_customBackItemWithTarget:self action:@selector(clickedSeachBarAction) withImgName:@"searchYSHG"], [self lt_customBackItemWithTarget:self action:@selector(clickedScreenBarAction) withImgName:@"screenYSHGR"]];
            
        }
            break;
        case 1:
        {// 奖励信息
            self.navigationItem.rightBarButtonItems = nil;
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
#pragma mark--导航条按钮
// 导航条
- (UIBarButtonItem *)lt_customBackItemWithTarget:(id)target action:(SEL)action withImgName:(NSString*)imgName{
    UIImage *image =UIImageMake(imgName) ;
    UIImage *backImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:target action:action];
}
- (void)clickedSeachBarAction {
    //暂时只有绩效等级的功能 奖励信息还没有
    YSHRManagerSearchSGViewController *searchVC = [YSHRManagerSearchSGViewController new];
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    if (self.selectIndex == 0) {
        YSHRMDPLevelViewController *levelVC = self.subViewControllers[0];
        [paramDic setObject:levelVC.deptId forKey:@"queryDeptIds"];
        [paramDic setObject:levelVC.year forKey:@"year"];
        [paramDic setObject:@1 forKey:@"pageNumber"];
        searchVC.searchVCType = TeamHRSearchTypePerformance;
    }
    
    searchVC.placeholderStr = @"请输入姓名/工号";
    searchVC.searchURLStr = getDepartmentPerformanceInfo;
    searchVC.searchParamStr = @"keyWord";
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
        weakSelf.deptNameStr = model.point_name;
        // 对未加载的页面 更换部门名称
        YSHRMDRewardViewController *rewardVC = (YSHRMDRewardViewController*)weakSelf.subViewControllers[1];
        rewardVC.deptNameStr = model.point_name;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sreenDeptHRLevel" object:nil userInfo:@{@"deptIds":model.point_id, @"deptName":model.point_name}];
    };
    [self presentViewController:deptVC animated:YES completion:nil];
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
