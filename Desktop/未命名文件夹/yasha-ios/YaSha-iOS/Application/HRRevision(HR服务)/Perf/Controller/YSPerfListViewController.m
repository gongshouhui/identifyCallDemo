//
//  YSPerfListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSPerfListViewController.h"
#import "YSPerfListCell.h"
#import "YSPerfInfoViewController.h"

@interface YSPerfListViewController ()

@property (nonatomic, strong) NSString *year;

@end

@implementation YSPerfListViewController

static NSString *cellIdentifier = @"PerfListCell";

- (void)initTableView {
    self.year = [NSString stringWithFormat:@"%zd", [[[NSDate date] dateByAddingHours:8] year]];
    [super initTableView];
    [self.tableView registerClass:[YSPerfListCell class] forCellReuseIdentifier:cellIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNetworkingWithNewYear:) name:@"selectPerfYear" object:nil];
    [self doNetworking];
}

/** 选择年份后重新获取数据 */
- (void)doNetworkingWithNewYear:(NSNotification *)notification {
    self.year = notification.userInfo[@"year"];
    self.pageNumber = 1;
    [self doNetworking];
}

/** 请求绩效列表 */
- (void)doNetworking {
    NSString *urlString;
    switch (self.perfType) {
        case MonthPerf:
        {
            urlString = [NSString stringWithFormat:@"%@%@/%@/40/%zd", YSDomain, getMyPerfInfoListApi, self.year, self.pageNumber];
            break;
        }
        case QtlyPerf:
        {
            urlString = [NSString stringWithFormat:@"%@%@/%@/30/%zd", YSDomain, getMyPerfInfoListApi, self.year, self.pageNumber];
            break;
        }
        case YearPerf:
        {
            urlString = [NSString stringWithFormat:@"%@%@/%@/10/%zd", YSDomain, getMyPerfInfoListApi, self.year, self.pageNumber];
            break;
        }
    }
    
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"====22222-------%@",response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getPerfListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getPerfListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        DLog(@"绩效列表:%@", response);
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPerfListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSPerfListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setCellModel:self.dataSourceArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPerfListModel *cellModel = self.dataSourceArray[indexPath.row];
    YSPerfInfoViewController *perfInfoViewController = [[YSPerfInfoViewController alloc] init];
    perfInfoViewController.perfInfoType = PerfNormalInfoType;
    perfInfoViewController.cellModel = cellModel;
    perfInfoViewController.perfType = _perfType;
    perfInfoViewController.year = _year;
    [self.navigationController pushViewController:perfInfoViewController animated:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
