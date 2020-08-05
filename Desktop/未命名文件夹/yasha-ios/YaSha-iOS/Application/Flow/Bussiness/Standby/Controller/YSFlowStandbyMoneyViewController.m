//
//  YSFlowStandbyMoneyViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/4/10.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowStandbyMoneyViewController.h"
#import "YSFlowAttachmentViewController.h"

@interface YSFlowStandbyMoneyViewController ()
@property (nonatomic, strong) NSMutableArray *titleArray;//标题数组
@property (nonatomic, strong) NSMutableArray *flowDataSourceArray;//流程数据数组
@property (nonatomic, strong) NSMutableArray *attachmentArray;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;//整体表单数据模型
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;//考勤机申请信息数据模型
@property (nonatomic, strong) NSMutableArray *expensePersonArr;

@end

@implementation YSFlowStandbyMoneyViewController

- (NSMutableArray *)expensePersonArr {
    if (!_expensePersonArr) {
        _expensePersonArr = [NSMutableArray array];
    }
    return _expensePersonArr;
}


- (void)initSubviews {
    [super initSubviews];
    self.attachmentArray = [NSMutableArray array];
//    [self.flowFormHeaderView.actionButton removeFromSuperview];
//    self.flowFormHeaderView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 108*kHeightScale);
    [self.flowFormHeaderView hiddenActionButton];
    [self titleArray];
    [self monitorAction];
}
- (void)doNetworking {
   NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getLoanInfoByCodeApi, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"考勤机流程详情:%@", response);
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

- (void)doWithData{
    [self.expensePersonArr addObject:@{@"备用金类型":self.flowAssetsApplyFormListModel.loanType}];
    [self.expensePersonArr addObject:@{@"申请人":self.flowAssetsApplyFormListModel.loanName}];
    [self.expensePersonArr addObject:@{@"所属部门":self.flowAssetsApplyFormListModel.loanDeptName}];
    [self.expensePersonArr addObject:@{@"职务级别":self.flowAssetsApplyFormListModel.jobLevelStr}];
    if (self.flowAssetsApplyFormListModel.proName.length > 0) {
        [self.expensePersonArr addObject:@{@"工程项目名称":self.flowAssetsApplyFormListModel.proName}];
    }
    [self.expensePersonArr addObject:@{@"收款方":self.flowAssetsApplyFormListModel.loanName}];
    [self.expensePersonArr addObject:@{@"入账公司":self.flowAssetsApplyFormListModel.entryCompName}];
    
    [self.expensePersonArr addObject:@{@"申请金额":[NSString stringWithFormat:@"￥%@",self.flowAssetsApplyFormListModel.loanMoney]}];
    [self.expensePersonArr addObject:@{@"预计还款时间":[YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.planRetDate andFormatter:@"yyyy-MM-dd"]}];
    [self.expensePersonArr addObject:@{@"业务说明":self.flowAssetsApplyFormListModel.remark}];
    [self.expensePersonArr addObject:@{@"附件":[NSString stringWithFormat:@"%ld",self.flowAssetsApplyFormListModel.mobileFiles.count]}];
     [self.dataSourceArray addObject:@{@"申请信息":_expensePersonArr}];
    
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
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *contentDic = valueArr[indexPath.row];
    if ([[contentDic allKeys].firstObject hasPrefix:@"附件"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    self.flowAssetsApplyFormListModel.categoryStr = @"备用金";
    [cell setExpenseDetailWithDictionary:valueArr[indexPath.row] Model:self.flowAssetsApplyFormListModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSourceArray[indexPath.section];
    NSArray *valueArr = [dic allValues].firstObject;
    NSDictionary *contentDic = valueArr[indexPath.row];
    if ([[contentDic allKeys].firstObject hasPrefix:@"附件"]) {
        if (self.flowAssetsApplyFormListModel.mobileFiles.count > 0) {
            YSFlowAttachmentViewController *FlowAttachmentViewController = [[YSFlowAttachmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
            FlowAttachmentViewController.attachMentArray = self.flowAssetsApplyFormListModel.mobileFiles;
            [self.navigationController pushViewController:FlowAttachmentViewController animated:YES];
        }else{
            [QMUITips showInfo:@"暂无附件信息" inView:self.view hideAfterDelay:1];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFlowFormListCell *cell) {
//        [cell setLeftArray:self.titleArray indexPath:indexPath];
//        [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
//
//    }];
//}




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
