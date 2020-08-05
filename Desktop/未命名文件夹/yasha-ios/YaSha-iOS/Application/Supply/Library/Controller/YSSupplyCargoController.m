//
//  YSSupplyCargoController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSupplyCargoController.h"
#import "YSPMSInfoHeaderView.h"
#import "YSSupplyAddressTableViewCell.h"

@interface YSSupplyCargoController ()

@property (nonatomic, strong) YSPMSInfoHeaderView *infoHeaderView;
@property (nonatomic, strong) NSArray *franCategory;// 供货类别
@property (nonatomic, strong) NSArray *franRegion;//供货区域
@property (nonatomic, assign) NSInteger isCountry;//是否全国

@end

@implementation YSSupplyCargoController

- (void)initTableView {
    [super initTableView];
    self.title = @"供货信息";
    [self.tableView registerClass:[YSSupplyAddressTableViewCell class] forCellReuseIdentifier:@"SupplyCargoCell"];
    [self doNetworking];
    
}
- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain, getFranCategoryAndFranRegion, _id] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"========%@",response);
        if (![response[@"data"] isEqual:[NSNull null]]) {
            self.franCategory = response[@"data"][@"franCategory"];
            self.franRegion = response[@"data"][@"franRegion"];
        }
        [self.tableView cyl_reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"--------%@",error);
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.franCategory.count > 0 ? self.franCategory.count : 1;
    }else{
        return self.franRegion.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5*kHeightScale, kSCREEN_WIDTH, 42*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    self.infoHeaderView = [[YSPMSInfoHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [backView addSubview:self.infoHeaderView];
    NSArray *headlineArray = @[@"供货类别",@"供货区域"];
    self.infoHeaderView.positionLabel.text = headlineArray[section];
    self.infoHeaderView.positionLabel.textColor = [UIColor blackColor];
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SupplyCargoCell" cacheByIndexPath:indexPath configuration:^(YSSupplyAddressTableViewCell *cell) {
        cell.addressLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.section == 0) {
            if (self.franCategory.count > 0) {
                NSDictionary *dic = self.franCategory[indexPath.row];
                cell.addressLabel.text = [NSString stringWithFormat:@"%ld、%@-%@-%@-%@",(long)indexPath.row+1,dic[@"oneTypeName"],dic[@"twoTypeName"],dic[@"threeTypeName"],dic[@"fourTypeName"] == nil ? @"": dic[@"fourTypeName"]];
            }else{
                cell.addressLabel.text = @"暂无供货类别";
            }
        }else{
            NSDictionary *dic = self.franRegion[indexPath.row];
            if ([dic[@"isCountry"] isEqual:@"1"]) {
                cell.addressLabel.text = @"全国";
            }else{
                cell.addressLabel.text = [NSString stringWithFormat:@"%ld、%@-%@-%@",(long)indexPath.row+1,dic[@"province"],dic[@"city"],dic[@"area"]];
            }
        }
    }]+10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSSupplyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplyCargoCell"];
    if (cell == nil) {
        cell = [[YSSupplyAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SupplyCargoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (self.franCategory.count > 0) {
            NSDictionary *dic = self.franCategory[indexPath.row];
            cell.addressLabel.text = [NSString stringWithFormat:@"%ld、%@-%@-%@-%@",(long)indexPath.row+1,dic[@"oneTypeName"],dic[@"twoTypeName"],dic[@"threeTypeName"],dic[@"fourTypeName"] == nil ? @"": dic[@"fourTypeName"]];
        }else{
            cell.addressLabel.text = @"暂无供货类别";
        }
        
    }else{
        NSDictionary *dic = self.franRegion[indexPath.row];
        if ([dic[@"isCountry"] isEqual:@1]) {
            cell.addressLabel.text = @"全国";
        }else{
            cell.addressLabel.text = [NSString stringWithFormat:@"%ld、%@-%@-%@",(long)indexPath.row+1,dic[@"province"],dic[@"city"],dic[@"area"]];
        }
    }
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIView *)makePlaceHolderView {
    return [YSUtility NoDataView:@"无数据"];
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
