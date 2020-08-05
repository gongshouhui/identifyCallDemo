//
//  YSMessageClockListGWViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMessageClockListGWViewController.h"
#import "YSClockListGWTableViewCell.h"
#import "YSAttendanceRecordGZLNViewController.h"//考勤记录
#import "YSMessageClockListModel.h"
#import "YSMessageInfoModel.h"

@interface YSMessageClockListGWViewController ()

@end

@implementation YSMessageClockListGWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打卡";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFCFCFC"];
    [self doNetworking];
}

- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFCFCFC"];
    [self.tableView registerClass:[YSClockListGWTableViewCell class] forCellReuseIdentifier:@"clockListCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UILabel *lineLab = [UILabel new];
    lineLab.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, 1);
    lineLab.backgroundColor = kUIColor(244, 244, 244, 1);
    [self.view addSubview:lineLab];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, getClockNotificationList,self.pageNumber];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"消息打卡列表页:%@",response);
        if ([response[@"code"] intValue] == 1) {
            self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
            [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSMessageClockListModel class] json:response[@"data"]]];
            self.tableView.mj_footer.state = self.dataSourceArray.count < [response[@"total"] intValue] ?MJRefreshStateIdle :MJRefreshStateNoMoreData ;
            [self ys_reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failureBlock:^(NSError *error) {
        [self ys_showNetworkError];
    } progress:nil];
}

#pragma mark--setter&&getter
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 198*kHeightScale;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSClockListGWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clockListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSMessageClockListModel *model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    @weakify(self);
    [[[cell.detailBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self changeReadingStatusWith:model];
        YSAttendanceRecordGZLNViewController *complaintVC = [YSAttendanceRecordGZLNViewController new];
        
        complaintVC.clockModel = model;
        [self.navigationController pushViewController:complaintVC animated:YES];
    }];
    return cell;
}
//上传已读状态
- (void)changeReadingStatusWith:(YSMessageClockListModel*)model {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, updateReadingStatus,model.id];
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"打卡周报已阅==%@",response);
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
    
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSComplaintAttendanceGWViewController *complaintVC = [YSComplaintAttendanceGWViewController new];
    
    
    [self.navigationController pushViewController:complaintVC animated:YES];

}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
