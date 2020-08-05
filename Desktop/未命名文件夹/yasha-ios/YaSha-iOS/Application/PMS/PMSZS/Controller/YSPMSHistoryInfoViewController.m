//
//  YSPMSHistoryInfoViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/30.
//
//

#import "YSPMSHistoryInfoViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSPMSHistoryInfoModel.h"
#import "YSPMSInfoHeaderView.h"

@interface YSPMSHistoryInfoViewController ()<CYLTableViewPlaceHolderDelegate>{
    NSArray *titleArr;
    NSInteger pageNumber;
    NSMutableArray *allContentArray;
    NSArray *groupArray;
}

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSMutableArray *allContentArray;
@property (nonatomic, strong) NSArray *groupArray;

@end

@implementation YSPMSHistoryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"变更历史";
    pageNumber = 1;
    allContentArray = [NSMutableArray array];
    titleArr = @[@"变更事项",@"变更日期",@"变更人",@"变更说明"];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[YSPMSInfoDetailHeaderCell class] forCellReuseIdentifier:@"HistoryInfoCell"];
    [self doNetworking];
    
}

- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getChangeRecordListApp,self.projectId] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"-------%@",response);
        groupArray = [response[@"data"] allKeys];
        NSArray *arr;
        NSMutableArray *allgroupArr = [NSMutableArray array];
        for ( int i = 0 ; i < groupArray.count ;i++) {
          arr = [YSDataManager getPMSHistoryInfoData:response[@"data"][groupArray[i]]];
            [allgroupArr addObject:arr];
          
        }
        for (int i = 0; i < allgroupArr.count; i ++) {
            NSMutableArray *contentArray = [NSMutableArray array];
            for (YSPMSHistoryInfoModel *model in arr) {
                [contentArray addObject:model.item];
                [contentArray addObject:[YSUtility timestampSwitchTime:model.updateTime andFormatter:@"yyyy-MM-dd HH:mm:ss"]];
                [contentArray addObject:model.updator];
                [contentArray addObject:model.remark];
            }
            [allContentArray addObject:contentArray];
        }
//        self.tableView.mj_footer.state = [YSDataManager getPMSInfoListData:response].count < 10 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self.tableView cyl_reloadData];
        [self.tableView.mj_header endRefreshing];
        
        
    } failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allContentArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*kHeightScale, kSCREEN_WIDTH, 42*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    self.infoHeaderView = [[YSPMSInfoHeaderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [backView addSubview:self.infoHeaderView];
    self.infoHeaderView.positionLabel.text = groupArray[section];
    
    return backView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"HistoryInfoCell" cacheByIndexPath:indexPath configuration:^(YSPMSInfoDetailHeaderCell *cell) {
        if (![allContentArray[indexPath.section][indexPath.row] isEqual:@""]) {
            cell.contentLabel.font = [UIFont systemFontOfSize:15];
            cell.contentLabel.text = allContentArray[indexPath.section][indexPath.row] ;
        }else{
            cell.contentLabel.text = @"设置";
        }
        
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoDetailHeaderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YSPMSInfoDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryInfoCell"];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, kSCREEN_WIDTH, 0, 0);
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        make.left.mas_equalTo(cell.contentView.mas_left).offset(30);
        make.size.mas_equalTo(CGSizeMake(80*kWidthScale, 25*kHeightScale));
        
    }];
    [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        make.left.mas_equalTo(cell.titleLabel.mas_right).offset(17);
        make.size.mas_equalTo(CGSizeMake(140*kWidthScale, 25*kHeightScale));
    }];
    cell.titleLabel.text = titleArr[indexPath.row%4];
    cell.contentLabel.text = allContentArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
}

@end
