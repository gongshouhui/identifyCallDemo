//
//  YSFlowLawDepartDetailViewController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowLawDepartDetailViewController.h"
#import "YSLawDepartModel.h"
#import "YSFlowFormListCell.h"
#import "YSExpenseShareHeaderView.h"
#import "YSFlowFormSectionHeaderView.h"
@interface YSFlowLawDepartDetailViewController ()<YSExpenseShareHeaderViewDelegate>
////当前控制器记录展开收起
//@property (nonatomic,strong) NSMutableArray *isOpenArray;
@end

@implementation YSFlowLawDepartDetailViewController
//- (NSMutableArray *)isOpenArray {
//    if (!_isOpenArray) {
//        _isOpenArray = [NSMutableArray array];
//    }
//    return _isOpenArray;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"各部门资料明细";
    [self hideMJRefresh];
    [self setUpData];
    [self.tableView reloadData];
}

- (void)setUpData {
    for (YSLawDepartModel *model in self.departArr) {
        NSMutableArray *infoArray = [NSMutableArray array];
        [infoArray addObject:@{@"title":@"接收人",@"content":model.receiverName}];
        [infoArray addObject:@{@"title":@"资料" ,@"content":model.receiveData}];
        [infoArray addObject:@{@"title":@"类型" ,@"content":model.type}];
        [infoArray addObject:@{@"title":@"提供时间" ,@"content":[YSUtility timestampSwitchTime:model.submitDate andFormatter:@"yyyy-MM-dd hh:mm"]}];
        [infoArray addObject:@{@"title":@"拟提交时间" ,@"content":[YSUtility timestampSwitchTime:model.planSubmitDate andFormatter:@"yyyy-MM-dd"]}];
        [infoArray addObject:@{@"title":@"经办人" ,@"content":model.operator}];
        [infoArray addObject:@{@"title":@"经办人联系方式" ,@"content":model.operatorPhone}];
        [infoArray addObject:@{@"title":@"法务部接收资料情况" ,@"content":model.lawsuitData }];
        [infoArray addObject:@{@"title":@"备注" ,@"content":model.remark}];
        [self.dataSourceArray addObject:@{@"title":model.deptName,@"content":infoArray}];

        //        if ([self.departArr indexOfObject:model] == 0) {
        //            [self.isOpenArray addObject:@"open"];
        //        }else{
        //             [self.isOpenArray addObject:@"close"];
        //        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //    if ([self.isOpenArray[section] isEqualToString:@"open"]) {
    return [self.dataSourceArray[section][@"content"] count];
    //    }else{
    //        return 0;
    //    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"]; //出列可重用的cell
    
    if (cell == nil) {
        cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
    }
    [cell setCommonBusinessFlowDetailWithDictionary:self.dataSourceArray[indexPath.section][@"content"][indexPath.row]];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.dataSourceArray[section];
    YSFlowFormSectionHeaderView *flowFormSectionHeaderView = [[YSFlowFormSectionHeaderView alloc] init];
    flowFormSectionHeaderView.backgroundColor = kGrayColor(247);
    flowFormSectionHeaderView.titleLabel.text =  self.dataSourceArray[section][@"title"];
    return flowFormSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  30*kHeightScale;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//        return 44*kHeightScale;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *title = self.dataSourceArray[section][@"title"];
//        YSExpenseShareHeaderView *view = [[YSExpenseShareHeaderView alloc]init];
//    view.backgroundColor = kGrayColor(247);
//        view.lineView.hidden = YES;
//        view.titleLb.textColor = kGrayColor(153);
//        view.titleLb.text = title;
//        view.delegate = self;
//        view.tag = 500 + section;
//        if ([self.isOpenArray[section] isEqualToString:@"close"]) {
//            view.arrowBtn.selected = NO;
//        }else{
//            view.arrowBtn.selected = YES;
//        }
//
//        return view;
//}


//- (void)expandButtonDidClick:(YSExpenseShareHeaderView *)headerView {
//    NSInteger index = headerView.tag - 500;
//    if ([self.isOpenArray[index] isEqualToString:@"close"]) {
//        self.isOpenArray[index] = @"open";
//    }else{
//        self.isOpenArray[index] = @"close";
//    }
//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

@end
