//
//  YSFlowTenderbargainingViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/4/19.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowTenderbargainingViewController.h"
#import "YSFlowAttachmentViewController.h"
#import "YSFlowTenderIsChooseNewViewController.h"
#import "YSFlowTenderTableViewCell.h"
#import "YSFlowTenderNewTableViewCell.h"
#import "YSBidAttachmentViewController.h"

@interface YSFlowTenderbargainingViewController ()
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;//整体表单数据模型
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;//考勤机申请信息数据模型
@property (nonatomic, strong) NSMutableArray *expensePersonArr;
@property (nonatomic, strong) NSArray *bidFranArr;
@property (nonatomic, strong) NSMutableArray *attachmentArray;

@end

@implementation YSFlowTenderbargainingViewController

- (NSMutableArray *)expensePersonArr {
    if(!_expensePersonArr) {
        _expensePersonArr = [NSMutableArray array];
    }
    return  _expensePersonArr;
}


- (void)initSubviews {
    [super initSubviews];
    self.attachmentArray = [NSMutableArray array];
//    [self.flowFormHeaderView.actionButton removeFromSuperview];
//    self.flowFormHeaderView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 108*kHeightScale);
    [self.flowFormHeaderView hiddenActionButton];
    [self monitorAction];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getTenderBidInfoApi, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"招标议价流程:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.info;
            [self doWithData];
            for (int i = 0; i < self.flowAssetsApplyFormListModel.mobileFiles.count; i++) {
                YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.mobileFiles[i];
                [self.attachmentArray addObjectsFromArray:@[@[applyInfosModel.fileName,
                                                              applyInfosModel.filePath,
                                                              applyInfosModel.viewPath,
                                                              @(applyInfosModel.fileType),
                                                              @(applyInfosModel.fileSize)
                                                              ]]];
            }
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

- (void) doWithData {
	
    if ([self.cellModel.processDefinitionKey isEqualToString:@"srm_bid_contract_flow"]) {//招标议价/合同盖章审批流程
        [self.expensePersonArr addObject:@{@"招标编号":self.flowAssetsApplyFormListModel.code}];
        [self.expensePersonArr addObject:@{@"编辑时间":[YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.createTime andFormatter:@"yyyy-MM-dd"]}];
        [self.expensePersonArr addObject:@{@"招标材料":self.flowAssetsApplyFormListModel.bidMtrl}];
        [self.expensePersonArr addObject:@{@"项目名称":[NSString stringWithFormat:@"%@%@",self.flowAssetsApplyFormListModel.proCode,self.flowAssetsApplyFormListModel.proName]}];
        [self.expensePersonArr addObject:@{@"项目地址":[NSString stringWithFormat:@"%@%@%@",self.flowAssetsApplyFormListModel.province,self.flowAssetsApplyFormListModel.city,self.flowAssetsApplyFormListModel.area]}];
        [self.expensePersonArr addObject:@{@"项目经理":self.flowAssetsApplyFormListModel.proManagerName}];
        [self.expensePersonArr addObject:@{@"项目性质":self.flowAssetsApplyFormListModel.managerModel}];
        [self.expensePersonArr addObject:@{@"工程造价(万元)":self.flowAssetsApplyFormListModel.pmoney}];
        [self.expensePersonArr addObject:@{@"采购模式":self.flowAssetsApplyFormListModel.modelStr}];
        [self.expensePersonArr addObject:@{@"是否重点项目":[self.flowAssetsApplyFormListModel.isKey isEqualToString:@"10"]?@"是":@"否"}];
        [self.expensePersonArr addObject:@{@"全品是否盖章":self.flowAssetsApplyFormListModel.useSealUnit}];
        [self.expensePersonArr addObject:@{@"采购合同版本":self.flowAssetsApplyFormListModel.contractTypeStr ?self.flowAssetsApplyFormListModel.contractTypeStr:@" "}];
        [self.expensePersonArr addObject:@{@"备注":self.flowAssetsApplyFormListModel.remark}];
        [self.expensePersonArr addObject:@{@"合同付款及工期":self.flowAssetsApplyFormListModel.payRemark}];
		[self.expensePersonArr addObject:@{@"目标成本价":[YSUtility thousandsFormat:self.flowAssetsApplyFormListModel.targetCastPrice]}];
		[self.expensePersonArr addObject:@{@"限价":[YSUtility thousandsFormat:self.flowAssetsApplyFormListModel.limitPrice]}];
		
        [self.expensePersonArr addObject:@{@"中标金额":self.flowAssetsApplyFormListModel.money}];
        [self.expensePersonArr addObject:@{@"附件":@"0"}];
        [self.expensePersonArr addObject:@{@"中标供应商":@" "}];
        [self.expensePersonArr addObject:@{@"未中标供应商":@" "}];
        [self.dataSourceArray addObject:@{@"基础信息":_expensePersonArr}];
    }
    //拟邀供应商招标审批流程
    if ([self.cellModel.processDefinitionKey isEqualToString:@"srm_fran_invitation_flow"]) {
        [self.expensePersonArr addObject:@{@"招标编号":self.flowAssetsApplyFormListModel.code}];
        [self.expensePersonArr addObject:@{@"编辑时间":[YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.createTime andFormatter:@"yyyy-MM-dd"]}];
        [self.expensePersonArr addObject:@{@"招标材料":self.flowAssetsApplyFormListModel.bidMtrl}];
        [self.expensePersonArr addObject:@{@"项目名称":[NSString stringWithFormat:@"%@%@",self.flowAssetsApplyFormListModel.proCode,self.flowAssetsApplyFormListModel.proName]}];
        [self.expensePersonArr addObject:@{@"项目地址":[NSString stringWithFormat:@"%@%@%@",self.flowAssetsApplyFormListModel.province,self.flowAssetsApplyFormListModel.city,self.flowAssetsApplyFormListModel.area]}];
        [self.expensePersonArr addObject:@{@"项目经理":self.flowAssetsApplyFormListModel.proManagerName}];
        [self.expensePersonArr addObject:@{@"采购模式":self.flowAssetsApplyFormListModel.modelStr}];
        [self.expensePersonArr addObject:@{@"项目性质":self.flowAssetsApplyFormListModel.managerModel}];
        [self.expensePersonArr addObject:@{@"工程造价(万元)":self.flowAssetsApplyFormListModel.pmoney}];
        [self.expensePersonArr addObject:@{@"是否重点项目":[self.flowAssetsApplyFormListModel.isKey isEqualToString:@"10"]?@"是":@"否"}];
        [self.dataSourceArray addObject:@{@"基础信息":_expensePersonArr}];
        self.bidFranArr = self.flowAssetsApplyFormListModel.bidFranList;
    }
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.bidFranArr.count > 0) {
        return 2;
    }else {
        return self.dataSourceArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [[self.dataSourceArray[section] allValues].firstObject count];
    }else {
        return self.bidFranArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dic = self.dataSourceArray[indexPath.section];
        NSArray *valueArr = [dic allValues].firstObject;
		
        YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSDictionary *contentDic = valueArr[indexPath.row];
        if ([[contentDic allKeys].firstObject hasPrefix:@"附件"] ||[[contentDic allKeys].firstObject hasPrefix:@"中标供应商"]||[[contentDic allKeys].firstObject hasPrefix:@"未中标供应商"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}else{
			 cell.accessoryType = UITableViewCellAccessoryNone;
		}
        
        self.flowAssetsApplyFormListModel.categoryStr = @"备用金";
        [cell setExpenseDetailWithDictionary:valueArr[indexPath.row] Model:self.flowAssetsApplyFormListModel];
        return cell;
    }else {
        NSDictionary *dic = self.bidFranArr[indexPath.row];
        YSFlowTenderNewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[YSFlowTenderNewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowTenderNewTableViewCell"];
        }
        [cell setTenderNewData:dic];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.cellModel.processDefinitionKey isEqualToString:@"srm_bid_contract_flow"]){
        NSDictionary *dic = self.dataSourceArray[indexPath.section];
        NSArray *valueArr = [dic allValues].firstObject;
        NSDictionary *contentDic = valueArr[indexPath.row];
        if ([[contentDic allKeys].firstObject hasPrefix:@"附件"]) {
//            if ([self.flowAssetsApplyFormListModel.useSealUnit isEqualToString:@"是"]) {//全品是否盖章
           
            YSBidAttachmentViewController *vc = [[YSBidAttachmentViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
                if (self.flowAssetsApplyFormListModel.mobileFiles.count) {
                    [vc.dataSourceArray addObject:self.flowAssetsApplyFormListModel.mobileFiles];
                    [vc.titleArray addObject:@"公共附件"];
                }
                if (self.flowAssetsApplyFormListModel.mobileFilesList.count) {
                    [vc.dataSourceArray addObject:self.flowAssetsApplyFormListModel.mobileFilesList];
                    [vc.titleArray addObject:@"合同附件"];
                }
                if (self.flowAssetsApplyFormListModel.mobileFilesQpList.count) {
                    [vc.dataSourceArray addObject:self.flowAssetsApplyFormListModel.mobileFilesQpList];
                    [vc.titleArray addObject:@"全品合同附件"];
                }
//            }else {
//
//                if (self.attachmentArray.count > 0) {//显示默认
//                    YSFlowAttachmentViewController *FlowAttachmentViewController = [[YSFlowAttachmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    FlowAttachmentViewController.applyInfosArray = self.attachmentArray;
//                    [self.navigationController pushViewController:FlowAttachmentViewController animated:YES];
//                }else{
//                    [QMUITips showInfo:@"暂无附件信息" inView:self.view hideAfterDelay:1];
//                }
//            }
        }
        
        if ([[contentDic allKeys].firstObject hasPrefix:@"中标供应商"]) {
            
            YSFlowTenderIsChooseNewViewController *FlowTenderIsChooseViewController = [[YSFlowTenderIsChooseNewViewController alloc]initWithStyle:UITableViewStyleGrouped];
            FlowTenderIsChooseViewController.titleName = @"中标供应商";
            FlowTenderIsChooseViewController.flowTenderType = middleMark;
            FlowTenderIsChooseViewController.id = self.flowAssetsApplyFormListModel.id;
            [self.navigationController pushViewController:FlowTenderIsChooseViewController animated:YES];
        }
        if ([[contentDic allKeys].firstObject hasPrefix:@"未中标供应商"]) {
            YSFlowTenderIsChooseNewViewController *FlowTenderIsChooseViewController = [[YSFlowTenderIsChooseNewViewController alloc]initWithStyle:UITableViewStyleGrouped];
            FlowTenderIsChooseViewController.titleName = @"未中标供应商";
            FlowTenderIsChooseViewController.flowTenderType = unMiddleMark;
            FlowTenderIsChooseViewController.id = self.flowAssetsApplyFormListModel.id;
            [self.navigationController pushViewController:FlowTenderIsChooseViewController animated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSDictionary *dic = self.dataSourceArray[section];
        YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
        flowFormSectionHeaderView.backgroundColor = kGrayColor(247);
        flowFormSectionHeaderView.titleLabel.text = [dic allKeys].firstObject;
        return flowFormSectionHeaderView;
    }else{
        if (self.bidFranArr.count > 0) {
            YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
            flowFormSectionHeaderView.backgroundColor = kGrayColor(247);
            flowFormSectionHeaderView.titleLabel.text = @"供应商信息";
            return flowFormSectionHeaderView;
        }else {
            return nil;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return  30*kHeightScale;
    }else{
        if (self.bidFranArr.count > 0) {
            return  30*kHeightScale;
        }else {
            return 0.01;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }else{
        return 60*kHeightScale;
    }
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
