//
//  YSFlowTripChangeViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/7/26.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowTripChangeViewController.h"
#import "YSFlowDetailPageController.h"

@interface YSFlowTripChangeViewController ()
@property (nonatomic, strong) NSMutableArray *expensePersonArr;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;//整体表单数据模型
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;//考勤机申请信息数据模型

@end

@implementation YSFlowTripChangeViewController
- (NSMutableArray *)expensePersonArr {
    if (!_expensePersonArr) {
        _expensePersonArr = [NSMutableArray array];
    }
    return _expensePersonArr;
}

- (void)initSubviews {
    [super initSubviews];
//    self.flowFormHeaderView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 108*kHeightScale);
//    [self.flowFormHeaderView.actionButton removeFromSuperview];
    [self.flowFormHeaderView hiddenActionButton];
    [self monitorAction];
   
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain,getBusinessInfoExtraByCodeApi,self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"出差变更申请流程:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.info;
            [self setUpData];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)setUpData {
    [self.expensePersonArr addObject:@{@"取消出差":[self.flowAssetsApplyFormListModel.cancel integerValue]==0?@"否":@"是" }];
    if ([self.flowAssetsApplyFormListModel.cancel integerValue]==0) {
        [self.expensePersonArr addObject:@{@"实际出差日期":[YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.actualStartTime andFormatter:@"yyyy年MM月dd日"]}];
        [self.expensePersonArr addObject:@{@"实际返程日期":[YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.actualEndTime andFormatter:@"yyyy年MM月dd日"]}];
    }   
    [self.expensePersonArr addObject:@{@"备注":self.flowAssetsApplyFormListModel.remark}];
    [self.expensePersonArr addObject:@{@"原出差流程":self.flowAssetsApplyFormListModel.businessInfoCode}];
    [self.dataSourceArray addObject:@{@"申请信息":self.expensePersonArr}];
    
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
    NSDictionary *contentDic = valueArr[indexPath.row];
    if ([[contentDic allKeys].firstObject hasPrefix:@"原出差流程"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setExpenseDetailWithDictionary:valueArr[indexPath.row] Model:self.flowAssetsApplyFormListModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSourceArray[indexPath.section];
    NSArray *valueArr = [dic allValues].firstObject;
    NSDictionary *contentDic = valueArr[indexPath.row];
    if ([[contentDic allKeys].firstObject hasPrefix:@"原出差流程"]) {
        YSFlowDetailPageController *flowDetailPageController = [[YSFlowDetailPageController alloc] init];
        flowDetailPageController.flowType = self.flowType;
        YSFlowListModel *cellModel = [[YSFlowListModel alloc]init];
        DLog(@"=======%@",self.flowAssetsApplyFormListModel.processInstanceId);
        cellModel.processInstanceId = self.flowAssetsApplyFormListModel.businessInfoProcessId;
        cellModel.businessKey =self.flowAssetsApplyFormListModel.businessInfoCode;
        DLog(@"=======%@",self.flowAssetsApplyFormListModel.businessInfoCode);
        YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:@"ems_business_flow"];
        //获得plist文件数据model
        flowDetailPageController.flowModel = flowModel;
        //获得流程列表数据model
        flowDetailPageController.cellModel = cellModel;
        //判断是否可以在手机端处理
        if (flowModel.isMobile) {
            [flowDetailPageController reloadData];
            [self.navigationController pushViewController:flowDetailPageController animated:YES];
        } else {
            [QMUITips showInfo:@"此流程仅支持电脑端处理" inView:self.view hideAfterDelay:1];
        }
    }
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
    return 30*kHeightScale;
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
    return 200*kHeightScale;
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
