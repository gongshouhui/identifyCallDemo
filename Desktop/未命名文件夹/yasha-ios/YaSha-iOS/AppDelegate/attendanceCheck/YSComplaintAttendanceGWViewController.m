//
//  YSComplaintAttendanceGWViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/19.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSComplaintAttendanceGWViewController.h"
#import "YSAttendanceWFooterView.h"
#import "YSCRMYXAddTableViewCell.h"
#import "YSCRMYXBaseModel.h"
#import "YSFlowFormModel.h"
#import "YSComplaintListModel.h"
#import "YSCRMEnumChoseGView.h"
#import "YSContactSelectPersonViewController.h"
#import "YSContactModel.h"

@interface YSComplaintAttendanceGWViewController ()
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, copy) NSString *markStr;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableDictionary *paramDic;
@property (nonatomic, strong) YSFlowFormModel *flowFormModel;
@property (nonatomic, strong) NSMutableArray *projectDataArray;
@property (nonatomic, strong) UIButton *cloverBtn;
@property (nonatomic, strong) NSMutableArray *projectNameArray;



@end

@implementation YSComplaintAttendanceGWViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"异常申诉";
    
    //人员选择通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPerson:) name:KNotificationPostSelectedPerson object:nil];
    [self doNetworking];
}

- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    [self.tableView registerClass:[YSCRMYXAddTableViewCell class] forCellReuseIdentifier:@"attdanceComplaintcell"];
    [self.tableView registerClass:[YSAttendanceWFooterView class] forHeaderFooterViewReuseIdentifier:@"footerHeaderView"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    self.tableView.tableFooterView = self.footerView;
}

- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    NSDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setValue:self.detailGWModel.dateStr forKey:@"appealDate"];
    [paramDic setValue:[YSUtility getUID] forKey:@"employCode"];
    [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, getAppealFlowDataForMobile] isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        DLog(@"异常流程申诉:%@", response);
        if ([[response objectForKey:@"code"] intValue] == 1) {
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
            [self laodInitData];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];
    } progress:nil];
}

- (void)laodInitData {
    [self.dataSourceArray removeAllObjects];
    //忘记打卡三次 只能选 其他
    NSString *timeClockStr = [NSString stringWithFormat:@"%@~%@", [YSUtility judgeIsEmpty:[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"checkStartTime"]]] ? @"未打卡" : [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"checkStartTime"]], [YSUtility judgeIsEmpty:[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"checkEndTime"]]] ? @"未打卡" : [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"checkEndTime"]]];
    
    NSInteger forgetCount = 1;
    if ([[self.flowFormModel.info objectForKey:@"forgetCount"] integerValue] >= 3) {
        forgetCount = 0;
        //只有 忘记打卡 跟 其他 两个选项 当 忘记打卡 次数大于等于3次是
        [self.paramDic setValue:@"other" forKey:@"excepReason"];
    }
    
    //当用户选择 项目部-->为 '是' 时,增加项目信息
//    NSArray *projectNameArray = @[@{@"nameStr":@"项目名称", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"项目经理", @"textTF":@"", @"holderStr":@"请选择", @"accessoryView":@1, @"isTFEnabled":@(YES)}];
//    [self.projectNameArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:projectNameArray]];

    
    
    NSMutableArray *dataArray = @[@{@"nameStr":@"异常日期", @"holderStr":@"自动带出", @"accessoryView":@0,@"isTFEnabled":@(YES), @"textTF":[YSUtility cancelNullData:[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"appealDate"] andFormatter:@"yyyy-MM-dd"]]}, @{@"nameStr":@"打卡时间", @"holderStr":@"自动带出", @"accessoryView":@0, @"isTFEnabled":@(YES), @"isMustWrite":@(YES), @"textTF":timeClockStr}, @{@"nameStr":@"申诉时间", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES), @"textTF":@""}, @{@"nameStr":@"上级领导", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES), @"textTF":@""}, @{@"nameStr":@"项目部", @"holderStr":@"请选择", @"accessoryView":@(1), @"isMustWrite":@(YES), @"isTFEnabled":@(YES), @"textTF":@""}, @{@"nameStr":@"异常原因", @"holderStr":@"请选择", @"accessoryView":@(forgetCount), @"isMustWrite":@(YES), @"isTFEnabled":@(YES), @"textTF":forgetCount == 0 ? @"其他" : @""}].mutableCopy;
    
    [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray]];
    [self.tableView reloadData];

}
//是项目部 请求其所在的项目信息
- (void)requestProjectData {
    if (self.dataSourceArray.count <= 6) {
        // 新增 项目名称 项目经理
        NSArray *projectNameArray = @[@{@"nameStr":@"项目名称", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"项目经理", @"textTF":@"", @"holderStr":@"请选择", @"accessoryView":@1, @"isTFEnabled":@(YES)}];
        
        YSCRMYXBaseModel *model = [self.dataSourceArray lastObject];
        [self.dataSourceArray removeLastObject];
        [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:projectNameArray]];
        [self.dataSourceArray addObject:model];
        [self.tableView reloadData];
    }
    
    
    [QMUITips showLoadingInView:self.view];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getProjectListByUserNo, [YSUtility getUID]];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"异常申诉-获取其所在的项目数据:%@", response);
        [QMUITips hideAllToastInView:self.view animated:NO];
        if (1 == [[response objectForKey:@"code"] integerValue]) {
            
            self.projectDataArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[response objectForKey:@"data"]]];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];

}
- (void)submit {
    for (YSCRMYXBaseModel *model in self.dataSourceArray) {
        if ([YSUtility judgeIsEmpty:model.textTF] && model.isMustWrite) {
            [QMUITips showInfo:[NSString stringWithFormat:@"请选择-%@",model.nameStr] inView:self.view hideAfterDelay:1];
            return;
        }
    }
    if ([YSUtility judgeIsEmpty:self.markStr]) {
        [QMUITips showInfo:@"请填写-事由说明" inView:self.view hideAfterDelay:1];
        return;
    }
    [self.paramDic setValue:self.markStr forKey:@"remark"];
    [self.paramDic setValue:@"submit" forKey:@"optFlag"];
    [self.paramDic setObject:[self.flowFormModel.info objectForKey:@"appealDate"] forKey:@"appealDate"];
    [QMUITips showLoadingInView:self.view];
    //上传图片
    __block NSString *filekeyName;
    if (self.imgArray.count != 0) {
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_group_async(group, queue, ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            // 本地添加的文件 上传之后返回的数组
            [YSNetManager ys_uploadFileWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, uploadFileApi] parameters:nil fileModelArray:self.imgArray file:@"files" fileType:@"application/octet-stream" successBlock:^(id response) {
                DLog(@"文件上传:%@", response);
                dispatch_semaphore_signal(semaphore);// 发送信号量(+1)
                if (1 == [[response objectForKey:@"code"] integerValue] && [[response objectForKey:@"data"] count] != 0) {
                    NSMutableArray *nameArray = [NSMutableArray new];
                    for (NSDictionary *crmProFilesList in [[response objectForKey:@"data"] objectForKey:@"uploadeFiles"]) {
                        [nameArray addObject:[crmProFilesList objectForKey:@"filePath"]];
                    }
                    filekeyName = [nameArray componentsJoinedByString:@","];
                }
            } failurBlock:^(NSError *error) {
                dispatch_semaphore_signal(semaphore);// 发送信号量(+1)
            } upLoadProgress:nil];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);// 信号量-1,(如果>0,则向下执行,否则等待)
        });
        dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.paramDic setObject:self.markStr forKey:@"remark"];
            [self.paramDic setObject:filekeyName forKey:@"filekey"];
            [self.paramDic setObject:@"atds_ycss_apply_flow" forKey:@"modelKey"];//异常申诉
            [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, saveFlowData] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
                [QMUITips hideAllToastInView:self.view animated:NO];
                DLog(@"异常申诉表单提交信息:%@", response);
                if (1 == [[response objectForKey:@"code"] integerValue]) {
                    [QMUITips hideAllTipsInView:self.view];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"complaintVCUpdateFlowData" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [QMUITips hideAllTipsInView:self.view];
                    [QMUITips showError:@"异常申诉流程提交失败" inView:self.view hideAfterDelay:1];
                }
            } failureBlock:^(NSError *error) {
                DLog(@"error:%@", error);
                [QMUITips hideAllToastInView:self.view animated:NO];
                [QMUITips showError:@"异常申诉接口异常，请联系信息部处理" inView:self.view hideAfterDelay:1];
            } progress:nil];
        });
    }else {
        [self.paramDic setObject:self.markStr forKey:@"remark"];
        [self.paramDic setObject:@"atds_ycss_apply_flow" forKey:@"modelKey"];//异常申诉
        [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, saveFlowData] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
            [QMUITips hideAllToastInView:self.view animated:NO];
            DLog(@"表单提交信息:%@", response);
            if (1 == [[response objectForKey:@"code"] integerValue]) {
                [QMUITips hideAllTipsInView:self.view];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"complaintVCUpdateFlowData" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [QMUITips hideAllTipsInView:self.view];
                [QMUITips showError:@"异常申诉流程提交失败" inView:self.view hideAfterDelay:1];
            }
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
            [QMUITips hideAllToastInView:self.view animated:NO];
            [QMUITips showError:@"异常申诉接口异常，请联系信息部处理" inView:self.view hideAfterDelay:1];

        } progress:nil];
    }
}

#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30*kHeightScale;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"申请信息";
    titleLab.textColor = [UIColor  colorWithHexString:@"#999999"];
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(12)];
    [headerView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    return headerView;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YSAttendanceWFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerHeaderView"];
    YSWeak;
    __weak typeof(sectionFooterView) weakView = sectionFooterView;
    sectionFooterView.selectedImageBlock = ^(NSArray * _Nonnull imgArray) {
        weakSelf.imgArray = [NSMutableArray arrayWithArray:imgArray];
    };
    @weakify(self);
    __weak typeof(sectionFooterView) weakFootView = sectionFooterView;
    [[sectionFooterView.markTV rac_textSignal] subscribeNext:^(NSString *x) {
        @strongify(self);
        self.markStr = x;
        if (x.length <= 0) {
            weakView.markLab.hidden = NO;
            weakFootView.numberLab.text = @"0/100";
        }else {
            weakView.markLab.hidden = YES;
            if (x.length>100) {
                [QMUITips showInfo:@"不能超过100字" inView:self.view hideAfterDelay:1];
                self.markStr = [NSString stringWithFormat:@"%@", [x substringToIndex:100]];
                weakFootView.markTV.text = self.markStr;
            }
            weakFootView.numberLab.text = [NSString stringWithFormat:@"%ld/100",x.length];

        }
        
    }];
    
    return sectionFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 280*kHeightScale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];

    YSCRMYXAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attdanceComplaintcell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.complaintFlowModel = model;
    cell.accessoryBtn.enabled = NO;
    cell.accessorySwitch.enabled = NO;
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    if (indexPath.row == 0) {
        cell.rightTF.textColor = kUIColor(0, 0, 0, 0.25);
    }
    else if (indexPath.row == 1) {
        cell.hiddenLab.textColor = kUIColor(0, 0, 0, 0.25);
        cell.rightTF.textColor = [UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];
    YSCRMYXAddTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([model.nameStr isEqualToString:@"异常原因"]) {
        //还要判断 是否忘记打卡已经三次
        if ([[self.flowFormModel.info objectForKey:@"forgetCount"] integerValue] >= 3) {
            return;
        }
        [self choseDataChangeCellShowWithDataModel:model cell:cell withType:0];
    }else if ([model.nameStr isEqualToString:@"上级领导"]) {
        YSContactSelectPersonViewController *selectPerson = [[YSContactSelectPersonViewController alloc]init];
        selectPerson.indexPath = indexPath;
        selectPerson.jumpSourceStr = @"flowLaunch";
        [self.rt_navigationController pushViewController:selectPerson animated:YES];
    }
    else if ([model.nameStr isEqualToString:@"项目部"]) {
        [self choseDataChangeCellShowWithDataModel:model cell:cell withType:1];
    }
    else if ([model.nameStr isEqualToString:@"申诉时间"]) {
        [self choseDataChangeCellShowWithDataModel:model cell:cell withType:2];
    }
    else if ([model.nameStr isEqualToString:@"项目经理"]) {
        YSContactSelectPersonViewController *selectPerson = [[YSContactSelectPersonViewController alloc]init];
        selectPerson.indexPath = indexPath;
        selectPerson.jumpSourceStr = @"flowLaunch";
        [self.rt_navigationController pushViewController:selectPerson animated:YES];
    }
    else if ([model.nameStr isEqualToString:@"项目名称"]) {
        if (self.projectDataArray.count == 0) {
            [QMUITips showSucceed:@"暂无项目信息" inView:self.view hideAfterDelay:2];
            return;
        }
        YSWeak;
        [self.view addSubview:self.cloverBtn];
        YSCRMEnumChoseGView *enumView = [[YSCRMEnumChoseGView alloc] initWithFrame:(CGRectMake(0, kSCREEN_HEIGHT-325*kHeightScale, kSCREEN_WIDTH, 325*kHeightScale))];
        enumView.type = YSCRMEnumChoseGViewType2;
        [self.view addSubview:enumView];
        enumView.dataArray = self.projectDataArray;
        @weakify(self);
        [[enumView.cancelBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            @strongify(self);
            [self clickedCloverBtnAction:self.cloverBtn];
        }];
        enumView.choseEnumBlock = ^(YSCRMYXGEnumModel * _Nonnull choseModel) {
            [weakSelf clickedCloverBtnAction:weakSelf.cloverBtn];
            //项目名称
            model.textTF = choseModel.projectName;
            cell.rightTF.text = choseModel.projectName;
            
            //项目经理
            YSCRMYXBaseModel *nextModel = weakSelf.dataSourceArray[indexPath.row+1];
            YSCRMYXAddTableViewCell *nextCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]];
            nextModel.textTF = choseModel.name;
            nextCell.rightTF.text = choseModel.name;
            
            [weakSelf.paramDic setObject:choseModel.projectNo forKey:@"projectNo"];
            [weakSelf.paramDic setObject:choseModel.projectName forKey:@"projectName"];

            [weakSelf.paramDic setObject:choseModel.staffNo forKey:@"projectManagerNo"];
            [weakSelf.paramDic setObject:choseModel.name forKey:@"projectManager"];
            [weakSelf.tableView reloadData];
        };
    }
}

- (void)choseDataChangeCellShowWithDataModel:(YSCRMYXBaseModel *)model cell:(YSCRMYXAddTableViewCell *)cell withType:(NSInteger)type {
    NSString *alertTitle = @"";
    NSString *title1;
    NSString *title2;
    NSString *title3;
    switch (type) {
        case 0:
            {//异常原因
                alertTitle = @"异常原因";
                title1 = @"忘记打卡";
                title2 = @"其他";
            }
            break;
        case 1:
            {//是否为项目部
                alertTitle = @"是否为项目部";
                title1 = @"是";
                title2 = @"否";
            }
            break;
        case 2:
            {//申诉时间
                alertTitle = @"申诉时间";
                title1 = @"上午";
                title2 = @"下午";
                title3 = @"全天";
            }
            break;
        default:
            break;
    }
    QMUIAlertController *alertVC = [QMUIAlertController alertControllerWithTitle:alertTitle message:@"" preferredStyle:(QMUIAlertControllerStyleActionSheet)];

    QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:(QMUIAlertActionStyleDestructive) handler:nil];
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:title1 style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
        switch (type) {
            case 0:
                {//异常原因
                    [self.paramDic setValue:@"wjdk" forKey:@"excepReason"];
                }
                break;
            case 1:
                {//是否为项目部
                    [self requestProjectData];
                    [self.paramDic setValue:@"1" forKey:@"isProject"];
                }
                break;
            case 2:
                {//申诉时间 时段
                    [self.paramDic setValue:@"AM" forKey:@"startPeriod"];
                }
                break;
            default:
                break;
        }
        model.textTF = title1;
        cell.rightTF.text = title1;
        
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:title2 style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
        model.textTF = title2;
        cell.rightTF.text = title2;
        switch (type) {
            case 0:
                {//异常原因
                    [self.paramDic setValue:@"other" forKey:@"excepReason"];
                }
                break;
            case 1:
                {//是否为项目部
                    if (self.dataSourceArray.count >=7) {
                        // 去掉项目名称 项目经理
                        [self.dataSourceArray removeObjectsInRange:(NSMakeRange(self.dataSourceArray.count-3, 2))];
                    }
                    [self.tableView reloadData];
                    [self.paramDic setValue:@"0" forKey:@"isProject"];
                }
                break;
            case 2:
                {//打卡时间
                    [self.paramDic setValue:@"PM" forKey:@"startPeriod"];
                }
                break;
            default:
                break;
        }
        
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:title3 style:(QMUIAlertActionStyleDefault) handler:^(QMUIAlertAction *action) {
        //打卡时间
        model.textTF = title3;
        cell.rightTF.text = title3;
        [self.paramDic setValue:@"DAY" forKey:@"startPeriod"];
    }];
    [alertVC addAction:action0];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    if (type == 2) {
        [alertVC addAction:action3];
    }
    [alertVC showWithAnimated:YES];
}


#pragma mark - 选择单个人员的回调通知
- (void)selectPerson:(NSNotification *)notification {
    DLog(@"人员选择信息:%@", notification);
    YSContactModel *internalModel = notification.userInfo[@"selectedArray"][0];
    NSIndexPath *indexPath = notification.userInfo[@"selectIndexPath"];
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];
    model.textTF = internalModel.name;
    // 工号 internalModel.userId
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.rightTF.text = internalModel.name;
    if ([model.nameStr isEqualToString:@"上级领导"]) {
        [self.paramDic setObject:internalModel.userId forKey:@"leaderNo"];
        [self.paramDic setObject:internalModel.name forKey:@"leaderName"];
    }
    else if ([model.nameStr isEqualToString:@"项目经理"]) {
        [self.paramDic setObject:internalModel.userId forKey:@"projectManagerNo"];
        [self.paramDic setObject:internalModel.name forKey:@"projectManager"];
    }

}

#pragma mark--setter&&getter
- (NSMutableArray *)projectNameArray {
    if (!_projectNameArray) {
        _projectNameArray = [NSMutableArray new];
    }
    return _projectNameArray;
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
- (NSMutableArray *)projectDataArray {
    if (!_projectDataArray) {
        _projectDataArray = [NSMutableArray new];
    }
    return _projectDataArray;
}
- (NSMutableDictionary *)paramDic {
    if (!_paramDic) {
        _paramDic = [NSMutableDictionary new];
    }
    return _paramDic;
}
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200*kHeightScale)];
        UILabel *markLab = [[UILabel alloc] init];
        markLab.numberOfLines = 0;
        markLab.text = @"说明：\n因公外出流程请至待办进行申请（路径：待办-发起）\n每月忘记打卡只可申诉三次。";
        markLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(10)];
        markLab.textColor = kUIColor(0, 0, 0, 0.3);
        [_footerView addSubview:markLab];
        [markLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10*kHeightScale);
            make.left.mas_equalTo(16*kHeightScale);
            make.right.mas_equalTo(-16*kHeightScale);
        }];
        
        
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
            make.top.mas_equalTo(markLab.mas_bottom).offset(80*kHeightScale);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _footerView;
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
