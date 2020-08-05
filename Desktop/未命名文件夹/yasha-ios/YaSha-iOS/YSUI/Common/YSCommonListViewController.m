//
//  YSCommonListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//

#import "YSCommonListViewController.h"

@interface YSCommonListViewController ()<UISearchBarDelegate>


@property (nonatomic, strong) UIButton *filtButton;
//@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation YSCommonListViewController

- (void)didInitialized {
    [super didInitialized];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeChangedNotification:) name:YSThemeChangedNotification object:nil];
}

- (void)handleThemeChangedNotification:(NSNotification *)notification {
    NSObject<YSThemeProtocol> *themeBeforeChanged = notification.userInfo[YSThemeBeforeChangedName];
    themeBeforeChanged = [themeBeforeChanged isKindOfClass:[NSNull class]] ? nil : themeBeforeChanged;
    
    NSObject<YSThemeProtocol> *themeAfterChanged = notification.userInfo[YSThemeAfterChangedName];
    themeAfterChanged = [themeAfterChanged isKindOfClass:[NSNull class]] ? nil : themeAfterChanged;
    
    [self themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
}

#pragma mark - <YSChangingThemeDelegate>

- (void)themeBeforeChanged:(NSObject<YSThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<YSThemeProtocol> *)themeAfterChanged {
    [self.tableView reloadData];
}

- (void)initTableView {
    [super initTableView];
    // iOS 11下不想使用Self-Sizing的话，可以通过以下方式关闭，解决MJRefresh回弹
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
    // 滑动时搜索框隐藏
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    
    // 默认值
    _pageNumber = 1;
    _keyWord = @"";
    YSWeak;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        if (weakSelf.keyWord.length <= 0) {
            weakSelf.keyWord = @"";
            weakSelf.searchField.text = @"";
        }
        [weakSelf doNetworking];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNumber ++;
        [weakSelf doNetworking];
    }];
    footer.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    
    //[self doNetworking];
}

- (void)ys_reloadData {
    [QMUITips hideAllToastInView:self.view animated:YES];
    [self.tableView reloadData];
    if (self.dataSourceArray.count == 0 && self.dataSource.count == 0) {
        [QMUITips showLoadingInView:self.view hideAfterDelay:0.5];
        [self showEmptyViewWithImage:UIImageMake(@"无数据") text:@"" detailText:@"" buttonTitle:@"点击重试" buttonAction:@selector(doNetworking)];
    } else {
        [self hideEmptyView];
    }
}
- (void)ys_reloadDataWithImageName:(NSString *)imageName text:(NSString *)text {
    [QMUITips hideAllToastInView:self.view animated:YES];
    [self.tableView reloadData];
    if (imageName.length == 0) {
        imageName = @"无数据";
    }
    if (self.dataSourceArray.count == 0) {
        [self showEmptyViewWithImage:UIImageMake(imageName) text:text detailText:@"" buttonTitle:@"" buttonAction:@selector(doNetworking)];
    } else {
        [self hideEmptyView];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
}

- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
}

- (void)ys_showNetworkError {
    [QMUITips hideAllTipsInView:self.view];
    [QMUITips showLoadingInView:self.view hideAfterDelay:0.5];
    [self showEmptyViewWithImage:UIImageMake(@"404") text:@"请求失败" detailText:@"请检查网络连接" buttonTitle:@"点击重试" buttonAction:@selector(doNetworking)];
    self.emptyView.backgroundColor = [UIColor whiteColor];
}

- (BOOL)layoutEmptyView {
    [super layoutEmptyView];
    if (self.emptyView) {
        // 由于为self.emptyView设置frame时会调用到self.view，为了避免导致viewDidLoad提前触发，这里需要判断一下self.view是否已经被初始化
        BOOL viewDidLoad = self.emptyView.superview || [self isViewLoaded];
        if (viewDidLoad) {
            CGSize newEmptyViewSize = self.emptyView.superview.bounds.size;
            CGSize oldEmptyViewSize = self.emptyView.frame.size;
            if (!CGSizeEqualToSize(newEmptyViewSize, oldEmptyViewSize)) {
                self.emptyView.frame = CGRectMake(0, 40, kSCREEN_WIDTH, kSCREEN_HEIGHT);
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

#pragma mark - UISearchBarDelegateDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.pageNumber = 1;
    self.keyWord = searchBar.text;
    [self doNetworking];
}

- (BOOL)shouldHideSearchBarWhenEmptyViewShowing {
    return NO;
}

- (void)ys_shouldShowSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.barTintColor = [UIColor lightGrayColor];
    self.searchBar.placeholder = @"请输入关键词";
   
    if (@available(iOS 13.0, *)) {
        _searchField =_searchBar.searchTextField;
    }else {
		 // 通过 KVC 获取 UISearchBar 的私有变量 searchField，设置 UISearchBar 样式
        _searchField = [_searchBar valueForKey:@"_searchField"];
    }
    YSWeak;
    if (_searchField) {
        [[_searchField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
            weakSelf.keyWord = weakSelf.searchField.text;
            weakSelf.pageNumber = 1;
            [weakSelf doNetworking];
        }];
        [_searchField setBackgroundColor:[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1.00]];
        _searchField.layer.cornerRadius = 5.0f*kHeightScale;
        _searchField.layer.masksToBounds = YES;
   }
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(searchView);
    }];
    self.tableView.tableHeaderView = searchView;
}

- (void)ys_shouldShowSearchBaraAndScreening {
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    searchView.backgroundColor = [UIColor whiteColor];
    
    _filtButton = [[UIButton alloc] init];
    [_filtButton setTitle:@"筛选" forState:UIControlStateNormal];
    [_filtButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_filtButton addTarget:self action:@selector(monitorFiltButton) forControlEvents:UIControlEventTouchUpInside];
//    _filtButton.frame = CGRectMake(315, 0, 50, 40);
    [searchView addSubview:_filtButton];
    [_filtButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_top).offset(5);
        make.bottom.mas_equalTo(searchView.mas_bottom).offset(-5);
        make.right.mas_equalTo(searchView.mas_right).offset(-2);
        make.width.mas_equalTo(60*kWidthScale);
    }];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.barTintColor = [UIColor whiteColor];
//    searchBar.frame = CGRectMake(10, 0, 300, 40);
    self.searchBar.placeholder = @"请输入关键词";
   
    if (@available(iOS 13.0, *)) {
        _searchField =_searchBar.searchTextField;
    }else {
		 // 通过 KVC 获取 UISearchBar 的私有变量 searchField，设置 UISearchBar 样式
        _searchField = [_searchBar valueForKey:@"_searchField"];
    }
    YSWeak;
    
    if (_searchField) {
        [[_searchField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
            weakSelf.keyWord = weakSelf.searchField.text;
            weakSelf.pageNumber = 1;
            [weakSelf doNetworking];
        }];
        [_searchField setBackgroundColor:[UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1.00]];
        _searchField.layer.cornerRadius = 5.0f*kHeightScale;
        _searchField.layer.masksToBounds = YES;
    }
    [searchView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_top).offset(5);
        make.left.mas_equalTo(searchView.mas_left).offset(15);
        make.bottom.mas_equalTo(searchView.mas_bottom).offset(-5);
        make.right.mas_equalTo(_filtButton.mas_left).offset(-5);
    }];
   
    
    self.tableView.tableHeaderView = searchView;
}

- (void)monitorFiltButton {
    
}

- (void)hideMJRefresh {
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
