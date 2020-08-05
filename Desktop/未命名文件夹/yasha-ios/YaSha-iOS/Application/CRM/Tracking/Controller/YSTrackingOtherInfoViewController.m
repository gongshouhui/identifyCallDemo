//
//  YSTrackingOtherInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/12/26.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSTrackingOtherInfoViewController.h"
#import "YSFlowFormListCell.h"
#import "YSFlowFormSectionHeaderView.h"
#import "YSFlowAttachmentViewController.h"
#import "YSReporetModel.h"

@interface YSTrackingOtherInfoViewController ()
@property (nonatomic, strong) NSMutableArray *expensePersonArr;
@property (nonatomic,strong)YSReporetModel *model;
@property (nonatomic,strong)YSReporetInfoModel *infoModel;
@property (nonatomic,strong)YSAssessmentOtherModel *otherModel;

@end

@implementation YSTrackingOtherInfoViewController
- (NSMutableArray *)expensePersonArr {
    if (!_expensePersonArr) {
        _expensePersonArr = [NSMutableArray array];
    }
    return _expensePersonArr;
}
- (void)initSubviews {
    [super initSubviews];
    self.title = @"";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attachmentList) name:@"attachment" object:nil];
    [self doNetworking];
}

- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-40*kHeightScale-kTopHeight);
}

- (void)attachmentList {
    if (self.model.fileVos.count>0) {
        YSFlowAttachmentViewController *FlowAttachmentViewController = [[YSFlowAttachmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
        FlowAttachmentViewController.attachMentArray = self.model.fileVos;
        [self.navigationController pushViewController:FlowAttachmentViewController animated:YES];
    }else {
        [QMUITips showInfo:@"暂无附件" inView:self.view hideAfterDelay:1];
    }
}
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getProReportInfoByIdApi,self.id];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:@{@"type":@"BAPG"} successBlock:^(id response) {
        DLog(@"------%@",response);
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            self.dataSource = [YSDataManager getReporedInfoData:response];
            self.model = self.dataSource[0];
            [self handleData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
    
}
- (void)handleData {
    NSMutableArray *otherArray = [NSMutableArray array];
    self.infoModel = self.model.proReportInfo;
    self.otherModel = self.infoModel.proAssessmentOther;
    [otherArray addObject:@{@"业务阶段":self.infoModel.bizStatusStr}];
    [otherArray addObject:@{@"跟踪动态":[YSUtility cancelNullData:self.otherModel.trackStateStr]}];
    [otherArray addObject:@{@"是否放弃":[YSUtility judgeWhetherOrNot:self.otherModel.isGiveUp]}];
    [self.expensePersonArr addObject:@{@"其他信息":otherArray}];
    NSMutableArray *informationArray = [NSMutableArray array];
    [informationArray addObject:@{@"是否资审":[YSUtility judgeWhetherOrNot:self.otherModel.isCapitalAudit]}];
    [informationArray addObject:@{@"报名/资审日期":[YSUtility timestampSwitchTime:self.otherModel.capitalAuditDate andFormatter:@"yyyy-MM-dd"]}];
    [informationArray addObject:@{@"报名/资审结果":[YSUtility judgeWhetherOrPass:self.otherModel.capitalAuditResult]}];
    [self.expensePersonArr addObject:@{@"报名资审":informationArray}];
    NSMutableArray *tenderArray = [NSMutableArray array];
    [tenderArray addObject:@{@"标前评审日期":[YSUtility timestampSwitchTime:self.otherModel.preReviewDate andFormatter:@"yyyy-MM-dd"]}];
    [tenderArray addObject:@{@"投标日期":[YSUtility timestampSwitchTime:self.otherModel.bidDate andFormatter:@"yyyy-MM-dd"]}];//qualityRequirement
    [tenderArray addObject:@{@"质量要求":[YSUtility cancelNullData:self.otherModel.qualityRequirement]}];

    [tenderArray addObject:@{@"保证金金额(万元)":[NSString stringWithFormat:@"%@ %@",self.otherModel.bondMoney.length > 0 ?self.infoModel.preWinnMoneyCurrencyStr:@"",[YSUtility cancelNullData:self.otherModel.bondMoney]] }];
    [tenderArray addObject:@{@"保证金类型":self.otherModel.bondTypeStr}];
    [tenderArray addObject:@{@"是否转履约":[YSUtility judgeWhetherOrNot:self.otherModel.isPerformance]}];
    [tenderArray addObject:@{@"投标项目经理":self.otherModel.bidManager}];
    [tenderArray addObject:@{@"是否出场":[YSUtility judgeWhetherOrNot:self.otherModel.isOut]}];
    [tenderArray addObject:@{@"出场日期":[YSUtility timestampSwitchTime:self.otherModel.outDate andFormatter:@"yyyy-MM-dd"]}];
    [tenderArray addObject:@{@"商务标":self.otherModel.businessStandard}];
    [tenderArray addObject:@{@"技术标":self.otherModel.technologyStandard}];
    [tenderArray addObject:@{@"资信标":self.otherModel.creditworthinessStandard}];
    [tenderArray addObject:@{@"其他配合":self.otherModel.otherCoordination}];
    [self.expensePersonArr addObject:@{@"投标阶段":tenderArray}];
    NSMutableArray *endArray = [NSMutableArray array];
    [endArray addObject:@{@"是否有开标反馈":[YSUtility judgeWhetherOrNot:self.otherModel.isHaveFeedback]}];
    [endArray addObject:@{@"开标结果":self.otherModel.bidOpenResultStr}];
    [endArray addObject:@{@"中标日期":[YSUtility timestampSwitchTime:self.otherModel.winBidDate andFormatter:@"yyyy-MM-dd"]}];
    [endArray addObject:@{@"中标金额(万元)":[NSString stringWithFormat:@"%@ %@",self.otherModel.winBidMoney.length > 0 ?self.infoModel.preWinnMoneyCurrencyStr:@"",[YSUtility cancelNullData:self.otherModel.winBidMoney]]}];
    [endArray addObject:@{@"是否有中标通知书":[YSUtility judgeWhetherOrNot:self.otherModel.isHaveNotice]}];
    [endArray addObject:@{@"合同项目经理":self.otherModel.contractProManager}];
    [endArray addObject:@{@"合同签订日期":[YSUtility timestampSwitchTime:self.otherModel.contractSignedDate andFormatter:@"yyyy-MM-dd"]}];
    [self.expensePersonArr addObject:@{@"结束阶段":endArray}];
    [self.tableView cyl_reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.expensePersonArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.expensePersonArr[section] allValues].firstObject count];
}
#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.expensePersonArr[section];
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    flowFormSectionHeaderView.backgroundColor = kGrayColor(247);
    flowFormSectionHeaderView.titleLabel.text = [dic allKeys].firstObject;
    return flowFormSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  30*kHeightScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.expensePersonArr[indexPath.section];
    NSArray *valueArr = [dic allValues].firstObject;
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell setExpenseDetailWithDictionary:valueArr[indexPath.row] Model:nil];
    NSDictionary *dicTitle = valueArr[indexPath.row];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:[dicTitle allKeys].firstObject];
    //找出特定字符在整个字符串中的位置
    NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:redRange];
    [cell.lableNameLabel setAttributedText:contentStr];
    cell.valueLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
