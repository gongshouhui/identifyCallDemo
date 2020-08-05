//
//  YSEMSExpensesBaseController.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"
#import "YSCommonTableViewController.h"
#import "YSMonthListView.h"
#import "YSEMSExpenseSelectCell.h"
#import "YSEMSExpenseDetailCell.h"
#import "YSEMSExpenseBillsCell.h"
#import "YSEMSMyExpenseModel.h"
@interface YSEMSExpensesBaseController :YSCommonTableViewController
@property (nonatomic,strong) YSMonthListView *monthListView;
@property (nonatomic,strong) YSEMSExpenseSelectCell *selectCell;
//费用报表类型：0:我的报销单；1:对公报销；2:备用金
@property (nonatomic,assign) NSInteger expenseType;
@property (nonatomic,strong) NSString *currentselectedDate;
@property (nonatomic,strong) YSEMSMyExpenseModel *expenseMoel;
- (NSMutableAttributedString *)reduceFontTwoSizeWithString:(NSString *)content;
@end
