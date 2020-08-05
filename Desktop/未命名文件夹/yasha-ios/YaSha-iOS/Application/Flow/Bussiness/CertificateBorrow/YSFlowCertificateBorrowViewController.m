//
//  YSFlowCertificateBorrowViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/10/9.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowCertificateBorrowViewController.h"
#import "YSFlowAttachmentViewController.h"
#import "YSCertificateBorrowDetailsController.h"
#import "YSNewsAttachmentModel.h"

@interface YSFlowCertificateBorrowViewController ()
@property (nonatomic, strong) NSMutableArray *attachmentArray;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;//整体表单数据模型
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;//考勤机申请信息数据模型
@property (nonatomic, strong) NSMutableArray *expensePersonArr;
@property (nonatomic, strong) UIButton *attachmentBtn;
@property (nonatomic,strong) UILabel *attachLb;
@end

@implementation YSFlowCertificateBorrowViewController

#pragma mark -- 懒加载
- (NSMutableArray *)expensePersonArr {
    if(!_expensePersonArr) {
        _expensePersonArr = [NSMutableArray array];
    }
    return  _expensePersonArr;
}
- (UILabel *)attachLb {
    if (!_attachLb) {
        _attachLb = [[UILabel alloc]init];
        _attachLb.layer.masksToBounds = YES;
        _attachLb.layer.cornerRadius = 13;
        _attachLb.backgroundColor = [UIColor redColor];
        _attachLb.textColor = [UIColor whiteColor];
        _attachLb.textAlignment = NSTextAlignmentCenter;
    }
    return _attachLb;
}
-(void)initSubviews {
    [super initSubviews];
    self.attachmentArray = [NSMutableArray array];
    [self.flowFormHeaderView.actionButton setTitle:@"附件" forState:UIControlStateNormal];
    _attachmentBtn = [[UIButton alloc]init];
    _attachmentBtn.frame = CGRectMake(0, 108*kHeightScale, kSCREEN_WIDTH, 60*kHeightScale);
    _attachmentBtn.backgroundColor = [UIColor clearColor];
    [_attachmentBtn addTarget:self action:@selector(attachment) forControlEvents:UIControlEventTouchUpInside];
    [self.flowFormHeaderView addSubview:_attachmentBtn];
    //附件个数
    [self.flowFormHeaderView addSubview:self.attachLb];
    [self.attachLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-30);
        make.height.width.mas_equalTo(26);
    }];
    [self monitorAction];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getBorrowingDetailApi, self.cellModel.businessKey];
    DLog(@"========%@",urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"证书借用流程详情:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
           self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.info;
           [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            [self setUpData];
            if (self.flowAssetsApplyFormListModel.zsjyfj.count) {
                self.attachLb.hidden = NO;
                self.attachLb.text = [NSString stringWithFormat:@"%ld",self.flowAssetsApplyFormListModel.zsjyfj.count];
            }else{
                self.attachLb.hidden = YES;
            }
           
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void)setUpData {
    [self.expensePersonArr addObject:@{@"项目分类":self.flowAssetsApplyFormListModel.projectClass}];
    [self.expensePersonArr addObject:@{@"借用日期":[YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.borrowTime andFormatter:@"yyyy-MM-dd"]}];
    [self.expensePersonArr addObject:@{@"预计归还日期":[YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.expectreturnTime andFormatter:@"yyyy-MM-dd"]}];
    if ([self.flowAssetsApplyFormListModel.projectClass isEqualToString:@"工管项目"]) {
        [self.expensePersonArr addObject:@{@"项目所属公司":self.flowAssetsApplyFormListModel.staffCompony}];
        [self.expensePersonArr addObject:@{@"借用工程项目":self.flowAssetsApplyFormListModel.projectName}];
        [self.expensePersonArr addObject:@{@"项目所属部门":self.flowAssetsApplyFormListModel.projectDept}];
        [self.expensePersonArr addObject:@{@"是否押证":[self.flowAssetsApplyFormListModel.isMortgage isEqualToString:@"n"]?@"否":@"是"}];
    }else if([self.flowAssetsApplyFormListModel.projectClass isEqualToString:@"分公司营销项目"] ||[self.flowAssetsApplyFormListModel.projectClass isEqualToString:@"公司营销项目"]){
        [self.expensePersonArr addObject:@{@"借用营销项目":self.flowAssetsApplyFormListModel.projectName}];
        [self.expensePersonArr addObject:@{@"是否押证":[self.flowAssetsApplyFormListModel.isMortgage isEqualToString:@"n"]?@"否":@"是"}];
    }
    [self.expensePersonArr addObject:@{@"用途":self.flowAssetsApplyFormListModel.purpose}];
    [self.expensePersonArr addObject:@{@"证书信息":[NSString stringWithFormat:@"%lu",(unsigned long)self.flowAssetsApplyFormListModel.zsjylb.count]}];
    [self.dataSourceArray addObject:@{@"借用事项":self.expensePersonArr}];
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
    if ([[contentDic allKeys].firstObject hasPrefix:@"证书信息"]) {
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSourceArray[indexPath.section];
    NSArray *valueArr = [dic allValues].firstObject;
    NSDictionary *contentDic = valueArr[indexPath.row];
    if ([[contentDic allKeys].firstObject hasPrefix:@"证书信息"]) {
        if (self.flowAssetsApplyFormListModel.zsjylb.count>0) {
            YSCertificateBorrowDetailsController *FlowHRInfoViewController = [[YSCertificateBorrowDetailsController alloc] initWithStyle:UITableViewStyleGrouped];
            FlowHRInfoViewController.listData = self.flowAssetsApplyFormListModel.zsjylb;
            [self.navigationController pushViewController:FlowHRInfoViewController animated:YES];
        }else{
            [QMUITips showInfo:@"暂无证书信息" inView:self.view hideAfterDelay:1];
        }
    }
}
#pragma mark - 查看附件
- (void)attachment {
    
    if (self.flowAssetsApplyFormListModel.zsjyfj.count > 0) {
        YSFlowAttachmentViewController *FlowAttachmentViewController = [[YSFlowAttachmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
        FlowAttachmentViewController.attachMentArray = self.flowAssetsApplyFormListModel.zsjyfj;
        [self.navigationController pushViewController:FlowAttachmentViewController animated:YES];
    }else{
        [QMUITips showInfo:@"暂无附件信息" inView:self.view hideAfterDelay:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

