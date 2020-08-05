//
//  YSMQProjectApplyViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/8/17.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQProjectApplyViewController.h"

@interface YSMQProjectApplyViewController ()
@property (nonatomic, strong) NSMutableArray *expensePersonArr;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;//整体表单数据模型
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;//考勤机申请信息数据模型
@end

@implementation YSMQProjectApplyViewController

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
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getMQPersonApplyRequireFlowDetail, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取幕墙人员需求申请流程详情:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.info;
            [self doWithData];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)doWithData {
    
    if ([self.flowAssetsApplyFormListModel.mqPersonApply.applyNatureStr isEqualToString:@"直营"]) {
        [self.expensePersonArr addObject:@{@"项目名称":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.proName]}];
        [self.expensePersonArr addObject:@{@"所属部门":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.proDeptName]}];
        [self.expensePersonArr addObject:@{@"项目地址":[NSString stringWithFormat:@"%@%@%@",[YSUtility judgeData:self.flowAssetsApplyFormListModel.baseInfo.province],[YSUtility judgeData:self.flowAssetsApplyFormListModel.baseInfo.city],[YSUtility judgeData:self.flowAssetsApplyFormListModel.baseInfo.address]]}];
        [self.expensePersonArr addObject:@{@"项目性质":[YSUtility judgeData:self.flowAssetsApplyFormListModel.baseInfo.proNatureName]}];
        [self.expensePersonArr addObject:@{@"合同价":[YSUtility judgeData:self.flowAssetsApplyFormListModel.baseInfo.contPrice]}];
        
        [self.expensePersonArr addObject:@{@"执行经理":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.proManagerName]}];
        [self.expensePersonArr addObject:@{@"项目负责人":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.proGeneralManager]}];
//        [self.expensePersonArr addObject:@{@"幕墙类型":@""}];
        [self.expensePersonArr addObject:@{@"现有人员数量":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.currentPersonCount]}];
        [self.expensePersonArr addObject:@{@"申请人员数量":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.requireCount]}];
    }else{
        [self.expensePersonArr addObject:@{@"所属部门":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.proDeptName]}];
        [self.expensePersonArr addObject:@{@"考核总监":@""}];
        [self.expensePersonArr addObject:@{@"负责项目数量":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.projectCount]}];
        [self.expensePersonArr addObject:@{@"现有人员数量":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.currentPersonCount]}];
        [self.expensePersonArr addObject:@{@"申请人员数量":[YSUtility judgeData:self.flowAssetsApplyFormListModel.mqPersonApply.requireCount]}];
    }
    
    [self.dataSourceArray addObject:@{@"基础信息":_expensePersonArr}];
    for (int i = 0 ; i < self.flowAssetsApplyFormListModel.personApplyRequire.count; i++) {
        YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.personApplyRequire[i];
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObject:@{@"申请岗位":[YSUtility judgeData:applyInfosModel.station]}];
        [tempArray addObject:@{@"申请原因":[YSUtility judgeData:applyInfosModel.postStr]}];
        [tempArray addObject:@{@"申请数量":[YSUtility judgeData:applyInfosModel.requireCount]}];
        [tempArray addObject:@{@"现有数量":[YSUtility judgeData:applyInfosModel.existingCount]}];
        [tempArray addObject:@{@"要求到岗日期":[[YSUtility judgeData: applyInfosModel.enterDate] substringToIndex:10]}];
        [tempArray addObject:@{@"项目兼职":[YSUtility judgeData:applyInfosModel.partTime ]}];
        [tempArray addObject:@{@"建议人员":[YSUtility judgeData:applyInfosModel.relName]}];
        [tempArray addObject:@{@"人员要求":[YSUtility judgeData:applyInfosModel.remark ]}];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
        NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:i+1]];
        NSLog(@"str = %@", string);
        [self.dataSourceArray addObject:@{[NSString stringWithFormat:@"人员需求细则 · %@",string]:tempArray}];
    }
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
