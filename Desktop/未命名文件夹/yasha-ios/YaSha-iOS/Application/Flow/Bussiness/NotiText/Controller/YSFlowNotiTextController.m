//
//  YSFlowNotiTextController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowNotiTextController.h"
#import "YSFlowNotiTextModel.h"
#import "YSNewsAttachmentCell.h"
#import "YSNewsAttachmentViewController.h"
#import "YSFlowNotiContentController.h"
@interface YSFlowNotiTextController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YSFlowNotiTextModel *flowModel;
@end

@implementation YSFlowNotiTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)initSubviews {
    [super initSubviews];
    [self monitorAction];
}
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@", YSDomain, getNotiText, self.cellModel.businessKey] isNeedCache:NO parameters:nil successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1 ) {
            self.flowModel = [YSFlowNotiTextModel yy_modelWithJSON:response[@"data"]];
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
    YSFlowNotiTextListModel *listModel = _flowModel.info;
    NSMutableArray *notiArr = [NSMutableArray arrayWithCapacity:15];
    [notiArr addObject:@{@"发布板块":listModel.typeIdArrayRemark == nil?@"":listModel.typeIdArrayRemark}];
    [notiArr addObject:@{@"发文类别":listModel.categoryName == nil?@"":listModel.categoryName}];
    [notiArr addObject:@{@"发文标题":listModel.title == nil?@"":listModel.title}];
    [notiArr addObject:@{@"发文主体":listModel.ownerName == nil?@"":listModel.ownerName}];
    [notiArr addObject:@{@"发文内容":@""}];
    [notiArr addObject:@{@"关键词":listModel.keyword == nil?@"":listModel.keyword}];
    [notiArr addObject:@{@"发文范围":listModel.rangeList == nil?@"":listModel.rangeList}];
    [self.dataSourceArray addObject:notiArr];
    if (_flowModel.info.fileList.count) {
         [self.dataSourceArray addObject:_flowModel.info.fileList];
    }
   
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dic = self.dataSourceArray[indexPath.section][indexPath.row];
        YSFlowFormListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[YSFlowFormListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.contentDic = dic;
        if ([[dic allKeys].firstObject isEqualToString:@"发文内容"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }else{
        YSNewsAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlowAttachmentCell"];
        if (cell == nil) {
            cell = [[YSNewsAttachmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlowAttachmentCell"];
        }
        cell.cellModel = self.dataSourceArray[indexPath.section][indexPath.row];
        return cell;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    return 80*kHeightScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    if (section == 0) {
        flowFormSectionHeaderView.titleLabel.text = @"申请信息";
    }else if (section == 1) {
        flowFormSectionHeaderView.titleLabel.text = @"附件列表";
    }
    return flowFormSectionHeaderView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSDictionary *dic = self.dataSourceArray[indexPath.section][indexPath.row];
        if ([[dic allKeys].firstObject isEqualToString:@"发文内容"]) {
            YSFlowNotiContentController *vc = [[YSFlowNotiContentController alloc]init];
            vc.contentText = _flowModel.info.content;
            vc.timeStr = [YSUtility timestampSwitchTime:_flowModel.info.writingTime  andFormatter:@"yyyy-MM-dd"];
            vc.ownerName = _flowModel.info.ownerName;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        YSNewsAttachmentViewController *NewsAttachmentViewController = [[YSNewsAttachmentViewController alloc]init];
        NewsAttachmentViewController.attachmentModel = self.dataSourceArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:NewsAttachmentViewController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30*kHeightScale;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
