//
//  YSPMSMQPlanListViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQPlanListViewController.h"
#import "YSPMSMQPlanInfoViewController.h"
#import "YSPMSMQPlanPageViewController.h"
#import "YSPMSPlanListModel.h"
#import "YSPMSPlanListCell.h"

@interface YSPMSMQPlanListViewController ()<UISearchBarDelegate,UISearchControllerDelegate>

@property (nonatomic, assign) BOOL mqResults;
@property (nonatomic, assign) BOOL mqPlanResults;

@end

@implementation YSPMSMQPlanListViewController

- (void)initTableView {
    //数据控制权限
    _mqResults = [YSUtility checkDatabaseSystemSn:MQInfomanagement andModuleSn:ZSAllPriCompanyModel andCompanyId:MQcompanyId andPermissionValue:ZSAllPriCompanyPermissionValue];
//    _mqPlanResults = [YSUtility checkDatabaseSystemSn:MQInfomanagement andModuleSn:ZSPlanModel andCompanyId:MQcompanyId andPermissionValue:ZSStatusPermissionValue];
    [super initTableView];
    [self.tableView registerClass:[YSPMSPlanListCell class] forCellReuseIdentifier:@"PlanListCell"];
    [self ys_shouldShowSearchBar];
    self.searchBar.delegate =self;
    [self doNetworking];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"进度计划管理";
}
//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"幕墙进度计划管理"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"幕墙进度计划管理"];
}
- (void)doNetworking {
    [super doNetworking];
    NSDictionary *payload = @{@"priCompanyId":MQcompanyId,
                              @"isAllPriCompany":_mqResults ? @"true" : @"false",
//                              @"auditStatus":_mqPlanResults ? @"" : @"40",
                              @"keyWord":self.keyWord
                              };
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain, getPlanInfolistAppMQ, self.pageNumber] isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"------%@",response);
        if (self.pageNumber == 1) {
            [self.dataSourceArray removeAllObjects];
        }
        NSMutableArray *mutableArray = [NSMutableArray array];
        if (![response[@"data"] isEqual:[NSNull null]]) {
            for (NSDictionary *dic in response[@"data"]) {
                [mutableArray addObject:dic];
                [self.dataSourceArray addObject:[YSPMSPlanListModel yy_modelWithJSON:dic]];
            }
        }
        self.tableView.mj_footer.state = mutableArray.count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"======%@",error);
    } progress:nil];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97*kHeightScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanListCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YSPMSPlanListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlanListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSPMSPlanListModel *model = self.dataSourceArray[indexPath.row];
    [cell setPMSPlanListDataCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePMSKeyboard" object:nil];
    YSPMSMQPlanPageViewController *PMSMQPlanPageViewController = [[YSPMSMQPlanPageViewController alloc]init];
    PMSMQPlanPageViewController.refreshPlanListBlock = ^{
        [self doNetworking];
    };
    YSPMSPlanListModel *model = self.dataSourceArray[indexPath.row];
    PMSMQPlanPageViewController.model = model;
    [self.navigationController pushViewController:PMSMQPlanPageViewController animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}
- (void)dealloc
{
    DLog(@"释放");
}
@end
