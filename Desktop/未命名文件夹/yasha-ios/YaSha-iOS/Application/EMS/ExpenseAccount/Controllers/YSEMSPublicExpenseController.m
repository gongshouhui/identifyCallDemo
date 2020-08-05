//
//  YSEMSPublicExpenseController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSEMSPublicExpenseController.h"

@interface YSEMSPublicExpenseController ()

@end

@implementation YSEMSPublicExpenseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"对公报销";
    self.expenseType = 1;
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
            [cell.segControl setTitle:@"付款申请" forSegmentAtIndex:0];
             [cell.segControl setTitle:@"对公冲账" forSegmentAtIndex:1];
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
            
            if (self.selectCell.segControl.selectedSegmentIndex == 0) {//付款申请
                //配置cell
                 cell.colorType = 3;
                cell.titleLb.attributedText = [self reduceFontTwoSizeWithString:@"付款申请"];
                cell.titleDetailLb.text = @"本人申请的付款申请单明细";
                cell.firstTextLb.text = @"审批中";
                cell.secondTextLb.text = @"待付款";
                cell.thitdTextLb.text = @"已付款";
                cell.firstValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.pubPexp.paymentMoney];
                cell.secondValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.pubPexp.unpaidVerificationMoney];
                cell.thirdValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.pubPexp.paidVerificationMoney];
                cell.fourthTypeView.hidden = YES;
                
                CGFloat totalValue = self.expenseMoel.pubPexp.paymentMoney + self.expenseMoel.pubPexp.unpaidVerificationMoney + self.expenseMoel.pubPexp.paidVerificationMoney;
               
                    NSArray *percentage = @[@(self.expenseMoel.pubPexp.paymentMoney/totalValue),@(self.expenseMoel.pubPexp.unpaidVerificationMoney/totalValue),@(self.expenseMoel.pubPexp.paidVerificationMoney/totalValue)];
                      [cell createPieChartWithTotalValue:totalValue text:@"总金额" itemArray:percentage];
                
            }else{//对公冲账
                //配置cell
                 cell.colorType = 3;
                cell.titleLb.attributedText = [self reduceFontTwoSizeWithString:@"对公冲账"];
                cell.titleDetailLb.text = @"本人申请的对公冲账明细";
                cell.firstTextLb.text = @"审批中";
                cell.secondTextLb.text = @"待冲账";
                cell.thitdTextLb.text = @"已冲账";
                cell.firstValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.pubPexp.offsetMoney];
                cell.secondValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.pubPexp.unpaidMoney];
                cell.thirdValueLb.text = [YSUtility thousandsFormat:self.expenseMoel.pubPexp.offsettedVerificationMoney];
                cell.fourthTypeView.hidden = YES;
                
                CGFloat totalValue = self.expenseMoel.pubPexp.offsetMoney + self.expenseMoel.pubPexp.unpaidMoney + self.expenseMoel.pubPexp.offsettedVerificationMoney;
               
                    NSArray *percentage = @[@(self.expenseMoel.pubPexp.offsetMoney/totalValue),@(self.expenseMoel.pubPexp.unpaidMoney/totalValue),@(self.expenseMoel.pubPexp.offsettedVerificationMoney/totalValue)];
                    [cell createPieChartWithTotalValue:totalValue text:@"总金额" itemArray:percentage];
               
            }
            
            
            return cell;
        }
            break;
            
        default:
        {
            YSEMSExpenseBillsCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YSEMSExpenseBillsCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.expenseMoel.pubPexp;
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
