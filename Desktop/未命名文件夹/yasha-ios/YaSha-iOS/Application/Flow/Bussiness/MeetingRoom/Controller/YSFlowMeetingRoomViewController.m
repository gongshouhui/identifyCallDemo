//
//  YSFlowMeetingRoomViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/12/14.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowMeetingRoomViewController.h"
#import "YSFlowExpressFormModel.h"
#import "YSFlowAssetsApplyFormModel.h"
#import "YSFlowTenderTableViewCell.h"

@interface YSFlowMeetingRoomViewController ()

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *flowDataSourceArray;
@property (nonatomic, strong) NSMutableArray *nextPageDataArray;
@property (nonatomic, strong) YSFlowAssetsApplyFormModel *flowAssetsApplyFormModel;
@property (nonatomic, strong) YSFlowAssetsApplyFormListModel *flowAssetsApplyFormListModel;
@property (nonatomic, assign) BOOL showAll;

@end

@implementation YSFlowMeetingRoomViewController

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObjectsFromArray:@[@{@"申请信息": @[@"会议室", @"申请类型",@"使用时间", @"开始时段", @"结束时段",@"备注"]}]];
        
    }
    return _titleArray;
}

- (NSMutableArray *)flowDataSourceArray {
    if (!_flowDataSourceArray) {
        _flowDataSourceArray = [[NSMutableArray alloc]initWithArray:@[@[@"", @"", @"",@"",@"", @""]]];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getMeetingroomApplyDetailApi, self.cellModel.businessKey];
    DLog(@"=======%@",urlString);
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"资产待办详情:%@", response);
        [QMUITips hideAllToastInView:self.view animated:YES];
        if ([response[@"code"] intValue] == 1) {
            self.flowAssetsApplyFormModel = [YSFlowAssetsApplyFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowAssetsApplyFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowAssetsApplyFormListModel = self.flowAssetsApplyFormModel.info;
            [self.flowDataSourceArray removeAllObjects];
           
            [self.flowDataSourceArray addObjectsFromArray:@[@[self.flowAssetsApplyFormListModel.meetingroomName,[self.flowAssetsApplyFormListModel.applyType intValue] == 0 ?@"单次":@"周期性" ,
                                                              [self.flowAssetsApplyFormListModel.applyType intValue] == 0 ?[NSString stringWithFormat:@"%@",self.flowAssetsApplyFormListModel.startDateStr]:[NSString stringWithFormat:@"%@至%@\n%@",self.flowAssetsApplyFormListModel.startDateStr,self.flowAssetsApplyFormListModel.endDateStr,self.flowAssetsApplyFormListModel.weekDays],
                                                              self.flowAssetsApplyFormListModel.startTimeStr,
                                                              self.flowAssetsApplyFormListModel.endTimeStr,
                                                              self.flowAssetsApplyFormListModel.remark,

                                                              ]]];
            DLog(@"======%@",self.flowDataSourceArray);
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
            return section == 2 ? 104+100*kHeightScale : 0.01;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
