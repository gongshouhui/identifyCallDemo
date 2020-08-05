//
//  YSMQProjectSecondedViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/8/17.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQProjectSecondedViewController.h"

@interface YSMQProjectSecondedViewController ()
@property (nonatomic, strong) NSMutableArray *expensePersonArr;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;//整体表单数据模型
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;//考勤机申请信息数据模型
@end

@implementation YSMQProjectSecondedViewController
- (NSMutableArray *)expensePersonArr {
    if (!_expensePersonArr) {
        _expensePersonArr = [NSMutableArray array];
    }
    return _expensePersonArr;
}

- (void)initSubviews {
    [super initSubviews];
    [self monitorAction];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getMQPersonAllotFlowDetail, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取幕墙人员调派申请流程详情:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.info;
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            [self doWithData];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)doWithData {
    //基础信息
//    [self.expensePersonArr addObject:@{@"调动类型":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.transferTypeStr]}];
    [self.expensePersonArr addObject:@{@"姓名":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.personName]}];
    [self.expensePersonArr addObject:@{@"所属部门":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.deptName]}];
    [self.expensePersonArr addObject:@{@"调派原因":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.allotType]}];
    [self.expensePersonArr addObject:@{@"要求到岗日期":self.flowAssetsApplyFormListModel.mqPersonAllot.enterDate.length>10?[self.flowAssetsApplyFormListModel.mqPersonAllot.enterDate substringToIndex:10]:@""}];
    [self.dataSourceArray addObject:@{@"基础信息":_expensePersonArr}];
    //调出信息
    NSMutableArray *tuneOutArray = [NSMutableArray array];
    if ([self.flowAssetsApplyFormListModel.mqPersonAllot.calloutTypeStr isEqualToString:@"项目部"]) {
        [tuneOutArray addObject:@{@"项目名称":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.oproName]}];
        [tuneOutArray addObject:@{@"所属部门":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.calloutDeptName]}];
        [tuneOutArray addObject:@{@"项目性质":[YSUtility judgeData:self.flowAssetsApplyFormListModel.ObaseInfo.proNatureName]}];
        [tuneOutArray addObject:@{@"执行经理":[YSUtility judgeData:self.flowAssetsApplyFormListModel.ObaseInfo.proManName]}];
        [tuneOutArray addObject:@{@"项目任职":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.duty]}];
        [tuneOutArray addObject:@{@"项目兼职":@""}];
        [tuneOutArray addObject:@{@"备注":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.calloutRemark]}];
    }else{
        [tuneOutArray addObject:@{@"调出部门":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.calloutDeptName]}];
        [tuneOutArray addObject:@{@"调出岗位":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.duty]}];
        [tuneOutArray addObject:@{@"考核总监":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.calloutAssessmentManager]}];
        [tuneOutArray addObject:@{@"负责区域":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.calloutTerritory]}];
        [tuneOutArray addObject:@{@"备注":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.calloutRemark]}];
    }
    [self.dataSourceArray addObject:@{@"调出信息":tuneOutArray}];
    //调出信息
    NSMutableArray *foldArray = [NSMutableArray array];
    if ([self.flowAssetsApplyFormListModel.mqPersonAllot.callinTypeStr isEqualToString:@"项目部"]) {
        [foldArray addObject:@{@"项目名称":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.iproName]}];
        [foldArray addObject:@{@"所属部门":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.callinDeptName]}];
        [foldArray addObject:@{@"项目性质":[YSUtility judgeData:self.flowAssetsApplyFormListModel.IbaseInfo.proNatureName]}];
        [foldArray addObject:@{@"执行经理":[YSUtility judgeData:self.flowAssetsApplyFormListModel.IbaseInfo.proManName]}];
        [foldArray addObject:@{@"项目拟任职":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.projectProposal]}];
        [foldArray addObject:@{@"费用分摊人":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.shareName]}];
        [foldArray addObject:@{@"备注":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.remark]}];
    }else{
        [foldArray addObject:@{@"调入部门":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.callinDeptName]}];
        [foldArray addObject:@{@"调入岗位":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.callinPost]}];
        [foldArray addObject:@{@"考核总监":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.callinAssessmentManager]}];
        [foldArray addObject:@{@"工作联系人":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.conterName]}];
        [foldArray addObject:@{@"负责区域":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.callinTerritory]}];
        [foldArray addObject:@{@"备注":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonAllot.remark]}];
    }
    [self.dataSourceArray addObject:@{@"调入信息":foldArray}];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSourceArray[section] allValues].firstObject count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSourceArray[indexPath.section];
    NSArray *valueArr = [dic allValues].firstObject;
    YSFlowFormListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setExpenseDetailWithDictionary:valueArr[indexPath.row] Model:self.flowAssetsApplyFormListModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.dataSourceArray[section];
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    flowFormSectionHeaderView.backgroundColor = kGrayColor(247);
    flowFormSectionHeaderView.titleLabel.text = [dic allKeys].firstObject;
    return flowFormSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  30*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
