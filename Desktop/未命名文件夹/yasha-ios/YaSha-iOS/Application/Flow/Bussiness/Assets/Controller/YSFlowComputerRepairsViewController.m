//
//  YSFlowComputerRepairsViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/15.
//

#import "YSFlowComputerRepairsViewController.h"
#import "YSFlowExpressFormModel.h"
#import "YSFlowAssetsApplyFormModel.h"

@interface YSFlowComputerRepairsViewController ()

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *flowDataSourceArray;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;
@property (nonatomic, assign) BOOL showAll;

@end

@implementation YSFlowComputerRepairsViewController

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObjectsFromArray:@[@{@"申请信息": @[@"申请单号", @"使用人", @"使用岗位", @"使用部门", @"使用公司", @"资产编码",@"资产名称",@"规格型号",@"区域公司",@"ITSM单号",@"申请原因"]}]];
    }
    return _titleArray;
}

- (NSMutableArray *)flowDataSourceArray {
    if (!_flowDataSourceArray) {
        _flowDataSourceArray = [[NSMutableArray alloc] initWithArray:@[@[@"", @"", @"", @"", @"", @"",@"",@"",@"",@"",@""]]];
    }
    return _flowDataSourceArray;
}

- (void)initSubviews {
    [super initSubviews];
    _showAll = NO;
    [self titleArray];
    [self monitorAction];
}

- (void)doNetworking {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getApplyByIdForMobileApi, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"电脑备件申请待办详情:%@", response);
        if ([response[@"code"] intValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.apply;
            [self.flowDataSourceArray removeAllObjects];
            [self.flowDataSourceArray addObjectsFromArray:@[@[@"无字段",
                                                              self.flowAssetsApplyFormListModel.useManName,
                                                              self.flowAssetsApplyFormListModel.useManLevel,
                                                              self.flowAssetsApplyFormListModel.useDept,
                                                              self.flowAssetsApplyFormListModel.useCompany,
                                                              self.flowAssetsApplyFormListModel.assetsNo,
                                                              self.flowAssetsApplyFormListModel.goodsName,
                                                              self.flowAssetsApplyFormListModel.proModel,
                                                              self.flowAssetsApplyFormListModel.ifAreaCompany ?@"是":@"否",
                                                              self.flowAssetsApplyFormListModel.itsmNo,
                                                              self.flowAssetsApplyFormListModel.reason
                                                              ]]];
            for (int i = 0; i < self.flowAssetsApplyFormListModel.applyInfos
                 .count; i++) {
                YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.applyInfos[i];
                [self.titleArray addObjectsFromArray:@[@{i == 0 ? @"明细信息" : @"" : i == 0 ? @[@"金额合计(元)", @"物品名称", @"规格型号",@"数量", @"参考价(元)", @"金额合计(元)"]:@[  @"物品名称", @"规格型号",@"数量", @"参考价(元)", @"金额合计(元)"]}]];
                
                [self.flowDataSourceArray addObjectsFromArray: i == 0? @[@[self.flowAssetsApplyFormListModel.amount,applyInfosModel.goodsName,applyInfosModel.proModel,
                                                                           [NSString stringWithFormat:@"%@%@",applyInfosModel.applyNumber, applyInfosModel.buyUnit],
                                                                           applyInfosModel.refPrice,
                                                                           [NSString stringWithFormat:@"%.2f",[applyInfosModel.refPrice floatValue]*[applyInfosModel.applyNumber floatValue]]
                                                                           ]]:@[@[applyInfosModel.goodsName,applyInfosModel.proModel,
                                                                                  [NSString stringWithFormat:@"%@%@",applyInfosModel.applyNumber, applyInfosModel.buyUnit],
                                                                                  applyInfosModel.refPrice,
                                                                                  [NSString stringWithFormat:@"%.2f",[applyInfosModel.refPrice floatValue]*[applyInfosModel.applyNumber floatValue]]
                                                                                  ]]];
            }
            
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
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setLeftArray:self.titleArray indexPath:indexPath];
    [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.valueLabel.textColor = kThemeColor;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    NSDictionary *sectionDic = _titleArray[section];
    flowFormSectionHeaderView.titleLabel.text = [sectionDic allKeys][0];
    return flowFormSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDic = _titleArray[section];
    return [[sectionDic allKeys][0] isEqual:@""] ? 10 : 30*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale)];
    // 显示更多明细
    if (self.flowDataSourceArray.count > 3) {
        if (section == 2 && !_showAll) {
            footerView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
            QMUIButton *button = [[QMUIButton alloc] init];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [button setTitle:@"更多明细" forState:UIControlStateNormal];
            [button setTitleColor:kThemeColor forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"更多明细"] forState:UIControlStateNormal];
            button.imagePosition = QMUIButtonImagePositionRight;
            button.spacingBetweenImageAndTitle = 5;
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                _showAll = YES;
                [self.tableView reloadData];
            }];
            [footerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(footerView.mas_centerX);
                make.top.mas_equalTo(footerView.mas_top).offset(10);
                make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH/2, 25*kHeightScale));
            }];
        }
    }
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.flowDataSourceArray.count > 3) {
        if (_showAll) {
            return section == _titleArray.count-1 ? 50*kHeightScale : 0.01;
        } else {
            return section == 2 ? 100*kHeightScale : 0.01;
        }
    } else {
        return section == _titleArray.count-1 ? 50*kHeightScale : 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFlowFormListCell *cell) {
        [cell setLeftArray:self.titleArray indexPath:indexPath];
        [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
