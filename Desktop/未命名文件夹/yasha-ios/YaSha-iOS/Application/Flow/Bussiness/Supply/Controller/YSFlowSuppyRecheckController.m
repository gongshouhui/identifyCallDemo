//
//  YSFlowSuppyRecheckController.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/22.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowSuppyRecheckController.h"
#import "YSFlowFormListCell.h"
#import "YSFlowSupplyRecheckGradeController.h"
#import "YSFlowAssetsApplyFormModel.h"
@interface YSFlowSuppyRecheckController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong)  YSFlowAssetsApplyFormModel*flowModel;
@end

@implementation YSFlowSuppyRecheckController
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"复核考察评分";
    // Do any additional setup after loading the view.
   
}
- (void)initSubviews
{
    [super initSubviews];
    //隐藏附言按钮
//    [self.flowFormHeaderView.actionButton removeFromSuperview];
//    self.flowFormHeaderView.frame = CGRectMake(0, 0, 0, 108*kHeightScale);
//    self.flowFormHeaderView.lineLabel.hidden = YES;
    [self.flowFormHeaderView hiddenActionButton];
    [self monitorAction];
   //[self doNetworking];
    
}
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@", YSDomain, getFranCheckInfoApi, self.cellModel.businessKey] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        DLog(@"--------%@",response);
        if ([response[@"code"] integerValue] == 1 ) {
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
    YSFlowAssetsApplyFormListModel *listModel = _flowModel.info;
    
    [self.dataArr addObject:@{@"复核考察类型":listModel.checkTypeStr == nil?@"":listModel.checkTypeStr}];
    [self.dataArr addObject:@{@"供应商编号":listModel.franNo == nil?@"":listModel.franNo}];
    [self.dataArr addObject:@{@"供应商名称":listModel.franName == nil?@"":listModel.franName}];
    [self.dataArr addObject:@{@"供应商简称":listModel.shortName == nil?@"":listModel.shortName}];
    [self.dataArr addObject:@{@"联系人":listModel.personName == nil?@"":listModel.personName}];
    [self.dataArr addObject:@{@"手机":listModel.mobile == nil?@"":listModel.mobile}];
    [self.dataArr addObject:@{@"准入日期":listModel.auditDateStr == nil?@"":listModel.auditDateStr}];
    if ([listModel.checkTypeStr isEqualToString:@"变更复察"]) {
        [self.dataArr addObject:@{@"状态":listModel.statusStr == nil?@"":listModel.statusStr}];
    }
    NSString *categroyStr = [[NSString alloc]init];
    for (NSString *str in listModel.franCategoryString) {
        categroyStr = [categroyStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",str]];
    }
    if (categroyStr.length) {
      categroyStr = [categroyStr substringToIndex:categroyStr.length - 1];
    }
    [self.dataArr addObject:@{@"供货类别":categroyStr}];
    
    [self.dataArr addObject:@{@"复核考察评分":listModel.score > 0?[NSString stringWithFormat:@"%.2f",listModel.score]:@""}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.contentDic = self.dataArr[indexPath.row];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    flowFormSectionHeaderView.titleLabel.text = @"申请信息";
    return flowFormSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30*kHeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArr.count -1) {
        YSFlowSupplyRecheckGradeController *vc = [[YSFlowSupplyRecheckGradeController alloc]init];
        vc.franInfoID = self.flowModel.info.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
