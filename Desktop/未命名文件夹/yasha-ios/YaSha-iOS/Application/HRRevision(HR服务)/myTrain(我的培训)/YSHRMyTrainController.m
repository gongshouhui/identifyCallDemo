//
//  YSHRMyTrainController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMyTrainController.h"
#import "YSHRMyTrainHeaderView.h"
#import "YSHRTrainCell.h"
#import "YSHRTrainSectionHeaderView.h"
#import "YSHRYearSelectedView.h"
#import "YSHRTrainSummyModel.h"
#import "YSHRTrainDetailModel.h"
@interface YSHRMyTrainController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *openArr;
@property (nonatomic,strong) NSString *currentSelectedYear;
@property (nonatomic,strong) YSHRTrainSummyModel *summyModel;
@property (nonatomic,strong) YSHRMyTrainHeaderView *headerView;

@end

@implementation YSHRMyTrainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的培训";
    [self.openArr addObject:@"open"];
    YSHRMyTrainHeaderView *headerView = [[YSHRMyTrainHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    //
    YSHRYearSelectedView *selectView = [[YSHRYearSelectedView alloc]init];
    [self.view addSubview:selectView];
    [self.view bringSubviewToFront:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight + 15);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    YSWeak;
    [selectView setSelectBlock:^(NSString * _Nonnull year) {
        [weakSelf doNetworking];
        [weakSelf getTranSummary];
    }];
    self.currentSelectedYear = selectView.currentSelectedYear;
    [self getTranSummary];
    [self doNetworking];
}
- (void)getTranSummary{
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getTrainingSummary,self.currentSelectedYear] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            self.summyModel = [YSHRTrainSummyModel yy_modelWithJSON:response[@"data"]];
            [self.headerView setSummaryModel:_summyModel];
        }
    } failureBlock:^(NSError *error) {
        
    } progress:nil];
    
}
- (void)doNetworking {
    [super doNetworking];
   
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%ld",YSDomain,getTrainDetail,self.pageNumber] isNeedCache:NO parameters:@{@"year":self.currentSelectedYear} successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            [QMUITips hideAllTipsInView:self.view];
            self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
            [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSHRTrainDetailModel class] json:response[@"data"]]];
            self.tableView.mj_footer.state = self.dataSourceArray.count < [response[@"total"] intValue] ?MJRefreshStateIdle :MJRefreshStateNoMoreData ;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failureBlock:^(NSError *error) {
         [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } progress:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YSHRTrainDetailModel *detailModel = self.dataSourceArray[section];
    if (detailModel.isExtend) {
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSHRTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSHRTrainCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"YSHRTrainCell" owner:self options:nil].firstObject;
    }
    cell.detailModel = self.dataSourceArray[indexPath.section];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSHRTrainSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YSHRTrainSectionHeaderView"];
    if (view == nil) {
        view = [[NSBundle mainBundle] loadNibNamed:@"YSHRTrainSectionHeaderView" owner:self options:nil].firstObject;
    }
    view.detailModel = self.dataSourceArray[section];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150;
}
@end
