//
//  YSFlowAttachListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSFlowAttachListViewController.h"
#import "YSFlowAttachListCell.h"
#import "YSFlowAttachListModel.h"
#import "YSNewsAttachmentViewController.h"
#import "YSNewsAttachmentModel.h"
#import "YSFlowListCell.h"
#import "YSFlowCustomDetailController.h"
#import "YSFlowDetailPageController.h"

@interface YSFlowAttachListViewController ()

@end

@implementation YSFlowAttachListViewController

static NSString *cellIdentifierPS = @"YSFlowAttachPSListCell";
static NSString *cellIdentifierFile = @"FlowRecordFileListCell";
static NSString *cellIdentifierFlow = @"FlowRecordFlowListCell";


- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    [self.tableView registerClass:[YSFlowAttachPSListCell class] forCellReuseIdentifier:cellIdentifierPS];
    [self.tableView registerClass:[YSFlowAttachFileListCell class] forCellReuseIdentifier:cellIdentifierFile];
    [self.tableView registerClass:[YSFlowAttachFlowListCell class] forCellReuseIdentifier:cellIdentifierFlow];
    [self doNetworking];
}

- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kTopHeight+kBottomHeight, 0);
}

- (void)doNetworking {
    [super doNetworking];
    if (_flowAttachType == FlowAttachTypePS) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getPostscriptListApi, self.cellModel.businessKey];
        DLog(@"附言:%@", urlString);
        [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
            DLog(@"获取提交者附言:%@", response);
            self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
            [self.dataSourceArray addObjectsFromArray:[YSDataManager getFlowAttachPSListData:response]];
            self.tableView.mj_footer.state = [YSDataManager getFlowAttachPSListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
            [self.tableView.mj_header endRefreshing];
            [self ys_reloadData];
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
        } progress:nil];
    } else if (_flowAttachType == FlowAttachTypeFile) {
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //请求1
            NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getAttachmentApi, self.cellModel.businessKey];
            [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
                DLog(@"获取关联文档:%@", response);
                [self.dataSourceArray addObjectsFromArray:[YSDataManager getFlowAttachFileListData:response]];
                dispatch_group_leave(group);
            } failureBlock:^(NSError *error) {
                DLog(@"error:%@", error);
                dispatch_group_leave(group);
            } progress:nil];
        });
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //请求2
            NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getPostscriptListApi, self.cellModel.businessKey];
            [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
                DLog(@"获取提交者附言:%@", response);
                for (NSDictionary *dic in response[@"data"]) {
                    YSFlowAttachPSListModel *model = [YSFlowAttachPSListModel yy_modelWithJSON:dic];
                     [self.dataSourceArray addObjectsFromArray:[YSDataManager getFlowAttachFileListAndPSListData:model.mobileFileVos]];
                }
                dispatch_group_leave(group);
            } failureBlock:^(NSError *error) {
                DLog(@"error:%@", error);
                dispatch_group_leave(group);
            } progress:nil];
        });
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            //界面刷新
            NSLog(@"任务均完成，刷新界面");
            [self ys_reloadData];
        });
    } else {
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getRelateFlowVo,self.cellModel.businessKey];
        [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
            DLog(@"流程列表:%@", response);
            
            [QMUITips hideAllToastInView:self.view animated:YES];
            if ([response[@"code"] intValue] == 1) {
                self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
                [self.dataSourceArray addObjectsFromArray:[YSDataManager getFlowListData:response]];
                self.tableView.mj_footer.state = self.dataSourceArray.count < [response[@"total"] intValue] ?MJRefreshStateIdle :MJRefreshStateNoMoreData ;
                [self.tableView.mj_header endRefreshing];
                [self ys_reloadData];
            }
        } failureBlock:^(NSError *error) {
        } progress:nil];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_flowAttachType == FlowAttachTypePS) {
        YSFlowAttachPSListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierPS];
        if (!cell) {
            cell = [[YSFlowAttachPSListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierPS];
        }
        YSFlowAttachPSListModel *cellModel = self.dataSourceArray[indexPath.row];
        [cell setCellModel:cellModel];
        
        return cell;
    } else if (_flowAttachType == FlowAttachTypeFile) {
        YSFlowAttachFileListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierFile];
        if (!cell) {
            cell = [[YSFlowAttachFileListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierFile];
        }
        YSNewsAttachmentModel *cellModel = self.dataSourceArray[indexPath.row];
        [cell setCellModel:cellModel];
        
        return cell;
    } else {
        YSFlowListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierFlow];
        cell = [[YSFlowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierFlow];
        YSFlowListModel *cellModel = self.dataSourceArray[indexPath.row];
        [cell setAssociatedFlowCell: cellModel];
        return cell;

    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_flowAttachType == FlowAttachTypePS) {
        return [tableView fd_heightForCellWithIdentifier:cellIdentifierPS configuration:^(YSFlowAttachPSListCell *cell) {
            YSFlowAttachPSListModel *cellModel = self.dataSourceArray[indexPath.row];
            [cell setCellModel:cellModel];
        }];
    } else if (_flowAttachType == FlowAttachTypeFile) {
        return 50*kHeightScale + 30;
    } else {
        return 50*kHeightScale + 30;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_flowAttachType == FlowAttachTypeFile) {
        YSNewsAttachmentModel *attachmentModel = self.dataSourceArray[indexPath.row];
        YSNewsAttachmentViewController *newsAttachmentViewController = [[YSNewsAttachmentViewController alloc] init];
        newsAttachmentViewController.attachmentModel = attachmentModel;
        [self.navigationController pushViewController:newsAttachmentViewController animated:YES];
    }
    if(_flowAttachType == FlowAttachTypeFlow ) {
        YSFlowListModel *cellModel = self.dataSourceArray[indexPath.row];
        //自定义流程
        if (cellModel.processType == 1 || cellModel.processType == 5) {
            YSFlowCustomDetailController *flowDetailPageController = [[YSFlowCustomDetailController alloc] init];
//            flowDetailPageController.flowType = _flowType;
            //获得流程列表数据model
            flowDetailPageController.cellModel = cellModel;
            [self.navigationController pushViewController:flowDetailPageController animated:YES];
        } else {
            YSFlowDetailPageController *flowDetailPageController = [[YSFlowDetailPageController alloc] init];
//            flowDetailPageController.flowType = _flowType;
            YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:cellModel.processDefinitionKey];
            //获得plist文件数据model
            flowDetailPageController.flowModel = flowModel;
            //获得流程列表数据model
            flowDetailPageController.cellModel = cellModel;
            //判断是否可以在手机端处理
            if (flowModel.isMobile) {
                [flowDetailPageController reloadData];
                [self.navigationController pushViewController:flowDetailPageController animated:NO];
            } else {
                [QMUITips showInfo:@"此流程仅支持电脑端处理" inView:self.view hideAfterDelay:1];
            }
        }

    }
}

@end
