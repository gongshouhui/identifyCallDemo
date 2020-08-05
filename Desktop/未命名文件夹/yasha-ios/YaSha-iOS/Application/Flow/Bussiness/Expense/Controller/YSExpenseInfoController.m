//
//  YSExpenseInfoController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseInfoController.h"
#import "YSExpenseShareHeaderView.h"
#import "YSExpenseInfoCell.h"
#import "YSCostInfoModel.h"
@interface YSExpenseInfoController ()<YSExpenseShareHeaderViewDelegate>
@property (nonatomic,strong) NSMutableArray *openArr;

@end

@implementation YSExpenseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self doNetworking];
    // Do any additional setup after loading the view.
}
- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getAllPexpInvoDetaiListApi,self.detailID] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
           [self.dataSourceArray removeAllObjects];
           [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCostInfoModel class] json:response[@"data"]]];
            self.openArr = [NSMutableArray array];
            for (int i = 0; i < self.dataSourceArray.count; i++) {
                NSString *str = @"open";
                [self.openArr addObject:str];
            }
        }
        [self ys_reloadData];
        
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];
    } progress:nil];
}
#pragma mark - tableViewDataSource,tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.openArr[section] isEqualToString:@"open"]) {
        return 1;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCostInfoModel *model = self.dataSourceArray[indexPath.section];
    YSCostInfoModelDetail *detailModel = model.info;
    YSExpenseInfoCell *cell = [[YSExpenseInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.infoModel = detailModel;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSCostInfoModel *model = self.dataSourceArray[section];
    YSExpenseShareHeaderView *view = [[YSExpenseShareHeaderView alloc]init];
    [view updateConstraintForExpenseHeader];
    view.titleLb.text = model.name;
    [view.arrowBtn setTitle:[NSString stringWithFormat:@"￥%.2f",model.taxAmountTatol] forState:UIControlStateNormal];
    view.delegate = self;
    view.tag = 500 + section;
    view.backgroundColor = [UIColor whiteColor];
    view.arrowBtn.hidden = NO;
    if ([self.openArr[section] isEqualToString:@"close"]) {
        view.arrowBtn.selected = NO;
    }else{
        view.arrowBtn.selected = YES;
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - YSExpenseShareHeaderView 代理方法
- (void)expandButtonDidClick:(YSExpenseShareHeaderView *)headerView {
    NSInteger index = headerView.tag - 500;
    if ([self.openArr[index] isEqualToString:@"close"]) {
        self.openArr[index] = @"open";
    }else{
        self.openArr[index] = @"close";
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:headerView.tag-500];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
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
