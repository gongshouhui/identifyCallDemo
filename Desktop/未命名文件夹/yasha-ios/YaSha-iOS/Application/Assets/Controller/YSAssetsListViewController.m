//
//  YSAssetsListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/9.
//

#import "YSAssetsListViewController.h"
#import "YSAssetsListCell.h"
#import "YSAssetsDetailListViewController.h"

@interface YSAssetsListViewController ()

@end

@implementation YSAssetsListViewController

static NSString *cellIdentifier = @"AssetsListCell";

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSAssetsListCell class] forCellReuseIdentifier:cellIdentifier];
    [self doNetworking];
}

- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kTopHeight+kBottomHeight, 0);
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/20/%@", YSDomain, _assetsListType == AssetsListDealing ? getAjaxListDealing : getAjaxListFinish, [NSString stringWithFormat:@"%zd", self.pageNumber]];
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"盘点清册数据:%@", response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getAssetsListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getAssetsListData:response].count < 20 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAssetsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetsListCell"];
    if (!cell) {
        cell = [[YSAssetsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssetsListCell"];
    }
    [cell setCellModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAssetsDetailListViewController *assetsDetailListViewController = [[YSAssetsDetailListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    assetsDetailListViewController.assetsListType = _assetsListType;
    YSAssetsListModel *cellModel = self.dataSourceArray[indexPath.row];
    assetsDetailListViewController.model = cellModel;
    [self.navigationController pushViewController:assetsDetailListViewController animated:YES];
}

@end
