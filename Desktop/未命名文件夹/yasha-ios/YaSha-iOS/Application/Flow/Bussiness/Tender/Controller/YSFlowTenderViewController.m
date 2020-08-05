//
//  YSFlowTenderViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/20.
//

#import "YSFlowTenderViewController.h"
#import "YSFlowExpressFormModel.h"
#import "YSFlowAssetsApplyFormModel.h"
#import "YSFlowTenderTableViewCell.h"
#import "YSFlowTenderIsChooseViewController.h"
#import "YSFlowAttachmentViewController.h"

@interface YSFlowTenderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *flowDataSourceArray;
@property (nonatomic, strong) NSMutableArray *nextPageDataArray;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;
@property (nonatomic, assign) BOOL showAll;

@end

@implementation YSFlowTenderViewController

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObjectsFromArray:@[@{@"基础信息": @[@"招标编号", @"编辑时间",@"招标材料", @"项目名称", @"项目地址",@"项目经理", @"采购模式", @"项目性质",@"工程造价(元)",@"是否重点项目",@"备注",@"附件",@"中标供应商",@"未中标供应商"]}]];
    }
    return _titleArray;
}

- (NSMutableArray *)flowDataSourceArray {
    if (!_flowDataSourceArray) {
        _flowDataSourceArray = [[NSMutableArray alloc]initWithArray:@[@[@"", @"", @"",@"",@"", @"",@"", @"",@"",@"",@"",@"",@"",@""]]];
    }
    return _flowDataSourceArray;
}

- (void)initSubviews {
    [super initSubviews];
    _showAll = NO;
    [self.flowFormHeaderView hiddenActionButton];
    [self titleArray];
    [self monitorAction];
}

- (void)doNetworking {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getTenderBidInfoApi, self.cellModel.businessKey];
    DLog(@"--------%@",urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"资产待办详情:%@", response);
        if ([response[@"code"] intValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.info;
            [self.flowDataSourceArray removeAllObjects];
            [self.flowDataSourceArray addObjectsFromArray:@[@[
                                                                self.flowAssetsApplyFormListModel.code,
                                      [NSString stringWithFormat:@"%@",
                                       [YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.createTime andFormatter:@"yyyy-MM-dd"]],
                                                              self.flowAssetsApplyFormListModel.bidMtrl,
                                                              [NSString stringWithFormat:@"%@%@",self.flowAssetsApplyFormListModel.proCode,self.flowAssetsApplyFormListModel.proName],
                                                              [NSString stringWithFormat:@"%@%@%@",self.flowAssetsApplyFormListModel.province,self.flowAssetsApplyFormListModel.city,self.flowAssetsApplyFormListModel.area],self.flowAssetsApplyFormListModel.proManagerName,
                                                              self.flowAssetsApplyFormListModel.modelStr,
                                                              self.flowAssetsApplyFormListModel.managerModel,
                                                              [NSString stringWithFormat:@"%.2f万",[self.flowAssetsApplyFormListModel.pmoney floatValue]],
                                                              self.flowAssetsApplyFormListModel.isBid ? @"是":@"否",
                                                              self.flowAssetsApplyFormListModel.remark,
                                                                [NSString stringWithFormat:@"%lu",(unsigned long)self.flowAssetsApplyFormListModel.mobileFiles
                                                                 .count],
                                           
                                                        ]]];
           
            [self.tableView reloadData];
            
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.flowDataSourceArray.count > 3) {
        return _showAll ? self.flowDataSourceArray.count : 3;
    } else {
        return _titleArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *rowDic = _titleArray[section];
    NSArray *titleArray = [rowDic allValues][0];
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setLeftArray:self.titleArray indexPath:indexPath];
    if (indexPath.row > 11) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        if (indexPath.row == 11) {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(8);
                make.bottom.mas_equalTo(cell.contentView.mas_bottom).offset(-8);
                
                make.right.mas_equalTo(cell.contentView.mas_right).offset(0);
                make.size.mas_equalTo(CGSizeMake(26,26));
            }];
            cell.valueLabel.layer.masksToBounds = YES;
            cell.valueLabel.layer.cornerRadius = 13;
            cell.valueLabel.backgroundColor = [UIColor redColor];
            cell.valueLabel.textColor = [UIColor whiteColor];
            cell.valueLabel.textAlignment = NSTextAlignmentCenter;
        }

        [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
  }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFlowFormListCell *cell) {
        if (indexPath.row <= 10) {
            [cell setLeftArray:self.titleArray indexPath:indexPath];
            [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
        }else{
            cell.valueLabel.text = @"设置";
        }
        }];
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 11) {
        YSFlowTenderIsChooseViewController *FlowTenderIsChooseViewController = [[YSFlowTenderIsChooseViewController alloc]initWithStyle:UITableViewStyleGrouped];
        if (indexPath.row == 12) {
            FlowTenderIsChooseViewController.titleName = @"中标供应商";
            FlowTenderIsChooseViewController.flowTenderType = middleMark;
        }else{
            FlowTenderIsChooseViewController.titleName = @"未中标供应商";
            FlowTenderIsChooseViewController.flowTenderType = unMiddleMark;
        }
        FlowTenderIsChooseViewController.id = self.flowAssetsApplyFormListModel.id;
        [self.navigationController pushViewController:FlowTenderIsChooseViewController animated:YES];
    }
    if (indexPath.row == 11) {
        self.nextPageDataArray = [NSMutableArray array];
        if (self.flowAssetsApplyFormListModel.mobileFiles.count > 0) {
            YSFlowAttachmentViewController *FlowAttachmentViewController = [[YSFlowAttachmentViewController alloc] initWithStyle:UITableViewStyleGrouped];
            FlowAttachmentViewController.attachMentArray = self.flowAssetsApplyFormListModel.mobileFiles;
            [self.navigationController pushViewController:FlowAttachmentViewController animated:YES];
        }else{
            [QMUITips showInfo:@"暂无附件信息" inView:self.view hideAfterDelay:1];
        }
       
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    flowFormSectionHeaderView.backgroundColor = kGrayColor(247);
    flowFormSectionHeaderView.titleLabel.text = @"基础信息";
    return flowFormSectionHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
