//
//  YSCertificateBorrowDetailsController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/10/9.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCertificateBorrowDetailsController.h"
#import "YSFlowFormSectionHeaderView.h"
#import "YSPMSInfoDetailHeaderCell.h"
@interface YSCertificateBorrowDetailsController ()
@property (nonatomic,copy)NSArray *titleArray;
@property (nonatomic,strong) NSMutableArray *contentArray;

@end

@implementation YSCertificateBorrowDetailsController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"件号",@"证书编号",@"证书名称",@"工程名称",@"人员工号",@"人员姓名",@"发证日期",@"评定日期",@"有效日期",@"发证机构"];
    }
    return _titleArray;
}
- (void)initTableView {
    [super initTableView];
    self.title = @"证书详情";
    self.contentArray = [NSMutableArray array];
    for (NSDictionary *dic in self.listData) {
        [self.contentArray addObject:dic[@"partNo"]];
        [self.contentArray addObject:dic[@"certificateNo"]];
        [self.contentArray addObject:dic[@"certificateName"]];
        [self.contentArray addObject:dic[@"projectName"]];
        [self.contentArray addObject:dic[@"csno"]];
        [self.contentArray addObject:dic[@"csname"]];
        [self.contentArray addObject:dic[@"publishTime"]];
        [self.contentArray addObject:dic[@"rateTime"]];
        [self.contentArray addObject:dic[@"effectiveTime"]];
        [self.contentArray addObject:dic[@"publishOrg"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    DLog(@"=======%@",self.contentArray);
//    [self.tableView reloadData];
}
#pragma mark -- tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"index"];
    if (cell == nil) {
        cell = [[YSPMSInfoDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"index"];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.titleArray[indexPath.row]];
    cell.titleLabel.font = [UIFont systemFontOfSize:15];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",self.contentArray[indexPath.row*(1+indexPath.section)]] ;
    if (!cell.titleLabel.text.length) {
        cell.titleLabel.text = @"    ";
    }
    if (!cell.contentLabel.text.length) {
        cell.contentLabel.text = @"    ";
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    flowFormSectionHeaderView.backgroundColor = kGrayColor(247);
    flowFormSectionHeaderView.titleLabel.text = [NSString stringWithFormat:@"证书信息%ld",(long)section+1];
    return flowFormSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
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
