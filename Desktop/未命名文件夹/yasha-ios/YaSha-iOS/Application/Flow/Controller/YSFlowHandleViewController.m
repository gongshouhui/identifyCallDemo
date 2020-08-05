//
//  YSFlowHandleViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/30.
//

#import "YSFlowHandleViewController.h"
#import "YSDingDingHeader.h"
#import "YSInternalModel.h"
#import "YSFlowHandleCell.h"
#import "YSFlowFormSectionHeaderView.h"
#import "YSFlowPageController.h"
#import "YSContactSelectPeopleViewController.h"
#import <IQKeyboardManager.h>
#import "YSContactModel.h"
#import "YSContactSelectPersonViewController.h"
#import "UIButton+RepetitionDisable.h"
#import "YSRejectHandleHelper.h"
#import "YSRejectModel.h"
@interface YSFlowHandleViewController ()<QMUITextViewDelegate, QMUITableViewDataSource, QMUITableViewDelegate, SWTableViewCellDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) QMUITextView *textView;
@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic,strong) YSRejectHandleHelper *rejectHelper;
//记录URL
@property (nonatomic,strong) NSString *rejectUrl;//驳回请求URL被后台按照驳回类型的不同，分为不同的URL，相当于增加了处理类型（驳回不同节点类型如果放在参数里判断就好了，这样驳回就还像其他如审批一样是一个处理事件）
@end

@implementation YSFlowHandleViewController

static NSString *cellIdentifier = @"FlowHandleCell";

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"转阅说明", @"流程处理", @"驳回说明", @"加签说明", @"转办说明", @"流程处理", @"撤回说明",@"流程处理",@"流程处理",@"协同说明"];
    }
    return _titleArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

//#pragma UINavigationControllerDelegate  设置导航栏左，右侧文字颜色
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
//    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
//}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.navigationController.delegate = self;
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"提交" position:QMUINavigationButtonPositionRight target:self action:@selector(submit)];
    
    self.title = self.titleArray[_flowHandleType];
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    _textView = [[QMUITextView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH)];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.autoResizable = YES;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.placeholder = @"请输入您的意见...";
    _textView.maximumTextLength = 2000;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:_textView];
    
    if (_flowHandleType == FlowHandleTypeReject) {
        self.rejectHelper = [[YSRejectHandleHelper alloc]initWithTaskID:self.cellModel.taskId];
        [self.view addSubview:self.rejectHelper.tableView];
        [self.rejectHelper.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_textView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    if (_flowHandleType == FlowHandleTypeTrans || _flowHandleType == FlowHandleTypeAdd || _flowHandleType == FlowHandleTypeChange) {
        
        //多选
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPeople:) name:KNotificationPostSelectedPeolple object:nil];
        //单选
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPerson:) name:KNotificationPostSelectedPerson object:nil];
        
        self.tableView = [[QMUITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_textView.mas_bottom);
            make.left.bottom.right.mas_equalTo(self.view);
        }];
        
        [self addPeople];
    }
}

//- (void)viewDidLoad {
//    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"提交" position:QMUINavigationButtonPositionRight target:self action:@selector(submit)];
//}

- (void)viewDidLayoutSubviews {
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(@available(iOS 11.0,*)){
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.height.mas_equalTo(kSCREEN_WIDTH);
        }else{
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(kTopHeight);
            make.height.mas_equalTo(kSCREEN_WIDTH);
        }
    }];
}

- (void)addPeople {
    if (_flowHandleType == FlowHandleTypeChange) {
        YSContactSelectPersonViewController *selectPerson = [[YSContactSelectPersonViewController alloc]init];
        //流程转办
        selectPerson.jumpSourceStr = @"flowChange";
        [self.rt_navigationController pushViewController:selectPerson animated:YES];
    } else {
        YSContactSelectPeopleViewController *contactSelectPeople = [[YSContactSelectPeopleViewController alloc]init];
        [self.rt_navigationController pushViewController:contactSelectPeople animated:YES];
    }
}
#pragma mark - 多选人员通知回调
/** 多选 */
- (void)selectPeople:(NSNotification *)notification {
    NSArray *array = notification.userInfo[@"selectedArray"];
    for (YSContactModel *model  in array) {
        [self.dataSourceArray addObject:model];
    }
    [self.tableView reloadData];
}

/** 单选 */
- (void)selectPerson:(NSNotification *)notification {
    NSArray *array = notification.userInfo[@"selectedArray"];
    YSContactModel *internalModel = array[0];
    [self.dataSourceArray addObject:internalModel];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.dataSourceArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSFlowHandleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[YSFlowHandleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        YSInternalModel *cellModel = self.dataSourceArray[indexPath.row];
        [cell setCellModel:cellModel];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _flowHandleType == FlowHandleTypeChange ? @"更换人员" : @"添加人员";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray array];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    YSInternalModel *cellModel = self.dataSourceArray[index];
    [self.dataSourceArray removeObject:cellModel];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSourceArray.count > 0 && section == 0) {
        YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
        flowFormSectionHeaderView.titleLabel.text = @"已选人员";
        return flowFormSectionHeaderView;
    } else {
        UIView *view = [[UIView alloc] init];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataSourceArray.count == 0) {
        return 0.01;
    } else {
        return section == 0 ?  30*kHeightScale : 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataSourceArray.count > 0 && section == 0) {
        UIView *footerView = [[UIView alloc] init];
        QMUIButton *button = [[QMUIButton alloc] init];
        [button setTitleColor:UIColorGray forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button setTitle:@"向左滑动删除人员" forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImage:[UIImage imageNamed:@"alert"] forState:UIControlStateNormal];
        button.imagePosition = QMUIButtonImagePositionLeft;
        button.spacingBetweenImageAndTitle = 5;
        [footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(footerView.mas_centerY);
            make.left.mas_equalTo(footerView.mas_left).offset(15);
            make.right.mas_equalTo(footerView.mas_right).offset(-15);
            make.height.mas_equalTo(20*kHeightScale);
        }];
        
        return footerView;
    } else {
        UIView *view = [[UIView alloc] init];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 30*kHeightScale : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self addPeople];
    }
}
#pragma mark - 提交处理
- (void)submit {
    /** 流程处理后更新状态 */
    /**
     转阅：转阅动作执行完毕后，回到当前界面，当前数据状态不做任何更新（知会节点只拥有转阅功能，转阅后现在是不需要刷新待办）。
     审批：审批动作执行完毕后，返回待办列表页，待办中该数据消失，已审批的流程数据在“已办”中查看。
     驳回：驳回动作执行完毕后，返回待办列表页，待办中该数据消失，已驳回的流程数据在“已办”中查看。
     加签：加签动作执行完毕后，返回待办列表页，待办中该数据消失，该流程数据在“已办”中查看
     转办：转办动作执行完毕后，返回待办列表页，待办中该数据消失，该流程数据在“已办”中查看
     暂存：暂存动作执行完毕后，返回待办列表页，待办中仍有该流程数据，不在“已办”中显示
     撤回：仅针对已处理未办结的流程，可在已办中点击流程详情页中撤回，点击撤回后，流程回到撤回者的待办中，界面回到已办的流程列表页。
     转阅已读：当turnread = yes，是别人转阅过来的，，做“转阅已读”处理，程序员自己执行，不需用户点击，待办中该数据消失，已办不显示
     评审：评审动作执行完毕后，返回待办列表页，待办中该数据消失，该流程数据在“已办”中查看
     协同：xie'tong动作执行完毕后，返回待办列表页，待办中该数据消失，该流程数据在“已办”中查看
     知会：知会动作执行完毕后，返回待办列表页，待办中该数据消失，“已办”中显示
     另：知会节点，进入详情页程序员自动调用流程处理接口，做知会处理
     */
    [_textView resignFirstResponder];
    if (_outWarningMessage && !_textView.text.length) {//需要填写费用报销超标信息
        QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"确定" style:(QMUIAlertActionStyleCancel) handler:^(QMUIAlertAction *action) {
            
        }];
        QMUIAlertController *alertVC = [[QMUIAlertController alloc]initWithTitle:nil message:self.outWarningMessage preferredStyle:(QMUIAlertControllerStyleAlert)];
        [alertVC addAction:action];
        [alertVC showWithAnimated:YES];
        return;
    }
    NSMutableArray *userIdsArray = [NSMutableArray array];
    NSMutableArray *userNamesArray = [NSMutableArray array];
    for (YSContactModel *model in self.dataSourceArray) {
        [userIdsArray addObject:model.userId];
        [userNamesArray addObject:model.name];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, flowProcessApi, _flowHandleType+1];
    NSDictionary *payload = nil;
    
    if (_flowHandleType == FlowHandleTypeTrans) {// 转阅
        if (userIdsArray.count > 50) {
            [QMUITips showError:@"单次转阅人数不可超过50人" inView:self.view hideAfterDelay:1.5];
            return;
        }
        payload = @{
                    @"message": _textView.text,
                    @"processInstanceId": _cellModel.processInstanceId,
                    @"userIds": userIdsArray,
                    @"userNames": userNamesArray
                    };
    } else if (_flowHandleType == FlowHandleTypeAdd) {// 加签
		if (!userIdsArray.count) {
			[QMUITips showError:@"请至少选择一个加签人" inView:self.view hideAfterDelay:1.5];
			return;
		}
        if (userIdsArray.count > 50) {
            [QMUITips showError:@"加签人数不可超过50人" inView:self.view hideAfterDelay:1.5];
            return;
        }
        payload = @{
                    @"message": _textView.text,
                    @"taskId": _cellModel.taskId,
                    @"processInstanceId": _cellModel.processInstanceId,
                    @"userIds": userIdsArray,
                    @"userNames": userNamesArray
                    };
    } else if (_flowHandleType == FlowHandleTypeChange) {   // 转办
        payload = @{
                    @"message": _textView.text,
                    @"taskId": _cellModel.taskId,
                    @"userIds": userIdsArray,
                    @"processInstanceId": _cellModel.processInstanceId,
                    @"userNames": userNamesArray
                    };
    }else if (_flowHandleType == FlowHandleTypeReject) {   // 驳回
        //驳回下面的三种类型现在后台是  相当于添加三种处理类型，所以这里需要需改URL，将指针传过去
        payload = [self getRejectHandleParameter];
        urlString = self.rejectUrl;
        if (payload == nil) {
            return;
        }
    }else if (_flowHandleType == FlowHandleTypeRevoke){
        payload = @{
                    @"message": _textView.text,
                    @"taskId": _cellModel.taskId,
                    @"processInstanceId": _cellModel.processInstanceId
                    };
        
    }else {//审批，
		if (self.additionMessage.length) {
			_textView.text = [NSString stringWithFormat:@"%@  %@",self.additionMessage,_textView.text];
		}
        payload = @{
                    @"message": _textView.text,
                    @"taskId": _cellModel.taskId,
                    @"userIds": userIdsArray,
                    @"processInstanceId": _cellModel.processInstanceId
                    };
    }
    
    if ((_flowHandleType == FlowHandleTypeReject || [_cellModel.taskType isEqualToString:FlowTaskXT] || [_cellModel.taskType isEqualToString:FlowTaskPS] || _flowHandleType == FlowHandleTypeRevoke) && _textView.text.length == 0) {
        if (_flowHandleType == FlowHandleTypeReject) {
            [QMUITips showInfo:@"请填写驳回理由" inView:self.view hideAfterDelay:1];
            return;
        }else if(_flowHandleType == FlowHandleTypeRevoke){
            [QMUITips showInfo:@"请填写撤回理由" inView:self.view hideAfterDelay:1];
            return;
        }else{
            [QMUITips showInfo:@"请填写信息" inView:self.view hideAfterDelay:1];
            return;
        }
    } else if (_flowHandleType == FlowHandleTypeTrans){
        if (userIdsArray.count <= 0) {
            [QMUITips showInfo:@"请选择人员" inView:self.view hideAfterDelay:1];
            return;
        }
    }
    //    }else {
    self.navigationItem.rightBarButtonItem.enabled = NO;//防止重复点击
    [QMUITips showInfo:@"提交中..." inView:self.view];
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"data"] intValue] == 1) {
            NSDictionary *handleDic = @{
                                        //                                            @"flowType": [NSString stringWithFormat:@"%zd", _flowType],
                                        @"flowHandleType": [NSString stringWithFormat:@"%zd", _flowHandleType],
                                        @"model": _cellModel
                                        };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUpdateFlowStatus" object:nil userInfo:handleDic];
            //转阅回到当前页面，，撤回回到已办列表，其他回到待办列表
            if (_flowHandleType == FlowHandleTypeTrans) {
                [QMUITips showSucceed:@"流程转阅成功" inView:self.view hideAfterDelay:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else{
                [QMUITips showSucceed:@"提交成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for (UIViewController *viewController in self.rt_navigationController.rt_viewControllers) {
                        if ([viewController isKindOfClass:[YSFlowPageController class]]) {
                            [self.navigationController popToViewController:viewController animated:YES];
                        }
                    }
                });
                
            }
            
            
            
        } else {
            [QMUITips showError:response[@"msg"] inView:self.view hideAfterDelay:1];
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;//防止重复点击
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTips];
        self.navigationItem.rightBarButtonItem.enabled = YES;//防止重复点击
    } progress:nil];
    //    }
}
#pragma mark - 驳回处理
- (NSDictionary *)getRejectHandleParameter {
    NSDictionary *payload = nil;
    YSRejectModel *rejectModel = self.rejectHelper.selectedModel;
    if (!rejectModel) {
        [QMUITips showInfo:@"请选择驳回类型" inView:self.view hideAfterDelay:1];
        return nil;
    }
    switch (rejectModel.rejectType) {
        case RejectTypeSource:
            payload = @{
                        @"taskId":_cellModel.taskId,
                        @"message":_textView.text,
                        @"processInstanceId": _cellModel.processInstanceId
                        };
            self.rejectUrl = [NSString stringWithFormat:@"%@%@/31", YSDomain, flowProcessApi];
            break;
        case RejectTypeLastNode:
            payload = @{
                        @"taskId":_cellModel.taskId,
                        @"message":_textView.text,
                        @"processInstanceId":_cellModel.processInstanceId
                        };
            self.rejectUrl = [NSString stringWithFormat:@"%@%@/32", YSDomain, flowProcessApi];
            
            break;
            
        default:
        {
            YSRejectNodeModel *nodeModel = rejectModel.nodeModel;
            if (!nodeModel) {
                [QMUITips showInfo:@"请选择指定节点" inView:self.view hideAfterDelay:1.5];
                return nil;
            }
            payload = @{
                        @"taskId":_cellModel.taskId,
                        @"message":_textView.text,
                        @"processInstanceId":_cellModel.processInstanceId,
                        @"activityId":nodeModel.nodeId,
                        @"activityName":nodeModel.nodeName,
                        @"userNames":@[nodeModel.userName]
                        };
            self.rejectUrl = [NSString stringWithFormat:@"%@%@/33", YSDomain, flowProcessApi];
        }
            break;
    }
    return payload;
}
#pragma mark - textView 代理方法
- (BOOL)textViewShouldReturn:(QMUITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}
- (void)dealloc {
    DLog(@"释放");
}
@end

