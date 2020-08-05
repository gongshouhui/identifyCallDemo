//
//  YSExpenseAccountController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSEMSExpenseAccountController.h"

@interface YSEMSExpenseAccountController ()

@end

@implementation YSEMSExpenseAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    //子类继承，实现tableView的代理来实现不同的情况,表头全部继承父类
    self.title = @"我的报销单";
    self.expenseType = 0;
    [self doNetworking];
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
            cell.segControl.hidden = YES;
            self.selectCell = cell;
            YSWeak;
            [cell setDateBlock:^(NSString *date) {//选择日期block
                [weakSelf.monthListView resetState];
                weakSelf.currentselectedDate = date;
                [weakSelf doNetworking];
                
            }];
            
            return cell;
        }
            break;
        case 1:
        {
            YSEMSExpenseDetailCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YSEMSExpenseDetailCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //配置cell
            cell.colorType = 4;
            cell.titleLb.attributedText = [self reduceFontTwoSizeWithString:@"我的报销单"];
            cell.titleDetailLb.text = @"本人申请的差旅报销单与个人报销单明细";
            cell.firstTextLb.text = @"审批中";
            cell.secondTextLb.text = @"待付款";
            cell.thitdTextLb.text = @"已付款";
            cell.fourthTextLb.text = @"已冲账";
            cell.firstValueLb.text = [YSUtility positiveFormat:[NSString stringWithFormat:@"%.2f", self.expenseMoel.myPexp.applyMoney]];//;
            cell.secondValueLb.text = [YSUtility positiveFormat:[NSString stringWithFormat:@"%.2f", self.expenseMoel.myPexp.unpaidVerificationMoney]];
            cell.thirdValueLb.text = [YSUtility positiveFormat:[NSString stringWithFormat:@"%.2f", self.expenseMoel.myPexp.paidVerificationMoney]];
            cell.fourthValueLb.text = [YSUtility positiveFormat:[NSString stringWithFormat:@"%.2f", self.expenseMoel.myPexp.offsettedVerificationMoney]];
            CGFloat totalValue = self.expenseMoel.myPexp.applyMoney + self.expenseMoel.myPexp.unpaidVerificationMoney + self.expenseMoel.myPexp.paidVerificationMoney + self.expenseMoel.myPexp.offsettedVerificationMoney;
            
                NSArray *percentage = @[@(self.expenseMoel.myPexp.applyMoney/totalValue),@(self.expenseMoel.myPexp.unpaidVerificationMoney/totalValue),@(self.expenseMoel.myPexp.paidVerificationMoney/totalValue),@(self.expenseMoel.myPexp.offsettedVerificationMoney/totalValue)];
                [cell createPieChartWithTotalValue:totalValue text:@"总报销金额" itemArray:percentage];
           
            
            return cell;
        }
            break;
            
        default:
        {
            YSEMSExpenseBillsCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YSEMSExpenseBillsCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.expenseMoel.myPexp;
            cell.titleDetailLb.text = @"涉及到的单据为差旅报销单和个人报销单";
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
