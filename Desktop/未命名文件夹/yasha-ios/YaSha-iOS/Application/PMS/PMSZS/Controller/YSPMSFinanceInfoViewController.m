//
//  YSPMSFinanceInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSFinanceInfoViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSPMSInfoHeaderView.h"
#import "YSPMSFinanceInfoModel.h"

@interface YSPMSFinanceInfoViewController ()

@property (nonatomic, strong) NSArray *twoGroupArr;
@property (nonatomic, strong) NSMutableArray *handelLettersArr;//保函信息数组
@property (nonatomic, strong) NSArray *threeGroupArr;
@property (nonatomic, strong) NSMutableArray *handelPaymentsArr;//付款信息数组
@property (nonatomic, strong) NSString *priceStr;//保证金

@end

@implementation YSPMSFinanceInfoViewController

- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.twoGroupArr = @[@"类型",@"备注"];
    self.threeGroupArr = @[@"类型",@"比例",@"备注"];
    self.handelLettersArr = [NSMutableArray array];
    self.handelPaymentsArr = [NSMutableArray array];
    self.title = @"财务信息";
    [self.tableView registerClass:[YSPMSInfoDetailHeaderCell class] forCellReuseIdentifier:@"FinanceInfoCell"];
    [self doNetworking];
}
- (void)doNetworking {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain, getFinanceListApp, self.projectId] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"=======%@",response);
        self.priceStr = [YSUtility cancelNullData:response[@"data"][@"perBondPrice"]];
        if (![response[@"data"][@"letters"] isEqual:[NSNull null]] && [response[@"data"][@"letters"] count] > 0) {
            
            for (NSDictionary *dic in response[@"data"][@"letters"]) {
                [self.handelLettersArr addObject:dic[@"type"]];
                [self.handelLettersArr addObject:dic[@"remark"]];
            }
        }else{
            [self.handelLettersArr addObject:@"暂无保函信息数据"];
        }
        if (![response[@"data"][@"payments"] isEqual:[NSNull null]] && [response[@"data"][@"payments"] count] > 0) {
            
            for (NSDictionary *dic in response[@"data"][@"payments"]) {
                [self.handelPaymentsArr addObject:dic[@"type"]];
                [self.handelPaymentsArr addObject:[NSString stringWithFormat:@"%@",dic[@"scale"]]];
                [self.handelPaymentsArr addObject:dic[@"remark"]];
            }
        }else{
            [self.handelPaymentsArr addObject:@"暂无付款信息数据"];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
    } progress:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return self.handelLettersArr.count ;
    }else{
        return self.handelPaymentsArr.count ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section {
    return 52*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*kHeightScale, kSCREEN_WIDTH, 42*kHeightScale)];
    backView.backgroundColor = [UIColor whiteColor];
    self.infoHeaderView = [[YSPMSInfoHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [backView addSubview:self.infoHeaderView];
    NSArray *headlineArray = @[@"履约保证金",@"保函信息",@"付款信息"];
    self.infoHeaderView.positionLabel.text = headlineArray[section];
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FinanceInfoCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[YSPMSInfoDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FinanceInfoCell"];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, kSCREEN_WIDTH, 0, 0);
    [cell setInfoDetailCellData:self.priceStr andLetters:[self.handelLettersArr copy] andPayments:[self.handelPaymentsArr copy] andIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [tableView fd_heightForCellWithIdentifier:@"FinanceInfoCell" cacheByIndexPath:indexPath configuration:^( YSPMSInfoDetailHeaderCell *cell) {
            if ([self.handelLettersArr[indexPath.row] length]>0) {
                cell.contentLabel.text = self.handelLettersArr[indexPath.row];
            }else{
                cell.contentLabel.text = @"设置";
            }
        }];
    }else if (indexPath.section == 2) {
        return [tableView fd_heightForCellWithIdentifier:@"FinanceInfoCell" cacheByIndexPath:indexPath configuration:^( YSPMSInfoDetailHeaderCell *cell) {
            if ([self.handelPaymentsArr[indexPath.row] length]>0) {
                cell.contentLabel.text = self.handelPaymentsArr[indexPath.row];
            }else{
                cell.contentLabel.text = @"设置";
            }
        }];
    }
    return 44*kHeightScale;
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
