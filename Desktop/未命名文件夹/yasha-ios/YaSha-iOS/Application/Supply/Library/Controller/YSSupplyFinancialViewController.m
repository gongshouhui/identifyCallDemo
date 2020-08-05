//
//  YSSupplyFinancialViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSupplyFinancialViewController.h"

@interface YSSupplyFinancialViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation YSSupplyFinancialViewController

- (void)initTableView {
    [super initTableView];
    self.title = @"财务信息";
    self.titleArray = @[@"付款方式",@"付款条件",@"付款币种",@"发票币种",@"税率",@"税种"];
    self.contentArray = [NSMutableArray array];
    [self.contentArray addObject:_model.payWay];
    [self.contentArray addObject:_model.payTerm];
    [self.contentArray addObject:_model.payCurrency];
    [self.contentArray addObject:_model.billCurrency];
    [self.contentArray addObject:_model.taxRate];
    [self.contentArray addObject:_model.taxCategory];
    [QMUITips hideAllToastInView:self.view animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10*kHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplyFinancialCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SupplyFinancialCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = self.contentArray[indexPath.row];
    cell.detailTextLabel.textColor = kUIColor(126, 126, 126, 1);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
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
