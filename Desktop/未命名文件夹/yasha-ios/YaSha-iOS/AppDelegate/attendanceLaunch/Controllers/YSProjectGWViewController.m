//
//  YSProjectGWViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/23.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSProjectGWViewController.h"
#import "YSFlowLaunchFormHeaderView.h"
#import "YSCRMYXAddTableViewCell.h"
#import "YSCRMYXBaseModel.h"
#import "YSAttendanceWFooterView.h"
#import "YSMQImageSelectCellCell.h"
#import "YSContactSelectPersonViewController.h"
#import "YSContactModel.h"
#import "YSFlowPageController.h"
#import "YSCRMEnumChoseGView.h"


@interface YSProjectGWViewController ()<PGDatePickerDelegate,CRMYXTextFieldDelegate>
@property (nonatomic, strong) YSFlowLaunchFormHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, copy) NSString *markStr;
@property (nonatomic, strong) NSMutableDictionary *paramDic;
//YES:结束时间小于开始时间 NO:正常
@property (nonatomic, assign) BOOL isIntervalTime;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSIndexPath *dateIndexPath;
@property (nonatomic, strong) NSMutableArray *projectDataArray;//项目数据数组
@property (nonatomic, strong) UIButton *cloverBtn;


@end

@implementation YSProjectGWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目调休申请";
    [self loadInitData];
    [self doNetworking];
    
    [self.paramDic setObject:@"submit" forKey:@"optFlag"];
    //人员选择通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPerson:) name:KNotificationPostSelectedPerson object:nil];
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView registerClass:[YSCRMYXAddTableViewCell class] forCellReuseIdentifier:@"attendanceCellSys"];
    [self.tableView registerClass:[YSAttendanceWFooterView class] forHeaderFooterViewReuseIdentifier:@"attendanceViewSys"];
}
- (void)loadInitData {
    NSArray *dataArray = @[@{@"nameStr":@"申请人员", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"申请人工号", @"textTF":@"", @"holderStr":@"自动带出", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"申请人职级", @"textTF":@"", @"holderStr":@"自动带出", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"项目名称", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"项目经理", @"textTF":@"", @"holderStr":@"自动带出", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"上级领导", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"开始时间", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"开始时间时段", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)},@{@"nameStr":@"结束时间", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"结束时间时段", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}];
    self.dataSourceArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray]];

    
}
- (void)doNetworking {
    [super doNetworking];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getFormDesInfoApi, _lanchModel.modelKey];
        DLog(@"===========%@",urlString);
        [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
            dispatch_semaphore_signal(semaphore);
            DLog(@"获取表单的 头部数据:%@", response);
            if (1 == [[response objectForKey:@"code"] integerValue]) {
                YSFlowLaunchFormListModel *flowLaunchFormListModel = [YSFlowLaunchFormListModel yy_modelWithJSON:response[@"data"]];
                [self.headerView setHeaderModel:flowLaunchFormListModel];
                [self ys_reloadData];
            }
            
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
            dispatch_semaphore_signal(semaphore);
        } progress:nil];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);// 信号量-1,(如果>0,则向下执行,否则等待)
    });
    //请求项目信息
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getProjectListByUserNo, [YSUtility getUID]];
        [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
            dispatch_semaphore_signal(semaphore);
            DLog(@"获取其所在的项目数据:%@", response);
            if (1 == [[response objectForKey:@"code"] integerValue]) {

                self.projectDataArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[response objectForKey:@"data"]]];
            }
            
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
            dispatch_semaphore_signal(semaphore);
        } progress:nil];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);// 信号量-1,(如果>0,则向下执行,否则等待)
    });
    
    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求人员的职级
        YSCRMYXBaseModel *model = self.dataSourceArray[0];
        model.textTF = [YSUtility getName];
        [self.paramDic setObject:[YSUtility getName] forKey:@"employName"];
        
        YSCRMYXBaseModel *modelID = self.dataSourceArray[1];
        modelID.textTF = [YSUtility getUID];
        [self.paramDic setObject:[YSUtility getUID] forKey:@"employCode"];
        NSString *url = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getUserDataForMobile, [YSUtility getUID]];
        [YSNetManager ys_request_GETWithUrlString:url isNeedCache:NO parameters:nil successBlock:^(id response) {
            [QMUITips hideAllToastInView:self.view animated:NO];
            DLog(@"异常申诉表单提交信息:%@", response);
            if (1 == [[response objectForKey:@"code"] integerValue]) {
                YSCRMYXBaseModel *modelPostName = self.dataSourceArray[2];
                modelPostName.textTF = [NSString stringWithFormat:@"%@", response[@"data"][@"info"][@"positionName"]];
                [self.paramDic setObject:modelPostName.textTF forKey:@"positionName"];
                [self ys_reloadData];
            }
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
            [QMUITips hideAllToastInView:self.view animated:NO];
        } progress:nil];
    });
    /*
     NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getFormDesInfoApi, _lanchModel.modelKey];
     DLog(@"===========%@",urlString);
     [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
     DLog(@"获取表单的 头部数据:%@", response);
     [QMUITips hideAllToastInView:self.view animated:NO];
     YSFlowLaunchFormListModel *flowLaunchFormListModel = [YSFlowLaunchFormListModel yy_modelWithJSON:response[@"data"]];
     [self.headerView setHeaderModel:flowLaunchFormListModel];
     [self ys_reloadData];
     
     } failureBlock:^(NSError *error) {
     DLog(@"error:%@", error);
     } progress:nil];
     */
}

#pragma mark--提交
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
    if (self.isIntervalTime) {
        [QMUITips showInfo:@"结束时间小于开始时间,请重新选择" inView:self.view hideAfterDelay:2];
        return;
    }
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
            [self.paramDic setObject:_lanchModel.modelKey forKey:@"modelKey"];
            [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, saveFlowData] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
                [QMUITips hideAllToastInView:self.view animated:NO];
                DLog(@"表单提交信息:%@", response);
                if (1 == [[response objectForKey:@"code"] integerValue]) {
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
                }else {
                    [QMUITips hideAllTipsInView:self.view];
                    [QMUITips showError:@"流程提交失败" inView:self.view hideAfterDelay:1];
                }
            } failureBlock:^(NSError *error) {
                DLog(@"error:%@", error);
                [QMUITips hideAllToastInView:self.view animated:NO];
                [QMUITips showError:@"项目调休接口异常，请联系信息部处理" inView:self.view hideAfterDelay:1];
            } progress:nil];
        });
    }else {
        [self.paramDic setObject:self.markStr forKey:@"remark"];
        [self.paramDic setObject:_lanchModel.modelKey forKey:@"modelKey"];
        [YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@", YSDomain, saveFlowData] isNeedCache:NO parameters:self.paramDic successBlock:^(id response) {
            [QMUITips hideAllToastInView:self.view animated:NO];
            DLog(@"表单提交信息:%@", response);
            if (1 == [[response objectForKey:@"code"] integerValue]) {
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
            }else {
                [QMUITips hideAllTipsInView:self.view];
                [QMUITips showError:@"流程提交失败" inView:self.view hideAfterDelay:1];
            }
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
            [QMUITips hideAllToastInView:self.view animated:NO];
            [QMUITips showError:@"项目调休接口异常，请联系信息部处理" inView:self.view hideAfterDelay:1];

        } progress:nil];
    }
}

#pragma mark--tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30*kHeightScale;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YSAttendanceWFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"attendanceViewSys"];
    
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
    lab.text = @"申请信息";
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];

    YSCRMYXAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attendanceCellSys" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addModel = model;
//    cell.delegate = self;
    cell.accessoryBtn.enabled = NO;
    cell.accessorySwitch.enabled = NO;
    if (cell.hiddenLab.isHidden) {
        cell.rightTF.textColor = [UIColor colorWithHexString:flowRightColor];
    }else {
        cell.rightTF.textColor = [UIColor clearColor];
        cell.hiddenLab.textColor = [UIColor colorWithHexString:flowRightColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.dateIndexPath = indexPath;
    YSCRMYXAddTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];
    if ([model.nameStr isEqualToString:@"开始时间"] || [model.nameStr isEqualToString:@"结束时间"]) {
        PGDatePicker *datePicker = [[PGDatePicker alloc] init];
        datePicker.delegate = self;
        datePicker.datePickerMode = PGDatePickerModeDate;
        [datePicker showWithShadeBackgroud];
    }
    else if ([model.nameStr isEqualToString:@"申请人员"] || [model.nameStr isEqualToString:@"上级领导"]) {
        YSContactSelectPersonViewController *selectPerson = [[YSContactSelectPersonViewController alloc]init];
        selectPerson.indexPath = indexPath;
        selectPerson.jumpSourceStr = @"flowLaunch";
        [self.rt_navigationController pushViewController:selectPerson animated:YES];
    }
    else if ([model.nameStr containsString:@"时间时段"]) {
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
        QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            
        }];
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"上午" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            model.textTF = @"上午";
            cell.rightTF.text = @"上午";
            if ([model.nameStr isEqualToString:@"开始时间时段"]) {
                [self.paramDic setObject:@"AM" forKey:@"startPeriod"];
            }else if ([model.nameStr isEqualToString:@"结束时间时段"]) {
                [self.paramDic setObject:@"AM" forKey:@"endPeriod"];
            }
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"下午" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            model.textTF = @"下午";
            cell.rightTF.text = @"下午";
            if ([model.nameStr isEqualToString:@"开始时间时段"]) {
                [self.paramDic setObject:@"PM" forKey:@"startPeriod"];
            }else if ([model.nameStr isEqualToString:@"结束时间时段"]) {
                [self.paramDic setObject:@"PM" forKey:@"endPeriod"];
            }
        }];
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"全天" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            model.textTF = @"全天";
            cell.rightTF.text = @"全天";
            if ([model.nameStr isEqualToString:@"开始时间时段"]) {
                [self.paramDic setObject:@"DAY" forKey:@"startPeriod"];
            }else if ([model.nameStr isEqualToString:@"结束时间时段"]) {
                [self.paramDic setObject:@"DAY" forKey:@"endPeriod"];
            }
        }];
        [alertController addAction:action0];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController addAction:action3];
        [alertController showWithAnimated:YES];
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

#pragma mark - 选择单个人员的回调通知
- (void)selectPerson:(NSNotification *)notification {
    DLog(@"人员选择信息:%@", notification);
    //上级领导 与 申请人员
    YSContactModel *internalModel = notification.userInfo[@"selectedArray"][0];
    NSIndexPath *indexPath = notification.userInfo[@"selectIndexPath"];
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];
    model.textTF = internalModel.name;
    
    
    
    
    if ([model.nameStr isEqualToString:@"上级领导"]) {
        [self.paramDic setObject:internalModel.userId forKey:@"leaderNo"];
        [self.paramDic setObject:internalModel.name forKey:@"leaderName"];
        [self.tableView reloadData];
        return;
    }else if ([model.nameStr isEqualToString:@"申请人员"]) {
        YSCRMYXBaseModel *modelID = self.dataSourceArray[indexPath.row+1];
        modelID.textTF = internalModel.userId;
        [self.paramDic setObject:internalModel.userId forKey:@"employCode"];
        [self.paramDic setObject:internalModel.name forKey:@"employName"];
    }
    //    YSCRMYXBaseModel *model
    [QMUITips showLoadingInView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getUserDataForMobile, internalModel.userId];
    [YSNetManager ys_request_GETWithUrlString:url isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"考勤请假请求职级======%@",response);
        //positionName
        if ([[response objectForKey:@"code"] integerValue] == 1) {
            YSCRMYXBaseModel *modelPostName = self.dataSourceArray[indexPath.row+2];
            modelPostName.textTF = [NSString stringWithFormat:@"%@", response[@"data"][@"info"][@"positionName"]];
            [self.paramDic setObject:modelPostName.textTF forKey:@"positionName"];
            [self.tableView reloadData];
        }
    }failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
        [QMUITips hideAllToastInView:self.view animated:NO];
        [self.tableView reloadData];
    } progress:nil];
}

#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.dateIndexPath];
    YSCRMYXBaseModel *model = [self.dataSourceArray objectAtIndex:self.dateIndexPath.row];
    if (datePicker.datePickerMode == PGDatePickerModeDateHourMinute) {
        model.textTF = [NSString stringWithFormat:@"%zd-%02ld-%02ld %02ld:%02ld", dateComponents.year, dateComponents.month, dateComponents.day, dateComponents.hour, dateComponents.minute];
        cell.rightTF.text = model.textTF;
    }else if (datePicker.datePickerMode == PGDatePickerModeDate) {
        model.textTF = [NSString stringWithFormat:@"%zd-%02ld-%02ld", dateComponents.year, dateComponents.month, dateComponents.day];
        cell.rightTF.text = model.textTF;
    }
    if ([model.nameStr isEqualToString:@"开始时间"]) {
        [self.paramDic setObject:model.textTF forKey:@"beginTime"];
    }else if ([model.nameStr isEqualToString:@"结束时间"]) {
        [self.paramDic setObject:model.textTF forKey:@"endTime"];
    }
    //判断 结束时间 是否比 开始时间小
    if ([[self.paramDic allKeys] containsObject:@"beginTime"] && [[self.paramDic allKeys] containsObject:@"endTime"]) {
        NSString *formatterStr = @"yyyy-MM-dd";
        if (datePicker.datePickerMode == PGDatePickerModeDate) {
            formatterStr = @"yyyy-MM-dd";
        }else if (datePicker.datePickerMode == PGDatePickerModeDateHourMinute) {
            formatterStr = @"yyyy-MM-dd HH:mm";
        }else if (datePicker.datePickerMode == PGDatePickerModeDateHourMinuteSecond) {
            formatterStr = @"yyyy-MM-dd HH:mm:ss";
        }
        NSArray *timeIntervalArray = [YSUtility getTimeIntervalWithFirstTime:[self.paramDic objectForKey:@"beginTime"] withEndTime:[self.paramDic objectForKey:@"endTime"] withFormatter:formatterStr];
        for (int i =0 ; i < timeIntervalArray.count; i++) {
            if ([timeIntervalArray[i] intValue]< 0) {
                [QMUITips showInfo:@"结束时间小于开始时间,请重新选择" inView:self.view hideAfterDelay:2];
                self.isIntervalTime = YES;
                return;
            }else {
                self.isIntervalTime = NO;
            }
        }

    }
    self.dateIndexPath = nil;
}
#pragma mark--setter&&getter
- (NSMutableArray *)projectDataArray {
    if (!_projectDataArray) {
        _projectDataArray = [NSMutableArray new];
    }
    return _projectDataArray;
}

- (NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray = [NSMutableArray new];
    }
    return _imgArray;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
