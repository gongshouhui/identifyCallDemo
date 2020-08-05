//
//  YSFlowTripFormListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/6.
//

#import "YSFlowTripFormListViewController.h"
#import "YSFlowTripFormModel.h"

@interface YSFlowTripFormListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *flowDataSourceArray;
@property (nonatomic, strong) NSArray *detailTitleArray;
@property (nonatomic, strong) NSMutableArray *detailDataSourceArray;
@property (nonatomic, strong) NSArray *detailRightTitleArray;
@property (nonatomic, strong) YSFlowTripFormModel *flowTripFormModel;
@property (nonatomic, strong) YSFlowTripFormListModel *flowTripFormListModel;

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) QMUIModalPresentationViewController *modalPresentationViewController;

@end

@implementation YSFlowTripFormListViewController

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObjectsFromArray:@[@{@"出差信息": @[@"出差人", @"所属公司", @"职务级别", @"出差日期", @"返程日期", @"出差事由", @"身份证号码", @"是否项目人员", @"工程项目名称", @"项目经理"]}]];
    }
    return _titleArray;
}

- (NSMutableArray *)flowDataSourceArray {
    if (!_flowDataSourceArray) {
        _flowDataSourceArray = [[NSMutableArray alloc] initWithArray:@[@[@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""]]];
    }
    return _flowDataSourceArray;
}

- (NSArray *)detailTitleArray {
    if (!_detailTitleArray) {
        _detailTitleArray = @[@"出差日期", @"起止地", @"项目类型", @"项目", @"出行方式", @"交通代买", @"预定酒店", @"备注"];
    }
    return _detailTitleArray;
}

- (NSMutableArray *)detailDataSourceArray {
    if (!_detailDataSourceArray) {
        _detailDataSourceArray = [NSMutableArray array];
    }
    return _detailDataSourceArray;
}

- (UITableView *)detailTableView {
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 450+kBottomHeight) style:UITableViewStyleGrouped];
        _detailTableView.dataSource = self;
        _detailTableView.delegate = self;
        [_detailTableView registerClass:[YSFlowFormListCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _detailTableView;
}

- (void)initSubviews {
    [super initSubviews];
    [self titleArray];
    [self flowDataSourceArray];
    [self monitorAction];
    
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getBusinessInfoByCodeApi, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"出差流程详情:%@", response);
        if ([response[@"code"] intValue] == 1) {
            self.flowTripFormModel = [YSFlowTripFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowTripFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowTripFormListModel = self.flowTripFormModel.info;
            [self.flowDataSourceArray removeAllObjects];
            
            [self.flowDataSourceArray addObjectsFromArray:@[@[self.flowTripFormListModel.businessPname,
                                                              self.flowTripFormListModel.businessName,
                                                              self.flowTripFormListModel.jobLevelName,
                                   
                                                              [YSUtility formatTimestamp:self.flowTripFormListModel.startTime Length:10],
                                                              [YSUtility formatTimestamp:self.flowTripFormListModel.endTime Length:10],
                                                              self.flowTripFormListModel.remark,
                                                              self.flowTripFormListModel.idCard,
                                                              self.flowTripFormListModel.proPerson,
                                                              self.flowTripFormListModel.proName,
                                                              self.flowTripFormListModel.proManagerName]]];
            for (int i = 0; i < self.flowTripFormListModel.businessTripList
                 .count; i ++) {
                YSFlowBusinessTripListModel *flowBusinessTripListModel = self.flowTripFormListModel.businessTripList[i];
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
                NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithInt:i+1]];
                [self.titleArray addObjectsFromArray:@[@{i == 0 ? @"行程明细" : @"" : @[[NSString stringWithFormat:@"行程%@", numberString], @"出差日期", @"起止地", @"交通代买", @"备注"]}]];
                [self.flowDataSourceArray addObjectsFromArray:@[@[@"查看详情",
                                                                  [YSUtility formatTimestamp:flowBusinessTripListModel.startTime Length:10],
                                                                  [flowBusinessTripListModel.address isEqual:@""] ?
                                                                  [NSString stringWithFormat:@"%@ → %@", flowBusinessTripListModel.startCity, flowBusinessTripListModel.endCity] : flowBusinessTripListModel.address,
                                                                  flowBusinessTripListModel.buyTickets,
                                                                  flowBusinessTripListModel.remark]]];
                [self.detailDataSourceArray addObjectsFromArray:@[@[[YSUtility formatTimestamp:flowBusinessTripListModel.startTime Length:10],
                                                                    [flowBusinessTripListModel.address isEqual:@""] ?
                                                                    [NSString stringWithFormat:@"%@ → %@", flowBusinessTripListModel.startCity, flowBusinessTripListModel.endCity] : flowBusinessTripListModel.address,
                                                                    flowBusinessTripListModel.proType,
                                                                    flowBusinessTripListModel.proName,
                                                                    flowBusinessTripListModel.tripMode,
                                                                    flowBusinessTripListModel.buyTickets,
                                                                    flowBusinessTripListModel.bookHotal,
                                                                    flowBusinessTripListModel.remark
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
    return tableView == self.tableView ? _titleArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *rowDic = _titleArray[section];
    NSArray *titleArray = [rowDic allValues][0];
    return tableView == self.tableView ? titleArray.count : 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (tableView == self.tableView) {
        [cell setLeftArray:self.titleArray indexPath:indexPath];
        [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
    } else {
        [cell setLeftDetailArray:self.detailTitleArray indexPath:indexPath];
        [cell setRightDetailArray:self.detailRightTitleArray indexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
        NSDictionary *sectionDic = _titleArray[section];
        flowFormSectionHeaderView.titleLabel.text = [sectionDic allKeys][0];
        
        return flowFormSectionHeaderView;
    } else {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 76)];
        titleView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"行程详情";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(titleView);
        }];
        
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDic = _titleArray[section];
    
    return tableView == self.tableView ? [[sectionDic allKeys][0] isEqual:@""] ? 10 : 30*kHeightScale : 76;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale)];
        return footerView;
    } else {
        UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale)];
        [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        finishButton.titleLabel.font = [UIFont systemFontOfSize:15];
        finishButton.backgroundColor = kThemeColor;
        [[finishButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [_modalPresentationViewController hideWithAnimated:YES completion:nil];
        }];
        
        return finishButton;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return tableView == self.tableView ? (section == _titleArray.count-1 ? 50*kHeightScale : 0.01) : 50*kHeightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFlowFormListCell *cell) {
        if (tableView == self.tableView) {
            [cell setLeftArray:self.titleArray indexPath:indexPath];
            [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
        } else {
            [cell setLeftDetailArray:self.detailTitleArray indexPath:indexPath];
            [cell setRightDetailArray:self.detailRightTitleArray indexPath:indexPath];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0 && indexPath.row == 0) {
        [self handleLayoutBlockAndAnimation:indexPath];
    }
}

- (void)handleLayoutBlockAndAnimation:(NSIndexPath *)indexPath {
    _detailRightTitleArray = _detailDataSourceArray[indexPath.section-1];
    [_detailTableView reloadData];
    
    __weak __typeof(self)weakSelf = self;
    _modalPresentationViewController = [[QMUIModalPresentationViewController alloc] init];
    _modalPresentationViewController.contentView = self.detailTableView;
    _modalPresentationViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        weakSelf.detailTableView.frame = CGRectSetXY(weakSelf.detailTableView.frame, CGFloatGetCenter(CGRectGetWidth(containerBounds), CGRectGetWidth(weakSelf.detailTableView.frame)), CGRectGetHeight(containerBounds) - CGRectGetHeight(_detailTableView.frame));
    };
    
    _modalPresentationViewController.showingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void(^completion)(BOOL finished)) {
        weakSelf.detailTableView.frame = CGRectSetY(weakSelf.detailTableView.frame, CGRectGetHeight(containerBounds));
        dimmingView.alpha = 0;
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 1;
            weakSelf.detailTableView.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    
    _modalPresentationViewController.hidingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void(^completion)(BOOL finished)) {
        [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 0.0;
            weakSelf.detailTableView.frame = CGRectSetY(weakSelf.detailTableView.frame, CGRectGetHeight(containerBounds));
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    [_modalPresentationViewController showWithAnimated:YES completion:nil];
}

@end
