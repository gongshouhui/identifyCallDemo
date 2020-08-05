//
//  YSPerfExamListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/20.
//

#import "YSPerfExamListViewController.h"
#import "YSPerfEvaluaListCell.h"
#import "YSPerfInfoViewController.h"

@interface YSPerfExamListViewController ()

@end

@implementation YSPerfExamListViewController

static NSString *cellIdentifier = @"PerfEvaluaListCell";

- (void)initTableView {
    [super initTableView];
    self.title = @"计划审核";
    [self ys_shouldShowSearchBar];
    [self.tableView registerClass:[YSPerfEvaluaListCell class] forCellReuseIdentifier:cellIdentifier];
    [self doNetworking];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, getPlanExamineConttentListApi, self.pageNumber];
    NSDictionary *payload = @{
                              @"keyWord": self.keyWord
                              };
    DLog(@"payload:%@", urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"计划审核列表:%@", response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getPerfEvaluaListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getPerfEvaluaListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
        [self ys_showNetworkError];
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPerfEvaluaListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSPerfEvaluaListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSPerfEvaluaListModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel andIndexPath:5];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPerfEvaluaListModel *cellModel = self.dataSourceArray[indexPath.row];
    YSPerfInfoViewController *perfInfoViewController = [[YSPerfInfoViewController alloc] init];
    perfInfoViewController.perfInfoType = PerfExamInfoType;
    perfInfoViewController.evaluaListModel = cellModel;
    [self.navigationController pushViewController:perfInfoViewController animated:YES];
    // 计划退回/生效之后删除该条数据
    [perfInfoViewController setReturnBlock:^(YSPerfEvaluaListModel *evaluaListModel) {
        [self.dataSourceArray removeObject:evaluaListModel];
        [self ys_reloadData];
    }];
}

@end
