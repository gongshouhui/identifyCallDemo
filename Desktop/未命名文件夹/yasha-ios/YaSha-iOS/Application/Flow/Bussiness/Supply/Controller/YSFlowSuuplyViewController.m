//
//  YSFlowSuuplyViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/18.
//

#import "YSFlowSuuplyViewController.h"
#import "YSFlowExpressFormModel.h"
#import "YSFlowAssetsApplyFormModel.h"
#import "YSFlowSuuplyProjectViewController.h" //代表项目
#import "YSFlowSupplyCategoryViewController.h" //供货类别
#import "YSFlowBusinessViewController.h"//企业经营情况
#import "YSFlowElectronicDataViewController.h"//电子资料
#import "YSEvaluationScoreViewController.h"//考评评分

@interface YSFlowSuuplyViewController ()

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *flowDataSourceArray;
@property (nonatomic, strong) NSMutableArray *nextPageDataArray;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;
@property (nonatomic, assign) BOOL showAll;

@end

@implementation YSFlowSuuplyViewController

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObjectsFromArray:@[@{@"申请信息": @[@"临时编号", @"供应商名称", @"公司分类", @"供应商简称", @"供应商分类", @"营业执照",@"组织机构代码证",@"注册日期",@"税务登记号",@"企业注册地址",@"注册资金",@"法人代表",@"销售模式",@"企业性质",@"准入评级",@"开拓来源",@"经营范围",@"联系人",@"联系电话",@"考评评分",@"电子资料",@"代表项目",@"企业经营情况",@"供货类别"]}]];
    }
    return _titleArray;
}

- (NSMutableArray *)flowDataSourceArray {
    if (!_flowDataSourceArray) {
        _flowDataSourceArray = [[NSMutableArray alloc] initWithArray:@[@[@"", @"", @"", @"", @"", @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]]];
    }
    return _flowDataSourceArray;
}

- (void)initSubviews {
    [super initSubviews];
    _showAll = NO;
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 554*kHeightScale);
//    [self.flowFormHeaderView.actionButton removeFromSuperview];
//    self.flowFormHeaderView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, (30+108)*kHeightScale);
    [self.flowFormHeaderView hiddenActionButton];
    [self titleArray];
    [self monitorAction];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getFranAdmitFlowInfoApi, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"资产待办详情:%@", response);
        DLog(@"资产待办详情:%@", response[@"msg"]);
        if ([response[@"code"] intValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.info;
            [self.flowDataSourceArray removeAllObjects];
            YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.admitPersons[0];
            YSFlowAssetsApplyFormApplyInfosModel *scoreInfosModel;
            if (self.flowAssetsApplyFormListModel.admitScoreCounts.count > 0) {
                scoreInfosModel = self.flowAssetsApplyFormListModel.admitScoreCounts[0];
            }
            
            [self.flowDataSourceArray addObjectsFromArray:@[@[self.flowAssetsApplyFormListModel.no,
                                                              self.flowAssetsApplyFormListModel.name,
                                                              self.flowAssetsApplyFormListModel.comCategory,
                                                              self.flowAssetsApplyFormListModel.shortName,
                                                              self.flowAssetsApplyFormListModel.franCategory,
                                                              self.flowAssetsApplyFormListModel.license,
                                                              self.flowAssetsApplyFormListModel.organ,
                                                               [YSUtility timestampSwitchTime:self.flowAssetsApplyFormListModel.registerDate andFormatter:@"yyyy-MM-dd"],
                                                              self.flowAssetsApplyFormListModel.taxNo,
                                                              [NSString stringWithFormat:@"%@%@%@%@",self.flowAssetsApplyFormListModel.province,self.flowAssetsApplyFormListModel.city,self.flowAssetsApplyFormListModel.area,self.flowAssetsApplyFormListModel.address],
                                                              [NSString stringWithFormat:@"%@万",self.flowAssetsApplyFormListModel.registerMoney],
                                                              self.flowAssetsApplyFormListModel.legalPerson,self.flowAssetsApplyFormListModel.saleModel,self.flowAssetsApplyFormListModel.comNature,self.flowAssetsApplyFormListModel.admitLevel == nil ?@"" : self.flowAssetsApplyFormListModel.admitLevel,self.flowAssetsApplyFormListModel.openSource == nil ?@"": self.flowAssetsApplyFormListModel.openSource,self.flowAssetsApplyFormListModel.busScope,applyInfosModel.name,applyInfosModel.mobile,scoreInfosModel.score == nil ?@"":[NSString stringWithFormat:@"%.2f",[scoreInfosModel.score floatValue]],@"4",@"5",@"6",@"7"
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
   
    if (indexPath.row >19) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFlowFormListCell *cell) {
        [cell setLeftArray:self.titleArray indexPath:indexPath];
        [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 19:{
            YSEvaluationScoreViewController *EvaluationScoreViewController = [[YSEvaluationScoreViewController alloc]initWithStyle:UITableViewStyleGrouped];
            self.nextPageDataArray = [NSMutableArray array];
            if (self.flowAssetsApplyFormListModel.scores
                .count>0) {
                for (int i = 0; i < self.flowAssetsApplyFormListModel.scores
                     .count; i ++) {
                    YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.scores[i];
                    [self.nextPageDataArray addObjectsFromArray:@[applyInfosModel.templateName,applyInfosModel.weight,[YSUtility timestampSwitchTime:applyInfosModel.createTime andFormatter:@"yyyy-MM-dd"],applyInfosModel.content,applyInfosModel.score]];
                    EvaluationScoreViewController.name = applyInfosModel.name;
                }
                DLog(@"------%@",self.nextPageDataArray);
                EvaluationScoreViewController.applyInfosArray = self.nextPageDataArray;
                EvaluationScoreViewController.arrayData = self.flowAssetsApplyFormListModel.scores;
                EvaluationScoreViewController.score = self.flowDataSourceArray[0][indexPath.row];
                [self.navigationController pushViewController:EvaluationScoreViewController animated:YES];
            }else {
                [QMUITips showInfo:@"暂无考评评分数据" inView:self.view hideAfterDelay:1.0];
            }
            
            break;
        }
        case 20:
        {
            YSFlowElectronicDataViewController *FlowElectronicDataViewController = [[YSFlowElectronicDataViewController alloc]initWithStyle:UITableViewStyleGrouped];
            self.nextPageDataArray = [NSMutableArray array];
            for (int i = 0; i < self.flowAssetsApplyFormListModel.admitElectrons
                 .count; i ++) {
                YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.admitElectrons[i];
                [self.nextPageDataArray addObjectsFromArray:@[@[applyInfosModel.name,applyInfosModel.mobileFiles]]];
            }
            FlowElectronicDataViewController.applyInfosArray = self.nextPageDataArray;
            [self.navigationController pushViewController:FlowElectronicDataViewController animated:YES];
            
           break;
        }
        case 21:
        {
            YSFlowSuuplyProjectViewController *FlowSuuplyProjectViewController = [[YSFlowSuuplyProjectViewController alloc]initWithStyle:UITableViewStyleGrouped];
            self.nextPageDataArray = [NSMutableArray array];
            if (self.flowAssetsApplyFormListModel.represents
                .count > 0) {
                for (int i = 0; i < self.flowAssetsApplyFormListModel.represents
                     .count; i ++) {
                    YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.represents[i];
                    [self.nextPageDataArray addObjectsFromArray:@[@[applyInfosModel.longName,applyInfosModel.statusStr,applyInfosModel.name,applyInfosModel.createTime]]];
                }
                FlowSuuplyProjectViewController.applyInfosArray = self.nextPageDataArray;
                [self.navigationController pushViewController:FlowSuuplyProjectViewController animated:YES];
            }else {
                [QMUITips showInfo:@"暂无代表项目数据" inView:self.view hideAfterDelay:1.0];
            }
           
            break;
        }
        case 22:
        {
            YSFlowBusinessViewController *FlowBusinessViewController = [[YSFlowBusinessViewController alloc]initWithStyle:UITableViewStyleGrouped];
            self.nextPageDataArray = [NSMutableArray array];
            if (self.flowAssetsApplyFormListModel.operates
                .count > 0) {
                for (int i = 0; i < self.flowAssetsApplyFormListModel.operates
                     .count; i ++) {
                    YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.operates[i];
                    [self.nextPageDataArray addObjectsFromArray:@[@[applyInfosModel.name,applyInfosModel.createTime,applyInfosModel.svalue]]];
                }
                DLog(@"=======%@",self.nextPageDataArray);
                FlowBusinessViewController.applyInfosArray = self.nextPageDataArray;
                [self.navigationController pushViewController:FlowBusinessViewController animated:YES];
            }else{
                [QMUITips showInfo:@"暂无企业经营情况数据" inView:self.view hideAfterDelay:1.0];
            }
            
            break;
        }
        case 23:
        {
            YSFlowSupplyCategoryViewController *FlowSupplyCategoryViewController = [[YSFlowSupplyCategoryViewController alloc]initWithStyle:UITableViewStyleGrouped];
            self.nextPageDataArray = [NSMutableArray array];
            if (self.flowAssetsApplyFormListModel.categorys
                .count > 0) {
                for (int i = 0; i < self.flowAssetsApplyFormListModel.categorys
                     .count; i ++) {
                    YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.categorys[i];
                    [self.nextPageDataArray addObjectsFromArray:@[@[applyInfosModel.oneTypeName,applyInfosModel.twoTypeName,applyInfosModel.threeTypeName,applyInfosModel.fourTypeName]]];
                    
                }            FlowSupplyCategoryViewController.applyInfosArray = self.nextPageDataArray;
                [self.navigationController pushViewController:FlowSupplyCategoryViewController animated:YES];
            }else {
                [QMUITips showInfo:@"暂无供货类别数据" inView:self.view hideAfterDelay:1.0];
            }
            
            break;
        }
            break;
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
