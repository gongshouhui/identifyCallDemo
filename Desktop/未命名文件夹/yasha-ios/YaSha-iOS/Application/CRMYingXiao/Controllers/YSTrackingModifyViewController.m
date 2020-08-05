//
//  YSTrackingModifyViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/6/11.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSTrackingModifyViewController.h"
#import "YSBottomTwoBtnCGView.h"
#import "YSCRMYXAddTableViewCell.h"
#import "YSCRMYXBaseModel.h"
#import "YSFlowFormSectionHeaderView.h"
#import "YSCRMEnumChoseGView.h"



@interface YSTrackingModifyViewController ()
@property (nonatomic, strong) NSMutableDictionary *paramDic;
@property (nonatomic,strong)YSReporetInfoModel *infoModel;
@property (nonatomic,strong)YSAssessmentOtherModel *otherModel;
@property (nonatomic, strong) NSMutableArray *expensePersonArr;
@property (nonatomic, strong) NSMutableArray *trackStateArray;
@property (nonatomic, strong) UIButton *cloverBtn;



@end

@implementation YSTrackingModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 其他信息
    [self loadBottomBtnView];
    [self doNetworking];
}
- (void)layoutTableView {
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kBottomHeight-90*kHeightScale-kTopHeight-40*kHeightScale);
}

- (void)initTableView {
    [super initTableView];
    [self.tableView registerClass:[YSCRMYXAddTableViewCell class] forCellReuseIdentifier:@"CRMCellSys"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    if (@available(iOS 11, *)) {
//        self.tableView.estimatedRowHeight = 0;
//        self.tableView.estimatedSectionFooterHeight = 0;
//        self.tableView.estimatedSectionHeaderHeight = 0;
//    }else{
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
}

- (void)loadBottomBtnView {
    YSBottomTwoBtnCGView *bottomView = [[YSBottomTwoBtnCGView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView.leftBtn addTarget:self action:@selector(clickedSaveBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView changeSubViewsWith:1];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 70*kHeightScale));
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(20*kHeightScale);
        make.left.mas_equalTo(0);
    }];
}

- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@", YSDomain, getProReportInfoByIdApi,self.id] isNeedCache:NO parameters:@{@"type":@"BAPG"} successBlock:^(id response) {
        DLog(@"\n详情-%@",response);
        dispatch_group_leave(group);
        if ([response[@"code"] integerValue] == 1) {
            NSArray *dataArrayt = [YSDataManager getReporedInfoData:response];
            self.model = dataArrayt[0];
            [self.paramDic setValuesForKeysWithDictionary:[[response objectForKey:@"data"] objectForKey:@"proReportInfo"]];
            [self loadInitData];
        }
    } failureBlock:^(NSError *error) {
        dispatch_group_leave(group);
    } progress:nil];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getDicTypeEnumApi] isNeedCache:NO parameters:nil successBlock:^(id response) {
            DLog(@"跟踪动态枚举值:%@-\n想要的值:%@", response, [response objectForKey:@"trackState"]);
            dispatch_group_leave(group);
            
            if (1 == [[response objectForKey:@"code"] integerValue]) {
                _trackStateArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[[response objectForKey:@"data"] objectForKey:@"trackState"]]];//跟踪动态
            }
        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group);
        } progress:nil];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [QMUITips hideAllToastInView:self.view animated:NO];
    });
    
}

- (void)loadInitData {
    NSMutableArray *otherArray = [NSMutableArray array];
    self.infoModel = self.model.proReportInfo;
    self.otherModel = self.infoModel.proAssessmentOther;
    // 其他信息
    [otherArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"业务阶段", @"holderStr":@"", @"accessoryView":@0, @"isMustWrite":@(YES), @"textTF":[YSUtility cancelNullData:self.infoModel.bizStatusStr], @"isTFEnabled":@(YES)}]];
    
    [otherArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"跟踪动态", @"holderStr":@"需选择", @"accessoryView":@1, @"textTF":[YSUtility cancelNullData:self.otherModel.trackStateStr], @"isTFEnabled":@(YES)}]];
    
    [otherArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否放弃", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility judgeWhetherOrNot:self.otherModel.isGiveUp], @"isTFEnabled":@(YES)}]];
    [self.expensePersonArr addObject:@{@"其他信息":otherArray}];
    [self.dataSourceArray addObject:otherArray];
    
    //----------------报名资审----------------------
    NSMutableArray *informationArray = [NSMutableArray array];
    [informationArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否资审", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility judgeWhetherOrNot:self.otherModel.isCapitalAudit], @"isTFEnabled":@(YES)}]];

    [informationArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"报名/资审日期", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility timestampSwitchTime:self.otherModel.capitalAuditDate andFormatter:@"yyyy-MM-dd"], @"isTFEnabled":@(YES)}]];
    
    [informationArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"报名/资审结果", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility judgeWhetherOrPass:self.otherModel.capitalAuditResult], @"isTFEnabled":@(YES)}]];
    [self.expensePersonArr addObject:@{@"报名资审":informationArray}];
    [self.dataSourceArray addObject:informationArray];
    
    //----------------投标阶段----------------------
    NSMutableArray *tenderArray = [NSMutableArray array];
    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"标前评审日期", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility timestampSwitchTime:self.otherModel.preReviewDate andFormatter:@"yyyy-MM-dd"], @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"投标日期", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility timestampSwitchTime:self.otherModel.bidDate andFormatter:@"yyyy-MM-dd"], @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"质量要求", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility cancelNullData:self.otherModel.qualityRequirement], @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"保证金金额(万元)", @"holderStr":@"", @"accessoryView":@0, @"textTF":[NSString stringWithFormat:@"%@ %@",self.otherModel.bondMoney.length > 0 ?self.infoModel.preWinnMoneyCurrencyStr:@"",[YSUtility cancelNullData:self.otherModel.bondMoney]], @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"保证金类型", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility cancelNullData:self.otherModel.bondTypeStr], @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否转履约", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility judgeWhetherOrNot:self.otherModel.isPerformance], @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"投标项目经理", @"holderStr":@"", @"accessoryView":@0, @"textTF":self.otherModel.bidManager, @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否出场", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility judgeWhetherOrNot:self.otherModel.isOut], @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"出场日期", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility timestampSwitchTime:self.otherModel.outDate andFormatter:@"yyyy-MM-dd"], @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"商务标", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility cancelNullData:self.otherModel.businessStandard], @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"技术标", @"holderStr":@"", @"accessoryView":@0, @"textTF":self.otherModel.technologyStandard, @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"资信标", @"holderStr":@"", @"accessoryView":@0, @"textTF":self.otherModel.creditworthinessStandard, @"isTFEnabled":@(YES)}]];

    [tenderArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"其他配合", @"holderStr":@"", @"accessoryView":@0, @"textTF":self.otherModel.otherCoordination, @"isTFEnabled":@(YES)}]];

    [self.expensePersonArr addObject:@{@"投标阶段":tenderArray}];
    [self.dataSourceArray addObject:tenderArray];
    //++++++++++++++++++++结束阶段++++++++++++++++++
    NSMutableArray *endArray = [NSMutableArray array];
    [endArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否有开标反馈", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility judgeWhetherOrNot:self.otherModel.isHaveFeedback], @"isTFEnabled":@(YES)}]];

    [endArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"开标结果", @"holderStr":@"", @"accessoryView":@0, @"textTF":self.otherModel.bidOpenResultStr, @"isTFEnabled":@(YES)}]];

    [endArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"中标日期", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility timestampSwitchTime:self.otherModel.winBidDate andFormatter:@"yyyy-MM-dd"], @"isTFEnabled":@(YES)}]];

    [endArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"中标金额(万元)", @"holderStr":@"", @"accessoryView":@0, @"textTF":[NSString stringWithFormat:@"%@ %@",self.otherModel.winBidMoney.length > 0 ?self.infoModel.preWinnMoneyCurrencyStr:@"",[YSUtility cancelNullData:self.otherModel.winBidMoney]], @"isTFEnabled":@(YES)}]];

    [endArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"是否有中标通知书", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility judgeWhetherOrNot:self.otherModel.isHaveNotice], @"isTFEnabled":@(YES)}]];

    [endArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"合同项目经理", @"holderStr":@"", @"accessoryView":@0, @"textTF":self.otherModel.contractProManager, @"isTFEnabled":@(YES)}]];
    [endArray addObject:[YSCRMYXBaseModel yy_modelWithJSON:@{@"nameStr":@"合同签订日期", @"holderStr":@"", @"accessoryView":@0, @"textTF":[YSUtility timestampSwitchTime:self.otherModel.contractSignedDate andFormatter:@"yyyy-MM-dd"], @"isTFEnabled":@(YES)}]];

    [self.expensePersonArr addObject:@{@"结束阶段":endArray}];
    [self.dataSourceArray addObject:endArray];
    
    [self.tableView reloadData];
    
}

- (void)clickedSaveBtnAction {
    // 基本信息页面的 可修改信息
    [self.paramDic setValuesForKeysWithDictionary:self.recordNoDic];
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, saveProReportApi] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"单据保存数据:%@", response);
        if (1 == [[response objectForKey:@"code"] integerValue]) {
            [QMUITips showSucceed:[response objectForKey:@"msg"] inView:self.view hideAfterDelay:1];
            
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}

#pragma mark-- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCRMYXAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CRMCellSys" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.section][indexPath.row];
    cell.editModel = model;
    cell.accessorySwitch.enabled = NO;
    cell.accessoryBtn.enabled = NO;
    if ([model.nameStr isEqualToString:@"跟踪动态"]) {
        cell.rightTF.textColor = [UIColor colorWithHexString:@"#2F86F6"];
    }else {
        cell.rightTF.textColor = [UIColor colorWithHexString:@"#41485D"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.section][indexPath.row];
    YSCRMYXAddTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row ==1) {
        @weakify(self);
        [self.view addSubview:self.cloverBtn];
        YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:(CGRectMake(0, kSCREEN_HEIGHT-325*kHeightScale-kTopHeight, kSCREEN_WIDTH, 325*kHeightScale))];
        [self.view addSubview:enumView];
        enumView.dataArray = self.trackStateArray;
        [[enumView.cancelBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            @strongify(self);
            [self clickedCloverBtnAction:self.cloverBtn];
        }];
        enumView.choseEnumBlock = ^(YSCRMYXGEnumModel * _Nonnull choseModel) {
            @strongify(self);
            [self clickedCloverBtnAction:self.cloverBtn];
            model.textTF = choseModel.name;
            cell.rightTF.text = choseModel.name;
            NSMutableDictionary *proAssessmentOtherDic = [NSMutableDictionary dictionaryWithDictionary:[self.paramDic objectForKey:@"proAssessmentOther"]];
            [proAssessmentOtherDic setObject:choseModel.code forKey:@"trackState"];
            [self.paramDic setObject:proAssessmentOtherDic forKey:@"proAssessmentOther"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"saveCRMWithRecordNo" object:nil userInfo:@{@"proAssessmentOther":proAssessmentOtherDic}];//跟踪状态
        };
    }
}


#pragma mark--setter&&getter
- (NSMutableArray *)trackStateArray {
    if (!_trackStateArray) {
        _trackStateArray = [NSMutableArray new];
    }
    return _trackStateArray;
}
- (NSMutableArray *)expensePersonArr {
    if (!_expensePersonArr) {
        _expensePersonArr = [NSMutableArray new];
    }
    return _expensePersonArr;
}
- (NSMutableDictionary *)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
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
    UIView *superView = sender.superview;
    UIView *outsideView = [superView.subviews lastObject];
    [UIView animateWithDuration:1 animations:^{
        [outsideView removeFromSuperview];
        [weakSelf.view addSubview:weakSelf.cloverBtn];
    } completion:^(BOOL finished) {
        [weakSelf.cloverBtn removeFromSuperview];
        weakSelf.cloverBtn = nil;
    }];
    
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
