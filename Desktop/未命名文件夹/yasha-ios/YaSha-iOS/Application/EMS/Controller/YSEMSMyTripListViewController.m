//
//  YSEMSMyTripListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/14.
//

#import "YSEMSMyTripListViewController.h"
#import "YSEMSMyTripListCell.h"
#import "YSEMSMyTripDetailViewController.h"

@interface YSEMSMyTripListViewController ()

@end

@implementation YSEMSMyTripListViewController

static NSString *cellIdentifier = @"EMSMyTripListCell";

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSEMSMyTripListCell class] forCellReuseIdentifier:cellIdentifier];
    [self doNetworking];
}

- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kTopHeight, 0);
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd/%zd", YSDomain, getMyTripListApi, self.EMSMyTripType+1, self.pageNumber];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取我的出差列表:%@", response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getEMSMyTripListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getEMSMyTripListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSEMSMyTripListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSEMSMyTripListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setCellModel:self.dataSourceArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSEMSMyTripListCell *cell) {
        [cell setCellModel:self.dataSourceArray[indexPath.row]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSEMSMyTripDetailViewController *EMSMyTripDetailViewController = [[YSEMSMyTripDetailViewController alloc] init];
    EMSMyTripDetailViewController.cellModel = self.dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:EMSMyTripDetailViewController animated:YES];
}

@end
