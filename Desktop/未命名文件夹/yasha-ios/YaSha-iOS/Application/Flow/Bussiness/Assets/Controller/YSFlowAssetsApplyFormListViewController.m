//
//  YSFlowAssetsApplyFormListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/10.
//

#import "YSFlowAssetsApplyFormListViewController.h"
#import "YSFlowExpressFormModel.h"
#import "YSFlowAssetsApplyFormModel.h"

@interface YSFlowAssetsApplyFormListViewController ()<UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *flowDataSourceArray;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;
@property (nonatomic, assign) BOOL showAll;

@end

@implementation YSFlowAssetsApplyFormListViewController

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObjectsFromArray:@[@"申请信息",@"明细信息"]];
    }
    return _titleArray;
}

- (void)initSubviews {
    [super initSubviews];
    [self monitorAction];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getApplyByIdForMobileApi, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"资产待办详情:%@", response);
        if ([response[@"code"] intValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            [self.flowDataSourceArray removeAllObjects];
            [self doWithData];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}
- (void)doWithData {
    self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.apply;
    NSMutableArray *infoArr = [NSMutableArray array];
    [infoArr addObject:@{@"申请单号":self.flowAssetsApplyFormListModel.applyNo?self.flowAssetsApplyFormListModel.applyNo:@" "}];
    [infoArr addObject:@{@"使用人":self.flowAssetsApplyFormListModel.useManName?self.flowAssetsApplyFormListModel.useManName:@" "}];
    [infoArr addObject:@{@"使用岗位":self.flowAssetsApplyFormListModel.useManLevel?self.flowAssetsApplyFormListModel.useManLevel:@" "}];
    [infoArr addObject:@{@"使用部门":self.flowAssetsApplyFormListModel.useDept?self.flowAssetsApplyFormListModel.useDept:@" "}];
    [infoArr addObject:@{@"使用公司": self.flowAssetsApplyFormListModel.useCompany? self.flowAssetsApplyFormListModel.useCompany:@""}];
    [infoArr addObject:@{@"项目名称":self.flowAssetsApplyFormListModel.ownProject?self.flowAssetsApplyFormListModel.ownProject:@" "}];
    
    [self.dataSourceArray addObject:infoArr];//

    if (self.flowAssetsApplyFormListModel.applyInfos.count) {//有明细信息
        //明细信息
       
        for (int i = 0; i < self.flowAssetsApplyFormListModel.applyInfos.count; i++) {
             NSMutableArray *detailInfo = [NSMutableArray array];
            YSFlowAssetsApplyFormApplyInfosModel *applyInfosModel = self.flowAssetsApplyFormListModel.applyInfos[i];
            [detailInfo addObject:@{@"明细类":applyInfosModel.thirdCate?applyInfosModel.thirdCate:@""}];
            [detailInfo addObject:@{@"物品等级":applyInfosModel.goodsLevelName?applyInfosModel.goodsLevelName:@""}];
            [detailInfo addObject:@{@"等级说明":applyInfosModel.goodsLevelRemark?applyInfosModel.goodsLevelRemark:@""}];
            [detailInfo addObject:@{@"在用资产数":applyInfosModel.assetsCount?applyInfosModel.assetsCount:@""}];
            [detailInfo addObject:@{@"申请理由":applyInfosModel.applyReason?applyInfosModel.applyReason:@""}];
            [self.dataSourceArray addObject:detailInfo];
        }
       
        
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSourceArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dic = self.dataSourceArray[indexPath.section][indexPath.row];
    [cell setContentDic:dic];

    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    if (section < 2) {//第一个区和二区有标题
         flowFormSectionHeaderView.titleLabel.text = self.titleArray[section];
    }

    return flowFormSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < 2) {
        return 30*kHeightScale;
    }else{
        return 10;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale)];
//    // 显示更多明细
//    if (self.flowDataSourceArray.count > 3) {
//        if (section == 2 && !_showAll) {
//            footerView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
//            QMUIButton *button = [[QMUIButton alloc] init];
//            button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//            [button setTitle:@"更多明细" forState:UIControlStateNormal];
//            [button setTitleColor:kThemeColor forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:@"更多明细"] forState:UIControlStateNormal];
//            button.imagePosition = QMUIButtonImagePositionRight;
//            button.spacingBetweenImageAndTitle = 5;
//            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//                _showAll = YES;
//                [self.tableView reloadData];
//            }];
//            [footerView addSubview:button];
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(footerView.mas_centerX);
//                make.top.mas_equalTo(footerView.mas_top).offset(10);
//                make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH/2, 25*kHeightScale));
//            }];
//        }
//    }
//
//    return footerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (self.flowDataSourceArray.count > 3) {
//        if (_showAll) {
//            return section == _titleArray.count-1 ? 50*kHeightScale : 0.01;
//        } else {
//            return section == 2 ? 104+100*kHeightScale : 0.01;
//        }
//    } else {
//        return section == _titleArray.count-1 ? 50*kHeightScale : 0.01;
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
