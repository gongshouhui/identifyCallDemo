//
//  YSFlowAttendanceViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/15.
//

#import "YSFlowAttendanceViewController.h"
#import "YSFlowAssetsApplyFormModel.h"

@interface YSFlowAttendanceViewController ()<UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;//标题数组
@property (nonatomic, strong) NSMutableArray *flowDataSourceArray;//流程数据数组
@property (nonatomic, assign) BOOL showAll;//是否显示全部明细信息
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;//整体表单数据模型
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;//考勤机申请信息数据模型

@end

@implementation YSFlowAttendanceViewController

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObject:@{@"申请信息":@[@"申请单号",@"使用人",@"使用岗位",@"使用部门",@"使用公司",@"项目名称",@"项目经理",@"项目属性",@"备注"]}];
    }
    return _titleArray;
}

- (NSMutableArray *)flowDataSourceArray {
    if (!_flowDataSourceArray) {
        _flowDataSourceArray = [[NSMutableArray alloc] initWithArray:@[@[@"", @"", @"", @"", @"", @"",@"",@"",@""]]];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getApplyByIdForMobileApi, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"考勤机流程详情:%@", response);
        if ([response[@"code"] integerValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.flowFormHeaderView layoutIfNeeded];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.apply;
            [self.dataSourceArray removeAllObjects];
            [self dealWithData];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}
- (void)dealWithData {
    NSMutableArray *baseInfoArray = [NSMutableArray array];
    [baseInfoArray addObject:@{@"申请单号":self.flowAssetsApplyFormListModel.applyNo}];
    [baseInfoArray addObject:@{@"使用人":self.flowAssetsApplyFormListModel.useManName}];
    [baseInfoArray addObject:@{@"使用岗位":self.flowAssetsApplyFormListModel.useManLevel}];
    [baseInfoArray addObject:@{@"使用部门":self.flowAssetsApplyFormListModel.useDept}];
    [baseInfoArray addObject:@{@"使用公司":self.flowAssetsApplyFormListModel.useCompany}];
    [baseInfoArray addObject:@{@"项目名称":self.flowAssetsApplyFormListModel.ownProject}];
    [baseInfoArray addObject:@{@"项目经理":self.flowAssetsApplyFormListModel.managerName}];
    [baseInfoArray addObject:@{@"项目属性":self.flowAssetsApplyFormListModel.proNature}];
    [baseInfoArray addObject:@{@"备注":self.flowAssetsApplyFormListModel.remark}];
    [self.dataSourceArray addObject:@{@"title":@"申请信息",@"data":baseInfoArray}];
    
    for (int i = 0; i < self.flowAssetsApplyFormListModel.applyInfos
         .count; i++) {
        YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.applyInfos[i];
        [self.titleArray addObject:@{i == 0 ? @"明细信息" : @"" : @[@"物品名称", @"电池", @"4G模块", @"参考价(元)", @"规格型号",@"申请理由",@"备注"]}];
        
        NSMutableArray *infoArray = [NSMutableArray array];
        [infoArray addObject:@{@"物品名称":applyInfosModel.goodsName}];
        [infoArray addObject:@{@"电池":applyInfosModel.ifBattery ? @"是":@""}];
        [infoArray addObject:@{@"4G模块":applyInfosModel.if4gModel ? @"是":@""}];
        [infoArray addObject:@{@"参考价(元)":applyInfosModel.refPrice}];
        [infoArray addObject:@{@"规格型号":applyInfosModel.proModel}];
        [infoArray addObject:@{@"申请理由":applyInfosModel.applyReason}];
        [infoArray addObject:@{@"备注":applyInfosModel.remark}];
        if (i == 0) {
             [self.dataSourceArray addObject:@{@"title":@"明细信息",@"data":infoArray}];
        }else{
             [self.dataSourceArray addObject:@{@"title":@"",@"data":infoArray}];
        }
    }
    
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSourceArray.count > 3) {
        return _showAll ? self.dataSourceArray.count : 3;
    } else {
        return self.dataSourceArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataSourceArray[section];
    return [dic[@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dic = self.dataSourceArray[indexPath.section];
    cell.contentDic = dic[@"data"][indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    NSDictionary *sectionDic = self.dataSourceArray[section];
    flowFormSectionHeaderView.titleLabel.text = sectionDic[@"title"];
    return flowFormSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDic = self.dataSourceArray[section];
    return [sectionDic[@"title"] length] > 0 ? 30*kHeightScale : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale)];
    // 显示更多明细
    if (self.dataSourceArray.count > 3) {
        if (section == 2 && !_showAll) {
            footerView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
            QMUIButton *button = [[QMUIButton alloc] init];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [button setTitle:@"更多明细" forState:UIControlStateNormal];
            [button setTitleColor:kThemeColor forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"更多明细"] forState:UIControlStateNormal];
            button.imagePosition = QMUIButtonImagePositionRight;
            button.spacingBetweenImageAndTitle = 5;
            YSWeak;
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                weakSelf.showAll = YES;
                [weakSelf.tableView reloadData];
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
    if (self.dataSourceArray.count > 3) {
        if (_showAll) {
            return section == self.dataSourceArray.count-1 ? 50*kHeightScale : 0.01;
        } else {
            return section == 2 ? 104+100*kHeightScale : 0.01;
        }
    } else {
        return  0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
