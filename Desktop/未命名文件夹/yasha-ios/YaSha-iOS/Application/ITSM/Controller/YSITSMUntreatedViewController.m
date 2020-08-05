//
//  YSITSMUntreatedViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/4.
//

#import "YSITSMUntreatedViewController.h"
#import "YSProcessedTableViewCell.h"
#import "YSITSMUntreatedModel.h"
#import "YSReasonViewController.h"

@interface YSITSMUntreatedViewController ()<CYLTableViewPlaceHolderDelegate>

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSString *keyWords;
@property (nonatomic, strong) NSMutableDictionary *payload;

@end

@implementation YSITSMUntreatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.payload = [NSMutableDictionary dictionary];
    _pageNumber = 1;
    _dataSourceArray = [NSMutableArray array];
    _keyWords = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[YSProcessedTableViewCell class] forCellReuseIdentifier:@"ProcessedTableViewCell"];
  
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self doNetworking];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNumber ++;
        [self doNetworking];
    }];
   
    [self doNetworking];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAndFilter:) name:@"searchITSM" object:nil];
}

- (void)searchAndFilter:(NSNotification *)notification {
    
    for (int i = 0; i < notification.userInfo.allKeys.count; i ++) {
        DLog(@"======%@",notification.userInfo.allKeys[i]);
        [_payload setObject:notification.userInfo.allValues[i] forKey:notification.userInfo.allKeys[i]];
    }
    _pageNumber = 1;
    [self doNetworking];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, getFeedBackHistory, _pageNumber];
    [self.payload setObject:self.keyWord forKey:@"keyWords"];
    [self.payload setObject:@"undone" forKey:@"statusName"];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:_payload successBlock:^(id response) {
        DLog(@"获取待处理:%@", response);
        if (![response[@"data"] isEqual:[NSNull null]]) {
            if (_pageNumber == 1) {
                [_dataSourceArray removeAllObjects];
            }
            [_dataSourceArray addObjectsFromArray:[YSDataManager getAlllistData:response]];
            if (self.keyWord.length <= 0) {
                self.tableView.mj_footer.state = [YSDataManager getAlllistData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
                [self.tableView.mj_header endRefreshing];
            }
        }
        
        [self.tableView cyl_reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSProcessedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YSProcessedTableViewCell"];
    if (!cell) {
        cell = [[YSProcessedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcessedTableViewCell"];
    }
    YSITSMUntreatedModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    cell.lastButton.tag = indexPath.row;
    [[cell.lastButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YSReasonViewController *reasonViewController = [[YSReasonViewController alloc] init];
        reasonViewController.navigationItem.title = @"撤销请求";
        YSITSMUntreatedModel *cellModel = _dataSourceArray[indexPath.row];
        reasonViewController.eventId = cellModel.id;
        reasonViewController.type = @"0";
        [self.navigationController pushViewController:reasonViewController animated:YES];
        [reasonViewController setReturnBlock:^(BOOL reload) {
            [self.dataSourceArray removeObjectAtIndex:indexPath.row];
            [self.tableView cyl_reloadData];
        }];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSITSMUntreatedModel *cellModel = self.dataSourceArray[indexPath.row];
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", cellModel.tsUserMobilePhone];
    if (cellModel.tsUserMobilePhone.length > 0) {
        
    
        NSString *versionPhone = [[UIDevice currentDevice] systemVersion];
        if ([versionPhone compare:@"10.2"options:NSNumericSearch] ==NSOrderedDescending || [versionPhone compare:@"10.2"options:NSNumericSearch] ==NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{}completionHandler:nil];
        }else{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}

#pragma mark - CYLTableViewPlaceHolderDelegate

- (BOOL)enableScrollWhenPlaceHolderViewShowing {
    return YES;
}

- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
}

@end
