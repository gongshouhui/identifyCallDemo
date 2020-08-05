//
//  YSTrackingInfoViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/12/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSTrackingInfoViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSFlowAttachmentViewController.h"
#import "YSReporetModel.h"

@interface YSTrackingInfoViewController()
@property (nonatomic,strong)YSReporetModel *model;
@property (nonatomic,strong)YSReporetInfoModel *infoModel;
@property (nonatomic,strong)YSAssessmentInfoModel *assessmentInfoModel;
@end


@implementation YSTrackingInfoViewController
- (void)initTableView {
    [super initTableView];
    self.title = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attachmentList) name:@"attachment" object:nil];
    [self doNetworking];
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

- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-40*kHeightScale-kTopHeight);
}
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getProReportInfoByIdApi,self.id];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:@{@"type":@"BAPG"} successBlock:^(id response) {
       
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
    self.assessmentInfoModel = self.infoModel.proAssessmentInfo;
    [proGeneralArr addObject:@{@"备案号 *":self.assessmentInfoModel.recordNo}];
    [proGeneralArr addObject:@{@"报备日期 *":[YSUtility timestampSwitchTime:self.assessmentInfoModel.reportDate andFormatter:@"yyyy-MM-dd"]}];
    [proGeneralArr addObject:@{@"项目名称 *":self.infoModel.projectName}];
    [proGeneralArr addObject:@{@"工程类别 *":self.infoModel.programmeTypeStr}];
    [proGeneralArr addObject:@{@"项目类型 *":self.infoModel.projectTypeStr}];
    [proGeneralArr addObject:@{@"招标方式 *":self.infoModel.tenderTypeStr}];
    [proGeneralArr addObject:@{@"招标内容 *":self.infoModel.tenderContentStr}];
    [proGeneralArr addObject:@{@"预计投标日期 *":[YSUtility timestampSwitchTime:self.infoModel.tenderExpectDate andFormatter:@"yyyy-MM-dd"]}];
    [proGeneralArr addObject:@{@"工程造价(万元) *":[NSString stringWithFormat:@"%@ %@",self.infoModel.projectCost.length > 0 ? self.infoModel.projectCostCurrencyStr:@"",[YSUtility cancelNullData:self.infoModel.projectCost]]}];
    [proGeneralArr addObject:@{@"工程面积(平方米) *":self.infoModel.projectArea}];
    [proGeneralArr addObject:@{@"工程地址 *":[NSString stringWithFormat:@"%@%@%@%@",self.infoModel.proProvinceName,self.infoModel.proCityName,self.infoModel.proAreaName,self.infoModel.proAddress]}];
    [proGeneralArr addObject:@{@"甲方单位 *":self.infoModel.firstPartyCompany}];
    [proGeneralArr addObject:@{@"是否合作 *":[YSUtility judgeWhetherOrNot:self.assessmentInfoModel.isCooperation]}];
    [proGeneralArr addObject:@{@"甲方项目对接人 *":self.infoModel.firstPartyUser}];
    [proGeneralArr addObject:@{@"甲方项目对接人联系方式 *":self.infoModel.firstPartyUserLink}];
    [proGeneralArr addObject:@{@"甲方项目对接人职务 *":self.infoModel.firstPartyUserPost}];
    [proGeneralArr addObject:@{@"项目所属区域/团队 *":self.infoModel.deptName}];
    [proGeneralArr addObject:@{@"所属团队负责人 *":self.infoModel.deptLeader}];
    [proGeneralArr addObject:@{@"项目跟踪人 *":self.infoModel.proTrackName}];
    [proGeneralArr addObject:@{@"项目跟踪人联系方式 *":self.infoModel.proTrackMobile}];
    [proGeneralArr addObject:@{@"对接人":self.infoModel.pickUpUserName}];
    [proGeneralArr addObject:@{@"项目自评级 *":self.infoModel.projectSelfGradeStr}];
    [proGeneralArr addObject:@{@"预计定标日期":[YSUtility timestampSwitchTime:self.infoModel.preWinnDate andFormatter:@"yyyy-MM-dd"]}];
    [proGeneralArr addObject:@{@"预计进场日期":[YSUtility timestampSwitchTime:self.infoModel.planEnterDate andFormatter:@"yyyy-MM-dd"]}];
    [proGeneralArr addObject:@{@"预计完成日期":[YSUtility timestampSwitchTime:self.infoModel.planFinishDate andFormatter:@"yyyy-MM-dd"]}];
    if ([self.infoModel.projectSelfGradeStr isEqualToString:@"AA"]) {
        [proGeneralArr addObject:@{@"预计中标金额(万元)":[NSString stringWithFormat:@"%@ %@",self.infoModel.preWinnMoney.length > 0? self.infoModel.preWinnMoneyCurrencyStr:@"",[YSUtility cancelNullData:self.infoModel.preWinnMoney]]}];
        [proGeneralArr addObject:@{@"项目推进情况":self.infoModel.projectProgressRemark}];
        [proGeneralArr addObject:@{@"问题与支持":self.infoModel.questionSupportRemark}];
    }
    [proGeneralArr addObject:@{@"是否含有工业化装配式 *":[YSUtility judgeWhetherOrNot:self.infoModel.isIndustryConf]}];
    if ([[NSString stringWithFormat:@"%@",self.infoModel.isIndustryConf] isEqualToString:@"1"]) {
        [proGeneralArr addObject:@{@"工业化装配式体量(平方米)":[YSUtility cancelNullData:self.infoModel.industryConfArea]}];
        [proGeneralArr addObject:@{@"工业化装配式单方造价(元/平方米)":[NSString stringWithFormat:@"%@ %@",self.infoModel.industryConfPrice.length > 0? self.infoModel.industryConfPriceCurrencyStr:@"",[YSUtility cancelNullData:self.infoModel.industryConfPrice]]}];
        [proGeneralArr addObject:@{@"预计竣工日期":[YSUtility timestampSwitchTime:self.infoModel.planCompleteDate andFormatter:@"yyyy-MM-dd"]}];
        [proGeneralArr addObject:@{@"订单总套数":[YSUtility cancelNullData:self.infoModel.orderCount]}];
        [proGeneralArr addObject:@{@"订单户型个数":[YSUtility cancelNullData:self.infoModel.orderApartmentCount]}];
        [proGeneralArr addObject:@{@"预付款比例(%)":[YSUtility cancelNullData:self.infoModel.advanceChargeProportion]}];
        
    }
    [proGeneralArr addObject:@{@"是否工管联动*":[YSUtility judgeWhetherOrNot:self.infoModel.isManagementLinkage]}];
    [proGeneralArr addObject:@{@"是否需要智能化支持":[YSUtility judgeWhetherOrNot:self.infoModel.isNeedIntelligentSupport]}];

    [proGeneralArr addObject:@{@"备注":self.assessmentInfoModel.remark}];
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
