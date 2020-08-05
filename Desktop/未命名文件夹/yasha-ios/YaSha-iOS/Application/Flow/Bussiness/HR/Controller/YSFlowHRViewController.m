//
//  YSFlowHRViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/4/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowHRViewController.h"
#import "YSFlowHRInfoViewController.h"
#import "YSFlowAttachmentViewController.h"

@interface YSFlowHRViewController ()
@property (nonatomic, strong) NSArray *employees;//人员信息数组
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;//整体表单数据模型
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;//考勤机申请信息数据模型
@property (nonatomic, strong) UIButton *attachmentBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) NSMutableArray *expensePersonArr;

@end

@implementation YSFlowHRViewController

- (NSMutableArray *)expensePersonArr {
    if(!_expensePersonArr) {
        _expensePersonArr = [NSMutableArray array];
    }
    return  _expensePersonArr;
}
- (void)initSubviews {
    [super initSubviews];
    [self.flowFormHeaderView.actionButton setTitle:@"附件" forState:UIControlStateNormal];
    _attachmentBtn = [[UIButton alloc]init];
    _attachmentBtn.frame = CGRectMake(0, 108*kHeightScale, kSCREEN_WIDTH, 60*kHeightScale);
    _attachmentBtn.backgroundColor = [UIColor clearColor];
    [_attachmentBtn addTarget:self action:@selector(attachment) forControlEvents:UIControlEventTouchUpInside];
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(320*kWidthScale, 17*kHeightScale, 26*kWidthScale, 26*kHeightScale)];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.layer.masksToBounds = YES;
    _numLabel.layer.cornerRadius = 13.0*kHeightScale;
    _numLabel.backgroundColor = [UIColor redColor];
    [_attachmentBtn addSubview:_numLabel];
    [self.flowFormHeaderView addSubview:_attachmentBtn];
    [self monitorAction];
}

- (void)doNetworking {
    NSString *urlString;
    if ([self.cellModel.processDefinitionKey isEqual:@"cshr_entry"]) {
        //入职流程
        urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, approveJoinApi, self.cellModel.businessKey,self.cellModel.processInstanceId];
    }else if([self.cellModel.processDefinitionKey isEqual:@"cshr_salary"]){
        //调薪流程
        urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, approveAdjustSalaryApi, self.cellModel.businessKey,self.cellModel.processInstanceId];
    }
    DLog(@"========%@",urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"入职信息流程详情:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.info;
            self.employees = self.flowAssetsApplyFormListModel.employees;
            [self setUpData];
            if (self.flowAssetsApplyFormListModel.mobileFiles.count > 0) {
                _numLabel.hidden = NO;
                _numLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)self.flowAssetsApplyFormListModel.mobileFiles.count];
            }else {
                _numLabel.hidden = YES;
            }
            
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)setUpData {
    if ([self.cellModel.processDefinitionKey isEqual:@"cshr_entry"]) {
        //入职流程
        [self.expensePersonArr addObject:@{@"项目名称":self.flowAssetsApplyFormListModel.projectName}];
        [self.expensePersonArr addObject:@{@"项目经理":self.flowAssetsApplyFormListModel.projectManagerName}];
        [self.expensePersonArr addObject:@{@"备注":self.flowAssetsApplyFormListModel.remark}];
        [self.expensePersonArr addObject:@{@"人员信息详情":[NSString stringWithFormat:@"%ld",(unsigned long)self.flowAssetsApplyFormListModel.employees.count]}];
        [self.dataSourceArray addObject:@{@"申请信息":self.expensePersonArr}];
    }else if([self.cellModel.processDefinitionKey isEqual:@"cshr_salary"]){
        //调薪流程
        [self.expensePersonArr addObject:@{@"项目名称":self.flowAssetsApplyFormListModel.projectName}];
        [self.expensePersonArr addObject:@{@"项目经理":self.flowAssetsApplyFormListModel.projectManagerName}];
        [self.expensePersonArr addObject:@{@"调整日薪":self.flowAssetsApplyFormListModel.dailYwageNew}];
        [self.expensePersonArr addObject:@{@"调薪生效日期":self.flowAssetsApplyFormListModel.effectiveDate}];
        [self.expensePersonArr addObject:@{@"备注":self.flowAssetsApplyFormListModel.remark}];
        [self.expensePersonArr addObject:@{@"人员信息详情":[NSString stringWithFormat:@"%ld",(unsigned long)self.flowAssetsApplyFormListModel.employees.count]}];
        [self.dataSourceArray addObject:@{@"申请信息":self.expensePersonArr}];
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
    NSDictionary *contentDic = valueArr[indexPath.row];
    if ([[contentDic allKeys].firstObject hasPrefix:@"人员信息详情"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setExpenseDetailWithDictionary:valueArr[indexPath.row] Model:self.flowAssetsApplyFormListModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSourceArray[indexPath.section];
    NSArray *valueArr = [dic allValues].firstObject;
    NSDictionary *contentDic = valueArr[indexPath.row];
    if ([[contentDic allKeys].firstObject hasPrefix:@"人员信息详情"]) {
        if (self.employees.count > 0) {
            YSFlowHRInfoViewController *FlowHRInfoViewController = [[YSFlowHRInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
            FlowHRInfoViewController.infoArray = self.employees;
            [self.navigationController pushViewController:FlowHRInfoViewController animated:YES];
        }else{
            [QMUITips showInfo:@"暂无人员信息" inView:self.view hideAfterDelay:1];
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
- (void)attachment {
    if (self.flowAssetsApplyFormListModel.mobileFiles > 0) {
        YSFlowAttachmentViewController *FlowAttachmentViewController = [[YSFlowAttachmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
        FlowAttachmentViewController.attachMentArray = self.flowAssetsApplyFormListModel.mobileFiles;
        [self.navigationController pushViewController:FlowAttachmentViewController animated:YES];
    }else{
        [QMUITips showInfo:@"暂无附件信息" inView:self.view hideAfterDelay:1];
    }
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
