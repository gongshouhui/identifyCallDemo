//
//  YSFlowInterContactsViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/8/6.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowInterContactsViewController.h"
#import "YSFlowAttachmentViewController.h"


@interface YSFlowInterContactsViewController ()
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;//整体表单数据模型
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;//考勤机申请信息数据模型
@property (nonatomic, strong) UIButton *attachmentBtn;
@property (nonatomic, strong) NSMutableArray *expensePersonArr;


@end

@implementation YSFlowInterContactsViewController

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
    [self.flowFormHeaderView addSubview:_attachmentBtn];
    [self monitorAction];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getIntercourseFlowDetailApi, self.cellModel.businessKey];
    DLog(@"========%@",urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"入职信息流程详情:%@", response);
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
    [self.expensePersonArr addObject:@{@"人员工号":self.flowAssetsApplyFormListModel.staffNo}];
    [self.expensePersonArr addObject:@{@"移除人员":self.flowAssetsApplyFormListModel.staffName}];
    
    [self.expensePersonArr addObject:@{@"时间":[YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.dealTime[@"time"] andFormatter:@"yyyy-MM-dd"]}];
    [self.expensePersonArr addObject:@{@"隶属公司":self.flowAssetsApplyFormListModel.company}];
    [self.expensePersonArr addObject:@{@"抄送部门":self.flowAssetsApplyFormListModel.companyDept}];
    [self.expensePersonArr addObject:@{@"发出部门":self.flowAssetsApplyFormListModel.sendDept}];
    [self.expensePersonArr addObject:@{@"事由":self.flowAssetsApplyFormListModel.reason}];
    [self.dataSourceArray addObject:@{@"申请信息":self.expensePersonArr}];
}

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
    
    if (self.flowAssetsApplyFormListModel.mobileFiles.count > 0) {
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
