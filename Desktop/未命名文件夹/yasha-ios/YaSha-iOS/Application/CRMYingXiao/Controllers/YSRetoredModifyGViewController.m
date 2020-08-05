//
//  YSRetoredModifyGViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/6/11.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRetoredModifyGViewController.h"
#import "YSFlowAttachmentViewController.h"
#import "YSPMSInfoDetailHeaderCell.h"
#import "YSReporetModel.h"
#import "YSReportFolderAddViewController.h"//附件
#import "YSCRMYXBaseModel.h"
#import "YSCRMYXAddTableViewCell.h"
#import "YSAliNumberKeyboard.h"
#import "YSCRMYXTFAccessView.h"
#import "YSCRMChoseCurrencyView.h"
#import "YSCRMFJDAddressProvincesModel.h"
#import "YSXRMFJDAddressChoseView.h"
#import "YSBottomTwoBtnCGView.h"
#import "YSCRMEnumChoseGView.h"
#import "YSContactSelectPersonViewController.h"
#import "YSContactModel.h"
#import "YSContactSelectOrgViewController.h"// 部门单选
#import "YSNewsAttachmentModel.h"//本地文件model
#import "YSCRMDepartTreeViewController.h"//部门树
#import "YSDeptTreePointModel.h"//部门树模型
#import "CSNnumberKeyboardView.h"

@interface YSRetoredModifyGViewController ()<CRMYXTextFieldDelegate, YSCRMChoseCurrencyViewDelegate, YSXRMFJDAddressChoseViewDelegate, PGDatePickerDelegate>

@property (nonatomic, strong) UIButton *cloverBtn;
@property (nonatomic, assign) NSIndexPath *choseIndex;
@property (nonatomic, strong) NSArray *addressArray;
@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSArray *ciryArray;
@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, assign) NSInteger provinceIndex;//选中的省 所在provinceArray位置
@property (nonatomic, assign) NSInteger cityIndex;//选中的市 所在ciryArray位置
@property (nonatomic, assign) NSInteger areaIndex;//选中的市 所在areaArray位置
@property (nonatomic, strong) NSIndexPath *dateIndexPath;//选中日期所在cell的位置
@property (nonatomic, strong) NSMutableArray *tenderTypeArray;//招标方式
@property (nonatomic, strong) NSMutableArray *projectSelfGradeArray;//项目自评级别
@property (nonatomic, strong) NSMutableArray *bizStatusArray;//业务阶段
@property (nonatomic, strong) NSMutableArray *projectTypeArray;//项目类型
@property (nonatomic, strong) NSMutableArray *programmeTypeArray;//工程类别
@property (nonatomic, strong) NSMutableArray *bondTypeArray;//保证金类型
@property (nonatomic, strong) NSMutableArray *tenderContentArray;//招标内容
//@property (nonatomic, strong) NSMutableArray *flowStatusArray;//表单类型
//@property (nonatomic, strong) NSMutableArray *trackStateArray;//猜的是跟踪动态



@property (nonatomic, strong) NSMutableArray *industrializationArray;//工业化装备式 根据工业化的switch值判断 是否在页面显示最底部的几个cell(为真:显示)
@property (nonatomic, strong) NSMutableArray *projectLevelArray;//项目自评级别 根据自评级别所选的值(AA:有中标金额/推进情况/问题与支持;其他没有)判断cell

@property (nonatomic, strong) NSMutableDictionary *paramDic;
@property (nonatomic, strong) NSMutableDictionary *industrializationDic;//根据工业化的switch值判断 保存/提交的是否 上传该字典(为真:上传)
@property (nonatomic, strong) NSMutableDictionary *projectLevelDic;//项目自评级别 根据自评级别所选的值(AA:有中标金额/推进情况/问题与支持;其他没有)判断cell

@property (nonatomic,strong)NSDictionary *attachmentDic;
@property (nonatomic,strong)YSReporetInfoModel *infoModel;
@property (nonatomic,strong)YSAssessmentInfoModel *assessmentInfoModel;
@property (nonatomic, assign) NSInteger projectLevelIndex;//自评级别变更的时候 添加cell的初始位置
@property (nonatomic, strong) NSMutableArray *fileArray;// 所选的文件
@property (nonatomic, strong) NSMutableArray *fileNetworkArray;
@property (nonatomic, strong) NSArray *deptArray;//部门树

@end

@implementation YSRetoredModifyGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改项目跟踪详情";
    self.provinceIndex = 0;
    self.cityIndex = 0;
    self.areaIndex = 0;
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"附件" tintColor:[UIColor colorWithHexString:@"#54576A"] position:QMUINavigationButtonPositionRight target:self action:@selector(choseOrCheckBtnAction:)];
    
    [self.view bringSubviewToFront:self.tableView];
    //处理本地省市区数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self handelLocationAddress];
    });
    
    _tenderTypeArray = [NSMutableArray new];//招标方式
    _projectSelfGradeArray = [NSMutableArray new];//项目自评级别
    _bizStatusArray = [NSMutableArray new];//业务阶段
    _projectTypeArray = [NSMutableArray new];//项目类型
    _programmeTypeArray = [NSMutableArray new];//工程类别
    _bondTypeArray = [NSMutableArray new];//保证金类型
    _tenderContentArray = [NSMutableArray new];//招标内容
    [self doNetworking];
    
    //选择人员的通知(单选)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPerson:) name:KNotificationPostSelectedPerson object:nil];
    
    // 有备案号-->其他信息界面点击 保存按钮
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"saveCRMWithRecordNo" object:nil] subscribeNext:^(NSNotification *x) {
        @strongify(self);
        [self.paramDic setObject:[x.userInfo objectForKey:@"proAssessmentOther"] forKey:@"proAssessmentOther"];
    }];
    [self.industrializationDic setObject:@"10" forKey:@"industryConfPriceCurrency"];//工业化装配式单方造价金额类型10-人民币 20-美元
    [self.projectLevelDic setObject:@"10" forKey:@"preWinnMoneyCurrency"];//预计中标金额类型
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        // 没有备案号 就没有 其他信息 页面 则不用再传递数据
        return;
    }
    //两个界面数据一致
    if (![[self.recordNoDic objectForKey:@"projectSelfGrade"] isEqualToString:@"188"]) {//不为"AA"级别
        [self.recordNoDic removeObjectForKey:@"preWinnMoneyCurrency"];//预计中标金额类型
        [self.recordNoDic removeObjectForKey:@"preWinnMoney"];//预计中标金额
        [self.recordNoDic removeObjectForKey:@"projectProgressRemark"];//项目推进情况
        [self.recordNoDic removeObjectForKey:@"questionSupportRemark"];//问题与支持
        
    }
}
- (void)layoutTableView {
    if(![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]){
        //有备案号
        self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-90*kHeightScale-40*kHeightScale-kTopHeight);
    }else {
        self.tableView.frame = CGRectMake(0, kTopHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-90*kHeightScale-kTopHeight);

    }
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSCRMYXAddTableViewCell class] forCellReuseIdentifier:@"CRMCellSys"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    if (@available(iOS 11, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)loadBottomBtnView {
    YSBottomTwoBtnCGView *bottomView = [[YSBottomTwoBtnCGView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView.leftBtn addTarget:self action:@selector(clickedSaveBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView.rightBtn addTarget:self action:@selector(clickedCommitBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    /*
    if ([self.infoModel.bizStatus isEqualToString:@"10"]&&([self.infoModel.flowStatus isEqualToString:@"10"] || [self.infoModel.flowStatus isEqualToString:@"30"] || [self.infoModel.flowStatus isEqualToString:@"40"] || [self.infoModel.flowStatus isEqualToString:@"60"])){
        // 备案阶段&&(未提交/输入/驳回)
        [bottomView changeSubViewsWith:1];
    }
     */
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        // 有备案号
        [bottomView changeSubViewsWith:1];
    }else if ([self.infoModel.flowStatus isEqualToString:@"60"]){
        // 无备案号 但是状态为 已审批
        [bottomView changeSubViewsWith:1];
}
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 70*kHeightScale));
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(20*kHeightScale);
        make.left.mas_equalTo(0);
    }];
}
- (void)loadInitData {    
    BOOL isAllowEdit = NO;
    
   
    self.infoModel = self.model.proReportInfo;
    [self layoutTableView];
    [self loadBottomBtnView];
    if ([self.infoModel.bizStatusStr isEqualToString:@"备案阶段"] && ([self.infoModel.flowStatusStr isEqualToString:@"输入中"] || [self.infoModel.flowStatusStr isEqualToString:@"驳回"] || [self.infoModel.flowStatusStr isEqualToString:@"未提交"])) {
        isAllowEdit = YES;
    }
    
    
    //        isTFEnabled默认是NO(可以输入)
    // 传递到 其他信息 页面的数据 保持数据一致
    [self.recordNoDic setObject:[self.paramDic objectForKey:@"projectCostCurrency"] forKey:@"projectCostCurrency"];//预计投标金额类型
    
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        
        self.assessmentInfoModel = self.infoModel.proAssessmentInfo;
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"备案号", @"holderStr":@"", @"accessoryView":@0, @"isMustWrite":@(YES), @"textTF":self.assessmentInfoModel.recordNo, @"isTFEnabled":@(YES)}]];
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"报备日期", @"holderStr":@"", @"accessoryView":@0, @"isMustWrite":@(YES), @"textTF":[YSUtility timestampSwitchTime:self.assessmentInfoModel.reportDate andFormatter:@"yyyy-MM-dd"], @"isTFEnabled":@(YES)}]];
        isAllowEdit = NO;
    }
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"项目名称", @"holderStr":@"请输入", @"accessoryView":@0, @"isMustWrite":@(YES), @"textTF":self.infoModel.projectName, @"isTFEnabled":@(!isAllowEdit)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"工程类别", @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(1):@(0), @"isMustWrite":@(YES), @"textTF":self.infoModel.programmeTypeStr, @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"项目类型", @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(1):@(0), @"isMustWrite":@(YES), @"textTF":self.infoModel.projectTypeStr, @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"招标方式", @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(1):@(0), @"isMustWrite":@(YES), @"textTF":self.infoModel.tenderTypeStr, @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"招标内容", @"textTF":self.infoModel.tenderContentStr, @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(1):@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"预计投标日期", @"textTF":[YSUtility timestampSwitchTime:self.infoModel.tenderExpectDate andFormatter:@"yyyy-MM-dd"], @"holderStr":@"需选择", @"accessoryView":@(1), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}]];
    // 投标金额 就是 工程造价
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"预计投标金额(万元)", @"textTF":[YSUtility judgeIsEmpty:self.infoModel.projectCost]?@"":[NSString stringWithFormat:@"%.2f",[self.infoModel.projectCost doubleValue]], @"holderStr":@"需输入", @"accessoryView":@(AccessoryViewTypeMoney), @"isMustWrite":@(YES), @"currentyStr":self.infoModel.projectCostCurrencyStr ? self.infoModel.projectCostCurrencyStr : @"¥", @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"工程面积(平方米)", @"textTF":[YSUtility judgeIsEmpty:self.infoModel.projectArea]?@"":[NSString stringWithFormat:@"%.2f",[self.infoModel.projectArea doubleValue]], @"holderStr":isAllowEdit?@"需输入":@"", @"accessoryView":@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(!isAllowEdit)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"工程地址", @"textTF":[NSString stringWithFormat:@"%@ %@ %@",self.infoModel.proProvinceName,self.infoModel.proCityName,self.infoModel.proAreaName], @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(1):@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"详细地址", @"textTF":[NSString stringWithFormat:@"%@",self.infoModel.proAddress], @"holderStr":isAllowEdit?@"需输入":@"", @"accessoryView":@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(!isAllowEdit)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"甲方单位", @"textTF":self.infoModel.firstPartyCompany, @"holderStr":isAllowEdit?@"需输入":@"", @"accessoryView":@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(!isAllowEdit)}]];
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否合作", @"textTF":[YSUtility judgeWhetherOrNot:self.assessmentInfoModel.isCooperation], @"holderStr":@"", @"accessoryView":@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}]];
    }
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"甲方项目对接人", @"textTF":self.infoModel.firstPartyUser, @"holderStr":isAllowEdit?@"需输入":@"", @"accessoryView":@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(!isAllowEdit)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"甲方项目对接人联系方式", @"textTF":self.infoModel.firstPartyUserLink, @"holderStr":isAllowEdit?@"需输入":@"", @"accessoryView":@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(!isAllowEdit)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"甲方项目对接人职务", @"textTF":self.infoModel.firstPartyUserPost, @"holderStr":isAllowEdit?@"需输入":@"", @"accessoryView":@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(!isAllowEdit)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"项目所属区域/团队", @"textTF":self.infoModel.deptName, @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(1):@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"所属团队负责人", @"textTF":self.infoModel.deptLeader, @"holderStr":isAllowEdit?@"自动带出":@"", @"accessoryView":@(0), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"所属区域/团队所在公司", @"textTF":self.infoModel.companyName, @"holderStr":isAllowEdit?@"自动带出":@"", @"accessoryView":@(0), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"对接人", @"textTF":self.infoModel.pickUpUserName, @"holderStr":isAllowEdit?@"自动带出":@"", @"accessoryView":@(0), @"isTFEnabled":@(YES)}]];
    
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"项目跟踪人", @"textTF":self.infoModel.proTrackName, @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(2):@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"项目跟踪人联系方式", @"textTF":self.infoModel.proTrackMobile, @"holderStr":isAllowEdit?@"自动带出":@"", @"accessoryView":@(0), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否工管联动", @"textTF":[YSUtility judgeWhetherOrNot:self.infoModel.isManagementLinkage], @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@([self.infoModel.isManagementLinkage integerValue]+3):@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否需要智能化支持", @"textTF":[YSUtility judgeWhetherOrNot:self.infoModel.isNeedIntelligentSupport], @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@([self.infoModel.isNeedIntelligentSupport integerValue]+3):@(0), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"项目自评级别", @"textTF":self.infoModel.projectSelfGradeStr, @"holderStr":@"需选择", @"accessoryView":@(1), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"预计定标日期", @"textTF":[YSUtility timestampSwitchTime:self.infoModel.preWinnDate andFormatter:@"yyyy-MM-dd"], @"holderStr":@"请选择", @"accessoryView":@(1), @"isTFEnabled":@(YES), @"isMustWrite":@(YES)}]];
    
   [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"预计进场日期", @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(1):@(0), @"isMustWrite":@(YES), @"textTF":[YSUtility timestampSwitchTime:self.infoModel.planEnterDate andFormatter:@"yyyy-MM-dd"], @"isTFEnabled":@(YES)}]];
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"预计完成日期", @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(1):@(0), @"isMustWrite":@(YES), @"textTF":[YSUtility timestampSwitchTime:self.infoModel.planFinishDate andFormatter:@"yyyy-MM-dd"], @"isTFEnabled":@(YES)}]];
    
    self.projectLevelIndex = self.dataSourceArray.count;
    if ([self.infoModel.projectSelfGradeStr isEqualToString:@"AA"]) {
        [self.projectLevelArray removeAllObjects];
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"预计中标金额(万元)", @"textTF":[YSUtility judgeIsEmpty:self.infoModel.preWinnMoney]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.preWinnMoney floatValue]], @"holderStr":@"请输入", @"accessoryView":@(AccessoryViewTypeMoney), @"isMustWrite":@(YES), @"currentyStr":[YSUtility judgeIsEmpty:self.infoModel.preWinnMoneyCurrencyStr] ? @"¥": self.infoModel.preWinnMoneyCurrencyStr, @"isTFEnabled":@(YES)}]];
        [self.projectLevelArray addObject:[self.dataSourceArray lastObject]];
        [self.projectLevelDic setObject:[YSUtility judgeIsEmpty:self.infoModel.preWinnMoneyCurrency]? @"10" : self.infoModel.preWinnMoneyCurrency forKey:@"preWinnMoneyCurrency"];//金额类型
        [self.projectLevelDic setObject:[YSUtility cancelNullData:self.infoModel.preWinnMoney] forKey:@"preWinnMoney"];//金额
        
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"项目推进情况", @"textTF":self.infoModel.projectProgressRemark, @"holderStr":@"请输入", @"accessoryView":@(0), @"isMustWrite":@(YES)}]];
        [self.projectLevelArray addObject:[self.dataSourceArray lastObject]];
        [self.projectLevelDic setObject:self.infoModel.projectProgressRemark forKey:@"projectProgressRemark"];
        
        
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"问题与支持", @"textTF":[YSUtility cancelNullData:self.infoModel.questionSupportRemark], @"holderStr":@"请输入", @"accessoryView":@(0), @"isMustWrite":@(YES)}]];
        [self.projectLevelArray addObject:[self.dataSourceArray lastObject]];
        [self.projectLevelDic setObject:[YSUtility cancelNullData:self.infoModel.questionSupportRemark] forKey:@"questionSupportRemark"];
        [self.recordNoDic setValuesForKeysWithDictionary:self.projectLevelDic];
    }
    [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否含有工业化装配式", @"textTF":[YSUtility judgeWhetherOrNot:self.infoModel.isIndustryConf], @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@([self.infoModel.isIndustryConf integerValue]+3):@(0), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}]];
    
    if ([[NSString stringWithFormat:@"%@",self.infoModel.isIndustryConf] isEqualToString:@"1"]) {
        [self.industrializationArray removeAllObjects];
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"工业化装配式体量(平方米)", @"textTF":[YSUtility judgeIsEmpty:self.infoModel.industryConfArea]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.industryConfArea floatValue]], @"holderStr":isAllowEdit?@"需输入":@"", @"accessoryView":@(0), @"isTFEnabled":@(!isAllowEdit)}]];
        [self.industrializationArray addObject:[self.dataSourceArray lastObject]];
        [self.industrializationDic setObject:self.infoModel.industryConfArea forKey:@"industryConfArea"];
        
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"工业化装配式单方造价(元/平方米)", @"textTF":[YSUtility judgeIsEmpty:self.infoModel.industryConfPrice]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.industryConfPrice floatValue]], @"holderStr":isAllowEdit?@"需输入":@"", @"accessoryView":isAllowEdit?@(AccessoryViewTypeMoney):@(0), @"isTFEnabled":@(YES), @"currentyStr":[YSUtility judgeIsEmpty:self.infoModel.industryConfPriceCurrencyStr] ? @"¥" : self.infoModel.industryConfPriceCurrencyStr}]];
        [self.industrializationArray addObject:[self.dataSourceArray lastObject]];
        [self.industrializationDic setObject:self.infoModel.industryConfPrice forKey:@"industryConfPrice"];
        [self.industrializationDic setObject:[YSUtility judgeIsEmpty:self.infoModel.industryConfPriceCurrency] ? @"10" :self.infoModel.industryConfPriceCurrency forKey:@"industryConfPriceCurrency"];//10-人民币 20-美元
        
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"预计竣工日期", @"textTF":[YSUtility timestampSwitchTime:self.infoModel.planCompleteDate andFormatter:@"yyyy-MM-dd"], @"holderStr":isAllowEdit?@"需选择":@"", @"accessoryView":isAllowEdit?@(1):@(0), @"isTFEnabled":@(YES)}]];
        [self.industrializationArray addObject:[self.dataSourceArray lastObject]];
        [self.industrializationDic setObject:self.infoModel.planCompleteDate forKey:@"planCompleteDate"];
        
        
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"订单总套数", @"textTF":[YSUtility cancelNullData:self.infoModel.orderCount], @"holderStr":isAllowEdit?@"需输入":@"", @"accessoryView":@(0), @"isTFEnabled":@(!isAllowEdit)}]];
        [self.industrializationArray addObject:[self.dataSourceArray lastObject]];
        [self.industrializationDic setObject:self.infoModel.orderCount forKey:@"orderCount"];
        
        
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"订单户型个数", @"textTF":[YSUtility cancelNullData:self.infoModel.orderApartmentCount], @"holderStr":isAllowEdit?@"请输入":@"", @"accessoryView":@(0), @"isTFEnabled":@(!isAllowEdit)}]];
        [self.industrializationArray addObject:[self.dataSourceArray lastObject]];
        [self.industrializationDic setObject:self.infoModel.orderApartmentCount forKey:@"orderApartmentCount"];
        
        
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"预付款比例(%)", @"textTF":[YSUtility judgeIsEmpty:self.infoModel.advanceChargeProportion]?@"":[NSString stringWithFormat:@"%.2f", [self.infoModel.advanceChargeProportion floatValue]], @"holderStr":isAllowEdit?@"请输入":@"", @"accessoryView":@(0), @"isTFEnabled":@(!isAllowEdit)}]];
        [self.industrializationArray addObject:[self.dataSourceArray lastObject]];
        [self.industrializationDic setObject:self.infoModel.advanceChargeProportion forKey:@"advanceChargeProportion"];
        
    }
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        [self.dataSourceArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"备注", @"textTF":self.assessmentInfoModel.remark, @"holderStr":@"", @"accessoryView":@(0), @"isTFEnabled":@(YES)}]];
    }
    self.fileNetworkArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSNewsAttachmentModel class] json:self.model.proReportInfo.crmProFilesList]];
    [self.paramDic removeObjectsForKeys:[self.industrializationDic allKeys]];
    [self.paramDic removeObjectsForKeys:[self.projectLevelDic allKeys]];
    [self.tableView reloadData];
    
}

// 请求获取枚举字典
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getDicTypeEnumApi] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"报备枚举值:%@-\n想要的值:%@", response, [response objectForKey:@"programmeType"]);
        dispatch_group_leave(group);

        if (1 == [[response objectForKey:@"code"] integerValue]) {
            _tenderTypeArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[[response objectForKey:@"data"] objectForKey:@"tenderType"]]];//招标方式
            _projectSelfGradeArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[[response objectForKey:@"data"] objectForKey:@"projectSelfGrade"]]];//项目自评级别
            _bizStatusArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[[response objectForKey:@"data"] objectForKey:@"bizStatusEnum"]]];//业务阶段
            _projectTypeArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[[response objectForKey:@"data"] objectForKey:@"projectType"]]];//项目类型
            _programmeTypeArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[[response objectForKey:@"data"] objectForKey:@"programmeType"]]];//工程类别
            _bondTypeArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[[response objectForKey:@"data"] objectForKey:@"bondType"]]];//保证金类型
            _tenderContentArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[[response objectForKey:@"data"] objectForKey:@"tenderContent"]]];//招标内容
        }
    } failureBlock:^(NSError *error) {
        dispatch_group_leave(group);
    } progress:nil];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@", YSDomain, getProReportInfoByIdApi,self.id] isNeedCache:NO parameters:@{@"type":@"BAPG"} successBlock:^(id response) {
            dispatch_group_leave(group);
            DLog(@"\n详情-%@",response);
            if ([response[@"code"] integerValue] == 1) {
                NSArray *dataArrayt = [YSDataManager getReporedInfoData:response];
                self.model = dataArrayt[0];
                [self.paramDic setValuesForKeysWithDictionary:[[response objectForKey:@"data"] objectForKey:@"proReportInfo"]];
                [self.recordNoDic setObject:[self.paramDic objectForKey:@"projectSelfGrade"] forKey:@"projectSelfGrade"];// 自评级别
                [self.paramDic removeObjectForKey:@"crmProFilesList"];//从字典中删除附件列表
                [self loadInitData];
            }
        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group);
        } progress:nil];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getDeptTreeApi] isNeedCache:NO parameters:nil successBlock:^(id response) {
            dispatch_group_leave(group);
//            DLog(@"营销部门树:%@", response);
            if (1==[[response objectForKey:@"code"] integerValue]) {
                self.deptArray = [NSArray arrayWithArray:[response objectForKey:@"data"]];
            }
        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group);
        } progress:nil];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [QMUITips hideAllToastInView:self.view animated:NO];
    });
    
}

- (void)handelLocationAddress {
    NSString *addrssPath = [[NSBundle mainBundle] pathForResource:@"addressLocation" ofType:@"json"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:addrssPath encoding:NSUTF8StringEncoding error:nil];
    NSData *addressData = [[NSData alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    _addressArray = [NSJSONSerialization JSONObjectWithData:addressData options:NSJSONReadingMutableLeaves error:nil];
    
    NSMutableArray *provincesArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *cityArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *areaArray = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *streetArray = [NSMutableArray arrayWithCapacity:0];
    // 省级数据
    for (NSDictionary *dict in _addressArray) {
        YSCRMFJDAddressProvincesModel *provinceModel = [YSCRMFJDAddressProvincesModel yy_modelWithJSON:dict];
        // 将省加入数组
        [provincesArray addObject:provinceModel];
        
        // 市级数据
        NSArray *childrenCityArray = [dict objectForKey:@"cities"];// 从本地数据中取到的 该省份下市区的数据
        NSMutableArray *cityChilderArray = [NSMutableArray new];
        //该省份下 区县的数据
        NSMutableArray *provinceAreaChilderArray = [NSMutableArray new];
        for (NSDictionary *cityDic in childrenCityArray) {
            
            // 将市加入中间数组
            YSCRMFJDAddressProvincesModel *cityMiddleModel = [YSCRMFJDAddressProvincesModel yy_modelWithJSON:cityDic];
            if ([cityMiddleModel.name isEqualToString:@"市辖区"]) {
                cityMiddleModel.name = provinceModel.name;
            }
            [cityChilderArray addObject:cityMiddleModel];
            
            // 该市下面的区
            NSArray *childrenAreaArray = [cityDic objectForKey:@"areas"];// 从本地数据中取到的 该市下的数据
            NSMutableArray *areaChilderArray = [NSMutableArray new];
            for (NSDictionary *areaCity in childrenAreaArray) {
                // 将该市下面的区加入中间数组
                YSCRMFJDAddressProvincesModel *areaMiddleModel = [YSCRMFJDAddressProvincesModel yy_modelWithJSON:areaCity];
                [areaChilderArray addObject:areaMiddleModel];
            }
            [provinceAreaChilderArray addObject:areaChilderArray];
        }
        // 将该市下面的区县 按照 省跟市区 的位置 装入数组
        [areaArray addObject:provinceAreaChilderArray];
        
        //将省下面的市 按省的位置加入市的数组
        [cityArray addObject:cityChilderArray];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        self.provinceArray = [NSArray arrayWithArray:provincesArray];
        self.ciryArray = [NSArray arrayWithArray:cityArray];
        self.areaArray = [NSArray arrayWithArray:areaArray];
    });
}

#pragma mark-- 查看或者添加附件
- (void)choseOrCheckBtnAction:(QMUINavigationButton*)sender {
    YSReportFolderAddViewController *folderVC = [YSReportFolderAddViewController new];
    folderVC.fileNetworkArray = self.fileNetworkArray;
    folderVC.addFolderArray = [NSMutableArray arrayWithArray:self.fileArray];
    YSWeak;
    folderVC.addFolderBlock = ^(NSMutableArray * _Nonnull addFolderArray) {
        NSMutableArray *finishNetworkArray = [NSMutableArray new];//删除之后剩下的网络文件
        for (YSNewsAttachmentModel *model in addFolderArray) {
            if ([weakSelf.fileNetworkArray containsObject:model]) {
                [finishNetworkArray addObject:model];
            }
            // 本地选中的文件
            if (![finishNetworkArray containsObject:model] && ![weakSelf.fileArray containsObject:model]) {
                [weakSelf.fileArray addObject:model];
            }
        }
        // 数组中网络文件先全部
        [weakSelf.fileNetworkArray removeAllObjects];
        // 在将剩下的文件 加入到数组中
        [weakSelf.fileNetworkArray addObjectsFromArray:finishNetworkArray];
        // 将网络请求到的文件(删除过剩下的),加到数组最前面
//        [weakSelf.fileArray insertObjects:weakSelf.fileNetworkArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSMakeRange(0, weakSelf.fileNetworkArray.count))]];
    };
    [self.navigationController pushViewController:folderVC animated:YES];
}
#pragma mark--保存/提交按钮
- (void)clickedSaveBtnAction {

    if ([self.infoModel.bizStatusStr isEqualToString:@"备案阶段"] && [self.infoModel.flowStatusStr isEqualToString:@"已审批"]) {
        for (YSCRMYXBaseModel *model in self.dataSourceArray) {
            if (model.isMustWrite && model.accessoryView < AccessoryViewTypeDetailSwitchOFF && [YSUtility judgeIsEmpty:model.textTF]) {
                if ([model.nameStr containsString:@"预计中标金额"]){
                    NSInteger objectIndex = [self.dataSourceArray indexOfObject:model];
                    YSCRMYXBaseModel *parentModel = [self.dataSourceArray objectAtIndex:objectIndex-2];
                    if ([parentModel.textTF isEqualToString:@"AA"]) {
                        [QMUITips showInfo:[NSString stringWithFormat:@"%@-未填", model.nameStr] inView:self.view hideAfterDelay:1];
                        return;
                    }
                }else if ([model.nameStr containsString:@"项目推进情况"]) {
                    NSInteger objectIndex = [self.dataSourceArray indexOfObject:model];
                    YSCRMYXBaseModel *parentModel = [self.dataSourceArray objectAtIndex:objectIndex-3];
                    if ([parentModel.textTF isEqualToString:@"AA"]) {
                        [QMUITips showInfo:[NSString stringWithFormat:@"%@-未填", model.nameStr] inView:self.view hideAfterDelay:1];
                        return;
                    }
                }else if ([model.nameStr containsString:@"问题与支持"]) {
                    NSInteger objectIndex = [self.dataSourceArray indexOfObject:model];
                    YSCRMYXBaseModel *parentModel = [self.dataSourceArray objectAtIndex:objectIndex-4];
                    if ([parentModel.textTF isEqualToString:@"AA"]) {
                        [QMUITips showInfo:[NSString stringWithFormat:@"%@-未填", model.nameStr] inView:self.view hideAfterDelay:1];
                        return;
                    }
                }
            }
        }
    }
    
    [QMUITips showLoadingInView:self.view];
    //是否新增了本地文件
    NSMutableArray *upFileArray = [NSMutableArray new];// 新增未上传的文件数组
    NSMutableArray *fileResultsArray = [NSMutableArray new];//新增且已上传的文件数组
    for (YSNewsAttachmentModel *mode in self.fileArray) {
        if (!mode.crmProFilesListDic) {
            [upFileArray addObject:mode];
        }
    }
    //只需要网络文件
    if (self.fileNetworkArray.count != 0) {
        for (YSNewsAttachmentModel *model in self.fileNetworkArray) {
            [fileResultsArray addObject:[model yy_modelToJSONObject]];
        }
    }
    if (upFileArray.count != 0) {// 本地文件未上传
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_group_async(group, queue, ^{
            // 本地添加的文件 上传之后返回的数组
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [YSNetManager ys_uploadFileWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, uploadFileApi] parameters:nil fileModelArray:upFileArray file:@"files" fileType:@"application/octet-stream" successBlock:^(id response) {
                DLog(@"文件上传:%@", response);
                dispatch_semaphore_signal(semaphore);// 发送信号量(+1)
                if (1 == [[response objectForKey:@"code"] integerValue] && [[response objectForKey:@"data"] count] != 0) {
                    for (NSDictionary *crmProFilesList in [[response objectForKey:@"data"] objectForKey:@"uploadeFiles"]) {
                        NSMutableDictionary *crmProFilesListDic = [NSMutableDictionary dictionaryWithDictionary:crmProFilesList];
                        [crmProFilesListDic setObject:[crmProFilesListDic objectForKey:@"fileName"] forKey:@"name"];
                        [fileResultsArray addObject:crmProFilesListDic];
                        
                        YSNewsAttachmentModel *modelFile = [YSNewsAttachmentModel new];
                        [modelFile yy_modelSetWithDictionary:crmProFilesListDic];
                        [self.fileNetworkArray addObject:modelFile];
                    }
                    
                    [self.fileArray removeAllObjects];
                }
            } failurBlock:^(NSError *error) {
                dispatch_semaphore_signal(semaphore);// 发送信号量(+1)
            } upLoadProgress:nil];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);// 信号量-1,(如果>0,则向下执行,否则等待)
        });
        dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 修改的保存
            NSMutableDictionary *finishDic = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
            if ([[self.paramDic objectForKey:@"isIndustryConf"] integerValue] == 1) {// 是否含有工业化装配式
                [finishDic setValuesForKeysWithDictionary:self.industrializationDic];
            }
            if ([[self.paramDic objectForKey:@"projectSelfGrade"] isEqualToString:@"188"]) {//自评级别是否为 AA
                [finishDic setValuesForKeysWithDictionary:self.projectLevelDic];
            }
            //网络文件
            if (fileResultsArray.count != 0) {
                [finishDic setObject:fileResultsArray forKey:@"crmProFilesList"];
            }
            // 删除了全部附件文件
            if (![[finishDic allKeys] containsObject:@"crmProFilesList"]) {
                [finishDic setObject:@[] forKey:@"crmProFilesList"];
            }
            [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, saveProReportApi] isNeedCache:NO parameters:finishDic successBlock:^(id response) {
                [QMUITips hideAllToastInView:self.view animated:NO];
                DLog(@"单据保存数据:%@", response);
                if (1 == [[response objectForKey:@"code"] integerValue]) {
                    [QMUITips showSucceed:[response objectForKey:@"msg"] inView:self.view hideAfterDelay:1];
                }
            } failureBlock:^(NSError *error) {
                [QMUITips hideAllToastInView:self.view animated:NO];
            } progress:nil];
        });
    }else {//本地选择的文件全部已经上传 或者 未选择本地文件
        // 修改的保存
        NSMutableDictionary *finishDic = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
        if ([[self.paramDic objectForKey:@"isIndustryConf"] integerValue] == 1) {// 是否含有工业化装配式
            [finishDic setValuesForKeysWithDictionary:self.industrializationDic];
        }
        if ([[self.paramDic objectForKey:@"projectSelfGrade"] isEqualToString:@"188"]) {//自评级别是否为 AA
            [finishDic setValuesForKeysWithDictionary:self.projectLevelDic];
        }
        // 文件列表(网络)
        if (fileResultsArray.count != 0) {
            [finishDic setObject:fileResultsArray forKey:@"crmProFilesList"];
        }
        // 删除了全部附件文件
        if (![[finishDic allKeys] containsObject:@"crmProFilesList"]) {
            [finishDic setObject:@[] forKey:@"crmProFilesList"];
        }
        [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, saveProReportApi] isNeedCache:NO parameters:finishDic successBlock:^(id response) {
            [QMUITips hideAllToastInView:self.view animated:NO];
            DLog(@"单据保存数据:%@", response);
            if (1 == [[response objectForKey:@"code"] integerValue]) {
                [QMUITips showSucceed:[response objectForKey:@"msg"] inView:self.view hideAfterDelay:1];
            }
        } failureBlock:^(NSError *error) {
            [QMUITips hideAllToastInView:self.view animated:NO];
        } progress:nil];
    }
}
- (void)clickedCommitBtnAction {
    
    for (YSCRMYXBaseModel *model in self.dataSourceArray) {
        if (model.isMustWrite && model.accessoryView < AccessoryViewTypeDetailSwitchOFF && [YSUtility judgeIsEmpty:model.textTF]) {
            if ([model.nameStr containsString:@"预计中标金额"]){
                NSInteger objectIndex = [self.dataSourceArray indexOfObject:model];
                YSCRMYXBaseModel *parentModel = [self.dataSourceArray objectAtIndex:objectIndex-2];
                if ([parentModel.textTF isEqualToString:@"AA"]) {
                    [QMUITips showInfo:[NSString stringWithFormat:@"%@-未填", model.nameStr] inView:self.view hideAfterDelay:1];
                    return;
                }
            }else if ([model.nameStr containsString:@"项目推进情况"]) {
                NSInteger objectIndex = [self.dataSourceArray indexOfObject:model];
                YSCRMYXBaseModel *parentModel = [self.dataSourceArray objectAtIndex:objectIndex-3];
                if ([parentModel.textTF isEqualToString:@"AA"]) {
                    [QMUITips showInfo:[NSString stringWithFormat:@"%@-未填", model.nameStr] inView:self.view hideAfterDelay:1];
                    return;
                }
            }else if ([model.nameStr containsString:@"问题与支持"]) {
                NSInteger objectIndex = [self.dataSourceArray indexOfObject:model];
                YSCRMYXBaseModel *parentModel = [self.dataSourceArray objectAtIndex:objectIndex-4];
                if ([parentModel.textTF isEqualToString:@"AA"]) {
                    [QMUITips showInfo:[NSString stringWithFormat:@"%@-未填", model.nameStr] inView:self.view hideAfterDelay:1];
                    return;
                }
            }else {
                [QMUITips showInfo:[NSString stringWithFormat:@"%@-未填", model.nameStr] inView:self.view hideAfterDelay:1];
                return;
            }
            
        }
    }
    
    QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        
    }];
    action0.buttonAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666F83"], NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)]};
    
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"确认" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        [self commitNetwork];
    }];
    [action1.button setTitleColor:[UIColor colorWithHexString:@"#2F86F6"] forState:(UIControlStateNormal)];
    action1.buttonAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F86F6"], NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)]};
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"是否确定提交单据?" preferredStyle:QMUIAlertControllerStyleAlert];
    alertController.alertMessageAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666F83"], NSFontAttributeName:UIFontMake(14),NSParagraphStyleAttributeName:[NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:0 lineBreakMode:NSLineBreakByTruncatingTail]};
    [alertController addAction:action1];
    [alertController addAction:action0];
    [alertController showWithAnimated:YES];
    
}
- (void)commitNetwork {
    // 成功返回列表页面 并刷新列表页面
    [QMUITips showLoadingInView:self.view];
    NSMutableArray *upFileArray = [NSMutableArray new];// 新增未上传的文件数组
    NSMutableArray *fileResultsArray = [NSMutableArray new];//新增且已上传的文件数组
    for (YSNewsAttachmentModel *mode in self.fileArray) {
        if (!mode.crmProFilesListDic) {
            [upFileArray addObject:mode];
        }
    }
    //只需要网络文件
    if (self.fileNetworkArray.count != 0) {
        for (YSNewsAttachmentModel *model in self.fileNetworkArray) {
            [fileResultsArray addObject:[model yy_modelToJSONObject]];
        }
    }
    if (upFileArray.count != 0) {
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_group_async(group, queue, ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            // 本地添加的文件 上传之后返回的数组
            [YSNetManager ys_uploadFileWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, uploadFileApi] parameters:nil fileModelArray:upFileArray file:@"files" fileType:@"application/octet-stream" successBlock:^(id response) {
                DLog(@"文件上传:%@", response);
                dispatch_semaphore_signal(semaphore);// 发送信号量(+1)
                if (1 == [[response objectForKey:@"code"] integerValue] && [[response objectForKey:@"data"] count] != 0) {
                    for (NSDictionary *crmProFilesList in [[response objectForKey:@"data"] objectForKey:@"uploadeFiles"]) {
                        NSMutableDictionary *crmProFilesListDic = [NSMutableDictionary dictionaryWithDictionary:crmProFilesList];
                        [crmProFilesListDic setObject:[crmProFilesListDic objectForKey:@"fileName"] forKey:@"name"];
                        [fileResultsArray addObject:crmProFilesListDic];
                        
                        YSNewsAttachmentModel *modelFile = [YSNewsAttachmentModel new];
                        [modelFile yy_modelSetWithDictionary:crmProFilesListDic];
                        [self.fileNetworkArray addObject:modelFile];
                    }
                    
                    [self.fileArray removeAllObjects];
                }
            } failurBlock:^(NSError *error) {
                dispatch_semaphore_signal(semaphore);// 发送信号量(+1)
            } upLoadProgress:nil];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);// 信号量-1,(如果>0,则向下执行,否则等待)
        });
        dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableDictionary *postDataDic = [NSMutableDictionary new];
            [postDataDic setValuesForKeysWithDictionary:self.paramDic];
            if (fileResultsArray.count != 0) {
                [postDataDic setObject:fileResultsArray forKey:@"crmProFilesList"];
            }
            // 新增的保存
            if ([[self.paramDic objectForKey:@"isIndustryConf"] integerValue] == 1) {// 是否含有工业化装配式 (1含有)
                [postDataDic setValuesForKeysWithDictionary:self.industrializationDic];
            }
            if ([[self.paramDic objectForKey:@"projectSelfGrade"] isEqualToString:@"188"]) {//自评级别是否为 AA
                [postDataDic setValuesForKeysWithDictionary:self.projectLevelDic];
            }
            // 删除了全部附件文件
            if (![[postDataDic allKeys] containsObject:@"crmProFilesList"]) {
                [postDataDic setObject:@[] forKey:@"crmProFilesList"];
            }
            [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, submitProReportApi] isNeedCache:NO parameters:postDataDic successBlock:^(id response) {
                DLog(@"文件提交:%@", response);
                [QMUITips hideAllToastInView:self.view animated:NO];
                if (1==[[response objectForKey:@"code"] integerValue]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCRMList" object:nil];
                }
            } failureBlock:^(NSError *error) {
                [QMUITips hideAllToastInView:self.view animated:NO];
            } progress:nil];
        });
    }else {
        // 已上传过文件 或者没有选择文件
        NSMutableDictionary *postDataDic = [NSMutableDictionary new];
        [postDataDic setValuesForKeysWithDictionary:self.paramDic];
        // 新增的保存
        if ([[self.paramDic objectForKey:@"isIndustryConf"] integerValue] == 1) {// 是否含有工业化装配式 (1含有)
            [postDataDic setValuesForKeysWithDictionary:self.industrializationDic];
        }
        if ([[self.paramDic objectForKey:@"projectSelfGrade"] isEqualToString:@"188"]) {//自评级别是否为 AA
            [postDataDic setValuesForKeysWithDictionary:self.projectLevelDic];
        }
    
        // 文件列表(网络)
        if (fileResultsArray.count != 0) {
            [postDataDic setObject:fileResultsArray forKey:@"crmProFilesList"];
        }
        // 删除了全部附件文件
        if (![[postDataDic allKeys] containsObject:@"crmProFilesList"]) {
            [postDataDic setObject:@[] forKey:@"crmProFilesList"];
        }
        [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, submitProReportApi] isNeedCache:NO parameters:postDataDic successBlock:^(id response) {
            DLog(@"文件提交:%@", response);
            [QMUITips hideAllToastInView:self.view animated:NO];
            if (1==[[response objectForKey:@"code"] integerValue]) {
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCRMList" object:nil];
            }
        } failureBlock:^(NSError *error) {
            [QMUITips hideAllToastInView:self.view animated:NO];
        } progress:nil];
    }
    
}
#pragma mark--tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, kHeightScale*32))];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"基本信息";
    lab.textColor = [UIColor colorWithHexString:@"#191F25"];
    lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(13)];
    [backView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Multiply(16));
        make.centerY.mas_equalTo(0);
    }];
    return backView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32*kHeightScale;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCRMYXAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CRMCellSys" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rightTF.textColor = [UIColor colorWithHexString:@"#41485D"];
    cell.hiddenLab.textColor = [UIColor colorWithHexString:@"#41485D"];
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];
    cell.editModel = model;
    cell.delegate = self;
    cell.accessorySwitch.enabled = NO;
    cell.accessoryBtn.enabled = NO;
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo] || [self.infoModel.flowStatusStr isEqualToString:@"已审批"]) {
        cell.accessorySwitch.hidden = YES;
        cell.accessoryBtn.hidden = YES;
    }
    if ([model.nameStr isEqualToString:@"预计投标日期"] || [model.nameStr isEqualToString:@"项目自评级别"] || [model.nameStr isEqualToString:@"预计定标日期"]) {
        cell.accessoryBtn.hidden = NO;
    }
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo] || [self.infoModel.flowStatus isEqualToString:@"60"]) {//有备案号 或者 已审批
        if ([model.nameStr isEqualToString:@"预计投标日期"] || [model.nameStr containsString:@"预计投标金额"] || [model.nameStr isEqualToString:@"项目自评级别"] || [model.nameStr isEqualToString:@"预计定标日期"] || [model.nameStr containsString:@"预计中标金额"] || [model.nameStr isEqualToString:@"跟踪动态"]) {
            cell.rightTF.textColor = [UIColor colorWithHexString:@"#2F86F6"];
            cell.hiddenLab.textColor = [UIColor colorWithHexString:@"#2F86F6"];
        }else if ([model.nameStr isEqualToString:@"项目推进情况"] || [model.nameStr isEqualToString:@"问题与支持"]) {
            cell.rightTF.textColor = [UIColor clearColor];
            cell.hiddenLab.textColor = [UIColor colorWithHexString:@"#2F86F6"];
        }

    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];
    YSCRMYXAddTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo] || [self.infoModel.flowStatusStr isEqualToString:@"已审批"]) {
        if (!([model.nameStr isEqualToString:@"预计定标日期"] || [model.nameStr isEqualToString:@"预计投标日期"] || [model.nameStr isEqualToString:@"项目自评级别"] || [model.nameStr containsString:@"金额"] || [model.nameStr containsString:@"单方造价"])) {
            return;
        }
    }
    YSWeak;
    CGRect bottomViewframe = CGRectMake(0, kSCREEN_HEIGHT-325*kHeightScale, kSCREEN_WIDTH, 325*kHeightScale);
    if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
        bottomViewframe = CGRectMake(0, kSCREEN_HEIGHT-325*kHeightScale-kTopHeight, kSCREEN_WIDTH, 325*kHeightScale);
    }
    if (model.accessoryView == AccessoryViewTypeDisclosureIndicator) {
        DLog(@"箭头项目");
        if ([model.nameStr isEqualToString:@"工程类别"]) {
            [self.view addSubview:self.cloverBtn];
            YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:bottomViewframe];
            [self.view addSubview:enumView];
            enumView.dataArray = self.programmeTypeArray;
            @weakify(self);
            [[enumView.cancelBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
            }];
            enumView.choseEnumBlock = ^(YSCRMYXGEnumModel * _Nonnull choseModel) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
                model.textTF = choseModel.name;
                cell.rightTF.text = choseModel.name;
                [weakSelf.paramDic setObject:choseModel.code forKey:@"programmeType"];
            };
        }else if ([model.nameStr isEqualToString:@"项目类型"]) {
            [self.view addSubview:self.cloverBtn];
            YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:bottomViewframe];
            [self.view addSubview:enumView];
            enumView.dataArray = self.projectTypeArray;
            @weakify(self);
            [[enumView.cancelBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
            }];
            enumView.choseEnumBlock = ^(YSCRMYXGEnumModel * _Nonnull choseModel) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
                model.textTF = choseModel.name;
                cell.rightTF.text = choseModel.name;
                [weakSelf.paramDic setObject:choseModel.code forKey:@"projectType"];
            };
            
        }else if ([model.nameStr isEqualToString:@"招标方式"]) {
            [self.view addSubview:self.cloverBtn];
            YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:bottomViewframe];
            [self.view addSubview:enumView];
            enumView.dataArray = self.tenderTypeArray;
            @weakify(self);
            [[enumView.cancelBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
            }];
            enumView.choseEnumBlock = ^(YSCRMYXGEnumModel * _Nonnull choseModel) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
                model.textTF = choseModel.name;
                cell.rightTF.text = choseModel.name;
                [weakSelf.paramDic setObject:choseModel.code forKey:@"tenderType"];
            };
        }else if ([model.nameStr isEqualToString:@"招标内容"]) {
            [self.view addSubview:self.cloverBtn];
            YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:bottomViewframe];
            [self.view addSubview:enumView];
            enumView.dataArray = self.tenderContentArray;
            @weakify(self);
            [[enumView.cancelBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
            }];
            enumView.choseEnumBlock = ^(YSCRMYXGEnumModel * _Nonnull choseModel) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
                model.textTF = choseModel.name;
                cell.rightTF.text = choseModel.name;
                [weakSelf.paramDic setObject:choseModel.code forKey:@"tenderContent"];
            };
        }else if ([model.nameStr isEqualToString:@"项目自评级别"]) {
            [self.view addSubview:self.cloverBtn];
            YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:bottomViewframe];
            @weakify(self);
            [[enumView.cancelBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
            }];
            enumView.choseEnumBlock = ^(YSCRMYXGEnumModel * _Nonnull choseModel) {
                @strongify(self);
                [self clickedCloverBtnAction:self.cloverBtn];
                model.textTF = choseModel.name;
                cell.rightTF.text = choseModel.name;
                [self.paramDic setObject:choseModel.code forKey:@"projectSelfGrade"];
                [self.recordNoDic setObject:choseModel.code forKey:@"projectSelfGrade"];//项目自评级别
                if (![choseModel.name isEqualToString:@"AA"]) {
                    [self.dataSourceArray removeObjectsInArray:self.projectLevelArray];
                    [self.tableView reloadData];
                }else if (![self.dataSourceArray containsObject:self.projectLevelArray[0]]){
                    [self.dataSourceArray insertObjects:self.projectLevelArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSMakeRange(self.projectLevelIndex, self.projectLevelArray.count))]];//预计中标金额-->问题与支持
                    [self.tableView reloadData];
                }
            };
            [self.view addSubview:enumView];
            enumView.dataArray = self.projectSelfGradeArray;
        }
        else if ([model.nameStr isEqualToString:@"工程地址"]) {
            YSXRMFJDAddressChoseView *areaView = [[YSXRMFJDAddressChoseView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
            areaView.tag = 1204;
            areaView.address_delegate = self;
            //        [[UIApplication sharedApplication].keyWindow addSubview:areaView];
            [self.view addSubview:areaView];
            [areaView setProvinceArray:[self.provinceArray copy]];
        }else if ([model.nameStr containsString:@"日期"]) {
            self.dateIndexPath = indexPath;
            PGDatePicker *datePicker = [[PGDatePicker alloc] init];
            datePicker.delegate = self;
            [datePicker showWithShadeBackgroud];
//            datePicker.minimumDate = [NSDate date];
            datePicker.datePickerMode = PGDatePickerModeDate;
        }
        else if ([model.nameStr isEqualToString:@"项目所属区域/团队"]) {
            if (self.deptArray.count != 0) {
                YSCRMDepartTreeViewController *departVC = [YSCRMDepartTreeViewController new];
                departVC.departArray = self.deptArray;
                departVC.choseCRMDeptTreeBlock = ^(NSArray * _Nonnull modelArray) {
                    // 部门
                    cell.rightTF.text = [NSString stringWithFormat:@"%@", [(YSDeptTreePointModel*)[modelArray objectAtIndex:0] point_name]];
                    model.textTF = [NSString stringWithFormat:@"%@", [(YSDeptTreePointModel*)[modelArray objectAtIndex:0] point_name]];
                    [weakSelf.paramDic setObject:[(YSDeptTreePointModel*)[modelArray objectAtIndex:0] point_id] forKey:@"deptId"];
                    [weakSelf.paramDic setObject:[(YSDeptTreePointModel*)[modelArray objectAtIndex:0] point_name] forKey:@"deptName"];
                    
                    
                    
                    [weakSelf requestPersonWithModelID:[(YSDeptTreePointModel*)[modelArray objectAtIndex:0] point_id] withIndexPath:indexPath];
                    
                };
                [self.navigationController pushViewController:departVC animated:YES];
            }else {
                [QMUITips showInfo:@"无部门可选" inView:self.view hideAfterDelay:1.5];
            }
        }
    }else if (model.accessoryView == AccessoryViewTypeDetailDisclosureButton) {
        DLog(@"选择人员");
        YSContactSelectPersonViewController *selectPerson = [[YSContactSelectPersonViewController alloc]init];
        selectPerson.indexPath = indexPath;
        selectPerson.jumpSourceStr = @"flowLaunch";
        [self.rt_navigationController pushViewController:selectPerson animated:YES];
    }else if (model.accessoryView == AccessoryViewTypeDetailSwitchON || model.accessoryView == AccessoryViewTypeDetailSwitchOFF) {
        [cell.accessorySwitch setOn:!cell.accessorySwitch.on];
        if (model.accessoryView == AccessoryViewTypeDetailSwitchON) {
            model.accessoryView = AccessoryViewTypeDetailSwitchOFF;
        }else {
            model.accessoryView = AccessoryViewTypeDetailSwitchON;
            
        }
        
        if ([model.nameStr isEqualToString:@"是否含有工业化装配式"]) {
            if (model.accessoryView == AccessoryViewTypeDetailSwitchOFF) {
                [self.dataSourceArray removeObjectsInArray:self.industrializationArray];
                
                
            }else {
                // 最后只有一个 备注cell 可以这样判断; cell多了可以用 自评级的判断
                if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {//有备案号
                    YSCRMYXBaseModel *lastModel = [self.dataSourceArray lastObject];
                    [self.dataSourceArray removeLastObject];
                    [self.dataSourceArray addObjectsFromArray:self.industrializationArray];
                    [self.dataSourceArray addObject:lastModel];

                }else {
                    [self.dataSourceArray addObjectsFromArray:self.industrializationArray];
                }
            }
            [self.paramDic setObject:@(model.accessoryView-3) forKey:@"isIndustryConf"];
            [self.tableView reloadData];
        }else if([model.nameStr isEqualToString:@"是否工管联动"]){
            // 工管联动 0不是 1是
            [self.paramDic setObject:@(model.accessoryView-3) forKey:@"isManagementLinkage"];
            
        }else if([model.nameStr isEqualToString:@"是否需要智能化支持"]){
            // 智能化支持 0不是 1是
            [self.paramDic setObject:@(model.accessoryView-3) forKey:@"isNeedIntelligentSupport"];
            
        }
    }else if (model.accessoryView == AccessoryViewTypeMoney) {
        CGFloat keyboardFrame_Y = kSCREEN_HEIGHT-kBottomHeight;
        if (![YSUtility judgeIsEmpty:self.infoModel.proAssessmentInfo.recordNo]) {
            //有备案号
            keyboardFrame_Y = keyboardFrame_Y - kTopHeight-40;
        }
        [self.view addSubview:self.cloverBtn];
        //金额键盘视图-币种默认是人民币
        CSNnumberKeyboardView *keyboardView = [[CSNnumberKeyboardView alloc] initWithFrame:(CGRectMake(0, keyboardFrame_Y-273, kSCREEN_WIDTH, 273)) withCurrencyStr:model.textTF?model.textTF:@"" withCurrentMoney:[model.currentyStr isEqualToString:@"$"]?@"美元":@"人民币"];
        keyboardView.tag = 10001;
        @weakify(self);
        //点击键盘上的币种选择按钮
        [[keyboardView.currencyBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            @strongify(self);
            self.choseIndex = indexPath;
            // 币种选择视图
            YSCRMChoseCurrencyView *currencyView = [[YSCRMChoseCurrencyView alloc] initWithFrame:(CGRectMake(0, keyboardFrame_Y-288*kHeightScale+10, kSCREEN_WIDTH, 288*kHeightScale))];
            if ([model.currentyStr containsString:@"$"]) {
                currencyView.titLab.text = @"美元";
            }else if ([model.currentyStr containsString:@"€"]) {
                currencyView.titLab.text = @"欧元";
            }else {
                currencyView.titLab.text = @"人民币";
            }
            currencyView.delegate = self;
            [self.view addSubview:currencyView];
        }];
        //点击键盘上的回收以及确定按钮
        keyboardView.choseBtnBlock = ^(BOOL isReturn) {
            @strongify(self);
            if (isReturn) {//为真 则当前显示的值为最后的值
                [self clickedCloverBtnAction:self.cloverBtn];
            }//为假还需在键盘视图在添加一个string记录初始数值 暂时不做操作
        };
        // 点击键盘其他按钮
        keyboardView.clickedKeyboardBlock = ^(NSString * _Nonnull number) {
            cell.rightTF.text = number;
            if (number.length > 1) {//去掉币种单位
                model.textTF = [number substringFromIndex:1];
            }else {
                model.textTF = @"";
            }
            [self changeDictionMoneyWithPathName:model.nameStr withValue:model.textTF];
        };
        [self.view addSubview:keyboardView];
        
    }
}
//将金额放入上传字典中
- (void)changeDictionMoneyWithPathName:(NSString*)name withValue:(NSString*)value {
    
    if ([name containsString:@"预计投标金额"]) {
        [self.paramDic setObject:value forKey:@"projectCost"];
        [self.recordNoDic setObject:value forKey:@"projectCost"];
    }else if ([name containsString:@"预计中标金额"]) {
        //这个必须要先将自评级别选为AA 不然没用
        [self.projectLevelDic setObject:value forKey:@"preWinnMoney"];
        [self.recordNoDic setObject:value forKey:@"preWinnMoney"];
    }else if ([name containsString:@"工业化装配式单方造价"]) {
        [self.industrializationDic setObject:value forKey:@"industryConfPrice"];
        
    }
}
// 根据项目所属区域/团队的id 请求负责人/对接人
- (void)requestPersonWithModelID:(NSString*)modelID withIndexPath:(NSIndexPath*)indexPath {
    [QMUITips showLoadingInView:self.view];
    
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getDeptLeaderAndPickerByIdApi] isNeedCache:NO parameters:@{@"deptId":modelID} successBlock:^(id response) {
        DLog(@"负责人和对接人和公司:%@", response);
        [QMUITips hideAllToastInView:self.view animated:NO];
        if (1 == [[response objectForKey:@"code"] integerValue]) {
            for (NSInteger i = 1; i < 4; i++) {
                YSCRMYXBaseModel *companyAutoModel = self.dataSourceArray[indexPath.row+i];
                YSCRMYXAddTableViewCell *companyAutoCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row+i) inSection:indexPath.section]];
                
                switch (i) {
                    case 1:
                    {
                        companyAutoModel.textTF = [[response objectForKey:@"data"] objectForKey:@"deptHeaderName"];
                        companyAutoCell.rightTF.text = [[response objectForKey:@"data"] objectForKey:@"deptHeaderName"];
                        [self.paramDic setObject:[[response objectForKey:@"data"] objectForKey:@"deptHeaderName"] forKey:@"deptLeader"];
                    }
                        break;
                    case 2:
                    {
                        companyAutoModel.textTF = [[response objectForKey:@"data"] objectForKey:@"companyName"];
                        companyAutoCell.rightTF.text = [[response objectForKey:@"data"] objectForKey:@"companyName"];
                        [self.paramDic setObject:[[response objectForKey:@"data"] objectForKey:@"companyName"] forKey:@"companyName"];
                        [self.paramDic setObject:[[response objectForKey:@"data"] objectForKey:@"companyId"] forKey:@"companyId"];
                    }
                        break;
                    case 3:
                    {
                        companyAutoModel.textTF = [[response objectForKey:@"data"] objectForKey:@"deptPicker"];
                        companyAutoCell.rightTF.text = [[response objectForKey:@"data"] objectForKey:@"deptPicker"];
                        [self.paramDic setObject:[[response objectForKey:@"data"] objectForKey:@"deptPicker"] forKey:@"pickUpUserName"];
                        [self.paramDic setObject:[[response objectForKey:@"data"] objectForKey:@"deptPickerNo"] forKey:@"pickUpUserNo"];
                    }
                        break;
                    default:
                        break;
                }
                
            }
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
    
}
#pragma mark - AreaSelectDelegate
- (void)selectIndex:(NSInteger)index selectDataArrayIndexID:(NSInteger)chose_index
{
    YSXRMFJDAddressChoseView *areaView = [self.view viewWithTag:1204];
    switch (index) {
        case 0:
        {
            
            
        }
            break;
        case 1:
        {
            self.provinceIndex = chose_index;
            [areaView setCityArray:self.ciryArray[chose_index]];
        }
            break;
        case 2:
        {
            self.cityIndex = chose_index;
            [areaView setRegionsArray:self.areaArray[self.provinceIndex][chose_index]];
        }
            break;
        default:
            break;
    }
}
- (void)getSelectAddressInfor:(NSArray *)addressInfor {
    self.provinceIndex = 0;
    self.cityIndex = 0;
    self.areaIndex = 0;
    DLog(@"所选的工程地址%@", addressInfor);
    NSIndexPath *adrressCellIndex = [NSIndexPath indexPathForRow:8 inSection:0];
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:adrressCellIndex];
    NSMutableString *addressStr = [NSMutableString stringWithCapacity:0];
    NSArray *keyArray = @[@[@"proProvinceCode", @"proProvinceName"], @[@"proCityCode", @"proCityName"], @[@"proAreaCode", @"proAreaName"]];
    for (int i = 0; i < keyArray.count; i++) {
        YSCRMFJDAddressProvincesModel *addressModel = [addressInfor objectAtIndex:i];
        [addressStr appendFormat:@"%@ ", addressModel.name];
        [self.paramDic setObject:addressModel.code forKey:keyArray[i][0]];
        [self.paramDic setObject:addressModel.name forKey:keyArray[i][1]];
    }
    cell.rightTF.text = addressStr;
    
    YSCRMYXBaseModel *model = self.dataSourceArray[8];
    model.textTF = addressStr;
    
}

#pragma mark--CRMYXTextFieldDelegate
- (void)textField:(UITextField*)textField inputTextFieldChangeModel:(YSCRMYXBaseModel *)model {
    YSWeak;
    NSInteger index = [weakSelf.dataSourceArray indexOfObject:model];
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.inputAccessoryView = nil;
    textField.inputView = nil;
    if ([model.nameStr containsString:@"项目名称"]) {
        textField.keyboardType = UIKeyboardTypeDefault;
    }else if ([model.nameStr containsString:@"详细地址"]) {
        textField.keyboardType = UIKeyboardTypeDefault;
    }else if ([model.nameStr containsString:@"甲方单位"]) {
        textField.keyboardType = UIKeyboardTypeDefault;
    }else if ([model.nameStr isEqualToString:@"甲方项目对接人"]) {
        textField.keyboardType = UIKeyboardTypeDefault;
    }else if ([model.nameStr isEqualToString:@"甲方项目对接人联系方式"]) {
        textField.keyboardType = UIKeyboardTypePhonePad;
    }else if ([model.nameStr isEqualToString:@"甲方项目对接人职务"]) {
        textField.keyboardType = UIKeyboardTypeDefault;
    }else if ([model.nameStr containsString:@"项目推进情况"]) {
        textField.keyboardType = UIKeyboardTypeDefault;
    }else if ([model.nameStr containsString:@"问题与支持"]) {
        textField.keyboardType = UIKeyboardTypeDefault;
    }else if ([model.nameStr containsString:@"工程面积"]) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        if ([[textField.text componentsSeparatedByString:@"."] count] == 2) {
            if ([[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] length] > 2) {
                textField.text =[NSString stringWithFormat:@"%@.%@", [[textField.text componentsSeparatedByString:@"."] firstObject], [[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] substringToIndex:2]];
            }
        }else if ([[textField.text componentsSeparatedByString:@"."] count] > 2) {
            if ([[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] length] > 2) {
                textField.text =[NSString stringWithFormat:@"%@.%@", [[textField.text componentsSeparatedByString:@"."] firstObject], [[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] substringToIndex:2]];
            }else {
                textField.text =[NSString stringWithFormat:@"%@.%@", [[textField.text componentsSeparatedByString:@"."] firstObject], [[textField.text componentsSeparatedByString:@"."] objectAtIndex:1]];
                
            }
        }
        if ([[textField.text componentsSeparatedByString:@"."] count] == 2 && [[[textField.text componentsSeparatedByString:@"."] objectAtIndex:0] length] < 1) {//先点小数点
            textField.text = [NSString stringWithFormat:@"0.%@", [[textField.text componentsSeparatedByString:@"."] objectAtIndex:1]];
        }
        if (textField.text.length >= 2 && [[textField.text substringToIndex:1] isEqualToString:@"0"] && ![[textField.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]) {//首位是0 且0后不跟小数点
            textField.text = [textField.text substringFromIndex:1];
        }

    }else if ([model.nameStr containsString:@"工业化装配式体量"]) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        if ([[textField.text componentsSeparatedByString:@"."] count] == 2) {
            if ([[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] length] > 2) {
                textField.text =[NSString stringWithFormat:@"%@.%@", [[textField.text componentsSeparatedByString:@"."] firstObject], [[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] substringToIndex:2]];
            }
        }else if ([[textField.text componentsSeparatedByString:@"."] count] > 2) {
            if ([[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] length] > 2) {
                textField.text =[NSString stringWithFormat:@"%@.%@", [[textField.text componentsSeparatedByString:@"."] firstObject], [[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] substringToIndex:2]];
            }else {
                textField.text =[NSString stringWithFormat:@"%@.%@", [[textField.text componentsSeparatedByString:@"."] firstObject], [[textField.text componentsSeparatedByString:@"."] objectAtIndex:1]];
                
            }
        }
        if ([[textField.text componentsSeparatedByString:@"."] count] == 2 && [[[textField.text componentsSeparatedByString:@"."] objectAtIndex:0] length] < 1) {//先点小数点
            textField.text = [NSString stringWithFormat:@"0.%@", [[textField.text componentsSeparatedByString:@"."] objectAtIndex:1]];
        }
        if (textField.text.length >= 2 && [[textField.text substringToIndex:1] isEqualToString:@"0"] && ![[textField.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]) {//首位是0 且0后不跟小数点
            textField.text = [textField.text substringFromIndex:1];
        }

    }else if ([model.nameStr containsString:@"订单总套数"]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        if (textField.text.length >= 2 && [[textField.text substringToIndex:1] isEqualToString:@"0"]) {//首位是0 且0后不跟小数点
            textField.text = [textField.text substringFromIndex:1];
        }
    }else if ([model.nameStr containsString:@"订单户型个数"]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        if (textField.text.length >= 2 && [[textField.text substringToIndex:1] isEqualToString:@"0"]) {//首位是0 且0后不跟小数点
            textField.text = [textField.text substringFromIndex:1];
        }
    }else if ([model.nameStr containsString:@"预付款比例"]) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        if ([[textField.text componentsSeparatedByString:@"."] count] == 2) {
            if ([[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] length] > 2) {
                textField.text =[NSString stringWithFormat:@"%@.%@", [[textField.text componentsSeparatedByString:@"."] firstObject], [[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] substringToIndex:2]];
            }
        }else if ([[textField.text componentsSeparatedByString:@"."] count] > 2) {
            if ([[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] length] > 2) {
                textField.text =[NSString stringWithFormat:@"%@.%@", [[textField.text componentsSeparatedByString:@"."] firstObject], [[[textField.text componentsSeparatedByString:@"."] objectAtIndex:1] substringToIndex:2]];
            }else {
                textField.text =[NSString stringWithFormat:@"%@.%@", [[textField.text componentsSeparatedByString:@"."] firstObject], [[textField.text componentsSeparatedByString:@"."] objectAtIndex:1]];
                
            }
        }
        if ([[textField.text componentsSeparatedByString:@"."] count] == 2 && [[[textField.text componentsSeparatedByString:@"."] objectAtIndex:0] length] < 1) {//先点小数点
            textField.text = [NSString stringWithFormat:@"0.%@", [[textField.text componentsSeparatedByString:@"."] objectAtIndex:1]];
        }
        if (textField.text.length >= 2 && [[textField.text substringToIndex:1] isEqualToString:@"0"] && ![[textField.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]) {//首位是0 且0后不跟小数点
            textField.text = [textField.text substringFromIndex:1];
        }

        if ([textField.text doubleValue] > 100.00) {
            [QMUITips showInfo:@"已到最大值" inView:self.view hideAfterDelay:1];
            textField.text = @"100.00";
        }
    }
    //----------------------赋值----------------------------------
    if ([textField.text containsString:@"¥"] || [textField.text containsString:@"$"] || [textField.text containsString:@"€"]) {
        model.textTF = [textField.text substringFromIndex:1];
    }else {
        model.textTF = textField.text;
    }
    
    if (![YSUtility judgeIsEmpty:textField.text] && ([model.nameStr isEqualToString:@"项目名称"]||[model.nameStr isEqualToString:@"项目推进情况"] || [model.nameStr isEqualToString:@"问题与支持"])) {
        cell.hiddenLab.hidden = NO;
        cell.rightTF.textColor = [UIColor clearColor];
        
        [cell.leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
            make.width.mas_equalTo(131*kWidthScale);
            make.top.mas_equalTo(14*kHeightScale);
            
        }];
        NSMutableArray *rowArray = [NSMutableArray new];
        for (NSInteger i = index+1; i < weakSelf.dataSourceArray.count; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView reloadRowsAtIndexPaths:rowArray withRowAnimation:(UITableViewRowAnimationNone)];
    }else {
        cell.hiddenLab.hidden = YES;
        cell.rightTF.textColor = [UIColor colorWithHexString:@"#41485D"];
        [cell.leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
            make.width.mas_equalTo(131*kWidthScale);
            make.top.mas_equalTo(14*kHeightScale);
            make.bottom.mas_equalTo(-14*kHeightScale);
        }];
    }
    
    if ([model.nameStr containsString:@"项目名称"]) {
        [self.paramDic setObject:model.textTF forKey:@"projectName"];
        
    }else if ([model.nameStr containsString:@"工程面积"]) {
        [self.paramDic setObject:model.textTF forKey:@"projectArea"];
        
    }else if ([model.nameStr isEqualToString:@"详细地址"]) {
        [self.paramDic setObject:model.textTF forKey:@"proAddress"];
    }else if ([model.nameStr isEqualToString:@"甲方单位"]) {
        [self.paramDic setObject:model.textTF forKey:@"firstPartyCompany"];
        
    }else if ([model.nameStr isEqualToString:@"甲方项目对接人"]) {
        [self.paramDic setObject:model.textTF forKey:@"firstPartyUser"];
        
    }else if ([model.nameStr isEqualToString:@"甲方项目对接人联系方式"]) {
        [self.paramDic setObject:model.textTF forKey:@"firstPartyUserLink"];
        
    }else if ([model.nameStr isEqualToString:@"甲方项目对接人职务"]) {
        [self.paramDic setObject:model.textTF forKey:@"firstPartyUserPost"];
        
    }else if ([model.nameStr isEqualToString:@"项目推进情况"]) {
        [self.projectLevelDic setObject:model.textTF forKey:@"projectProgressRemark"];
        [self.recordNoDic setObject:model.textTF forKey:@"projectProgressRemark"];
    }else if ([model.nameStr isEqualToString:@"问题与支持"]) {
        [self.projectLevelDic setObject:model.textTF forKey:@"questionSupportRemark"];
        [self.recordNoDic setObject:model.textTF forKey:@"questionSupportRemark"];
    }else if ([model.nameStr containsString:@"工业化装配式体量"]) {
        [self.industrializationDic setObject:model.textTF forKey:@"industryConfArea"];
        
    }else if ([model.nameStr containsString:@"订单总套数"]) {
        [self.industrializationDic setObject:model.textTF forKey:@"orderCount"];
        
    }else if ([model.nameStr containsString:@"订单户型个数"]) {
        [self.industrializationDic setObject:model.textTF forKey:@"orderApartmentCount"];
        
    }else if ([model.nameStr containsString:@"预付款比例"]) {
        [self.industrializationDic setObject:model.textTF forKey:@"advanceChargeProportion"];
        
    }
    
}

#pragma mark--YSCRMChoseCurrencyDelegate
- (void)didTableViewCellWith:(NSString *)currencyStr {
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.choseIndex];
    YSCRMYXBaseModel *model = [self.dataSourceArray objectAtIndex:self.choseIndex.row];
    CSNnumberKeyboardView *keyBoardView = [self.view viewWithTag:10001];
    if (![YSUtility judgeIsEmpty:currencyStr]) {// 为空 点击的是取消按钮
        cell.rightTF.text = [NSString stringWithFormat:@"%@%@", currencyStr, model.textTF];
        model.currentyStr = currencyStr;
        keyBoardView.currencyLab.text = [currencyStr isEqualToString:@"¥"]?@"人民币":@"美元";
        keyBoardView.currencyStr = currencyStr;
        if ([model.nameStr containsString:@"预计投标金额"]) {//预计投标金额 10人民币 20美元
            [self.paramDic setObject:[model.currentyStr isEqualToString:@"¥"] ? @"10" : @"20" forKey:@"projectCostCurrency"];
            [self.recordNoDic setObject:[self.paramDic objectForKey:@"projectCostCurrency"] forKey:@"projectCostCurrency"];
        }else if ([model.nameStr containsString:@"预计中标金额"]) {//预计中标金额
            [self.projectLevelDic setObject:[model.currentyStr isEqualToString:@"¥"] ? @"10" : @"20" forKey:@"preWinnMoneyCurrency"];
            [self.recordNoDic setObject:[self.projectLevelDic objectForKey:@"preWinnMoneyCurrency"] forKey:@"preWinnMoneyCurrency"];

        }else if ([model.nameStr containsString:@"工业化装配式单方造价"]) {//工业化装配式单方造价
            [self.industrializationDic setObject:[model.currentyStr isEqualToString:@"¥"] ? @"10" : @"20" forKey:@"industryConfPriceCurrency"];
        }
    }
    [cell.rightTF becomeFirstResponder];
    self.choseIndex = nil;
}

#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.dateIndexPath];
    YSCRMYXBaseModel *model = [self.dataSourceArray objectAtIndex:self.dateIndexPath.row];
    if (datePicker.datePickerMode == PGDatePickerModeDate) {
        model.textTF = [NSString stringWithFormat:@"%zd-%02ld-%02ld", dateComponents.year, dateComponents.month, dateComponents.day];
        cell.rightTF.text = [NSString stringWithFormat:@"%zd-%02ld-%02ld", dateComponents.year, dateComponents.month, dateComponents.day];
    }
    self.dateIndexPath = nil;
    if ([model.nameStr isEqualToString:@"预计投标日期"]) {
        [self.paramDic setObject:model.textTF forKey:@"tenderExpectDate"];
        [self.recordNoDic setObject:model.textTF forKey:@"tenderExpectDate"];
    }else if ([model.nameStr isEqualToString:@"预计定标日期"]) {
        [self.paramDic setObject:model.textTF forKey:@"preWinnDate"];
        [self.recordNoDic setObject:model.textTF forKey:@"preWinnDate"];
    }else if ([model.nameStr isEqualToString:@"预计进场日期"]) {
        [self.paramDic setObject:model.textTF forKey:@"planEnterDate"];
    }else if ([model.nameStr isEqualToString:@"预计完成日期"]) {
        [self.paramDic setObject:model.textTF forKey:@"planFinishDate"];
    }else if ([model.nameStr isEqualToString:@"预计竣工日期"]) {
        [self.industrializationDic setObject:model.textTF forKey:@"planCompleteDate"];
    }
}
#pragma mark--人员单选回调通知
- (void)selectPerson:(NSNotification *)notification {
    YSContactModel *internalModel = notification.userInfo[@"selectedArray"][0];
    NSIndexPath *indexPath = notification.userInfo[@"selectIndexPath"];
    YSCRMYXBaseModel *model = [self.dataSourceArray objectAtIndex:indexPath.row];
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    model.textTF = internalModel.name;
    cell.rightTF.text = internalModel.name;
    [self.paramDic setObject:internalModel.userId forKey:@"proTrackNo"];
    [self.paramDic setObject:internalModel.name forKey:@"proTrackName"];
    [self.paramDic setObject:internalModel.mobile forKey:@"proTrackMobile"];
    
    // 项目跟踪人联系方式
    NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    YSCRMYXAddTableViewCell *otherCell = [self.tableView cellForRowAtIndexPath:otherIndexPath];
    YSCRMYXBaseModel *otherModel = [self.dataSourceArray objectAtIndex:otherIndexPath.row];
    otherCell.rightTF.text = internalModel.mobile;
    otherModel.textTF = internalModel.mobile;
    
}
#pragma mark --setter&&getter
- (NSMutableDictionary *)recordNoDic {
    if (!_recordNoDic) {
        _recordNoDic = [NSMutableDictionary new];
    }
    return _recordNoDic;
}
- (NSMutableDictionary *)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
}
- (NSMutableArray *)fileNetworkArray {
    if (!_fileNetworkArray) {
        _fileNetworkArray = [NSMutableArray new];
    }
    return _fileNetworkArray;
}
- (NSMutableArray *)fileArray {
    if (!_fileArray) {
        _fileArray = [NSMutableArray new];
    }
    return _fileArray;
}
- (NSMutableDictionary *)industrializationDic {
    if (!_industrializationDic) {
        _industrializationDic = [NSMutableDictionary new];
    }
    return _industrializationDic;
}
- (NSMutableDictionary *)projectLevelDic {
    if (!_projectLevelDic) {
        _projectLevelDic = [NSMutableDictionary new];
    }
    return _projectLevelDic;
}
- (NSMutableArray *)industrializationArray {
    if (!_industrializationArray) {
        NSArray *dataArray = @[@{@"nameStr":@"工业化装配式体量(平方米)", @"holderStr":@"精确到小数点后两位", @"accessoryView":@0}, @{@"nameStr":@"工业化装配式单方造价(元/平方米)", @"holderStr":@"精确到小数点后两位", @"accessoryView":@(AccessoryViewTypeMoney), @"isTFEnabled":@(YES), @"currentyStr":@"¥"}, @{@"nameStr":@"预计竣工日期", @"holderStr":@"请选择", @"accessoryView":@1, @"accessoryView":@1, @"isTFEnabled":@(YES)}, @{@"nameStr":@"订单总套数", @"holderStr":@"可输入", @"accessoryView":@0}, @{@"nameStr":@"订单户型个数", @"holderStr":@"可输入整数", @"accessoryView":@0}, @{@"nameStr":@"预付款比例(%)", @"holderStr":@"精确到小数点后两位", @"accessoryView":@0}];
        _industrializationArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray]];
    }
    return _industrializationArray;
}

- (NSMutableArray *)projectLevelArray {
    if (!_projectLevelArray) {
        NSArray *dataArray = @[@{@"nameStr":@"预计中标金额 (万元)", @"currentyStr":@"¥", @"holderStr":@"精确到小数点后两位", @"accessoryView":@(AccessoryViewTypeMoney), @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"项目推进情况", @"holderStr":@"请输入", @"accessoryView":@0, @"isMustWrite":@(YES)}, @{@"nameStr":@"问题与支持", @"holderStr":@"请输入", @"accessoryView":@0, @"isMustWrite":@(YES)}];
        _projectLevelArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray]];
    }
    return _projectLevelArray;
}

- (UIButton *)cloverBtn {
    if (!_cloverBtn) {
        _cloverBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _cloverBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _cloverBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
        [_cloverBtn addTarget:self action:@selector(clickedCloverBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _cloverBtn;
}

- (void)clickedCloverBtnAction:(UIButton*)sender {
    
    YSWeak;
    [self.view endEditing:YES];
    self.choseIndex = nil;
    UIView *superView = sender.superview;
    UIView *outsideView = [superView.subviews lastObject];
    UIView *keyboard = [self.view viewWithTag:10001];
    [UIView animateWithDuration:1 animations:^{
        [outsideView removeFromSuperview];
        [keyboard removeFromSuperview];
        [weakSelf.view addSubview:weakSelf.cloverBtn];
    } completion:^(BOOL finished) {
        [weakSelf.cloverBtn removeFromSuperview];
        weakSelf.cloverBtn = nil;
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"修改界面销毁");
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
