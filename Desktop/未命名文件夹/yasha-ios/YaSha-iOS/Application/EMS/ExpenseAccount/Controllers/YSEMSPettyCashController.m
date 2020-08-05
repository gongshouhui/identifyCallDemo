//
//  YSEMSPettyCashController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSEMSPettyCashController.h"

@interface YSEMSPettyCashController ()

@end

@implementation YSEMSPettyCashController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备用金";
    self.expenseType = 2;
    [self doNetworking];
    // Do any additional setup after loading the view.
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            YSEMSExpenseSelectCell *cell = [[YSEMSExpenseSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.selectCell = cell;
            YSWeak;
            [cell setDateBlock:^(NSString *date) {//选择日期block
                [weakSelf.monthListView resetState];
                weakSelf.currentselectedDate = date;
                [weakSelf doNetworking];
                
            }];
            [cell.segControl setTitle:@"月账单" forSegmentAtIndex:0];
            [cell.segControl setTitle:@"余额" forSegmentAtIndex:1];
            [cell setSwitchBlock:^(NSInteger index) {//选择分段值
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
            return cell;
        }
            break;
        case 1:
        {
            YSEMSExpenseDetailCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YSEMSExpenseDetailCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.selectCell.segControl.selectedSegmentIndex == 0) {//月账单
                //配置cell
                cell.colorType = 3;
                cell.titleLb.attributedText =  [self reduceFontTwoSizeWithString:@"备用金月账单"];
                cell.titleDetailLb.text = @"本人申请的备用金明细";
                cell.firstTextLb.text = @"审批中";
                cell.secondTextLb.text = @"待付款";
                cell.thitdTextLb.text = @"已付款";
                cell.firstValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.myLoan.loanMoney];
                cell.secondValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.myLoan.unpaidVerificationMoney];
                cell.thirdValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.myLoan.paidVerificationMoney];
                cell.fourthTypeView.hidden = YES;
              
                CGFloat totalValue = self.expenseMoel.myLoan.loanMoney + self.expenseMoel.myLoan.unpaidVerificationMoney + self.expenseMoel.myLoan.paidVerificationMoney;
              
                    NSArray *percentage = @[@(self.expenseMoel.myLoan.loanMoney/totalValue),@(self.expenseMoel.myLoan.unpaidVerificationMoney/totalValue),@(self.expenseMoel.myLoan.paidVerificationMoney/totalValue)];
                    [cell createPieChartWithTotalValue:totalValue text:@"总借款金额"  itemArray:percentage];
                
            }else{//余额
                //配置cell
                 cell.colorType = 2;
                cell.titleLb.attributedText = [self reduceFontTwoSizeWithString:@"备用金余额 "];
                cell.titleDetailLb.text = @"财务已付款的备用金，其未冲账、未还款金额统计";
                cell.firstTextLb.text = @"超出还款期";
                cell.secondTextLb.text = @"还款期限内";
                cell.firstValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.myLoanAmount.overdueAmount];
                cell.secondValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.myLoanAmount.loanAmount];
                cell.thirdTypeView.hidden = YES;
                cell.fourthTypeView.hidden = YES;
                
                CGFloat totalValue = self.expenseMoel.myLoanAmount.overdueAmount + self.expenseMoel.myLoanAmount.loanAmount;
                
                    NSArray *percentage = @[@(self.expenseMoel.myLoanAmount.overdueAmount/totalValue),@(self.expenseMoel.myLoanAmount.loanAmount/totalValue)];
                    [cell createPieChartWithTotalValue:totalValue text:@"备用金总余额"  itemArray:percentage];
               
            }
           
            
            return cell;
        }
            break;
            
        default:
        {
            YSEMSExpenseBillsCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YSEMSExpenseBillsCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.expenseMoel.myLoan;
            cell.titleDetailLb.text = @"涉及到的单据为备用金申请单";
            return cell;
        }
            break;
    }
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
