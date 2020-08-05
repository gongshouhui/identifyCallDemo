//
//  YSSupplySupplierViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/3.
//

#import "YSSupplySupplierViewController.h"
#import "YSSupplyBankTableViewCell.h"
#import "YSSupplySupplierModel.h"

@interface YSSupplySupplierViewController ()

@end

@implementation YSSupplySupplierViewController

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSSupplyBankTableViewCell class] forCellReuseIdentifier:@"SupplySupplierCell"];
    [self doNetworking];
}

- (void)doNetworking {
    NSDictionary *payload  = @{@"franId":_id,@"status":@"10"};
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain, getFranRelateDetailApp, self.pageNumber] isNeedCache:NO parameters:payload successBlock:^(id response) {
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [self.dataSourceArray addObjectsFromArray:[YSDataManager getSupplySupplierData:response]];
        self.tableView.mj_footer.state = [YSDataManager getSupplySupplierData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        [self ys_reloadData];
        [self.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        DLog(@"------%@",error);
    } progress:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关联供应商";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3*self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SupplySupplierCell" cacheByIndexPath:indexPath configuration:^(YSSupplyBankTableViewCell *cell) {
        cell.contentLabel.font = [UIFont systemFontOfSize:13];
        YSSupplySupplierModel *model = self.dataSourceArray[indexPath.row/3];
        switch (indexPath.row%3) {
            case 0:
                cell.contentLabel.text = model.name;
                break;
            case 1:
                cell.contentLabel.text = model.no;
                break;
            case 2:
                cell.contentLabel.text = ([model.remark isEqual:@""] || [model.remark isEqual:[NSNull null]] || model.remark == nil) ? @"设置" : model.remark;
                break;
        }
        
    }]+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplySupplierCell" forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, kSCREEN_WIDTH, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row%3 == 0) {
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 1);
        lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:lineLabel];
    }
    [cell setSupplySupplierCellData:indexPath andCellModel:self.dataSourceArray[indexPath.row/3]];
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
