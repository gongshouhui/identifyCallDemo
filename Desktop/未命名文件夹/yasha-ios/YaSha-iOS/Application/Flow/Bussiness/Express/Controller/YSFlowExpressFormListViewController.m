//
//  YSFlowExpressFormListViewController.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/3.
//

#import "YSFlowExpressFormListViewController.h"
#import "YSFlowExpressFormModel.h"

@interface YSFlowExpressFormListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *flowDataSourceArray;
@property (nonatomic, strong) YSFlowExpressFormModel *flowExpressFormModel;
@property (nonatomic, strong) YSFlowExpressListModel *flowExpressListModel;

@end

@implementation YSFlowExpressFormListViewController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@{@"寄件人信息": @[@"费用所属公司", @"寄件人", @"联系方式", @"寄件公司", @"详细地址"]},
                        @{@"收件人信息": @[@"收件人", @"联系方式", @"收件公司", @"省市区", @"详细地址"]}];
    }
    return _titleArray;
}

- (void)initSubviews {
    [super initSubviews];
    [self titleArray];
    [self monitorAction];
}

- (void)doNetworking {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", YSDomain, getExpressByNoForMobileApi, self.cellModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"顺丰流程详情:%@", response);
        if ([response[@"code"] intValue] == 1) {
            self.flowExpressFormModel = [YSFlowExpressFormModel yy_modelWithJSON:response[@"data"]];
            [self.flowFormHeaderView setHeaderModel:self.flowExpressFormModel.baseInfo];
            [self.tableView setTableHeaderView:self.flowFormHeaderView];//taberViewHeader 内部采用自上而下的约束，他不像普通view在填充数据时自适应了高度，tableView表头比较特殊，需要在赋值后重新设置一次表头，tableView才能获取到正确的表头高度
            self.flowExpressListModel = self.flowExpressFormModel.info;
            self.flowDataSourceArray = @[@[self.flowExpressListModel.businessType,
                                           self.flowExpressListModel.sender,
                                           self.flowExpressListModel.senderMobile,
                                           self.flowExpressListModel.senderCompany,
                                           self.flowExpressListModel.senderAddress],
                                         @[self.flowExpressListModel.receiver,
                                           self.flowExpressListModel.receiverMobile,
                                           self.flowExpressListModel.receiverCompany,
                                           [NSString stringWithFormat:@"%@%@%@",
                                            self.flowExpressListModel.receiverProvince,
                                            self.flowExpressListModel.receiverCity,
                                            self.flowExpressListModel.receiverArea],
                                            self.flowExpressListModel.receiverAddress,]];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        DLog(@"error:%@", error);
    } progress:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
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
    return 30*kHeightScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == _titleArray.count-1 ? 50*kHeightScale : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(YSFlowFormListCell *cell) {
        [cell setLeftArray:self.titleArray indexPath:indexPath];
        [cell setRightArray:self.flowDataSourceArray indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
