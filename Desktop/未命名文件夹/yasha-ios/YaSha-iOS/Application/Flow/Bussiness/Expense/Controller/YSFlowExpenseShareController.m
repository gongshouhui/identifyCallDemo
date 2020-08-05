//
//  YSFlowExpenseShareController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowExpenseShareController.h"
#import "YSExpenseShareHeaderView.h"
#import "YSExpenseEditCell.h"
#import "YSFlowFormBottomView.h"
#import "YSFlowExpensePexpShareModel.h"
#import "UIImage+YSImage.h"
@interface YSFlowExpenseShareController ()<UITableViewDelegate,UITableViewDataSource,YSExpenseShareHeaderViewDelegate,YSExpenseEditCellDelegate>
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) NSArray *expenseCategoryArr;
@property (nonatomic,strong) YSFlowFormBottomView *bottomView;
@property (nonatomic,strong) NSMutableArray *openArr;
@property (nonatomic,strong) NSMutableArray *inputArray;
@end

@implementation YSFlowExpenseShareController
- (NSArray *)expenseCategoryArr {
    if (!_expenseCategoryArr) {
        _expenseCategoryArr = @[@"经营性费用",@"非经营性费用",@"固定补贴",@"公司承担"];
    }
    return _expenseCategoryArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营销费用分摊";
    self.openArr = [NSMutableArray array];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        NSString *str = @"open";
        [self.openArr addObject:str];
    }
    
}
- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomHeight + 50*kHeightScale, 0);
    [self setUpHeaderView];
    self.headerView.qmui_height = 105;
    self.tableView.tableHeaderView = self.headerView;
    _bottomView = [[YSFlowFormBottomView alloc] init];
    [_bottomView.handleButton setTitle:@"确认" forState:UIControlStateNormal];
    [_bottomView.transButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomHeight);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    [self bottomViewClick];
}
- (void)setUpHeaderView {
    self.headerView = [[UIView alloc]init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kGrayColor(153);
    label.text = @"全选为";
    [self.headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        
    }];
    
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = kGrayColor(240);
    [self.headerView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    
    NSMutableArray *btnArr = [NSMutableArray array];
    for (int i = 0; i < self.expenseCategoryArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        [self.headerView addSubview:btn];
        btn.tag = 500 + i;
        [btn setTitle:self.expenseCategoryArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:kGrayColor(51) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:kGrayColor(240)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(clickCategory:) forControlEvents:UIControlEventTouchUpInside];
        [btnArr addObject:btn];
    }
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:15 tailSpacing:15];
    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).mas_equalTo(10);
        make.bottom.mas_equalTo(sepView.mas_top).offset(-10);
        make.height.mas_equalTo(30);
    }];
}
#pragma mark - 提交修改
- (void)bottomViewClick {
    [self.view endEditing:YES];
    [_bottomView.sendActionSubject subscribeNext:^(UIButton *button) {
        if (button.tag == 0) {//确认按钮
            NSMutableArray *paraArr = [NSMutableArray array];
            for (YSFlowExpensePexpShareModel *model in self.dataSourceArray) {//费用类型（电费、水费）
                for (YSFlowExpenseShareDetailModel *departModel in model.marketShareDetailList) {//部门
                    CGFloat total = departModel.operateCost + departModel.noOperateCost + departModel.fixedSubsidy + departModel.compBear;
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:[NSString stringWithFormat:@"%.2f",departModel.money] forKey:@"money"];
                    [dic setValue:model.id forKey:@"expShareId"];
                    [dic setValue:departModel.id forKey:@"id"];
                    [dic setValue:departModel.costOwnerDept forKey:@"costOwnerDept"];
                    [dic setValue:@(departModel.operateCost) forKey:@"operateCost"];//exFinaOperateCost
                    [dic setValue:@(departModel.noOperateCost) forKey:@"noOperateCost"];
                    [dic setValue:@(departModel.fixedSubsidy) forKey:@"fixedSubsidy"];
                    [dic setValue:@(departModel.compBear) forKey:@"compBear"];
                    [paraArr addObject:dic];
                    DLog(@"total=====%0.2f",ABS(total - departModel.money));
                    if (ABS(total - departModel.money) > 0.01) {
                        [QMUITips showError:[NSString stringWithFormat:@"%@中的%@计算结果和总额不符",model.emsTypeName,departModel.costOwnerDept] inView:self.view hideAfterDelay:3.5];
                        return;
                    }
                }
            }
           //提交数据
            [QMUITips showLoadingInView:self.view];
            [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,updateFinaExpAccountInfoApi] isNeedCache:NO parameters:paraArr successBlock:^(id response) {
                [QMUITips hideAllTipsInView:self.view];
                if ([response[@"code"] integerValue] == 1) {
                    [QMUITips showSucceed:@"修改成功" inView:self.view hideAfterDelay:2];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        DLog(@"%@",[NSThread currentThread]);
                        if (self.modifySuccessBlock) {
                            self.modifySuccessBlock();
                        }
                    });
                   
                }
                
            } failureBlock:^(NSError *error) {
                [QMUITips hideAllTipsInView:self.view];
            } progress:nil];
            
            
        }else{//取消，所填数据置空
            for (YSFlowExpensePexpShareModel *model in self.dataSourceArray) {
                
                for (YSFlowExpenseShareDetailModel *departModel in model.marketShareDetailList) {//部门
                    departModel.detailItem = nil;
                    [self.tableView reloadData];
                }
            }
        }
    }];
}
#pragma mark - 费用分类点击
- (void)clickCategory:(UIButton *)button {
    [self.view endEditing:YES];
    for (UIButton *view in self.headerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.tag == button.tag) {
                view.selected = YES;
            }else{
                view.selected = NO;
            }
        }
        
    }
    NSInteger index = button.tag - 500;
    for (YSFlowExpensePexpShareModel *model in self.dataSourceArray) {//费用类型（电费、水费）
        for (YSFlowExpenseShareDetailModel *departModel in model.marketShareDetailList) {//部门
            for (int i = 0; i < self.expenseCategoryArr.count; i++) {//departModel.detailItem(经营性费用","非经营性费用","固定补贴","公司承担)
                switch (i) {
                    case 0:
                        departModel.operateCost = 0 == index ? departModel.money:0.00;
                        break;
                    case 1:
                        departModel.noOperateCost = 1 == index ? departModel.money:0.00;
                        break;
                    case 2:
                        departModel.fixedSubsidy = 2 == index ? departModel.money:0.00;
                        break;
                    case 3:
                        departModel.compBear = 3 == index ? departModel.money:0.00;
                        break;
    
                    default:
                        break;
                }
            }
    }
    }
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        NSString *str = @"open";
        self.openArr[i] = str;
    }
    [self.tableView reloadData];
}

#pragma mark - tableViewDataSource,tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFlowExpensePexpShareModel *model = self.dataSourceArray[section];
    if ([self.openArr[section] isEqualToString:@"open"]) {
        return model.marketShareDetailList.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowExpensePexpShareModel *model = self.dataSourceArray[indexPath.section];
    YSFlowExpenseShareDetailModel *departModel = model.marketShareDetailList[indexPath.row];
    YSExpenseEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSExpenseEditCell"];
    if (cell == nil) {
        cell = [[YSExpenseEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSExpenseEditCell"];
    }
    cell.model = departModel;
    cell.delegate = self;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSFlowExpensePexpShareModel *model = self.dataSourceArray[section];
    YSExpenseShareHeaderView *view = [[YSExpenseShareHeaderView alloc]init];
    [view updateConstraintForExpenseHeader];
    view.model = model;
    [view.arrowBtn setTitle:@"   " forState:UIControlStateNormal];
    view.delegate = self;
    view.tag = 500 + section;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowExpensePexpShareModel *model = self.dataSourceArray[indexPath.section];
    YSFlowExpenseShareDetailModel *departModel = model.marketShareDetailList[indexPath.row];
    CGSize departSize = [departModel.costOwnerDept boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
   
    if (kSCREEN_WIDTH - 100 < departSize.width) {
        CGSize newDepartSize = [departModel.costOwnerDept boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 100 -15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        return 230 + newDepartSize.height - 21;
    }else{
       return 230;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - YSFlowRecheckScoreHeaderView 代理方法
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
#pragma mark - YSExpenseEditCellDelegate 代理方法
- (void)expenseEditCell:(YSExpenseEditCell *)cell position:(NSDictionary *)dic {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger index = indexPath.section * 4 + [[dic allKeys].firstObject integerValue];
    self.inputArray[index] = [dic allValues].firstObject;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
