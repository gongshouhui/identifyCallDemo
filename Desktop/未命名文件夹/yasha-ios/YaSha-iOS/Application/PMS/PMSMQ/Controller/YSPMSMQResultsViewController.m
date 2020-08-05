//
//  YSPMSMQResultsViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/19.
//
//

#import "YSPMSMQResultsViewController.h"
#import "YSPMSInfoListCell.h"
#import "YSPMSInfoViewController.h"
#import "YSACLModel.h"

@interface YSPMSMQResultsViewController ()<CYLTableViewPlaceHolderDelegate>

@property(nonatomic , assign) NSInteger pageNumber;
@property(nonatomic , strong) NSMutableArray *dataSourceArray;
@property(nonatomic , strong) NSString *projectId;

@end

static NSString *cellIdentifier = @"PMSListCell";

@implementation YSPMSMQResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clicked)];
    _pageNumber = 1;
    _dataSourceArray = [NSMutableArray array];
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[YSPMSInfoListCell class] forCellReuseIdentifier:cellIdentifier];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self doNetworking];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNumber ++;
        [self doNetworking];
    }];
    [self doNetworking];
}

- (void)clicked {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)doNetworking {
    NSString *typeStr;
    switch (_num) {
        case 0:
            typeStr = @"zyxm";
            break;
        case 1:
            typeStr = @"khxm";
            break;
    }
    RLMResults *results = [YSACLModel objectsWhere:@"companyId = '0001K310000000000F91' AND moduleSn = 'pro_permission' AND permissionValue = 9 AND systemSn = 'pms'" ];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd",YSDomain,getBaseInfoListApp,_pageNumber];
    NSDictionary *diction = @{@"priCompanyId":@"0001K310000000000F91",
                              @"isAllPriCompany":results.count > 0 ? @true : @false,
                              @"proNature":typeStr,
                              @"name":self.keyWord

                              
                              };
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:diction successBlock:^(id response) {
        DLog(@"-------%@",response);
        NSArray *arr = [YSDataManager getPMSInfoListData:response];
        if (_pageNumber==1) {
            [_dataSourceArray removeAllObjects];
        }
        if (arr.count!=0) {
            [_dataSourceArray addObjectsFromArray:arr];
        }
        self.tableView.mj_footer.state = [YSDataManager getPMSInfoListData:response].count < 10 ? MJRefreshStateWillRefresh : MJRefreshStateIdle;
        [self.tableView cyl_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSPMSInfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YSPMSInfoListModel *cellModel = _dataSourceArray[indexPath.row];
    [cell setCellModel:cellModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoListModel *model = _dataSourceArray[indexPath.row];
    YSPMSInfoViewController *PMSInfoViewController = [[YSPMSInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    PMSInfoViewController.projectId = model.id;
    [self.navigationController pushViewController:PMSInfoViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - CYLTableViewPlaceHolderDelegate

- (BOOL)enableScrollWhenPlaceHolderViewShowing {
    return YES;
}

- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
