//
//  YSFlowRecordListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSFlowRecordListViewController.h"
#import "YSFlowRecordListCell.h"
#import "YSFlowRecordListModel.h"
#import "YSContactModel.h"
@interface YSFlowRecordListViewController ()

@end

@implementation YSFlowRecordListViewController

static NSString *cellIdentifier = @"FlowRecordListCell";

- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    [self.tableView registerClass:[YSFlowRecordListCell class] forCellReuseIdentifier:cellIdentifier];
    [self doNetworking];
}

- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kTopHeight+kBottomHeight, 0);
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%zd", YSDomain, getCommentsByProcessInstanceIdApi, _cellModel.processInstanceId, self.flowRecordType+1];
    DLog(@"=========%@",urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"处理列表:%@", response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getFlowRecordListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getFlowRecordListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self.tableView.mj_header endRefreshing];
        [self ys_reloadData];
    } failureBlock:^(NSError *error) {
        [self ys_showNetworkError];
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSFlowRecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSFlowRecordListModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setRecordListCellModel:cellModel andIndexPath:indexPath];
    YSWeak;
    [[cell.callButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YSStrong;
        RLMResults *results = [YSContactModel objectsWhere:[NSString stringWithFormat:@"userId = '%@'AND isOrg = NO AND delFlag = '1' AND postStatus = '1' AND status = '1' AND isPublic != '0'", cellModel.userId]];
        //点击立即联系，直接拨打人员信息中的手机字段号码，不需确认，点击一次即呼出。
        //若人员的手机字段号码为空，则默认拨打座机号码字段内容，不需确认，点击一次即呼出。
        //若上述两个字段内容均为空，则提示暂无可用号码（参考设计样式）
        if (results.count != 0) {
            YSContactModel *contactModel = results[0];
            if (contactModel.mobile.length) {
                [YSUtility openUrlWithType:YSOpenUrlCall urlString:contactModel.mobile];
            }else if (contactModel.phone.length) {
                [YSUtility openUrlWithType:YSOpenUrlCall urlString:contactModel.phone];
            }else{
                [QMUITips showError:@"暂无可用号码" inView:strongSelf.view hideAfterDelay:1.0];
            }


        } else {
            [QMUITips showError:@"暂无可用号码" inView: strongSelf.view hideAfterDelay:1.0];
        }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFlowRecordListCell *cell) {
//        YSFlowRecordListModel *cellModel = self.dataSourceArray[indexPath.row];
//        [cell setCellModel:cellModel];
//    }];
//}

@end
