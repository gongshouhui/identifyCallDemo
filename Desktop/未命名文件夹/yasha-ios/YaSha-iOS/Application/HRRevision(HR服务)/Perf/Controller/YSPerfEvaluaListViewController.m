//
//  YSPerfEvaluaListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/19.
//

#import "YSPerfEvaluaListViewController.h"
#import "YSPerfEvaluaListCell.h"
#import "YSPerfInfoViewController.h"

@interface YSPerfEvaluaListViewController ()

@end

@implementation YSPerfEvaluaListViewController

static NSString *cellIdentifier = @"PerfEvaluaListCell";

- (void)viewWillAppear:(BOOL)animated {
    [self doNetworking];
}
- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSPerfEvaluaListCell class] forCellReuseIdentifier:cellIdentifier];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, _perfEvaluaType == PerfSelfEvalua ? planPersonSocoreListApi : getReEvaluationListApi, self.pageNumber];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"绩效评估列表:%@", response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getPerfEvaluaListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getPerfEvaluaListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPerfEvaluaListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSPerfEvaluaListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSPerfEvaluaListModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel andIndexPath:_perfEvaluaType];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPerfEvaluaListModel *cellModel = self.dataSourceArray[indexPath.row];
    YSPerfInfoViewController *perfInfoViewController = [[YSPerfInfoViewController alloc] init];
    perfInfoViewController.perfInfoType = _perfEvaluaType == PerfSelfEvalua ? PerfSelfEvaluaInfoType : PerfReEvaluaInfoType;
    perfInfoViewController.evaluaListModel = cellModel;
    [self.navigationController pushViewController:perfInfoViewController animated:YES];
}

@end
