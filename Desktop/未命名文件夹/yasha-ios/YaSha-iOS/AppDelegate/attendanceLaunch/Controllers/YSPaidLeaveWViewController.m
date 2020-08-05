//
//  YSPaidLeaveWViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/13.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPaidLeaveWViewController.h"
#import "YSFlowLaunchFormHeaderView.h"
#import "YSCRMYXAddTableViewCell.h"
#import "YSCRMYXBaseModel.h"
#import "YSAttendanceWFooterView.h"
#import "YSMQImageSelectCellCell.h"
#import "YSContactSelectPersonViewController.h"
#import "YSContactModel.h"
#import "YSFlowPageController.h"
#import "YSCRMEnumChoseGView.h"

@interface YSPaidLeaveWViewController ()<PGDatePickerDelegate,CRMYXTextFieldDelegate>
@property (nonatomic, strong) YSFlowLaunchFormHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSIndexPath *dateIndexPath;//选中日期所在cell的位置
@property (nonatomic, copy) NSString *markStr;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableDictionary *paramDic;
@property (nonatomic, strong) NSMutableArray *baseArray;
//baseArray 基础上添加的数组
@property (nonatomic, strong) NSMutableArray *timeArray;//时间段
@property (nonatomic, strong) NSMutableArray *sjArray;//丧假
@property (nonatomic, strong) NSMutableArray *brjArray;//哺乳假
@property (nonatomic, strong) NSMutableArray *cjArray;//产假
//YES:结束时间小于开始时间 NO:正常
@property (nonatomic, assign) BOOL isIntervalTime;

//是否是项目部的 cell数组
@property (nonatomic, strong) NSMutableArray *projectArray;
@property (nonatomic, strong) NSMutableArray *projectDataArray;
@property (nonatomic, strong) UIButton *cloverBtn;




@end

@implementation YSPaidLeaveWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请假/调休";
    [self loadInitData];
    [self doNetworking];
    
    //自动显示当前用户 还需界面处理
//    [self.paramDic setObject:[YSUtility getName] forKey:@"employName"];
//    [self.paramDic setObject:[YSUtility getUID] forKey:@"employCode"];
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
    NSArray *dataArray = @[@{@"nameStr":@"申请人员", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"申请人工号", @"textTF":@"", @"holderStr":@"自动带出", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"申请人职级", @"textTF":@"", @"holderStr":@"自动带出", @"accessoryView":@0, @"isTFEnabled":@(YES)}, @{@"nameStr":@"上级领导", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"是否项目部", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"请假类型", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"开始时间", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)},@{@"nameStr":@"结束时间", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}];//7个cell
    NSArray *timeArray = @[@{@"nameStr":@"开始时间时段", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"结束时间时段", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}];
     NSArray *projectArray = @[@{@"nameStr":@"项目名称", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)},@{@"nameStr":@"项目经理", @"holderStr":@"请选择", @"accessoryView":@1, @"isTFEnabled":@(YES)}];
    //若取消缓存 self.timeArray = [NSMutableArray arrayWithArray:timeArray];
    //是否是项目部
    self.projectArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:projectArray]];
    
    self.timeArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:timeArray]];
    
    [self.baseArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray]];
    [self.dataSourceArray addObjectsFromArray:self.baseArray];
    [self.dataSourceArray insertObject:self.timeArray[0] atIndex:7];
    [self.dataSourceArray addObject:self.timeArray[1]];
    
    // 丧假
    NSArray *sjArray = @[@{@"nameStr":@"亲属类别", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"工作所在地", @"holderStr":@"需输入", @"accessoryView":@0, @"isMustWrite":@(YES)}, @{@"nameStr":@"丧事所在地", @"holderStr":@"需输入", @"accessoryView":@0, @"isMustWrite":@(YES)}];
    self.sjArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:sjArray]];
    
    //哺乳假
    NSArray *brjArray = @[@{@"nameStr":@"胞胎数", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)},@{@"nameStr":@"生育年度", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"哺乳假时间段", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}];
    self.brjArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:brjArray]];
    
    //产假
    NSArray *cjArray = @[@{@"nameStr":@"社保缴纳地", @"holderStr":@"需输入", @"accessoryView":@0, @"isMustWrite":@(YES)}, @{@"nameStr":@"生育年度", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"产假类别", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}];
    self.cjArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:cjArray]];
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
            [QMUITips hideAllToastInView:self.view animated:NO];
            YSFlowLaunchFormListModel *flowLaunchFormListModel = [YSFlowLaunchFormListModel yy_modelWithJSON:response[@"data"]];
            [self.headerView setHeaderModel:flowLaunchFormListModel];
            [self ys_reloadData];
            
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
    /**
     @[@"事假", @"病假", @"婚假", @"产检假", @"陪产假", @"工伤假", @"调休", @"丧假", @"带薪小时假", @"哺乳假", @"产假"]
     */
    //婚假 产检假  陪产假 工伤假 产假 图片必传
    if ([[self.paramDic objectForKey:@"childType"] isEqualToString:@"hj"] || [[self.paramDic objectForKey:@"childType"] isEqualToString:@"gsj"] || [[self.paramDic objectForKey:@"childType"] isEqualToString:@"cjj"] || [[self.paramDic objectForKey:@"childType"] isEqualToString:@"phj"] || [[self.paramDic objectForKey:@"childType"] isEqualToString:@"cj"]) {
        if (self.imgArray.count == 0) {
            [QMUITips showInfo:@"请选择图片" inView:self.view hideAfterDelay:1.5];
            return;
        }
    }
     // 病假大于一天需上传图片
    if ([[self.paramDic objectForKey:@"childType"] isEqualToString:@"bj"]) {
        if (self.imgArray.count == 0) {
            
            NSArray *timeIntervalArray = [YSUtility getTimeIntervalWithFirstTime:[self.paramDic objectForKey:@"beginTime"] withEndTime:[self.paramDic objectForKey:@"endTime"] withFormatter:@"yyyy-MM-dd"];
            DLog(@"时间间隔数组:%@", timeIntervalArray);//数组按照:天 时 分 秒
            if ([timeIntervalArray[0] intValue] > 1 ) {//此判断 时间跨度大于1天
                [QMUITips showInfo:@"请上传图片" inView:self.view hideAfterDelay:1.5];
                return;
            }else if ([timeIntervalArray[0] intValue] == 1 ) {
                //此判断 时间跨度为1天 ,在判断(时间区段上下午判断)
                if ([[self.paramDic objectForKey:@"startPeriod"] isEqualToString:@"PM"] && [[self.paramDic objectForKey:@"endPeriod"] isEqualToString:@"AM"]) {
                    //这是一天 不用传图片
                }else {
                   [QMUITips showInfo:@"请上传图片" inView:self.view hideAfterDelay:1.5];
                    return;
                }
            }
        }
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
                    [self.navigationController popViewControllerAnimated:YES];

                }else {
                    [QMUITips hideAllTipsInView:self.view];
                    [QMUITips showError:@"流程提交失败" inView:self.view hideAfterDelay:1];
                }
            } failureBlock:^(NSError *error) {
                DLog(@"error:%@", error);
                [QMUITips hideAllToastInView:self.view animated:NO];
                [QMUITips showError:@"请假接口异常，请联系信息部处理" inView:self.view hideAfterDelay:1];
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
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [QMUITips hideAllTipsInView:self.view];
                [QMUITips showError:@"流程提交失败" inView:self.view hideAfterDelay:1];
            }
        } failureBlock:^(NSError *error) {
            DLog(@"error:%@", error);
            [QMUITips hideAllToastInView:self.view animated:NO];
            [QMUITips showError:@"请假接口异常，请联系信息部处理" inView:self.view hideAfterDelay:1];

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
    cell.delegate = self;
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
        if ([[self.paramDic objectForKey:@"childType"] isEqualToString:@"xsj"] && [model.nameStr isEqualToString:@"结束时间"]) {
            //带薪小时假 结束时间 不能选择
            return;
        }
        if (![[self.paramDic allKeys] containsObject:@"childType"]) {
            //请假类型未选
            [QMUITips showInfo:@"请先选择请假类型" inView:self.view hideAfterDelay:1.5];
            return;
        }
        if ([[self.paramDic objectForKey:@"childType"] isEqualToString:@"xsj"] && ![[self.paramDic allKeys] containsObject:@"employCode"]) {
            //申请人员未选择
            [QMUITips showInfo:@"请先选择申请人员" inView:self.view hideAfterDelay:1.5];
            return;
        }
        PGDatePicker *datePicker = [[PGDatePicker alloc] init];
        datePicker.delegate = self;
        [datePicker showWithShadeBackgroud];
        datePicker.datePickerMode = PGDatePickerModeDate;
        if ([[self.paramDic allValues] containsObject:@"xsj"]) {
            //带薪小时假
            datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
        }
    }else if ([model.nameStr isEqualToString:@"请假类型"]) {
        //事假 病假 婚假 产检假  陪护假 工伤假 调休
        //丧假
        //带薪小时假
        //哺乳假
        //产假
        NSArray *holidayNameArray = @[@"事假", @"病假", @"婚假", @"产检假", @"陪产假", @"工伤假", @"调休", @"丧假", @"带薪小时假", @"哺乳假", @"产假"];
        
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
        QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            
        }];
        [alertController addAction:action0];
        for (int i = 0; i < holidayNameArray.count; i++) {
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:holidayNameArray[i] style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                [self changeHolidayType:i withNameStr:holidayNameArray[i]];
            }];
            [alertController addAction:action1];
        }
        [alertController showWithAnimated:YES];
    }else if ([model.nameStr isEqualToString:@"申请人员"]) {
        YSContactSelectPersonViewController *selectPerson = [[YSContactSelectPersonViewController alloc]init];
        selectPerson.indexPath = indexPath;
        selectPerson.jumpSourceStr = @"flowLaunch";
        [self.rt_navigationController pushViewController:selectPerson animated:YES];
    }else if ([model.nameStr isEqualToString:@"产假类别"] || [model.nameStr isEqualToString:@"胞胎数"] || [model.nameStr isEqualToString:@"生育方式"] || [model.nameStr isEqualToString:@"哺乳假时间段"] || [model.nameStr isEqualToString:@"亲属类别"] || [model.nameStr isEqualToString:@"生育年度"]) {
        
        NSArray *maternityHolidayArray = @[@"1", @"2", @"3"];
        if ([model.nameStr isEqualToString:@"产假类别"]) {
            maternityHolidayArray = @[@"小产假", @"生育产假"];
        }else if ([model.nameStr isEqualToString:@"生育方式"]) {
            maternityHolidayArray = @[@"顺产", @"剖腹产"];
        }else if ([model.nameStr isEqualToString:@"哺乳假时间段"]) {
            maternityHolidayArray = @[@"上午", @"下午", @"上下午"];
        }else if ([model.nameStr isEqualToString:@"亲属类别"]) {
            maternityHolidayArray = @[@"父母", @"配偶", @"子女", @"配偶父母", @"祖父母", @"外祖父母"];
        }else if ([model.nameStr isEqualToString:@"生育年度"]) {
            NSDate  *currentDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
            
            NSInteger year = [components year];
            maternityHolidayArray = @[[NSString stringWithFormat:@"%ld", year-1], [NSString stringWithFormat:@"%ld", year], [NSString stringWithFormat:@"%ld", year+1]];
        }
        
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
        QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            
        }];
        [alertController addAction:action0];
        for (int i = 0; i < maternityHolidayArray.count; i++) {
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:maternityHolidayArray[i] style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                [self changeMaternityHolidayType:i withTypeStr:maternityHolidayArray[i] withNameStr:model.nameStr];
            }];
            [alertController addAction:action1];
        }
        [alertController showWithAnimated:YES];
    }else if ([model.nameStr isEqualToString:@"开始时间时段"] || [model.nameStr isEqualToString:@"结束时间时段"]) {
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
    }else if ([model.nameStr isEqualToString:@"是否项目部"]) {
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
        QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            
        }];
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"是" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            model.textTF = @"是";
            cell.rightTF.text = @"是";
            [self changeCellNumberWith:@"1"];
            if (self.projectDataArray.count == 0) {
                [self requestProjectData];
            }
            
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"否" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
            model.textTF = @"否";
            cell.rightTF.text = @"否";
            [self changeCellNumberWith:@"0"];
        }];
        
        [alertController addAction:action0];
        [alertController addAction:action1];
        [alertController addAction:action2];
        
        [alertController showWithAnimated:YES];
    }
    else if ([model.nameStr isEqualToString:@"上级领导"]) {
        YSContactSelectPersonViewController *selectPerson = [[YSContactSelectPersonViewController alloc]init];
        selectPerson.indexPath = indexPath;
        selectPerson.jumpSourceStr = @"flowLaunch";
        [self.rt_navigationController pushViewController:selectPerson animated:YES];
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
#pragma mark--是否是项目部 改变cell个数
- (void)requestProjectData {
    if (self.dataSourceArray.count <= 6) {
        // 新增 项目名称 项目经理
        NSArray *projectNameArray = @[@{@"nameStr":@"项目名称", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}, @{@"nameStr":@"项目经理", @"textTF":@"", @"holderStr":@"请选择", @"accessoryView":@1, @"isTFEnabled":@(YES)}];
        
        YSCRMYXBaseModel *model = [self.dataSourceArray lastObject];//请假类型
        [self.dataSourceArray removeLastObject];
        [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:projectNameArray]];
        [self.dataSourceArray addObject:model];
        [self.tableView reloadData];
    }
    
    
    [QMUITips showLoadingInView:self.view];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getProjectListByUserNo, [YSUtility getUID]];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"请假/调休-获取其所在的项目数据:%@", response);
        [QMUITips hideAllToastInView:self.view animated:NO];
        if (1 == [[response objectForKey:@"code"] integerValue]) {
            
            self.projectDataArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[YSCRMYXGEnumModel class] json:[response objectForKey:@"data"]]];
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];

}
- (void)changeCellNumberWith:(NSString*)type {
//    [NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:dataArray]
    
    if ([type integerValue] == 1 && ![self.dataSourceArray containsObject:self.projectArray[0]]) {
        //是项目部 新增cell
       
        [self.dataSourceArray insertObjects:self.projectArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5,2)]];
    }else if ([type isEqualToString:@"0"]){
        [self.dataSourceArray removeObjectsInArray:self.projectArray];
    }
    [self.paramDic setValue:type forKey:@"isProject"];
    [self.tableView reloadData];
}

#pragma mark--请假类型选择
- (void)changeHolidayType:(NSInteger)typeIndex withNameStr:(NSString*)nameStr {
    //    NSArray *holidayNameArray = @[@"事假", @"病假", @"婚假", @"产检假", @"陪产假", @"工伤假", @"调休", @"丧假", @"带薪小时假", @"哺乳假", @"产假"];
    [self.dataSourceArray removeAllObjects];
   
    //清空参数字典中的已选时间 防止切换请假类型 时间判断出错
    [self.paramDic removeObjectForKey:@"beginTime"];
    [self.paramDic removeObjectForKey:@"endTime"];
    
    //@"事假",@"病假",@"婚假",@"产检假",@"陪产假",@"工伤假",@"调休"
    [self.dataSourceArray addObjectsFromArray:self.baseArray];
    NSInteger index = 5;//请假类型的位置
    if ([[self.paramDic objectForKey:@"isProject"] integerValue] == 1) {
        [self.dataSourceArray insertObjects:self.projectArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index,2)]];
        index = 7;
    }
    
    
    YSCRMYXBaseModel *model = self.dataSourceArray[index];
    model.textTF = nameStr;
    YSCRMYXBaseModel *timeModel0 = self.dataSourceArray[index+1];
    timeModel0.textTF = @"";//开始时间
    YSCRMYXBaseModel *timeModel1 = [self.dataSourceArray lastObject];
    timeModel1.textTF = @"";//结束时间
    //带薪小时假 因结束时间 不能选择 初始化数据
    timeModel1.holderStr = @"请选择";
    timeModel1.accessoryView = 1;
    
    if (typeIndex <= 6 && typeIndex != 2 && typeIndex != 4) {
        [self.dataSourceArray insertObject:self.timeArray[0] atIndex:index+2];
        [self.dataSourceArray addObject:self.timeArray[1]];
        
        switch (typeIndex) {
            case 0:
            {
                [self.paramDic setObject:@"shj" forKey:@"childType"];
            }
                break;
            case 1:
            {
                [self.paramDic setObject:@"bj" forKey:@"childType"];
            }
                break;
//            case 2://婚假-新需求 不要带时段
//            {
//                [self.paramDic setObject:@"hj" forKey:@"childType"];
//            }
//                break;
            case 3:
            {
                [self.paramDic setObject:@"cjj" forKey:@"childType"];
            }
                break;
//            case 4://陪产假-新需求 不要带时段
//            {
//                [self.paramDic setObject:@"phj" forKey:@"childType"];
//            }
//                break;
            case 5:
            {
                [self.paramDic setObject:@"gsj" forKey:@"childType"];
            }
                break;
            case 6:
            {
                [self.paramDic setObject:@"tj" forKey:@"childType"];
            }
                break;
            default:
                break;
        }
    }
    
    //其他假
    //当前baseArray 没有请假天数
    switch (typeIndex) {
        case 2://婚假-新需求 不要带时段
        {
            [self.paramDic setObject:@"hj" forKey:@"childType"];
        }
            break;
        case 4://陪产假-新需求 不要带时段
        {
            [self.paramDic setObject:@"phj" forKey:@"childType"];
            YSCRMYXBaseModel *holidayEndModel = [self.dataSourceArray lastObject];
            holidayEndModel.holderStr = @"由开始时间带出,可改";
            holidayEndModel.accessoryView = 0;
        }
            break;
        case 7:
        {//丧假-新需求 不要带时段
//            [self.dataSourceArray insertObject:self.timeArray[0] atIndex:5];
//            [self.dataSourceArray addObject:self.timeArray[1]];
            [self.paramDic setObject:@"sj" forKey:@"childType"];
            [self.dataSourceArray addObjectsFromArray:self.sjArray];
        }
            break;
        case 8:
        {//带薪小时假
            [self.paramDic setObject:@"xsj" forKey:@"childType"];
            YSCRMYXBaseModel *holidayEndModel = [self.dataSourceArray lastObject];
            holidayEndModel.holderStr = @"由开始时间自动带出";
            holidayEndModel.accessoryView = 0;
        }
            break;
        case 9:
        {//哺乳假
            [self.paramDic setObject:@"brj" forKey:@"childType"];
            [self.dataSourceArray addObjectsFromArray:self.brjArray];
        }
            break;
        case 10:
        {//产假
            [self.paramDic setObject:@"cj" forKey:@"childType"];
            [self.dataSourceArray addObjectsFromArray:self.cjArray];
            NSArray *newCJArray = @[@{@"nameStr":@"胞胎数", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)},@{@"nameStr":@"生育方式", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}];
            [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:newCJArray]];
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

//产假类别 胞胎数 哺乳假时间段 生育方式
- (void)changeMaternityHolidayType:(NSInteger)typeIndex withTypeStr:(NSString*)typeStr withNameStr:(NSString*)nameStr{
    
    if ([nameStr isEqualToString:@"产假类别"]) {
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:self.baseArray];
        if ([[self.paramDic objectForKey:@"isProject"] integerValue] == 1) {
            [self.dataSourceArray insertObjects:self.projectArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4,2)]];
        }
        [self.dataSourceArray addObjectsFromArray:self.cjArray];
        YSCRMYXBaseModel *model = [self.dataSourceArray lastObject];
        model.textTF = typeStr;
        
        if ([typeStr isEqualToString:@"小产假"]) {
            [self.paramDic setObject:@"xcj" forKey:@"produceCategory"];
            
        }else if ([typeStr isEqualToString:@"生育产假"]) {
            [self.paramDic setObject:@"sycj" forKey:@"produceCategory"];
            NSArray *newCJArray = @[@{@"nameStr":@"胞胎数", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)},@{@"nameStr":@"生育方式", @"holderStr":@"请选择", @"accessoryView":@1, @"isMustWrite":@(YES), @"isTFEnabled":@(YES)}];
            
            [self.dataSourceArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[YSCRMYXBaseModel class] json:newCJArray]];
        }
    }
    else if ([nameStr isEqualToString:@"生育方式"]) {
        YSCRMYXBaseModel *model = self.dataSourceArray[self.dateIndexPath.row];
        model.textTF = typeStr;
        if ([typeStr isEqualToString:@"顺产"]) {
            [self.paramDic setObject:@"sc" forKey:@"bearType"];
        }else if ([typeStr isEqualToString:@"剖腹产"]) {
            [self.paramDic setObject:@"pfc" forKey:@"bearType"];
        }
        
    }
    else if ([nameStr isEqualToString:@"胞胎数"]) {
        YSCRMYXBaseModel *model = self.dataSourceArray[self.dateIndexPath.row];
        model.textTF = typeStr;
        [self.paramDic setObject:typeStr forKey:@"birthsNum"];
    }
    else if ([nameStr isEqualToString:@"哺乳假时间段"]) {
        YSCRMYXBaseModel *model = self.dataSourceArray[self.dateIndexPath.row];
        model.textTF = typeStr;
        switch (typeIndex) {
            case 0:
                {//上午
                    [self.paramDic setObject:@"am" forKey:@"burPeriod"];
                }
                break;
            case 1:
                {//下午
                   [self.paramDic setObject:@"pm" forKey:@"burPeriod"];
                }
                break;
            case 2:
                {//上下午
                    [self.paramDic setObject:@"apm" forKey:@"burPeriod"];
                }
                break;
            default:
                break;
        }
    }
    else if ([nameStr isEqualToString:@"亲属类别"]) {
        //@"父母", @"配偶", @"子女", @"配偶父母", @"祖父母", @"外祖父母
        YSCRMYXBaseModel *model = self.dataSourceArray[self.dateIndexPath.row];
        model.textTF = typeStr;
        switch (typeIndex) {
            case 0:
            {
                [self.paramDic setObject:@"FM" forKey:@"relativeCategory"];
            }
                break;
            case 1:
            {
                [self.paramDic setObject:@"PO" forKey:@"relativeCategory"];
            }
                break;
            case 2:
            {
                [self.paramDic setObject:@"ZN" forKey:@"relativeCategory"];
            }
                break;
            case 3:
            {
                [self.paramDic setObject:@"POFM" forKey:@"relativeCategory"];
            }
                break;
            case 4:
            {
                [self.paramDic setObject:@"ZFM" forKey:@"relativeCategory"];
            }
                break;
            case 5:
            {
                [self.paramDic setObject:@"WZFM" forKey:@"relativeCategory"];
            }
                break;
            default:
                break;
        }
    }
    else if ([nameStr isEqualToString:@"生育年度"]){
        YSCRMYXBaseModel *model = self.dataSourceArray[self.dateIndexPath.row];
        model.textTF = typeStr;
        [self.paramDic setValue:typeStr forKey:@"year"];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 选择单个人员的回调通知
- (void)selectPerson:(NSNotification *)notification {
    DLog(@"人员选择信息:%@", notification);
    YSContactModel *internalModel = notification.userInfo[@"selectedArray"][0];
    NSIndexPath *indexPath = notification.userInfo[@"selectIndexPath"];
    YSCRMYXBaseModel *model = self.dataSourceArray[indexPath.row];
    model.textTF = internalModel.name;
    if ([model.nameStr isEqualToString:@"项目经理"]) {
        [self.paramDic setObject:internalModel.name forKey:@"projectManager"];
        [self.paramDic setObject:internalModel.userId forKey:@"projectManagerNo"];
        [self.tableView reloadData];
        return;
    }
    if ([model.nameStr isEqualToString:@"上级领导"]) {
        [self.paramDic setObject:internalModel.name forKey:@"leaderName"];
        [self.paramDic setObject:internalModel.userId forKey:@"leaderNo"];
        [self.tableView reloadData];
        return;
    }
    [self.paramDic setObject:internalModel.name forKey:@"employName"];
    
    YSCRMYXBaseModel *modelID = self.dataSourceArray[indexPath.row+1];
    modelID.textTF = internalModel.userId;
    [self.paramDic setObject:internalModel.userId forKey:@"employCode"];
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
            //            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath3] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
        [QMUITips hideAllToastInView:self.view animated:NO];
        [self.tableView reloadData];
    } progress:nil];
    /*
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getPostNameByNo,internalModel.userId] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"考勤请假请求职级======%@",response);
        if ([response[@"code"] integerValue]) {
            YSCRMYXBaseModel *modelPostName = self.dataSourceArray[indexPath.row+2];
            modelPostName.textTF = [NSString stringWithFormat:@"%@", response[@"data"][@"postName"]];
            [self.paramDic setObject:modelPostName.textTF forKey:@"positionName"];
            [self.tableView reloadData];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath3] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    } failureBlock:^(NSError *error) {
        DLog(@"=======%@",error);
        [QMUITips hideAllToastInView:self.view animated:NO];
        [self.tableView reloadData];
    } progress:nil];
*/
}

#pragma mark--CRMYXTextFieldDelegate
- (void)textField:(UITextField*)textField inputTextFieldChangeModel:(YSCRMYXBaseModel *)model {
    YSWeak;
    NSInteger index = [weakSelf.dataSourceArray indexOfObject:model];
    YSCRMYXAddTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    model.textTF = textField.text;
    
    if (![YSUtility judgeIsEmpty:textField.text] && ([model.nameStr isEqualToString:@"工作所在地"] || [model.nameStr isEqualToString:@"丧事所在地"])) {
        cell.hiddenLab.hidden = NO;
        cell.rightTF.textColor = [UIColor clearColor];
        cell.hiddenLab.textColor = [UIColor colorWithHexString:flowRightColor];
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
        cell.rightTF.textColor = [UIColor colorWithHexString:flowRightColor];
        [cell.leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15*kWidthScale);
            make.width.mas_equalTo(131*kWidthScale);
            make.top.mas_equalTo(14*kHeightScale);
            make.bottom.mas_equalTo(-14*kHeightScale);
        }];
    }

    
    if ([model.nameStr isEqualToString:@"工作所在地"]) {
        [self.paramDic setObject:textField.text forKey:@"workPlace"];
    }else if ([model.nameStr isEqualToString:@"社保缴纳地"]) {
        [self.paramDic setObject:textField.text forKey:@"socialPlace"];
    }else if ([model.nameStr isEqualToString:@"丧事所在地"]) {
        [self.paramDic setObject:textField.text forKey:@"funeralPlace"];
    }
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
                break;
            }else {
                self.isIntervalTime = NO;
            }
        }

    }
    //带薪小时假、陪产假 的 结束时间 网络请求
    if (([[self.paramDic objectForKey:@"childType"] isEqualToString:@"xsj"] ||[[self.paramDic objectForKey:@"childType"] isEqualToString:@"phj"])&& [model.nameStr isEqualToString:@"开始时间"]) {
        //带薪小时假计算结束时间
        [self requestEndTimeForHolidayWithLocation:self.dateIndexPath];
    }
    self.dateIndexPath = nil;
}
//带薪小时假计算结束时间
- (void)requestEndTimeForHolidayWithLocation:(NSIndexPath*)indexpath {
    YSCRMYXAddTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexpath.row+1 inSection:indexpath.section]];
    YSCRMYXBaseModel *model = [self.dataSourceArray objectAtIndex:indexpath.row+1];
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@%@/%@/%@", YSDomain, calculateEndTime, [self.paramDic objectForKey:@"employCode"], [self.paramDic objectForKey:@"beginTime"], [self.paramDic objectForKey:@"childType"]] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllToastInView:self.view animated:NO];
        DLog(@"带薪小时假-结束时间计算:%@", response);
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


#pragma mark--sett&&getter
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
- (NSMutableArray *)projectArray {
    if (!_projectArray) {
        _projectArray = [NSMutableArray new];
    }
    return _projectArray;
}
- (NSMutableArray *)projectDataArray {
    if (!_projectDataArray) {
        _projectDataArray = [NSMutableArray new];
    }
    return _projectDataArray;
}
-(NSMutableArray *)baseArray {
    if (!_baseArray) {
        _baseArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _baseArray;
}

- (NSMutableDictionary *)paramDic {
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
