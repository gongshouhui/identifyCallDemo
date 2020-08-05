//
//  YSSupplyAddressViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSupplyAddressViewController.h"
#import "YSPMSInfoHeaderView.h"
#import "YSSupplyAddressTableViewCell.h"

@interface YSSupplyAddressViewController ()

@property (nonatomic, strong) YSPMSInfoHeaderView *infoHeaderView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YSSupplyAddressViewController

- (void)initTableView {
    [super initTableView];
    self.title = @"地址信息";
    self.dataArray = [NSMutableArray array];
    [self.tableView registerClass:[YSSupplyAddressTableViewCell class] forCellReuseIdentifier:@"SupplyAddressCell"];
    [self doNetworking];
    
}

- (void)doNetworking {
    NSDictionary *payload  = @{@"franInfoId":_id,@"status":@"1"};
    DLog(@"=======%@",_id);
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/1",YSDomain, getFranFranAddressDetailApp] isNeedCache:NO parameters:payload successBlock:^(id response) {
        DLog(@"========%@",response);
        if (![response[@"data"] isEqual:[NSNull null]] && [response[@"data"] count] > 0) {
            //开票地址
            [self.dataArray addObject:response[@"data"][@"billingAddressInfo"]];
            //生产地址
            [self.dataArray addObject:response[@"data"][@"produceAddressInfo"]];
            //供货地址
            [self.dataArray addObject:response[@"data"][@"addressInfo"]];
            //收货地址
            [self.dataArray addObject:response[@"data"][@"receiptAddressInfo"]];
        }
        [self.tableView cyl_reloadData];
        
    } failureBlock:^(NSError *error) {
        DLog(@"--------%@",error);
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count>0) {
        return 4;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count>0) {
        return 1;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5*kHeightScale, kSCREEN_WIDTH, 42*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    self.infoHeaderView = [[YSPMSInfoHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [backView addSubview:self.infoHeaderView];
    NSArray *headlineArray = @[@"开票地址",@"生产地址",@"供货地址",@"收货地址"];
    self.infoHeaderView.positionLabel.text = headlineArray[section];
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplyAddressCell"];
    if (cell == nil) {
        cell  = [[YSSupplyAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SupplyAddressCell"];
    }
    DLog(@"======%@------%d",self.dataArray,([self.dataArray[indexPath.section] isEqual:[NSNull null]] || self.dataArray.count == 0 ));
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
        cell.addressLabel.text = ([self.dataArray[indexPath.section] isEqual:[NSNull null]] || self.dataArray.count == 0 || self.dataArray[indexPath.section] == nil )? @"暂无地址数据" : self.dataArray[indexPath.section];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SupplyAddressCell" cacheByIndexPath:indexPath configuration:^(YSSupplyAddressTableViewCell *cell) {
        if (self.dataArray.count > 0) {
            cell.addressLabel.text = ([self.dataArray[indexPath.section] isEqual:[NSNull null]] || self.dataArray.count == 0 ) ? @"暂无地址数据" : self.dataArray[indexPath.section];
        }
    }]+10;
    
}
- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
