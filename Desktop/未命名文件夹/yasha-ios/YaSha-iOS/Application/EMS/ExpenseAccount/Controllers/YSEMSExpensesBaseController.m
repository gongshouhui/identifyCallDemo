//
//  YSEMSExpensesBaseController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSEMSExpensesBaseController.h"

@interface YSEMSExpensesBaseController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YSEMSExpensesBaseController
- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(-kTopHeight, 0, 0, 0);
    YSMonthListView *headerView = [[YSMonthListView alloc]init];
    self.monthListView = headerView;
    headerView.frame = CGRectMake(0, 0, 0, 45 + kTopHeight);
    YSWeak;
    [headerView setDateBlock:^(NSString *date) {
        
        [weakSelf.selectCell setDateButtonTitle:date];
        weakSelf.currentselectedDate = date;
        [weakSelf doNetworking];
    }];
    self.tableView.tableHeaderView = headerView;
    //第一次默认当前时间
    self.currentselectedDate = [self currentDate];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //修改左侧按钮图片
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:(UIBarMetricsDefault)];
    self.titleView.tintColor = [UIColor whiteColor];//继承自qmui的controller titleview是替换了的
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)doNetworking {
    [super doNetworking];
  
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%zd/%@",YSDomain,getMyExpReport,self.expenseType,self.currentselectedDate] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            self.expenseMoel = [YSEMSMyExpenseModel yy_modelWithJSON:response[@"data"]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } failureBlock:^(NSError *error) {
       [QMUITips hideAllTipsInView:self.view];
    } progress:nil];
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 55;
            break;
       case 1:
            return 225;
            break;
        default:
            return 200;
            break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kGrayColor(245);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    //当前时间字符串
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}
- (NSMutableAttributedString *)reduceFontTwoSizeWithString:(NSString *)content {
    NSString *oneStr = @"（元）";
    NSString *unionString = [NSString stringWithFormat:@"%@%@",content,oneStr];
    NSMutableAttributedString *attiString = [[NSMutableAttributedString alloc]initWithString:unionString];
    [attiString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:16]} range:[unionString rangeOfString:content]];
    [attiString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:12]} range:[unionString rangeOfString:oneStr]];
    return attiString;
}

@end
