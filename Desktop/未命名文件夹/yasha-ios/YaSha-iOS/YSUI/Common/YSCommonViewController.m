//
//  YSCommonViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/10.
//

#import "YSCommonViewController.h"

@interface YSCommonViewController ()
@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> *sessionDataTaskMArr;
@end

@implementation YSCommonViewController

- (void)didInitialized {
    [super didInitialized];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeChangedNotification:) name:YSThemeChangedNotification object:nil];
}

- (void)handleThemeChangedNotification:(NSNotification *)notification {
    NSObject<YSThemeProtocol> *themeBeforeChanged = notification.userInfo[YSThemeBeforeChangedName];
    NSObject<YSThemeProtocol> *themeAfterChanged = notification.userInfo[YSThemeAfterChangedName];
    [self themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
}

#pragma mark - <YSChangingThemeDelegate>

- (void)themeBeforeChanged:(NSObject<YSThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<YSThemeProtocol> *)themeAfterChanged {
    
}
#pragma mark - 懒加载
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
- (NSMutableArray *)sessionDataTaskMArr {
    if (_sessionDataTaskMArr == nil) {
        _sessionDataTaskMArr = [NSMutableArray array];
    }
    return _sessionDataTaskMArr;
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    _pageNumber = 1;
    _dataSourceArray = [NSMutableArray array];
//    [self doNetworking];
}

- (void)doNetworking {
   // [QMUITips showLoadingInView:self.view];
}

- (void)ys_emptyView {
    [QMUITips hideAllToastInView:self.view animated:YES];
    [self hideEmptyView];
    
    [self showEmptyViewWithImage:UIImageMake(@"无数据") text:@"" detailText:@"" buttonTitle:@"点击重试" buttonAction:@selector(doNetworking)];
    
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
