//
//  YSFlowPageController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import "YSFlowPageController.h"
#import "YSFlowListViewController.h"
#import "YSFlowLaunchListViewController.h"
#import "YSPMSInfoPageSearchView.h"

@interface YSFlowPageController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *viewControllersArray;
@property (nonatomic, strong) UILabel *todoNumLabel;
@property (nonatomic, strong) YSFlowListViewController *flowTodoListViewController;
@property (nonatomic, strong) YSFlowListViewController *flowFinishedListViewController;
@property (nonatomic, strong) YSFlowListViewController *flowSentListViewController;
@property (nonatomic, strong) YSPMSInfoPageSearchView *flowInfoPageSearchView;
@end

@implementation YSFlowPageController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"待办", @"已办", @"已发"];
    }
    return _titleArray;
}

- (NSArray *)viewControllersArray {
    if (!_viewControllersArray) {
        _flowTodoListViewController = [[YSFlowListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _flowTodoListViewController.flowType = YSFlowTypeTodo;
        _flowFinishedListViewController = [[YSFlowListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _flowFinishedListViewController.flowType = YSFlowTypeFinished;
        _flowSentListViewController = [[YSFlowListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _flowSentListViewController.flowType = YSFlowTypeSent;
        _viewControllersArray = @[_flowTodoListViewController, _flowFinishedListViewController, _flowSentListViewController];
    }
    return _viewControllersArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.menuItemWidth = (kSCREEN_WIDTH-30) / 3.0;
    }
    return self;
}

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"待办"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"待办"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"流程中心";
    
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"发起" position:QMUINavigationButtonPositionRight target:self action:@selector(launch)];
    
    //显示待办未处理数
    _todoNumLabel = [[UILabel alloc] init];
    _todoNumLabel.textAlignment = NSTextAlignmentCenter;
    _todoNumLabel.font = [UIFont boldSystemFontOfSize:12];
    _todoNumLabel.textColor = [UIColor whiteColor];
    _todoNumLabel.backgroundColor = kThemeColor;
    _todoNumLabel.layer.masksToBounds = YES;
    [self.view addSubview:_todoNumLabel];
    [_todoNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left).offset(15+(kSCREEN_WIDTH-30)/3.0/2);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTodoCount:) name:@"PostFlowTodoCount" object:nil];
     [self createSearchView];
}

- (void)createSearchView {
    _flowInfoPageSearchView = [[YSPMSInfoPageSearchView alloc] init];
    _flowInfoPageSearchView.searchBar.placeholder = @"请输入项目名称...";
    _flowInfoPageSearchView.searchBar.delegate = self;
    [self.view addSubview:_flowInfoPageSearchView];
    [_flowInfoPageSearchView.filtButton removeFromSuperview];

    [_flowInfoPageSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(40*kHeightScale);
    }];
    [_flowInfoPageSearchView.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_flowInfoPageSearchView.mas_top).offset(5);
        make.left.mas_equalTo(_flowInfoPageSearchView.mas_left).offset(15);
        make.bottom.mas_equalTo(_flowInfoPageSearchView.mas_bottom).offset(-5);
        make.right.mas_equalTo(_flowInfoPageSearchView.mas_right).offset(-15);
    }];
}
#pragma mark - 搜索视图代理回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"searchFlow" object:nil userInfo:@{@"name": searchText}];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

- (void)launch {
    YSFlowLaunchListViewController *flowLaunchListViewController = [[YSFlowLaunchListViewController alloc] init];
    [self.navigationController pushViewController:flowLaunchListViewController animated:YES];
}

- (void)updateTodoCount:(NSNotification *)notifacation {
    NSDictionary *userInfo = notifacation.userInfo;
    NSInteger total = [userInfo[@"total"] integerValue];
    if (total > 99) {
        _todoNumLabel.text = @"99+";
        _todoNumLabel.font = [UIFont systemFontOfSize:8];
    } else {
        _todoNumLabel.text = [NSString stringWithFormat:@"%zd", total];
        _todoNumLabel.font = [UIFont systemFontOfSize:10];
    }
    _todoNumLabel.layer.cornerRadius = 10*kWidthScale;
    [_todoNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(40*kHeightScale);
        make.left.mas_equalTo(self.view.mas_left).offset(15+(kSCREEN_WIDTH-30)/3.0/2);
        make.size.mas_equalTo(CGSizeMake(total == 0 ? 0 : 20*kWidthScale, total == 0 ? 0 : 20*kWidthScale));
    }];
    self.refreshBlock();//刷新工作台角标
   
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
    return CGRectMake(0, 40*kHeightScale, kSCREEN_WIDTH, kMenuViewHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, kMenuViewHeight+40*kHeightScale, kSCREEN_WIDTH, kSCREEN_HEIGHT-kMenuViewHeight-40*kHeightScale);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
