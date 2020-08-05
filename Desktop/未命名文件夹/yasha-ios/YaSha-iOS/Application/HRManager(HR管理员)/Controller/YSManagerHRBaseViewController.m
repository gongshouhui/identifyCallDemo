//
//  YSManagerHRBaseViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSManagerHRBaseViewController.h"
#import "UIView+Extension.h"

@interface YSManagerHRBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *btn_search;
@property (nonatomic, strong) UIButton *btn_screen;


@end

@implementation YSManagerHRBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 箭头
//    self.navigationItem.leftBarButtonItem = [self lt_customBackItemWithTarget:self action:@selector(temaBack) withImgName:@"managerHRBackL"];
    [self hideMJRefresh];
    YSWeak;
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        YSStrong;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf refershTeamDataWithType:(RefreshStateTypeHeader)];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        YSStrong;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf refershTeamDataWithType:(RefreshStateTypeFooter)];
    }];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tapGesture.delegate = self;
    tapGesture.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:tapGesture];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 输出点击的view的类名
    DLog(@"输出=%@", NSStringFromClass([touch.view.superview class]));
    if ([NSStringFromClass([touch.view.superview class]) containsString:@"Cell"]) {
        
        return NO;
    }
    /*
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString:@"YSApplicationCell"]) {
        
        return NO;
    }*/
    return YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setNaviView];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)setNaviView {
    [self.view addSubview:self.navView];
}

- (void)initTableView {
    [super initTableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }


}

- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kTopHeight-kBottomHeight);
}

- (void)ys_showManagerSearchBar {
    if (self.navigationController.navigationBar.isHidden) {
        self.btn_search.hidden = NO;
    }else {
    
        self.navigationItem.rightBarButtonItem = [self lt_customBackItemWithTarget:self action:@selector(clickedSeachBarAction) withImgName:@"searchYSHG"];
    }
}
- (void)ys_showManagerScreenBar {
    if (self.navigationController.navigationBar.isHidden) {
        self.btn_search.hidden = NO;
        self.btn_screen.hidden = NO;
    }else {
    
        self.navigationItem.rightBarButtonItems = @[[self lt_customBackItemWithTarget:self action:@selector(clickedSeachBarAction) withImgName:@"searchYSHG"], [self lt_customBackItemWithTarget:self action:@selector(clickedScreenBarAction) withImgName:@"screenYSHGR"]];
    }
}

// 刷新数据
- (void)refershTeamDataWithType:(RefreshStateType)type {
    
    
}

- (void)ys_reloadData {
    [QMUITips hideAllToastInView:self.view animated:YES];
    [self.tableView reloadData];
    if (self.dataSourceArray.count == 0 && self.dataSource.count == 0) {
        [QMUITips showLoadingInView:self.view hideAfterDelay:0.5];
        [self showEmptyViewWithImage:UIImageMake(@"无数据") text:@"" detailText:@"" buttonTitle:@"点击重试" buttonAction:@selector(networkNewData)];
    } else {
        [self hideEmptyView];
    }
}

- (void)networkNewData {
    [self refershTeamDataWithType:(RefreshStateTypeHeader)];
}

#pragma mark--配置导航条
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kTopHeight)];
        [_navView setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(10*kWidthScale, 2*kHeightScale+kStatusBarHeight, 28*kWidthScale, 38*kHeightScale);
        [btn setImage:[UIImage imageNamed:@"返回白"] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeCenter;
        [btn addTarget:self action:@selector(temaBack) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:btn];
        
        _navTitleLabe = [[UILabel alloc]initWithFrame:CGRectMake(90*kWidthScale, kStatusBarHeight+11*kHeightScale, 195*kWidthScale, 22*kHeightScale)];
        _navTitleLabe.text = self.titleView.titleLabel.text;
        _navTitleLabe.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)];
        _navTitleLabe.textAlignment = NSTextAlignmentCenter;
        _navTitleLabe.textColor = [UIColor whiteColor];
        [_navView addSubview:_navTitleLabe];
        
        // 搜索按钮
        _btn_search = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btn_search setImage:[UIImage imageNamed:@"searchYSHG"] forState:(UIControlStateNormal)];
        [_btn_search addTarget:self action:@selector(clickedSeachBarAction) forControlEvents:(UIControlEventTouchUpInside)];
        _btn_search.hidden = YES;
        [_navView addSubview:_btn_search];
        [_btn_search mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kHeightScale));
            make.right.mas_equalTo(-16*kWidthScale);
            make.top.mas_equalTo(6*kHeightScale+kStatusBarHeight);
        }];
        
        _btn_screen = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _btn_screen.hidden = YES;
        [_btn_screen setImage:[UIImage imageNamed:@"screenYSHGR"] forState:(UIControlStateNormal)];
        [_btn_screen addTarget:self action:@selector(clickedScreenBarAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:_btn_screen];
        [_btn_screen mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kHeightScale));
            make.right.mas_equalTo(_btn_search.mas_left).offset(-15*kWidthScale);
            make.top.mas_equalTo(6*kHeightScale+kStatusBarHeight);
        }];
    }
    return _navView;
}
// 点击导航条上搜索按钮
- (void)clickedSeachBarAction {
}

// 点击导航条上组织筛选按钮
- (void)clickedScreenBarAction {
    
}
- (void)temaBack {
   // [YSNetManager ys_cancelAllRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)lt_customBackItemWithTarget:(id)target action:(SEL)action withImgName:(NSString*)imgName{
    UIImage *image =UIImageMake(imgName) ;
    UIImage *backImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:target action:action];
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
