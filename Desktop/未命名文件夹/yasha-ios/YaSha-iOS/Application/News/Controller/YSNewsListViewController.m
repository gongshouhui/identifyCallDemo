//
//  YSNewsListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/9.
//

#import "YSNewsListViewController.h"
#import "YSNewsListHeaderView.h"
#import "YSNewsListCell.h"
#import "YSNewsListModel.h"
#import "YSNewsDetailViewController.h"

@interface YSNewsListViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) YSNewsListHeaderView *newsListHeaderView;
@property (nonatomic, strong) NSArray *bannerArray;

@end

@implementation YSNewsListViewController

static NSString *cellIdentifier = @"NewsListCell";

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSNewsListCell class] forCellReuseIdentifier:cellIdentifier];
    [self addHeaderView];
    _newsType == YSNewsTypeNews ? [self getBanner] : nil;
    [self doNetworking];
}

- (UIEdgeInsets)tableViewInitialContentInset {
    return UIEdgeInsetsMake(0, 0, kBottomHeight+kTopHeight, 0);
}

/** 添加搜索和轮播界面 */
- (void)addHeaderView {
    YSWeak;
    _newsListHeaderView = [YSNewsListHeaderView initwithType:_newsType];
    _newsListHeaderView.cycleScrollView.delegate = self;
    [_newsListHeaderView.searchSubject subscribeNext:^(NSString *searchString) {
        weakSelf.keyWord = searchString;
        weakSelf.pageNumber = 1;
        [weakSelf doNetworking];
    }];
    self.tableView.tableHeaderView = _newsListHeaderView;
}

/** 获取轮播数据 */
- (void)getBanner {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/3/1", YSDomain, getNewsListApi];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取banner:%@", response);
        _bannerArray = [YSDataManager getNewsListData:response];
        _newsListHeaderView.cycleScrollView.imageURLStringsGroup = [YSDataManager getNewsBannerListData:response];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

/** 获取列表数据 */
- (void)doNetworking {
    [super doNetworking];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%zd", YSDomain, getNewsListApi, _newsType == YSNewsTypeNews ? @"1" : @"2", self.pageNumber];
    NSDictionary *payload = @{
                              @"keyWord": self.keyWord
                              };
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"获取新闻公告列表:%@", response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getNewsListData:response]];
        self.tableView.mj_footer.state = [YSDataManager getPerfListData:response].count < kPageSize ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
         [self.tableView.mj_header endRefreshing];
        [QMUITips hideAllTipsInView:self.view];
        //[self ys_showNetworkError];
    } progress:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSNewsListModel *cellModel = self.dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    _newsType == YSNewsTypeNotice ? [cell hideThumbImageView] : nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSNewsDetailViewController *newsDetailViewController = [[YSNewsDetailViewController alloc] init];
    newsDetailViewController.newsType = _newsType;
    YSNewsListModel *cellModel = self.dataSourceArray[indexPath.row];
    cellModel.alreadyRead ? cellModel.visitCount : cellModel.visitCount ++;
    newsDetailViewController.cellModel = cellModel;
    [self.navigationController pushViewController:newsDetailViewController animated:YES];
    [newsDetailViewController setSaveVisitRecordBlock:^(BOOL visited) {
        if (visited) {
            cellModel.alreadyRead = YES;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.refreshBlock();//工作台传过来的block，刷新
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100*kHeightScale;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    YSNewsDetailViewController *newsDetailViewController = [[YSNewsDetailViewController alloc] init];
    newsDetailViewController.newsType = _newsType;
    YSNewsListModel *cellModel = _bannerArray[index];
    // 0无  1内链 2外链
    switch (cellModel.bannerType) {
        case 0:
        {
            [QMUITips showError:@"暂无详情" inView:self.view hideAfterDelay:1.5];
            break;
        }
        case 1:
        {
            cellModel.id = cellModel.bannerId;
            newsDetailViewController.cellModel = cellModel;
            [self.navigationController pushViewController:newsDetailViewController animated:YES];
            [newsDetailViewController setSaveVisitRecordBlock:^(BOOL visited) {
                if (visited) {
                    cellModel.alreadyRead = YES;
                }
            }];
            break;
        }
        case 2:
        {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *url = [NSURL URLWithString:cellModel.sourceUrl];
            
            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [application openURL:url options:@{}
                   completionHandler:^(BOOL success) {
                       DLog(@"打开成功");
                   }];
            } else {
                BOOL success = [application openURL:url];
                DLog(@"打开成功:%d", success);
            }
            break;
        }
    }
}

@end
