//
//  YSFlowMQReplyController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/23.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowMQReplyController.h"
#import "YSFlowFormListCell.h"
#import "YSFlowFormSectionHeaderView.h"
@interface YSFlowMQReplyController ()

@end

@implementation YSFlowMQReplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评审意见定稿回复";
    [self setUpData];
    [self.tableView reloadData];
    
}
- (void)setUpData {
    
    for (int i = 0; i < self.replyArray.count; i++) {
        NSDictionary *dic = self.replyArray[i];
        NSMutableArray *infoArray = [NSMutableArray array];
        [infoArray addObject:@{@"title":@"评审意见" ,@"special":@(BussinessFlowCellHeadWhite)}];
        [infoArray addObject:@{@"special":@(BussinessFlowCellText),@"content":dic[@"reviewerComment"]}];
        [infoArray addObject:@{@"title":@"定稿回复" ,@"special":@(BussinessFlowCellHeadWhite)}];
        if ([dic[@"responses"] length] > 0) {
             [infoArray addObject:@{@"special":@(BussinessFlowCellText),@"content":dic[@"responses"]}];
        }
       
        [self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"明细（%d）",i+1],@"content":infoArray}];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray[section][@"content"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataSourceArray[indexPath.section][@"content"][indexPath.row];
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"]; //出列可重用的cell
    
    if (cell == nil) {
        cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
    }
    [cell setCommonBusinessFlowDetailWithDictionary:dic];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    flowFormSectionHeaderView.backgroundColor = kGrayColor(247);
    flowFormSectionHeaderView.titleLabel.text =  self.dataSourceArray[section][@"title"];
    return flowFormSectionHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  30*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
}
@end
