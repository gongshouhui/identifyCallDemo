//
//  YSSupplyContactViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/1.
//

#import "YSSupplyContactViewController.h"
#import "YSSupplyContactTableViewCell.h"

@interface YSSupplyContactViewController ()

@property (nonatomic, strong) NSMutableDictionary *payload;

@end

@implementation YSSupplyContactViewController

- (void)initTableView {
    _payload = [NSMutableDictionary dictionary];
    [super initTableView];
    [self.tableView registerClass:[YSSupplyContactTableViewCell class] forCellReuseIdentifier:@"SupplyContactCell"];
    [self doNetworking];
}

- (void)doNetworking {
    [self.payload setObject:@"1" forKey:@"status"];
    [self.payload setObject:_id forKey:@"franInfoId"];
    DLog(@"------%@",self.payload);
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd",YSDomain, getFranPersonDetailApp, self.pageNumber] isNeedCache:NO parameters:_payload successBlock:^(id response) {
        DLog(@"======%@",response);
        self.pageNumber == 1 ? [self.dataSourceArray removeAllObjects] : nil;
        [QMUITips hideAllTipsInView:self.view];
        if (![response[@"data"] isEqual:[NSNull null]]) {
            [self.dataSourceArray addObjectsFromArray:[YSDataManager getSupplyPersonListData:response]];
            self.tableView.mj_footer.state = [YSDataManager getSupplyPersonListData:response].count < 15 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
            [self ys_reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"======%@",error);
    } progress:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人信息";
    // Do any additional setup after loading the view.
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10*kHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplyContactCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSupplyContactCell:self.dataSourceArray[indexPath.row]];
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
