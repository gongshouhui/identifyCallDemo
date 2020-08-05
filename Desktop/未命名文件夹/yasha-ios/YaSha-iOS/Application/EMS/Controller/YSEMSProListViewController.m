//
//  YSEMSProListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/21.
//

#import "YSEMSProListViewController.h"
#import "YSEMSProListCell.h"

@interface YSEMSProListViewController ()

@end

@implementation YSEMSProListViewController

static NSString *cellIdentifier = @"EMSProListCell";

- (void)initSubviews {
    [super initSubviews];
    self.title = @"选择项目";
    [self ys_shouldShowSearchBar];
    [self.tableView registerClass:[YSEMSProListCell class] forCellReuseIdentifier:cellIdentifier];
    [self doNetworking];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kBottomHeight+kTopHeight, 0);
}

- (void)doNetworking {
    [super doNetworking];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/5/%ld/%zd", YSDomain, getProListApi, self.EMSProType, self.pageNumber];
    NSDictionary *payload = @{
                              @"keyWord": self.keyWord
                              };
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"获取项目列表:%@", response);
        
        if ([response[@"code"] intValue] == 1) {
            self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
            [self.dataSourceArray addObjectsFromArray:[YSDataManager getEMSProListData:response]];
            DLog(@"--------%@",self.dataSourceArray);
            self.tableView.mj_footer.state = [YSDataManager getEMSProListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
            [self ys_reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSEMSProListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSEMSProListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSEMSProListModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
//    [cell.sendSelectedSubject subscribeNext:^(id x) {
//        YSEMSProListModel *cellModel = self.dataSourceArray[indexPath.row];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"EMSSelectedPro" object:nil userInfo:@{@"proModel": cellModel}];
//        //[self.navigationController popViewControllerAnimated:YES];
//    }];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(id cell) {
        YSEMSProListModel *cellModel = self.dataSourceArray[indexPath.row];
        [cell setCellModel:cellModel];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSEMSProListModel *cellModel = self.dataSourceArray[indexPath.row];
	if (self.projectInfoBlock) {
		self.projectInfoBlock(@{@"proModel": cellModel});
	}
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    DLog(@"-----");
}
@end
