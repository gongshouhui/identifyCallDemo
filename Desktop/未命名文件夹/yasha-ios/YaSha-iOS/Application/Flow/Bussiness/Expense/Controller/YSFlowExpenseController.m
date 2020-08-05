//
//  YSFlowExpenseController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/11.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowExpenseController.h"
#import "YSFlowFormListCell.h"
#import "YSFlowAssetsApplyFormModel.h"
#import "YSExpenseAlertView.h"
#import "YSExpenseTransportController.h"
#import "YSExpenseSubsidyController.h"
#import "YSExpenseTransportController.h"
#import "YSExpenseShareCell.h"
#import "YSFlowExpenseShareController.h"
#import "YSExpenseInvoiceDetailController.h"
#import "YSFlowAttachmentViewController.h"
#import "YSNewsAttachmentModel.h"
@interface YSFlowExpenseController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  YSFlowAssetsApplyFormModel*flowModel;
@property (nonatomic,strong) YSFlowAssetsApplyFormListModel *detailModel;
@property (nonatomic,strong) NSMutableArray *expensePersonArr;
@end

@implementation YSFlowExpenseController
- (NSMutableArray *)expensePersonArr {
    if (!_expensePersonArr) {
        _expensePersonArr = [[NSMutableArray alloc]init];
    }
    return _expensePersonArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"报销单";
}
- (void)initSubviews
{
    [super initSubviews];
    //隐藏附言按钮
//    [self.flowFormHeaderView.actionButton removeFromSuperview];
//    self.flowFormHeaderView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 108*kHeightScale);
//    self.flowFormHeaderView.lineLabel.hidden = YES;
    //[self.flowFormHeaderView hiddenActionButton];
    self.tableView.sectionFooterHeight = 0.0;
    [self monitorAction];
}
- (void)doNetworking {
    
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@/%@",YSDomain,getExpAccountInfoApi,self.cellModel.businessKey,self.cellModel.taskId] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1 ) {
            [self.dataSourceArray removeAllObjects];
            self.flowModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            self.flowFormHeaderView.headerModel = self.flowModel.baseInfo;
           [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            [self doWithData];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];
    } progress:nil];
}
- (void)doWithData {
    _detailModel = _flowModel.info;
    if ([_detailModel.categoryStr isEqualToString:@"差旅报销单"]) {
        [self travelExpenseWithData];
    }else if ([_detailModel.categoryStr isEqualToString:@"个人报销单"]){
        [self personExpenseWithData];
    }else if ([_detailModel.categoryStr isEqualToString:@"对公冲账单"]){
        [self publicExpense];
    }else if ([_detailModel.categoryStr isEqualToString:@"付款申请单"]){
        [self payApply];
    }
    [self.tableView reloadData];
}
#pragma mark - 报销单数据重组
//付款申请单
- (void)payApply {
    [self.expensePersonArr addObject:@{@"申请人":_detailModel.expensesName?_detailModel.expensesName:@"-"}];
    [self.expensePersonArr addObject:@{@"所属部门":_detailModel.expensesDeptName?_detailModel.expensesDeptName:@"-"}];
    [self.expensePersonArr addObject:@{@"职务级别":_detailModel.jobLevelStr?_detailModel.jobLevelStr:@"-"}];
    if (_detailModel.proName.length > 0) {
        [self.expensePersonArr addObject:@{@"工程项目名称":_detailModel.proName}];
    }
    [self.expensePersonArr addObject:@{@"收款方":_detailModel.payee?_detailModel.payee:@"-"}];
    [self.expensePersonArr addObject:@{@"入账公司":_detailModel.entryCompName?_detailModel.entryCompName:@"-"}];
    [self.expensePersonArr addObject:@{@"申请金额":[NSString stringWithFormat:@"￥%.2f",_detailModel.applyMoney]}];
    [self.expensePersonArr addObject:@{@"业务说明":_detailModel.remark?_detailModel.remark:@"-"}];
    [self.expensePersonArr addObject:@{@"附件": [NSString stringWithFormat:@"%ld",_detailModel.mobileFiles.count?_detailModel.mobileFiles.count:0]}];//附件显示辅助视图箭头
    [self.dataSourceArray addObject:@{@"申请人信息":_expensePersonArr}];
    
}
//备用金
- (void)standbyMoney {
    
}

//对公冲账单
- (void)publicExpense {
    
    [self.expensePersonArr addObject:@{@"申请人":_detailModel.expensesName?_detailModel.expensesName:@"-"}];
    [self.expensePersonArr addObject:@{@"所属部门":_detailModel.expensesDeptName?_detailModel.expensesDeptName:@"-"}];
    [self.expensePersonArr addObject:@{@"职务级别":_detailModel.jobLevelStr?_detailModel.jobLevelStr:@"-"}];
    if (_detailModel.proName.length > 0) {
        [self.expensePersonArr addObject:@{@"工程项目名称":_detailModel.proName}];
    }
    [self.expensePersonArr addObject:@{@"收款方":_detailModel.payee?_detailModel.payee:@"-"}];
    [self.expensePersonArr addObject:@{@"入账公司":_detailModel.entryCompName?_detailModel.entryCompName:@"-"}];
    [self.expensePersonArr addObject:@{@"申请金额":[NSString stringWithFormat:@"￥%.2f",_detailModel.applyMoney]}];
    [self.expensePersonArr addObject:@{@"发票张数":[NSString stringWithFormat:@"%ld",_detailModel.invoiceNum]}];
    [self.expensePersonArr addObject:@{@"业务说明":_detailModel.remark?_detailModel.remark:@"-"}];
    [self.expensePersonArr addObject:@{@"附件": [NSString stringWithFormat:@"%ld",_detailModel.mobileFiles.count?_detailModel.mobileFiles.count:0]}];//附件显示辅助视图箭头
    [self.dataSourceArray addObject:@{@"申请人信息":_expensePersonArr}];
    //费用分摊
    [self.dataSourceArray addObject:@{@"费用分摊":_detailModel.pexpShareList}];
    
}
//个人
- (void)personExpenseWithData {
    [self.expensePersonArr addObject:@{@"申请日期":_detailModel.applyDate?[YSUtility timestampSwitchTime:_detailModel.applyDate andFormatter:@"yyyy-MM-dd"]:@"-"}];
    [self.expensePersonArr addObject:@{@"申请人":_detailModel.expensesName?_detailModel.expensesName:@"-"}];
    [self.expensePersonArr addObject:@{@"所属部门":_detailModel.expensesDeptName?_detailModel.expensesDeptName:@"-"}];
    [self.expensePersonArr addObject:@{@"职务级别":_detailModel.jobLevelStr?_detailModel.jobLevelStr:@"-"}];
    if (_detailModel.proName.length > 0) {
        [self.expensePersonArr addObject:@{@"工程项目名称":_detailModel.proName}];
    }
    [self.expensePersonArr addObject:@{@"是否为出场费":_detailModel.appearFee == 1 ?@"是":@"否"}];
    [self.expensePersonArr addObject:@{@"收款方":_detailModel.payee?_detailModel.payee:@"-"}];
    [self.expensePersonArr addObject:@{@"入账公司":_detailModel.entryCompName?_detailModel.entryCompName:@"-"}];
    [self.expensePersonArr addObject:@{@"申请金额":[NSString stringWithFormat:@"￥%.2f",_detailModel.applyMoney]}];
    [self.expensePersonArr addObject:@{@"付款金额":[NSString stringWithFormat:@"￥%.2f",_detailModel.payMoney]}];
    [self.expensePersonArr addObject:@{@"冲账金额":[NSString stringWithFormat:@"￥%.2f",_detailModel.writeOffMoney]}];
    [self.expensePersonArr addObject:@{@"发票张数":[NSString stringWithFormat:@"%ld",_detailModel.invoiceNum]}];
    [self.expensePersonArr addObject:@{@"报销说明":_detailModel.remark?_detailModel.remark:@"-"}];
   [self.expensePersonArr addObject:@{@"附件": [NSString stringWithFormat:@"%ld",_detailModel.mobileFiles.count?_detailModel.mobileFiles.count:0]}];//附件显示辅助视图箭头
    [self.dataSourceArray addObject:@{@"申请人信息":_expensePersonArr}];
    //费用分摊
    [self.dataSourceArray addObject:@{@"费用分摊":_detailModel.pexpShareList}];
    
    
    
}
//差旅
- (void)travelExpenseWithData {
    //[self.expensePersonArr addObject:@{@"申请日期":_detailModel.applyDate?[YSUtility timestampSwitchTime:_detailModel.applyDate andFormatter:@"yyyy-MM-dd"]:@"-"}];
    [self.expensePersonArr addObject:@{@"申请人":_detailModel.expensesName?_detailModel.expensesName:@"-"}];
    [self.expensePersonArr addObject:@{@"所属部门":_detailModel.expensesDeptName?_detailModel.expensesDeptName:@"-"}];
    [self.expensePersonArr addObject:@{@"职务级别":_detailModel.jobLevelStr?_detailModel.jobLevelStr:@"-"}];
    if (_detailModel.proName.length > 0) {
        [self.expensePersonArr addObject:@{@"工程项目名称":_detailModel.proName}];
    }
    [self.expensePersonArr addObject:@{@"是否为出场费":_detailModel.appearFee == 1 ?@"是":@"否"}];
    [self.expensePersonArr addObject:@{@"收款方":_detailModel.payee?_detailModel.payee:@"-"}];
    [self.expensePersonArr addObject:@{@"入账公司":_detailModel.entryCompName?_detailModel.entryCompName:@"-"}];
    [self.expensePersonArr addObject:@{@"申请金额":[NSString stringWithFormat:@"￥%.2f",_detailModel.applyMoney]}];
    [self.expensePersonArr addObject:@{@"付款金额":[NSString stringWithFormat:@"￥%.2f",_detailModel.payMoney]}];
    [self.expensePersonArr addObject:@{@"冲账金额":[NSString stringWithFormat:@"￥%.2f",_detailModel.writeOffMoney]}];
    //出差单号
    [self.expensePersonArr addObject:@{@"报销说明":_detailModel.remark?_detailModel.remark:@"-"}];
    [self.expensePersonArr addObject:@{@"附件": [NSString stringWithFormat:@"%ld",_detailModel.mobileFiles.count?_detailModel.mobileFiles.count:0]}];//附件显示辅助视图箭头
    
    [self.dataSourceArray addObject:@{@"申请人信息":_expensePersonArr}];
    
    //费用明细
    //要判断是否超标显示超标
    NSMutableArray *detailArr = [NSMutableArray array];
    if (_detailModel.tranWarningMsgTran.length) {
        [detailArr addObject:@{@"交通费用(超标)":[NSString stringWithFormat:@"￥%.2f",_detailModel.tranSum]}];
    }else{
        [detailArr addObject:@{@"交通费用":[NSString stringWithFormat:@"￥%.2f",_detailModel.tranSum]}];
    }
    if (_detailModel.putUpWarningMsg.length) {
        [detailArr addObject:@{@"住宿费用(超标)":[NSString stringWithFormat:@"￥%.2f",_detailModel.putUpSum]}];
    }else{
        [detailArr addObject:@{@"住宿费用":[NSString stringWithFormat:@"￥%.2f",_detailModel.putUpSum]}];
    }
    if (_detailModel.subsidyWarningMsg.length) {
        [detailArr addObject:@{@"补助(超标)":[NSString stringWithFormat:@"￥%.2f",_detailModel.subsidySum]}];
    }else{
        [detailArr addObject:@{@"补助":[NSString stringWithFormat:@"￥%.2f",_detailModel.subsidySum]}];
    }
    [self.dataSourceArray addObject:@{@"费用明细":detailArr}];
    //费用分摊
    [self.dataSourceArray addObject:@{@"费用分摊":_detailModel.pexpShareList}];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataSourceArray[section];
     if ([[dic allKeys].firstObject isEqualToString:@"费用分摊"]) {
         return 1;
     }
    return [[self.dataSourceArray[section] allValues].firstObject count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSourceArray[indexPath.section];
    NSArray *valueArr = [dic allValues].firstObject;
     if ([[dic allKeys].firstObject isEqualToString:@"费用分摊"]) {
        YSExpenseShareCell *cell = [[YSExpenseShareCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
         cell.dataArr = valueArr;
        cell.fatherTableView = tableView;
        return cell;
    }else{
        YSFlowFormListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSDictionary *contentDic = valueArr[indexPath.row];
        if ([[contentDic allKeys].firstObject hasPrefix:@"附件"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell setExpenseDetailWithDictionary:valueArr[indexPath.row] Model:_detailModel];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataSourceArray[section];
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    flowFormSectionHeaderView.backgroundColor = kGrayColor(247);
    flowFormSectionHeaderView.titleLabel.text = [dic allKeys].firstObject;
    return flowFormSectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //new 审批界面
    NSArray *array = [[self.dataSourceArray[indexPath.section] allValues] firstObject];
    NSDictionary *dic = array[indexPath.row];
    NSString *key = [dic allKeys].firstObject;
    //当为差旅报销单时传入"0","1","2"分别对应"ems_type_jtfy","ems_type_bz","ems_type_zsfy",业务和个人报销单不用传入值
    if ([key hasPrefix:@"附件"]) {
        YSFlowAttachmentViewController *vc = [[YSFlowAttachmentViewController alloc]init];
        NSMutableArray *attachArr = [NSMutableArray array];
        for (YSFlowAssetsApplyFormApplyInfosModel *model in self.detailModel.mobileFiles) {
            YSNewsAttachmentModel *attachModel = [[YSNewsAttachmentModel alloc]init];
            attachModel.fileName = model.fileName;
            attachModel.fileSize = model.fileSize;
            attachModel.fileType = model.fileType;
            attachModel.filePath = model.filePath;
            attachModel.viewPath = model.viewPath;
            [attachArr addObject:attachModel];
        }
        if (!attachArr.count) {
            [QMUITips showInfo:@"暂无附件信息" inView:self.view hideAfterDelay:1];
            return;
        }
        vc.attachMentArray = attachArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([key hasPrefix:@"交通费用"]) {
        YSExpenseTransportController *vc = [[YSExpenseTransportController alloc]init];
        vc.title = @"交通费用";
        vc.expenseID = _detailModel.id;
        vc.trantype = TranTypeTravel;
         [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([key hasPrefix:@"住宿费用"]) {
        YSExpenseTransportController *vc = [[YSExpenseTransportController alloc]init];
         vc.title = @"住宿费用";
        vc.expenseID = _detailModel.id;
        vc.trantype = TranTypeHouse;
         [self.navigationController pushViewController:vc animated:YES];
    }
    if ([key hasPrefix:@"补助"]) {
        YSExpenseTransportController *vc = [[YSExpenseTransportController alloc]init];
        vc.title = @"补助费用";
        vc.expenseID = _detailModel.id;
        vc.trantype = TranTypeSubSidy;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"申请金额"]) {//差旅点击申请金额不做相应
        if ([_detailModel.categoryStr isEqualToString:@"业务招待报销单"]) {
            YSExpenseTransportController *vc = [[YSExpenseTransportController alloc]init];
            vc.title = @"费用明细";
            vc.expenseID = _detailModel.id;
            vc.trantype = TranTypeBusisses;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([_detailModel.categoryStr isEqualToString:@"个人报销单"]){//个人报销单
            YSExpenseTransportController *vc = [[YSExpenseTransportController alloc]init];
            vc.title = @"费用明细";
            vc.expenseID = _detailModel.id;
            vc.trantype = TranTypePerson;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([_detailModel.categoryStr isEqualToString:@"对公冲账单"]){//个人报销单
            YSExpenseTransportController *vc = [[YSExpenseTransportController alloc]init];
            vc.title = @"费用明细";
            vc.expenseID = _detailModel.id;
            vc.trantype = TranTypePublic;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 处理/转阅 */
- (void)monitorAction {
   
    YSWeak;
    [self.flowFormBottomView.sendActionSubject subscribeNext:^(UIButton *button) {
        YSStrong;
        YSFlowHandleViewController *flowHandleViewController = [[YSFlowHandleViewController alloc] init];
        flowHandleViewController.cellModel = strongSelf.cellModel;
        if (button.tag == 0) {
            QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
                
            }];
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"审批" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
               
                if (strongSelf.detailModel.editMarket && strongSelf.detailModel.marketPexpShareList.count &&  !([strongSelf.detailModel.categoryStr isEqualToString:@"付款申请单"])) {//编辑权限
                    YSFlowExpenseShareController *vc = [[YSFlowExpenseShareController alloc]init];
                    
                    [vc.dataSourceArray addObjectsFromArray:strongSelf.detailModel.marketPexpShareList];
                    vc.modifySuccessBlock = ^{//修改成功
                        flowHandleViewController.flowHandleType = FlowHandleTypeApproval;
                        [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
                    };
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    if ([strongSelf.detailModel.categoryStr isEqualToString:@"差旅报销单"]) {//将超标信息传过去
                        if (strongSelf.detailModel.tranWarningMsgTran.length && strongSelf.detailModel.putUpWarningMsg.length) {
                            flowHandleViewController.outWarningMessage = @"交通费用和住宿费用存在超标，请填写超标意见！";
                        }else if (strongSelf.detailModel.tranWarningMsgTran.length && !strongSelf.detailModel.putUpWarningMsg.length){
                            flowHandleViewController.outWarningMessage = @"交通费用存在超标，请填写超标意见！";
                        }else if (!strongSelf.detailModel.tranWarningMsgTran.length && strongSelf.detailModel.putUpWarningMsg.length){
                            flowHandleViewController.outWarningMessage = @"住宿费用存在超标，请填写超标意见！";
                        }
                    }
                    flowHandleViewController.flowHandleType = FlowHandleTypeApproval;
                    [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
                }
            }];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"驳回" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                
                flowHandleViewController.flowHandleType = FlowHandleTypeReject;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"加签" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                    if (strongSelf.detailModel.editMarket && strongSelf.detailModel.marketPexpShareList.count &&  !([strongSelf.detailModel.categoryStr isEqualToString:@"付款申请单"])) {//加签权限
                        YSFlowExpenseShareController *vc = [[YSFlowExpenseShareController alloc]init];
                        [vc.dataSourceArray addObjectsFromArray:strongSelf.detailModel.marketPexpShareList];
                        vc.modifySuccessBlock = ^{//修改成功
                            flowHandleViewController.flowHandleType = FlowHandleTypeAdd;
                            [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
                        };
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        if ([strongSelf.detailModel.categoryStr isEqualToString:@"差旅报销单"]) {//将超标信息传过去
                            if (strongSelf.detailModel.tranWarningMsgTran.length && strongSelf.detailModel.putUpWarningMsg.length) {
                                flowHandleViewController.outWarningMessage = @"交通费用和住宿费用存在超标，请填写超标意见！";
                            }else if (strongSelf.detailModel.tranWarningMsgTran.length && !strongSelf.detailModel.putUpWarningMsg.length){
                                flowHandleViewController.outWarningMessage = @"交通费用存在超标，请填写超标意见！";
                            }else if (!strongSelf.detailModel.tranWarningMsgTran.length && strongSelf.detailModel.putUpWarningMsg.length){
                                flowHandleViewController.outWarningMessage = @"住宿费用存在超标，请填写超标意见！";
                            }
                        }
                        flowHandleViewController.flowHandleType = FlowHandleTypeAdd;
                        [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
                    }
            }];
            QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"转办" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeChange;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            QMUIAlertAction *action5 = [QMUIAlertAction actionWithTitle:@"暂存" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
                flowHandleViewController.flowHandleType = FlowHandleTypeSave;
                [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
            }];
            
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
            [alertController addAction:action0];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController addAction:action3];
            [alertController addAction:action4];
            [alertController addAction:action5];
            [alertController showWithAnimated:YES];
        } else if (button.tag == 2) {
            //测试用
//            YSFlowExpenseShareController *vc = [[YSFlowExpenseShareController alloc]init];
//            [vc.dataSourceArray addObjectsFromArray:_detailModel.pexpShareList];
//            vc.modifySuccessBlock = ^{//修改成功
//                flowHandleViewController.flowHandleType = FlowHandleTypeApproval;
//                [self.navigationController pushViewController:flowHandleViewController animated:YES];
//            };
//            [self.navigationController pushViewController:vc animated:YES];
            //
            flowHandleViewController.flowHandleType = FlowHandleTypeRevoke;
            [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
        } else {
            flowHandleViewController.flowHandleType = FlowHandleTypeTrans;
            [strongSelf.navigationController pushViewController:flowHandleViewController animated:YES];
        }
    }];
}
- (void)dealloc {
    DLog(@"shifang");
}
@end
