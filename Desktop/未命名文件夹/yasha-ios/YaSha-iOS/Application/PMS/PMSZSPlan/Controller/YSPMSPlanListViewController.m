//
//  YSPMSPlanListViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/14.
//

#import "YSPMSPlanListViewController.h"
#import "YSPMSPlanInfoViewController.h"
#import "YSPMSPlanListModel.h"
#import "YSPMSPlanListCell.h"


@interface YSPMSPlanListViewController ()<UISearchBarDelegate,UISearchControllerDelegate>

@property (nonatomic, assign) BOOL zsResults;
@property (nonatomic, assign) BOOL zsPlanResults;

@end

@implementation YSPMSPlanListViewController

//设置统计开始进入该模块
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"装饰进度计划管理"];
}

- (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"装饰进度计划管理"];
}

- (void)initTableView {
    _zsResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSAllPriCompanyModel andCompanyId:ZScompanyId andPermissionValue:ZSAllPriCompanyPermissionValue];
    _zsPlanResults = [YSUtility checkDatabaseSystemSn:Infomanagement andModuleSn:ZSPlanModel andCompanyId:ZScompanyId andPermissionValue:ZSStatusPermissionValue];
    [super initTableView];
    [self.tableView registerClass:[YSPMSPlanListCell class] forCellReuseIdentifier:@"PlanListCell"];
    [self ys_shouldShowSearchBar];
    self.searchBar.delegate = self;
    [self doNetworking];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"进度计划管理";
}

- (void)doNetworking {
    [super doNetworking];
    NSDictionary *payload = @{@"priCompanyId":@"0001K310000000000ABV",
                              @"isAllPriCompany":_zsResults ? @"true" : @"false",
                              @"auditStatus":_zsPlanResults ? @"" : @"40",
                              @"keyWord":self.keyWord
                              };
    DLog(@"=======%@",payload);
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain, getPlanInfolistApp, self.pageNumber] isNeedCache:NO parameters:payload successBlock:^(id response) {
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
    YSPMSPlanInfoViewController *PMSPlanInfoViewController = [[YSPMSPlanInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
    PMSPlanInfoViewController.refreshPlanListBlock = ^{
        [self doNetworking];
    };
    YSPMSPlanListModel *model = self.dataSourceArray[indexPath.row];
    PMSPlanInfoViewController.code = model.code;
    PMSPlanInfoViewController.id = model.id;
    PMSPlanInfoViewController.proManagerId = model.proManagerId;
    PMSPlanInfoViewController.titleName = model.proName;
    [self.navigationController pushViewController:PMSPlanInfoViewController animated:YES];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

@end
