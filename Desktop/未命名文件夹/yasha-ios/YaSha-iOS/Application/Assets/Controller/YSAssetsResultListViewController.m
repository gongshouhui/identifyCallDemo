//
//  YSAssetsResultListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/9.
//

#import "YSAssetsResultListViewController.h"
#import "YSAssetsSearchResultCell.h"
#import "YSAssetsDetailViewController.h"
#import "YSAssetsResultModel.h"

@interface YSAssetsResultListViewController ()

@end

@implementation YSAssetsResultListViewController

static NSString *cellIdentifier = @"AssetsSearchResultCell";

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSAssetsSearchResultCell class] forCellReuseIdentifier:cellIdentifier];
    [self doNetworking];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"查询结果";
}

- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(kTopHeight, 0, kBottomHeight, 0);
}

- (void)doNetworking {
    YSWeak;
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getMachineByQuery, [NSString stringWithFormat:@"%zd", self.pageNumber]];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:_payload successBlock:^(id response) {
        DLog(@"获取查询结果:%@", response);
        weakSelf.pageNumber == 1 ? [weakSelf.dataSourceArray removeAllObjects] : nil;
        [weakSelf.dataSourceArray addObjectsFromArray:[YSDataManager getAssetsResultListData:response]];
        weakSelf.tableView.mj_footer.state = [YSDataManager getAssetsResultListData:response].count < 10 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [weakSelf ys_reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAssetsSearchResultCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AssetsSearchResultCell"];
    cell = [[YSAssetsSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyResultTableViewCell"];
    YSAssetsResultModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAssetsDetailViewController *assetsDetailViewController = [[YSAssetsDetailViewController alloc] init];
    assetsDetailViewController.assetsType = AssetsTypeOther;
    YSAssetsDetailListModel *cellModel = [[YSAssetsDetailListModel alloc] init];
    YSAssetsResultModel *assetsResultModel = self.dataSourceArray[indexPath.row];
    cellModel.assetsNo = assetsResultModel.assetsNo;
    assetsDetailViewController.cellModel = cellModel;
    assetsDetailViewController.history = YES;
    assetsDetailViewController.titleString = @"资产详情";
    [self.navigationController pushViewController:assetsDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65*kHeightScale;
}

@end
