//
//  YSAssetsMineListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/9.
//

#import "YSAssetsMineListViewController.h"
#import "YSAssetsMineCell.h"
#import "YSAssetsMineModel.h"
#import "YSAssetsDetailViewController.h"

@interface YSAssetsMineListViewController ()

@property (nonatomic, strong) NSString *assetsTotalNumber;

@end

@implementation YSAssetsMineListViewController

static NSString *cellIdentifier = @"AssetsMineCell";

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"我的资产"];
}

//设置统计离开该模块
- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"我的资产"];
}

- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    [self.tableView registerClass:[YSAssetsMineCell class] forCellReuseIdentifier:cellIdentifier];
    [self doNetworking];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"我的资产";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资产";
}

- (void)doNetworking {
   
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, getMyAssets, self.pageNumber];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取我的资产列表:%@", response);
        _assetsTotalNumber = response[@"total"];
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        self.tableView.mj_footer.state = [YSDataManager getMyAssetsListData:response].count < 10 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getMyAssetsListData:response]];
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAssetsMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    YSAssetsMineModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAssetsDetailViewController *assetsDetailViewController = [[YSAssetsDetailViewController alloc] init];
    assetsDetailViewController.assetsType = AssetsTypeOther;
    YSAssetsDetailListModel *cellModel = [[YSAssetsDetailListModel alloc] init];
    YSAssetsMineModel *assetsMineModel = self.dataSourceArray[indexPath.row];
    cellModel.assetsNo = assetsMineModel.assetsNo;
    assetsDetailViewController.assetsType = AssetsTypeMine;
    assetsDetailViewController.cellModel = cellModel;
    assetsDetailViewController.history = YES;
    assetsDetailViewController.titleString = @"资产详情";
    assetsDetailViewController.assetStates = assetsMineModel.assetsStatus;
    assetsDetailViewController.id = assetsMineModel.id;
    assetsDetailViewController.RefreshBlock = ^(NSString *stateStr) {
//        YSAssetsMineCell *cell = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
//        cell.statusLabel.text = stateStr;
        [self doNetworking];
    };
    [self.navigationController pushViewController:assetsDetailViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.font = [UIFont systemFontOfSize:12];
    totalLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00];
    totalLabel.text = [NSString stringWithFormat:@"共有%@个资产", _assetsTotalNumber];
    [headerView addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerView);
        make.right.mas_equalTo(headerView.mas_right).offset(-15);
        make.height.mas_equalTo(12*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120*kHeightScale;
}

@end
