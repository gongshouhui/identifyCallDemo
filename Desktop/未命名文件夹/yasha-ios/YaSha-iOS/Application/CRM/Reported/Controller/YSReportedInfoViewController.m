//
//  YSReportedInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/12/19.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReportedInfoViewController.h"
#import "YSFlowAttachmentViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSReporetModel.h"

@interface YSReportedInfoViewController ()
@property (nonatomic,strong)NSDictionary *attachmentDic;
@property (nonatomic,strong)YSReporetInfoModel *infoModel;
@property (nonatomic,strong)YSAssessmentInfoModel *assessmentInfoModel;
@end

@implementation YSReportedInfoViewController
- (void)initTableView {
    [super initTableView];
    self.title = @"项目跟踪情况";
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"附件" position:QMUINavigationButtonPositionRight target:self action:@selector(attachment)];
    [self doNetworking];
}
- (void)attachment {
    if (self.model.fileVos.count>0) {
        YSFlowAttachmentViewController *FlowAttachmentViewController = [[YSFlowAttachmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
        FlowAttachmentViewController.attachMentArray = self.model.fileVos;
        [self.navigationController pushViewController:FlowAttachmentViewController animated:YES];
    }else {
        [QMUITips showInfo:@"暂无附件" inView:self.view hideAfterDelay:1];
    }
}
- (void)layoutTableView {
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-40*kHeightScale-kTopHeight);
    }else {
        [super layoutTableView];
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
    NSMutableArray *proGeneralArr = [NSMutableArray array];
  
    self.infoModel = self.model.proReportInfo;
    [self layoutTableView];
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        self.assessmentInfoModel = self.infoModel.proAssessmentInfo;
        [proGeneralArr addObject:@{@"备案号 *":self.assessmentInfoModel.recordNo}];
        [proGeneralArr addObject:@{@"报备日期 *":[YSUtility timestampSwitchTime:self.assessmentInfoModel.reportDate andFormatter:@"yyyy-MM-dd"]}];
//        [proGeneralArr addObject:@{@"评估通过日期 *":[YSUtility timestampSwitchTime:self.assessmentInfoModel.passDate andFormatter:@"yyyy-MM-dd"]}];
    }
    
    [proGeneralArr addObject:@{@"项目名称 *":self.infoModel.projectName}];
    [proGeneralArr addObject:@{@"工程类别 *":self.infoModel.programmeTypeStr}];
    [proGeneralArr addObject:@{@"项目类型 *":self.infoModel.projectTypeStr}];
    [proGeneralArr addObject:@{@"招标方式 *":self.infoModel.tenderTypeStr}];
    [proGeneralArr addObject:@{@"招标内容 *":self.infoModel.tenderContentStr}];
    [proGeneralArr addObject:@{@"预计投标日期 *":[YSUtility timestampSwitchTime:self.infoModel.tenderExpectDate andFormatter:@"yyyy-MM-dd"]}];
    
    [proGeneralArr addObject:@{@"预计投标金额(万元) *":[NSString stringWithFormat:@"%@ %@",self.infoModel.projectCost.length > 0 ? self.infoModel.projectCostCurrencyStr:@"",[YSUtility judgeIsEmpty:self.infoModel.projectCost]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.projectCost floatValue]]]}];
    [proGeneralArr addObject:@{@"工程面积(平方米) *":[YSUtility judgeIsEmpty:self.infoModel.projectArea]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.projectArea floatValue]]}];
    [proGeneralArr addObject:@{@"工程地址 *":[NSString stringWithFormat:@"%@ %@ %@",self.infoModel.proProvinceName,self.infoModel.proCityName,self.infoModel.proAreaName]}];
    //
    [proGeneralArr addObject:@{@"详细地址 *":[NSString stringWithFormat:@"%@",self.infoModel.proAddress]}];
    [proGeneralArr addObject:@{@"甲方单位 *":self.infoModel.firstPartyCompany}];
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        [proGeneralArr addObject:@{@"是否合作 *":[YSUtility judgeWhetherOrNot:self.assessmentInfoModel.isCooperation]}];
    }
    [proGeneralArr addObject:@{@"甲方项目对接人 *":self.infoModel.firstPartyUser}];
    [proGeneralArr addObject:@{@"甲方项目对接人联系方式 *":self.infoModel.firstPartyUserLink}];
    [proGeneralArr addObject:@{@"甲方项目对接人职务 *":self.infoModel.firstPartyUserPost}];
    [proGeneralArr addObject:@{@"项目所属区域/团队 *":self.infoModel.deptName}];
    [proGeneralArr addObject:@{@"所属团队负责人":self.infoModel.deptLeader}];
    // 新增的
    [proGeneralArr addObject:@{@"所属区域/团队所在公司":self.infoModel.companyName}];
    // 更换位置
    [proGeneralArr addObject:@{@"对接人":self.infoModel.pickUpUserName}];
    [proGeneralArr addObject:@{@"项目跟踪人 *":self.infoModel.proTrackName}];
    [proGeneralArr addObject:@{@"项目跟踪人联系方式*":self.infoModel.proTrackMobile}];
    [proGeneralArr addObject:@{@"是否工管联动*":[YSUtility judgeWhetherOrNot:self.infoModel.isManagementLinkage]}];
    [proGeneralArr addObject:@{@"是否需要智能化支持":[YSUtility judgeWhetherOrNot:self.infoModel.isNeedIntelligentSupport]}];

    [proGeneralArr addObject:@{@"项目自评级 *":self.infoModel.projectSelfGradeStr}];
    [proGeneralArr addObject:@{@"预计定标日期":[YSUtility timestampSwitchTime:self.infoModel.preWinnDate andFormatter:@"yyyy-MM-dd"]}];
    
    //预计进场日期
    [proGeneralArr addObject:@{@"预计进场日期":[YSUtility timestampSwitchTime:self.infoModel.planEnterDate andFormatter:@"yyyy-MM-dd"]}];

    //预计完成日期
    [proGeneralArr addObject:@{@"预计完成日期":[YSUtility timestampSwitchTime:self.infoModel.planFinishDate andFormatter:@"yyyy-MM-dd"]}];

    
    if ([self.infoModel.projectSelfGradeStr isEqualToString:@"AA"]) {
        [proGeneralArr addObject:@{@"预计中标金额(万元)":[NSString stringWithFormat:@"%@ %@",self.infoModel.preWinnMoney.length > 0? self.infoModel.preWinnMoneyCurrencyStr:@"",[YSUtility judgeIsEmpty:self.infoModel.preWinnMoney]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.preWinnMoney floatValue]]]}];
        [proGeneralArr addObject:@{@"项目推进情况":self.infoModel.projectProgressRemark}];
        [proGeneralArr addObject:@{@"问题与支持":self.infoModel.questionSupportRemark}];
    }
    [proGeneralArr addObject:@{@"是否含有工业化装配式 *":[YSUtility judgeWhetherOrNot:self.infoModel.isIndustryConf]}];
    if ([[NSString stringWithFormat:@"%@",self.infoModel.isIndustryConf] isEqualToString:@"1"]) {
        [proGeneralArr addObject:@{@"工业化装配式体量(平方米)":[YSUtility judgeIsEmpty:self.infoModel.industryConfArea]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.industryConfArea floatValue]]}];
        [proGeneralArr addObject:@{@"工业化装配式单方造价(元/平方米)":[NSString stringWithFormat:@"%@ %@",self.infoModel.industryConfPrice.length > 0? self.infoModel.industryConfPriceCurrencyStr:@"",[YSUtility judgeIsEmpty:self.infoModel.industryConfPrice]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.industryConfPrice floatValue]]]}];
        [proGeneralArr addObject:@{@"预计竣工日期":[YSUtility timestampSwitchTime:self.infoModel.planCompleteDate andFormatter:@"yyyy-MM-dd"]}];
        [proGeneralArr addObject:@{@"订单总套数":[YSUtility cancelNullData:self.infoModel.orderCount]}];
        [proGeneralArr addObject:@{@"订单户型个数":[YSUtility cancelNullData:self.infoModel.orderApartmentCount]}];
        [proGeneralArr addObject:@{@"预付款比例(%)":[YSUtility judgeIsEmpty:self.infoModel.advanceChargeProportion]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.advanceChargeProportion floatValue]]}];
    }
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        [proGeneralArr addObject:@{@"备注":self.assessmentInfoModel.remark}];
    }
    [self.dataSourceArray addObject:proGeneralArr];
    [self.tableView cyl_reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32*kHeightScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 32*kHeightScale)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16*kWidthScale, 7, kSCREEN_WIDTH-32*kWidthScale, 18*kHeightScale)];
    label.text = @"基本信息";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kUIColor(153, 153, 153, 1.0);;
    [view addSubview:label];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSPMSInfoDetailHeaderCell *cell =  [ tableView dequeueReusableCellWithIdentifier:@"reuseID"];
    if (cell == nil) {
        cell = [[YSPMSInfoDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = self.dataSourceArray[indexPath.section][indexPath.row];
    return cell;
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
