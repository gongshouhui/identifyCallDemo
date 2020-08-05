//
//  YSAssetsDetailListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/9.
//

#import "YSAssetsDetailListViewController.h"
#import "YSAssetsDetailCell.h"
#import "YSAssetsScanViewController.h"
#import "YSAssetsDetailViewController.h"

@interface YSAssetsDetailListViewController ()

@end

@implementation YSAssetsDetailListViewController

static NSString *cellIdentifier = @"AssetsDetailCell";

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSAssetsDetailCell class] forCellReuseIdentifier:cellIdentifier];
    self.title = _model.checkName;
    if (_assetsListType == AssetsListDealing) {
        UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [scanButton addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
        [scanButton setBackgroundImage:[UIImage imageNamed:@"scan_white"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
    }
    [self doNetworking];
}

- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(kTopHeight, 0, kBottomHeight, 0);
}

- (void)scan {
    if ([YSUtility checkCameraAuth]) {
        YSAssetsScanViewController *assetsScanViewController = [[YSAssetsScanViewController alloc] init];
        assetsScanViewController.id = _model.id;
        [self.navigationController pushViewController:assetsScanViewController animated:YES];
    }
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/20/%zd", YSDomain, getAjaxListInventory, self.pageNumber];
    NSDictionary *payload = @{
                              @"checkId": _model.id
                              };
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"盘点清册/历史列表:%@", response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        self.tableView.mj_footer.state = [YSDataManager getAssetsDetailListData:response].count < 20 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getAssetsDetailListData:response]];
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAssetsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[YSAssetsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssetsDetailCell"];
    }
    [cell setCellModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAssetsDetailViewController *assetsDetailViewController = [[YSAssetsDetailViewController alloc] init];
    assetsDetailViewController.assetsType = AssetsTypeOther;
    YSAssetsDetailListModel *cellModel = self.dataSourceArray[indexPath.row];
    assetsDetailViewController.titleString = @"资产详情";
    assetsDetailViewController.cellModel = cellModel;
    assetsDetailViewController.history = _assetsListType == AssetsListDealing ? NO : YES;
    [self.navigationController pushViewController:assetsDetailViewController animated:YES];
    [assetsDetailViewController setReturnBlock:^(YSAssetsDetailListModel *newCellModel) {
        self.dataSourceArray[indexPath.row] = cellModel;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 24)];
    UILabel *label = [[UILabel alloc] init];
    NSMutableString *scopeString = [NSMutableString string];
    if (![_model.scopeCompany isEqual:@""]) {
        [scopeString appendString:[NSString stringWithFormat:@"%@/", _model.scopeCompany]];
    }
    if (![_model.scopeDept isEqual:@""]) {
        [scopeString appendString:[NSString stringWithFormat:@"%@/", _model.scopeDept]];
    }
    if (![_model.scopeCate isEqual:@""]) {
        [scopeString appendString:_model.scopeCate];
    }
    label.text = [NSString stringWithFormat:@"%@  %@", [_model.startDate substringToIndex:10], scopeString];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.left.mas_equalTo(view.mas_left).offset(15);
        make.right.mas_equalTo(view.mas_right).offset(-15);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    return view;
}

@end
