//
//  YSSupplyBankViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/2.
//

#import "YSSupplyBankViewController.h"
#import "YSSupplyBankTableViewCell.h"
#import "YSSupplyBankModel.h"

@interface YSSupplyBankViewController ()

@end

@implementation YSSupplyBankViewController

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSSupplyBankTableViewCell class] forCellReuseIdentifier:@"SupplyBankViewCell"];
    [self doNetworking];
}

- (void)doNetworking {
    NSDictionary *payload  = @{@"franInfoId":_id,@"status":@"1"};
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain, getFranBlankDetailApp, self.pageNumber] isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"========%@",response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getSupplyBankData:response]];
        self.tableView.mj_footer.state = [YSDataManager getSupplyBankData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"--------%@",error);
    } progress:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行信息";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4*self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SupplyBankViewCell" cacheByIndexPath:indexPath configuration:^(YSSupplyBankTableViewCell *cell) {
         [cell setSupplyBankCellData:indexPath andCellModel:self.dataSourceArray[indexPath.row/4]];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplyBankViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, kSCREEN_WIDTH, 0, 0);
    [cell setSupplyBankCellData:indexPath andCellModel:self.dataSourceArray[indexPath.row/4]];
    if (indexPath.row%4 == 3) {
        UILabel *lineLabel = [[UILabel alloc]init];
//        lineLabel.frame = CGRectMake(0, 44*kHeightScale, kSCREEN_WIDTH, 1);
        lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(cell.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 1));
        }];
    }
    
    return cell;
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
