//
//  YSSupplyBlackListViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/4.
//

#import "YSSupplyBlackListViewController.h"
#import "YSSupplyListTableViewCell.h"
#import "YSSupplyListInfoViewController.h"

@interface YSSupplyBlackListViewController ()

@property (nonatomic, strong) NSMutableDictionary *payload;


@end

@implementation YSSupplyBlackListViewController

- (void)initTableView {
    self.payload = [NSMutableDictionary dictionary];
    [super initTableView];
    [self.tableView registerClass:[YSSupplyListTableViewCell class] forCellReuseIdentifier:@"SupplyListCell"];
    [self doNetworking];
}

- (void)doNetworking {
    [self.payload setObject:@"" forKey:@"status"];
    [self.payload setObject:@"" forKey:@"keyword"];
    [self.payload setObject:@"1" forKey:@"isBlackList"];
    DLog(@"------------%@",_payload);
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain,getFranInfoListApp,self.pageNumber] isNeedCache:NO parameters:_payload successBlock:^(id response) {
        DLog(@"========%@",response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [QMUITips hideAllTipsInView:self.view];
        if (![response[@"data"] isEqual:[NSNull null]]) {
            [self.dataSourceArray addObjectsFromArray:[YSDataManager getSupplyListData:response]];
            self.tableView.mj_footer.state = [YSDataManager getSupplyListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
            [self ys_reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"--------%@",error);
    } progress:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单";
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
    YSSupplyListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YSSupplyListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SupplyListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSupplyListCellData:self.dataSourceArray[indexPath.row]];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyListInfoViewController *SupplyListInfoViewController = [[YSSupplyListInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
    SupplyListInfoViewController.model = self.dataSourceArray[indexPath.row];
    [self.navigationController pushViewController:SupplyListInfoViewController animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
