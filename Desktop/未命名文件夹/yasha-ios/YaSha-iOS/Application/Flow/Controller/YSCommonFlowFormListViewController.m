//
//  YSCommonFlowFormListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/3.
//

#import "YSCommonFlowFormListViewController.h"
#import "YSFlowAttachPageController.h"

@interface YSCommonFlowFormListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation YSCommonFlowFormListViewController

NSString *const cellIdentifier = @"FlowFormListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initSubviews {
    [super initSubviews];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-(kTopHeight+40)-kBottomHeight - 50*kHeightScale) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.tableView registerClass:[YSFlowFormListCell class] forCellReuseIdentifier:cellIdentifier];

    _flowFormHeaderView = [[YSFlowFormHeaderView alloc] init];
    YSWeak;
    [[_flowFormHeaderView.actionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YSFlowAttachPageController *flowAttachPageController = [[YSFlowAttachPageController alloc] init];
        flowAttachPageController.cellModel = weakSelf.cellModel;
        flowAttachPageController.attachArray = weakSelf.attachArray;

        [weakSelf.navigationController pushViewController:flowAttachPageController animated:YES];
    }];

    self.tableView.tableHeaderView = _flowFormHeaderView;
    
    _flowFormBottomView = [[YSFlowFormBottomView alloc] init];
    [_flowFormBottomView setCellModel:_cellModel withFlowType:_flowType];
    [self.view addSubview:_flowFormBottomView];
    [_flowFormBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomHeight);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    
    [self checkTrans];
    [self doNetworking];
}

/** 转阅类型和知会节点类型 手动调用节后，相当于流程处理操作
 如果是他人转阅的流程，查看时不可操作，并且调用流程处理接口返回时并删除该条数据，知会节点时，点击待办进入详情页会调用流程处理<做审批处理>接口，待办列表消失
 */
- (void)checkTrans {
    if (_flowType == YSFlowTypeTodo) {
        
        if (_cellModel.turnRead) {
            [_flowFormBottomView removeFromSuperview];
            self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-(kTopHeight+40) - kBottomHeight);//移除
            NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, flowProcessApi, FlowHandleTypeTurnRead+1];
            NSDictionary *payload = @{
                                      @"message": @"",
                                      @"taskId": _cellModel.taskId,
                                      @"userIds": @[],
                                      @"processInstanceId": _cellModel.processInstanceId,
                                      };
            [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
                if ([response[@"code"] intValue] == 1) {
                    NSDictionary *handleDic = @{
                                                @"flowType": [NSString stringWithFormat:@"%zd", _flowType],
                                                @"flowHandleType": [NSString stringWithFormat:@"%zd", FlowHandleTypeTurnRead],
                                                @"model": _cellModel
                                                };
                    //转阅已读  发通知改变状态
                    _cellModel.turnRead ? [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUpdateFlowStatus" object:nil userInfo:handleDic] : nil;
                }
            } failureBlock:^(NSError *error) {
                
            } progress:nil];
        }
        if ([_cellModel.taskType isEqualToString:FlowTaskZH]) {
          
            NSString *urlString = [NSString stringWithFormat:@"%@%@/%zd", YSDomain, flowProcessApi, FlowHandleTypeApproval+1];
            NSDictionary *payload = @{
                                      @"message": @"",
                                      @"taskId": _cellModel.taskId,
                                      @"userIds": @[],
                                      @"processInstanceId": _cellModel.processInstanceId,
                                      };
            [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:payload successBlock:^(id response) {
                if ([response[@"code"] intValue] == 1) {
                    NSDictionary *handleDic = @{
                                                @"flowType": [NSString stringWithFormat:@"%zd", _flowType],
                                                @"flowHandleType": [NSString stringWithFormat:@"%zd", FlowHandleTypeApproval],
                                                @"model": _cellModel
                                                };
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PostUpdateFlowStatus" object:nil userInfo:handleDic];
                }
            } failureBlock:^(NSError *error) {
            
            } progress:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale)];
    return footerView;
}

/** 处理/转阅 */
- (void)monitorAction {
    YSWeak;
    [_flowFormBottomView.sendActionSubject subscribeNext:^(UIButton *button) {
        YSStrong;
        YSFlowHandleViewController *flowHandleViewController = [[YSFlowHandleViewController alloc] init];
        flowHandleViewController.cellModel = strongSelf.cellModel;
        if (button.tag == 0) {
            QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
                
            }];
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"审批" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeApproval;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"驳回" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeReject;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"审批并加签" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeAdd;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"转办" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeChange;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action5 = [QMUIAlertAction actionWithTitle:@"暂存" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeSave;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action6 = [QMUIAlertAction actionWithTitle:@"评审" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeReview;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            
            QMUIAlertAction *action7 = [QMUIAlertAction actionWithTitle:@"协同" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = YSFlowHandleTypeSynergy;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
            
            [alertController addAction:action0];
            
           if([strongSelf.cellModel.taskType isEqualToString:FlowTaskPS]){
                [alertController addAction:action6];
            }else if([strongSelf.cellModel.taskType isEqualToString:FlowTaskXT]){
                [alertController addAction:action7];
            }else{
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController addAction:action3];
            }
            
            [alertController addAction:action4];
            [alertController addAction:action5];
            [alertController showWithAnimated:YES];
        } else if (button.tag == 2) {
            flowHandleViewController.flowHandleType = FlowHandleTypeRevoke;
            [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
        } else {
            flowHandleViewController.flowHandleType = FlowHandleTypeTrans;
            [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            
        }
    }];
}

@end
