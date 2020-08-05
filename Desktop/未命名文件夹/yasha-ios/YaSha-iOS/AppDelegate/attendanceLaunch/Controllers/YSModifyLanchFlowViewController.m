//
//  YSModifyLanchFlowViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2020/2/19.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSModifyLanchFlowViewController.h"
#import "YSCRMYXAddTableViewCell.h"
#import "YSFlowLaunchFormHeaderView.h"
#import "YSCRMYXBaseModel.h"
#import "YSFlowLaunchFormListModel.h"
#import "YSCRMEnumChoseGView.h"
#import "YSFlowFormModel.h"
#import "YSFlowPageController.h"

@interface YSModifyLanchFlowViewController ()<PGDatePickerDelegate,CRMYXTextFieldDelegate>
@property (nonatomic, strong) YSFlowLaunchFormHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableDictionary *paramDic;

@property (nonatomic, strong) NSArray *flowTypeArray;//流程类型选项
@property (nonatomic, strong) NSArray *modifyTypeArray;//修改类型选项
//qj 请假/调休申请流程,cc 出差申请流程,ygwc 因公外出申请流程,jb 加班申请流程,yc 异常申诉流程
@property (nonatomic, strong) NSMutableArray *jbDataArray;
@property (nonatomic, strong) NSMutableArray *qjDataArray;
@property (nonatomic, strong) NSMutableArray *ccDataArray;
@property (nonatomic, strong) NSMutableArray *ygwcDataArray;
@property (nonatomic, strong) NSMutableArray *ycDataArray;
@property (nonatomic, strong) NSMutableArray *fromNumArray;
@property (nonatomic, strong) NSMutableArray *xmtxDataArray;//做缓存使用 均未用到


@property (nonatomic, copy) NSString *requestTypeStr;
@property (nonatomic, strong) YSFlowFormModel *fromInfoModel;
@property (nonatomic, strong) NSIndexPath *dateIndexPath;


@property (nonatomic, strong) UIButton *cloverBtn;

@end

@implementation YSModifyLanchFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修正考勤申请流程";
    [self loadInitData];
    [self doNetworking];
    [self.paramDic setObject:@"atds_writeOff_apply_flow" forKey:@"modelKey"];
    [self.paramDic setObject:@"submit" forKey:@"optFlag"];
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView registerClass:[YSCRMYXAddTableViewCell class] forCellReuseIdentifier:@"attendanceCellSys"];
}
- (void)loadInitData {
    //申请信息
    NSArray *dataArray1 = @[@{@"nameStr":@"流程类型", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"流程单号", @"holderStr":@"选择符合流程类型的单号", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"开始日期", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"结束日期", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"天数", @"holderStr":@"自动计算", @"accessoryView":@0, @"isTFEnabled":@(YES)}];
    [self.dataSourceArray addObject:[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray1]]];
    //修改信息
    NSArray *dataArray2 = @[@{@"nameStr":@"修改类型", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"开始时间", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"开始时间时段", @"holderStr":@"非必填", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"结束时间", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"结束时间时段", @"holderStr":@"非必填", @"accessoryView":@0, @"isTFEnabled":@(YES)}];
    [self.dataSourceArray addObject:[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray2]]];

//@{@"name":@"出差申请", @"code":@"cc"}
    self.flowTypeArray = [NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:@[@{@"name":@"加班申请", @"code":@"jb"}, @{@"name":@"因公外出申请", @"code":@"ygwc"}, @{@"name":@"异常申诉申请", @"code":@"yc"}, @{@"name":@"请假调休申请", @"code":@"qj"}, @{@"name":@"项目调休申请", @"code":@"xmtx"}]];
    
    self.modifyTypeArray = [NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:@[@{@"name":@"撤销申请流程", @"code":@"10"}, @{@"name":@"调整申请日期", @"code":@"20"}]];
}

//修改流程类型 初始化界面
- (void)refreshInitData{
    
    YSCRMYXBaseModel *model = self.dataSourceArray[0][0];
    [self.dataSourceArray removeAllObjects];
    
     
    NSString *processType = [self.paramDic objectForKey:@"processType"];
    [self.paramDic removeAllObjects];
    [self.paramDic setObject:@"atds_writeOff_apply_flow" forKey:@"modelKey"];
    [self.paramDic setObject:@"submit" forKey:@"optFlag"];
    [self.paramDic setObject:processType forKey:@"processType"];
    
    //申请信息
    NSArray *dataArray1 = @[@{@"nameStr":@"流程类型", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES), @"textTF":model.textTF}, @{@"nameStr":@"流程单号", @"holderStr":@"选择符合流程类型的单号", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"开始日期", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"结束日期", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"天数", @"holderStr":@"自动计算", @"accessoryView":@0, @"isTFEnabled":@(YES)}];
    [self.dataSourceArray addObject:[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray1]]];
    
    //修改信息
    NSArray *dataArray2 = @[@{@"nameStr":@"修改类型", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"开始时间", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"开始时间时段", @"holderStr":@"非必填", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"结束时间", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"结束时间时段", @"holderStr":@"非必填", @"accessoryView":@0, @"isTFEnabled":@(YES)}];
    [self.dataSourceArray addObject:[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray2]]];

    
    self.fromInfoModel = nil;
    [self.tableView reloadData];
}

- (void)doNetworking {
    [super doNetworking];

    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getFormDesInfoApi, _lanchModel.modelKey];//atds_writeOff_apply_flow
    DLog(@"===========%@",urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"获取表单的 头部数据:%@", response);
        [QMUITips hideAllToastInView:self.view animated:NO];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            YSFlowLaunchFormListModel *flowLaunchFormListModel = [YSFlowLaunchFormListModel yy_modelWithJSON:response[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.headerView setHeaderModel:flowLaunchFormListModel];
                [self ys_reloadData];
            });
        });
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}

#pragma mark-- 请求流程单号列表
- (void)requestDataList {
//    if (self.fromNumArray.count != 0) {
//        return;
//    }
    [self refreshInitData];
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getFlowDataByType] isNeedCache:NO parameters:@{@"type":self.requestTypeStr} successBlock:^(id response) {
        DLog(@"流程类型%@\n%@", self.requestTypeStr,response);
        [QMUITips hideAllToastInView:self.view animated:NO];
        if ([response[@"code"] intValue] == 1) {
            self.fromNumArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[response objectForKey:@"data"]]];
            for (YSCRMYXGEnumModel *model in self.fromNumArray) {
                model.name = model.flowCode;
            }
            if ([self.requestTypeStr isEqualToString:@"jb"]) {
                self.jbDataArray = [NSMutableArray arrayWithArray:self.fromNumArray];
            }else if ([self.requestTypeStr isEqualToString:@"ygwc"]) {
                self.ygwcDataArray = [NSMutableArray arrayWithArray:self.fromNumArray];
            }else if ([self.requestTypeStr isEqualToString:@"yc"]) {
                self.ycDataArray = [NSMutableArray arrayWithArray:self.fromNumArray];
            }else if ([self.requestTypeStr isEqualToString:@"qj"]) {
                self.qjDataArray = [NSMutableArray arrayWithArray:self.fromNumArray];
            }else if ([self.requestTypeStr isEqualToString:@"cc"]) {
                self.ccDataArray = [NSMutableArray arrayWithArray:self.fromNumArray];
            }else if ([self.requestTypeStr isEqualToString:@"xmtx"]) {
                self.xmtxDataArray = [NSMutableArray arrayWithArray:self.fromNumArray];
            }
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}

#pragma mark-- 请求流程详情
- (void)requestFormInfoWithCode:(NSString*)processCode {
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@%@", YSDomain, getProcessDataForMobile, processCode] isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"流程单号%@\n%@", processCode,response);
        [QMUITips hideAllToastInView:self.view animated:NO];
        if ([[response objectForKey:@"code"] integerValue] == 1) {
            self.fromInfoModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
            [self refreshTableView];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
    
}


- (void)submit {
    if ([YSUtility judgeIsEmpty:[self.paramDic objectForKey:@"processCode"]]) {
        [QMUITips showSucceed:@"请先选择-流程单号" inView:self.view hideAfterDelay:2];
        return;
    }
    if ([YSUtility judgeIsEmpty:[self.paramDic objectForKey:@"processStamp"]]) {
        [QMUITips showSucceed:@"请先选择-修改类型" inView:self.view hideAfterDelay:2];
        return;
    }
    if ([YSUtility judgeIsEmpty:[self.paramDic objectForKey:@"remark"]]) {
        [QMUITips showSucceed:@"请先填写-事由说明" inView:self.view hideAfterDelay:2];
        return;
    }
    
    //时段
    if (![[self.paramDic allKeys] containsObject:@"startPeriod"]) {
        [self.paramDic setObject:[self.fromInfoModel.info objectForKey:@"startPeriod"] forKey:@"startPeriod"];
    }
    if (![[self.paramDic allKeys] containsObject:@"endPeriod"]) {
        [self.paramDic setObject:[self.fromInfoModel.info objectForKey:@"endPeriod"] forKey:@"endPeriod"];
    }
    
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, submitProcessData] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
        DLog(@"修正流程提交:%@", response);
        [QMUITips hideAllToastInView:self.view animated:NO];
        if ([[response objectForKey:@"code"] integerValue] == 1) {
            [QMUITips hideAllTipsInView:self.view];
            for (UIViewController *vcController in self.rt_navigationController.rt_viewControllers) {
                if ([vcController isKindOfClass:[YSFlowPageController class]]) {
                    YSFlowPageController *flowPageController = (YSFlowPageController*)vcController;
                    [self.rt_navigationController popToViewController:flowPageController animated:YES complete:^(BOOL finished) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUpdateFlowTodo" object:nil];
                        [flowPageController setSelectIndex:2];
                        
                    }];
                }
            }
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}
#pragma mark--对页面赋值
- (void)refreshTableView {
    //申请信息
    //开始时间
    YSCRMYXBaseModel *startModel = self.dataSourceArray[0][2];
    if ([[self.paramDic objectForKey:@"processType"] isEqualToString:@"yc"]) {//异常申诉比较特别
        if (![startModel.nameStr isEqualToString:@"申诉时段"]) {
            NSMutableArray *detailArray = [NSMutableArray arrayWithArray:self.dataSourceArray[0]];
            [self.dataSourceArray removeObjectAtIndex:0];
            
            [detailArray removeObjectsInRange:(NSMakeRange(2, 3))];
            YSCRMYXBaseModel *timeModel = [YSCRMYXBaseModel new];
            timeModel.nameStr = @"申诉时段";
            timeModel.textTF = [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"startPeriodTrans"]];
            [detailArray addObject:timeModel];
            [self.dataSourceArray insertObject:detailArray atIndex:0];
        }else {
            startModel.textTF = [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"startPeriodTrans"]];
        }
        
    }else{
    
    startModel.textTF = [NSString stringWithFormat:@"%@ %@", [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"beginDateStr"]], [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"startPeriodTrans"]]];
    //结束时间
    YSCRMYXBaseModel *endModel = self.dataSourceArray[0][3];
    endModel.textTF = [NSString stringWithFormat:@"%@ %@", [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"endDateStr"]], [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"endPeriodTrans"]]];
    //天数
    YSCRMYXBaseModel *numberModel = self.dataSourceArray[0][4];
    numberModel.textTF = [NSString stringWithFormat:@"%@", [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"totalTime"]]];
    }
    //修改信息
    //异常申诉 比较特别
    if ([[self.paramDic objectForKey:@"processType"] isEqualToString:@"yc"]) {
        YSCRMYXBaseModel *changeModel = self.dataSourceArray[1][0];
        [self.dataSourceArray removeObjectAtIndex:1];
        NSArray *modifyArray = @[@{@"nameStr":@"修改类型", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES), @"textTF":changeModel.textTF}, @{@"nameStr":@"申诉时段", @"holderStr":@"", @"textTF":[YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"startPeriodTrans"]], @"accessoryView":@0, @"isTFEnabled":@(YES)}];
        [self.dataSourceArray addObject:[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:modifyArray]]];///startPeriod

        [self.tableView reloadData];
        return;
    }
    BOOL isShow = YES;//修改信息 是否显示 时间段
    
    // 加班
    if ([[self.paramDic objectForKey:@"processType"] isEqualToString:@"jb"]) {
        isShow = NO;
    }
    // 请假--带薪小时间
    if ([[self.paramDic objectForKey:@"processType"] isEqualToString:@"qj"] && [[self.fromInfoModel.info objectForKey:@"childType"] isEqualToString:@"xsj"]) {
        isShow = NO;
    }
    if (!isShow) {
        YSCRMYXBaseModel *changeModel = self.dataSourceArray[1][0];
        [self.dataSourceArray removeObjectAtIndex:1];
        NSArray *modifyArray = @[@{@"nameStr":@"修改类型", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES), @"textTF":changeModel.textTF}, @{@"nameStr":@"开始时间", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"结束时间", @"holderStr":@"", @"accessoryView":@0, @"isTFEnabled":@(YES)}];
        [self.dataSourceArray addObject:[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:modifyArray]]];
        
    }

    //开始时间
    YSCRMYXBaseModel *start1Model = self.dataSourceArray[1][1];
    start1Model.textTF = [NSString stringWithFormat:@"%@", [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"beginDateStr"]]];
    if (isShow) {
        YSCRMYXBaseModel *start2Model = self.dataSourceArray[1][2];
        start2Model.textTF = [NSString stringWithFormat:@"%@", [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"startPeriodTrans"]]];
        [self.paramDic setObject:[YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"startPeriod"]] forKey:@"startPeriod"];
    }
    
    
    //结束时间
    YSCRMYXBaseModel *end1Model = self.dataSourceArray[1][isShow?3:2];
    end1Model.textTF = [NSString stringWithFormat:@"%@", [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"endDateStr"]]];
    if (isShow) {
        YSCRMYXBaseModel *end2Model = self.dataSourceArray[1][4];
        end2Model.textTF = [NSString stringWithFormat:@"%@", [YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"endPeriodTrans"]]];
        [self.paramDic setObject:[YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"endPeriod"]] forKey:@"endPeriod"];
    }
    [self.paramDic setObject:[YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"endDateStr"]] forKey:@"endTime"];
    

    [self.paramDic setObject:[YSUtility cancelNullData:[self.fromInfoModel.info objectForKey:@"beginDateStr"]] forKey:@"beginTime"];
    

    [self.tableView reloadData];
}

#pragma mark--tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray[section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCRMYXAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attendanceCellSys" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modifyModel = self.dataSourceArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.section][indexPath.row];
    YSCRMYXAddTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    YSWeak;
    //申请信息
    if (indexPath.section == 0) {
        //选择流程类型
        if (indexPath.row == 0) {
            [self.view addSubview:self.cloverBtn];
            YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:(CGRectMake(0, kSCREEN_HEIGHT-325*kHeightScale, kSCREEN_WIDTH, 325*kHeightScale))];
            [self.view addSubview:enumView];
            enumView.dataArray = self.flowTypeArray;
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
                weakSelf.requestTypeStr = choseModel.code;
                [weakSelf.paramDic setObject:choseModel.code forKey:@"processType"];
                [weakSelf requestDataList];
            };
        }
        //选择流程单号
        else if (indexPath.row ==1) {
            if ([self.fromNumArray count] == 0) {
                [QMUITips showInfo:@"该类型下暂无单号,请重选-流程类型" inView:self.view hideAfterDelay:2];
                return;
            }
            [self.view addSubview:self.cloverBtn];
            YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:(CGRectMake(0, kSCREEN_HEIGHT-325*kHeightScale, kSCREEN_WIDTH, 325*kHeightScale))];
            [self.view addSubview:enumView];
            enumView.dataArray = self.fromNumArray;
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
                [weakSelf.paramDic setObject:choseModel.flowCode forKey:@"processCode"];
                [weakSelf requestFormInfoWithCode:choseModel.flowCode];
            };
        }
    }
    //修改信息
    else if (indexPath.section == 1) {
        //修改类型
        if (indexPath.row == 0) {
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
            QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
                
            }];
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"撤销申请流程" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                
                model.textTF = action.title;
                cell.rightTF.text = action.title;
                [self.paramDic setObject:@"10" forKey:@"processStamp"];
                [self changeModelAndCellStateWith:AccessoryViewTypeNone];
                [weakSelf refreshTableView];
            }];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"调整申请日期" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                
                model.textTF = action.title;
                cell.rightTF.text = action.title;
                [self.paramDic setObject:@"20" forKey:@"processStamp"];
                [self changeModelAndCellStateWith:AccessoryViewTypeDisclosureIndicator];
            }];
            
            [alertController addAction:action0];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController showWithAnimated:YES];

        }else if (![model.nameStr containsString:@"时段"]) {
            //不是调整申请日期 不允许选择时间
            if ([[self.paramDic objectForKey:@"processStamp"] integerValue] != 20) {
                return;
            }
            //带薪小时假 结束时间不能选
            if ([[self.paramDic  objectForKey:@"processType"] isEqualToString:@"qj"] && [[self.fromInfoModel.info objectForKey:@"childType"] isEqualToString:@"xsj"] && [model.nameStr isEqualToString:@"结束时间"]) {
                return;
            }
            self.dateIndexPath = indexPath;
            PGDatePicker *datePicker = [[PGDatePicker alloc] init];
            datePicker.delegate = self;
            datePicker.datePickerMode = PGDatePickerModeDate;
        
            if ([[self.paramDic  objectForKey:@"processType"] isEqualToString:@"qj"] && [[self.fromInfoModel.info objectForKey:@"childType"] isEqualToString:@"xsj"]) {
                //带薪小时假--显示时分
                datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
            }
            if ([[self.paramDic objectForKey:@"processType"] isEqualToString:@"yc"]) {//异常申诉--显示时分
                datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
            }
            [datePicker showWithShadeBackgroud];
            
        }
        else if ([model.nameStr containsString:@"时段"]) {
            if ([[self.paramDic objectForKey:@"processStamp"] integerValue] != 20) {
                return;
            }
            if ([[self.paramDic objectForKey:@"processType"] isEqualToString:@"jb"]) {
                //为 加班 的时候 时段不能选择 或者 异常申诉的时候
                 return;
            }
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
            QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
                
            }];
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"上午" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                if ([model.nameStr isEqualToString:@"开始时间时段"]) {
                    [self.paramDic setObject:@"AM" forKey:@"startPeriod"];
                }else if ([model.nameStr isEqualToString:@"结束时间时段"]) {
                    [self.paramDic setObject:@"AM" forKey:@"endPeriod"];
                }else if ([model.nameStr isEqualToString:@"申诉时段"]) {
                    [self.paramDic setObject:@"AM" forKey:@"startPeriod"];
                }
                model.textTF = @"上午";
                cell.rightTF.text = action.title;
            }];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"下午" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                if ([model.nameStr isEqualToString:@"开始时间时段"]) {
                    [self.paramDic setObject:@"PM" forKey:@"startPeriod"];
                }else if ([model.nameStr isEqualToString:@"结束时间时段"]) {
                    [self.paramDic setObject:@"PM" forKey:@"endPeriod"];
                }else if ([model.nameStr isEqualToString:@"申诉时段"]) {
                    [self.paramDic setObject:@"PM" forKey:@"startPeriod"];
                }
                model.textTF = action.title;
                cell.rightTF.text = action.title;
            }];
            QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"全天" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                if ([model.nameStr isEqualToString:@"开始时间时段"]) {
                    [self.paramDic setObject:@"DAY" forKey:@"startPeriod"];
                }else if ([model.nameStr isEqualToString:@"结束时间时段"]) {
                    [self.paramDic setObject:@"DAY" forKey:@"endPeriod"];
                }else if ([model.nameStr isEqualToString:@"申诉时段"]) {
                    [self.paramDic setObject:@"DAY" forKey:@"startPeriod"];
                }
                model.textTF = action.title;
                cell.rightTF.text = action.title;
            }];
            [alertController addAction:action0];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController addAction:action3];
            [alertController showWithAnimated:YES];

        }
    }
}

//改变修改信息 的时间cell
- (void)changeModelAndCellStateWith:(AccessoryViewType)accessoryView {
    
    for (int i = 1; i < [self.dataSourceArray[1] count]; i++) {
        YSCRMYXBaseModel *model = self.dataSourceArray[1][i];
        if ([model.nameStr containsString:@"时段"] && ([[self.paramDic objectForKey:@"processType"] isEqualToString:@"jb"])) {
            //为 加班 的时候  时段不能选择 或者异常申诉
            model.accessoryView = 0;
        }else {
        
            model.accessoryView = accessoryView;
        }
    }
    [self.tableView reloadData];
}
#pragma mark-- 带薪小时假 请求结束时间
- (void)requestSXJEndTime {
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataSourceArray[1] count]-1 inSection:1]];
    YSCRMYXBaseModel *model = [self.dataSourceArray objectAtIndex:[self.dataSourceArray[1] count]-1];
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@%@/%@/xsj", YSDomain, calculateEndTime, [YSUtility getUID], [self.paramDic objectForKey:@"beginTime"]] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"修正流程-带薪小时假-结束时间计算:%@", response);
        if ([[response objectForKey:@"code"] integerValue] == 1) {
             
            cell.rightTF.text = [response objectForKey:@"data"];
            model.textTF = [response objectForKey:@"data"];
            [self.paramDic setValue:[response objectForKey:@"data"] forKey:@"endTime"];
        }else {
            cell.rightTF.text = @"由开始时间自动带出";
            model.textTF = @"";
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:NO];
    } progress:nil];
}

#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.dateIndexPath];
    YSCRMYXBaseModel *model = [self.dataSourceArray[self.dateIndexPath.section] objectAtIndex:self.dateIndexPath.row];
    if (datePicker.datePickerMode == PGDatePickerModeDateHourMinute) {
        model.textTF = [NSString stringWithFormat:@"%zd-%02ld-%02ld %02ld:%02ld", dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute];
        cell.rightTF.text = model.textTF;
    }else if (datePicker.datePickerMode == PGDatePickerModeDate) {
        model.textTF = [NSString stringWithFormat:@"%zd-%02ld-%02ld", dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
        cell.rightTF.text = model.textTF;
    }else if (datePicker.datePickerMode == PGDatePickerModeDateHourMinuteSecond) {
        model.textTF = [NSString stringWithFormat:@"%zd-%02ld-%02ld %02ld:%02ld:%02ld", dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
        cell.rightTF.text = model.textTF;
    }
    if ([model.nameStr isEqualToString:@"开始时间"]) {
        [self.paramDic setObject:model.textTF forKey:@"beginTime"];
    }else if ([model.nameStr isEqualToString:@"结束时间"]) {
        [self.paramDic setObject:model.textTF forKey:@"endTime"];
    }
    
    self.dateIndexPath = nil;
    
    //带薪小时假 请求结束时间
    if ([[self.paramDic  objectForKey:@"processType"] isEqualToString:@"qj"] && [[self.fromInfoModel.info objectForKey:@"childType"] isEqualToString:@"xsj"]) {
        [self requestSXJEndTime];
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [UIView new];
        //事由说明
        UILabel *tvLabe = [UILabel new];
        tvLabe.text = @"事由说明";
        tvLabe.textColor = [UIColor colorWithHexString:@"#000000"];
        tvLabe.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(16)];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@*", tvLabe.text]];
        //找出特定字符在整个字符串中的位置
        NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:@"*"].location, [[contentStr string] rangeOfString:@"*"].length);
        //修改特定字符的颜色
        [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        //修改特定字符的字体大小
        [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:redRange];
        tvLabe.attributedText = contentStr;
        [view addSubview:tvLabe];
        [tvLabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(30*kHeightScale);
        }];
        
        
        UITextView *markTV = [UITextView new];
        markTV.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(16)];
        [view addSubview:markTV];
        [markTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*kWidthScale);
            make.right.mas_equalTo(-10*kHeightScale);
            make.top.mas_equalTo(tvLabe.mas_bottom).offset(8*kHeightScale);
            make.height.mas_equalTo(110*kHeightScale);
        }];
        @weakify(self);
        [markTV.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            [self.paramDic setObject:x forKey:@"remark"];
        }];
        return view;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 160;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, kHeightScale*32))];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [backView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Multiply(15));
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = section == 0 ? @"申请信息" : @"修改信息";
    lab.textColor = [UIColor colorWithHexString:@"#B1B1B1"];
    lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
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


#pragma mark--setter&&getter
- (NSMutableDictionary*)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
}
- (YSFlowLaunchFormHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YSFlowLaunchFormHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFF5"];
    }
    return _headerView;
}
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80*kHeightScale)];
        QMUIButton *submitButton = [YSUIHelper generateDarkFilledButton];
        @weakify(self);
        [[submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self submit];
        }];
        [submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_footerView addSubview:submitButton];
        [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
            make.center.mas_equalTo(_footerView);
        }];
    }
    return _footerView;
}

- (NSMutableArray *)jbDataArray {
    if (!_jbDataArray) {
        _jbDataArray = [NSMutableArray new];
    }
    return _jbDataArray;
}

- (NSMutableArray *)ygwcDataArray {
    if (!_ygwcDataArray) {
        _ygwcDataArray = [NSMutableArray new];
    }
    return _ygwcDataArray;
}

- (NSMutableArray *)ycDataArray {
    if (!_ycDataArray) {
        _ycDataArray = [NSMutableArray new];
    }
    return _ycDataArray;
}

- (NSMutableArray *)qjDataArray {
    if (!_qjDataArray) {
        _qjDataArray = [NSMutableArray new];
    }
    return _qjDataArray;
}

- (NSMutableArray *)ccDataArray {
    if (!_ccDataArray) {
        _ccDataArray = [NSMutableArray new];
    }
    return _ccDataArray;
}

- (NSMutableArray *)xmtxDataArray {
    if (!_xmtxDataArray) {
        _xmtxDataArray = [NSMutableArray new];
    }
    return _xmtxDataArray;
}

- (NSMutableArray *)fromNumArray {
    if (!_fromNumArray) {
        _fromNumArray = [NSMutableArray new];
    }
    return _fromNumArray;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
