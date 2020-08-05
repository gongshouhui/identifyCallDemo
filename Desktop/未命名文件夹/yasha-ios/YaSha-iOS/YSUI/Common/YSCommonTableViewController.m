//
//  YSCommonTableViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/7.
//

#import "YSCommonTableViewController.h"

@interface YSCommonTableViewController ()
@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> *sessionDataTaskMArr;
@end

@implementation YSCommonTableViewController

- (void)didInitializedWithStyle:(UITableViewStyle)style {
    [super didInitializedWithStyle:UITableViewStyleGrouped];
}

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
#pragma mark - 懒加载
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[];
    }
    return _dataSource;
}
- (NSMutableArray *)sessionDataTaskMArr {
    if (_sessionDataTaskMArr == nil) {
        _sessionDataTaskMArr = [NSMutableArray array];
    }
    return _sessionDataTaskMArr;
}
- (void)initTableView {
    [super initTableView];
    // iOS 11下不想使用Self-Sizing的话，可以通过以下方式关闭，解决MJRefresh回弹
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    }
}
// 获取员工信息的工号职级
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    
}

- (void)ys_reloadData {
    [QMUITips hideAllToastInView:self.view animated:YES];
    [self.tableView reloadData];
    if (self.dataSource.count == 0 && self.dataSourceArray.count == 0) {
        [self showEmptyViewWithImage:UIImageMake(@"无数据") text:@"" detailText:@"" buttonTitle:@"点击重试" buttonAction:@selector(doNetworking)];
    } else {
        [self hideEmptyView];
    }
}

- (void)ys_showNetworkError {
    [QMUITips hideAllToastInView:self.view animated:YES];
    [self showEmptyViewWithText:@"请求失败" detailText:@"请检查网络连接" buttonTitle:@"重试" buttonAction:@selector(doNetworking)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
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

#pragma mark -- 网络请求管理
- (void)addSessionDataTask:(NSURLSessionDataTask *)task {
    if (task == nil) {
        return;
    }
    [self.sessionDataTaskMArr addObject:task];
}

- (void)removeSessionDataTask:(NSURLSessionDataTask *)task {
    [self.sessionDataTaskMArr removeObject:task];
}

- (void)cancelAllSessionDataTask {
    if (self.sessionDataTaskMArr.count <= 0) {
        return;
    }
    for (NSURLSessionDataTask *dataTask in self.sessionDataTaskMArr) {
        if (dataTask.state == NSURLSessionTaskStateRunning || dataTask.state == NSURLSessionTaskStateSuspended ) {
            [dataTask cancel];
        }
    }
    [self.sessionDataTaskMArr removeAllObjects];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
