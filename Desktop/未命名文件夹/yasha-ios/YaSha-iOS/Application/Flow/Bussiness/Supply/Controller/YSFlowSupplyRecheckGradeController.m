//
//  YSFlowSupplyRecheckGradeController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2017/12/25.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowSupplyRecheckGradeController.h"
#import "YSPMSInfoHeaderView.h"
#import "YSFlowScoreTableViewCell.h"
#import "YSFlowSupplyRecheckScoreModel.h"
#import "YSFlowRecheckScoreHeaderView.h"
#import "YSFlowTemplateViewController.h"
@interface YSFlowSupplyRecheckGradeController ()

@end

@implementation YSFlowSupplyRecheckGradeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"复核考察评分";
    // Do any additional setup after loading the view.
}
- (void)initSubviews {
    [super initSubviews];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self hideMJRefresh];
    [self doNetworking];
}
- (void)doNetworking {
    
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@",YSDomain,getFranCheckScoreInfoApi,self.franInfoID] isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [QMUITips hideAllTipsInView:self.view];
            NSArray *dataArr = [NSArray yy_modelArrayWithClass:[YSFlowSupplyRecheckScoreModel class] json:response[@"data"]];
            
            
            NSMutableArray *datasourceArr = [NSMutableArray array];
            for (YSFlowSupplyRecheckScoreModel *scoreModel  in dataArr) {
                NSMutableArray *listArr = [NSMutableArray array];
                for (YSFlowSupplyRecheckScoreListModel *model in scoreModel.admitScoreList) {
                    NSMutableArray *array = [NSMutableArray array];
                    [array addObject:model.templateName];
                   
                    [array addObject:[NSString stringWithFormat:@"%.1f",model.weight]];
                    [array addObject:model.sdateStr];
                    [array addObject:model.content];
                    [array addObject:[NSString stringWithFormat:@"%.2f",model.score]];
                    [listArr addObjectsFromArray:array];
                }
                scoreModel.reScoreList = listArr;
                [datasourceArr addObject:scoreModel];
                
                
            }
            self.dataSource = [datasourceArr copy];
            
            [self ys_reloadData];
        }
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];
        
    } progress:nil];
}
#pragma mark - tableViewDataSource,tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFlowSupplyRecheckScoreModel *model = self.dataSource[section];
    return model.reScoreList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowSupplyRecheckScoreModel *model = self.dataSource[indexPath.section];
    YSFlowScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowScoreTableViewCell"];
    if (cell == nil) {
        cell = [[YSFlowScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowScoreTableViewCell"];
    }
    [cell setFlowScoreDataWithLine:model.reScoreList  andIndexPath:indexPath];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSFlowSupplyRecheckScoreModel *model = self.dataSource[section];
    YSFlowRecheckScoreHeaderView *headerView = [[YSFlowRecheckScoreHeaderView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.nameLb.text = model.name;
//    if (model.score) {
     headerView.detailLb.text = [NSString stringWithFormat:@"%.2f分",model.score];
//    }
    return headerView;
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     YSFlowSupplyRecheckScoreModel *model = self.dataSource[indexPath.section];
    if (indexPath.row%5 == 0) {
        
        YSFlowSupplyRecheckScoreListModel *scoreModel = model.admitScoreList[indexPath.row/5];
        YSFlowTemplateViewController *FlowTemplateViewController = [[YSFlowTemplateViewController alloc]init];
        FlowTemplateViewController.urlStr = [NSString stringWithFormat:@"%@%@.do",YSCheckTemplateDomain, scoreModel.mobileId];
        DLog(@" templateId  %@",[NSString stringWithFormat:@"%@%@.do",YSCheckTemplateDomain, scoreModel.mobileId]);
        [self.navigationController pushViewController:FlowTemplateViewController animated:YES];
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 47*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
