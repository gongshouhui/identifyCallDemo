//
//  YSFlowInterviewTableViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/10/23.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowInterviewTableViewController.h"
#import "YSFlowFormListCell.h"

@interface YSFlowInterviewTableViewController ()
@property (nonatomic,strong) NSMutableArray *handleArray;
@end

@implementation YSFlowInterviewTableViewController

- (NSMutableArray *)handleArray {
    if (!_handleArray) {
        _handleArray = [NSMutableArray array];
    }
    return _handleArray;
}
- (void)initTableView {
    [super initTableView];
    [self setUpData:self.dic];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"面试评价表";
}

#pragma mark -- 数据封装
- (void)setUpData:(NSDictionary *)dic {
    [self.handleArray addObject:@{@"title":@"应聘者",@"content":dic[@"interView"][@"name"]}];
    [self.handleArray addObject:@{@"title":@"性别",@"content":dic[@"interView"][@"sex"]}];
    [self.handleArray addObject:@{@"title":@"出生年月",@"content":dic[@"interView"][@"birthday"] }];
    [self.handleArray addObject:@{@"title":@"应聘岗位",@"content":dic[@"interView"][@"InterviewSummaries"][0][@"InterviewTitle"]}];
    for (NSDictionary *dic1 in dic[@"interView"][@"InterviewSummaries"]) {
        [self.handleArray addObject:@{@"title":dic1[@"InterviewInfoTypeName"],@"special":@(BussinessFlowCellHead)}];
        [self.handleArray addObject:@{@"title":@"面试人",@"content":dic1[@"Officer"]}];
        [self.handleArray addObject:@{@"title":@"面试时间",@"content":dic1[@"InterviewTime"]}];
        [self.handleArray addObject:@{@"title":@"面试结果",@"content":dic1[@"Conclusion"][@"ExtendValue"]}];
        [self.handleArray addObject:@{@"title":@"面试评价",@"content":dic1[@"Evaluate"]}];
    }
    self.dataSourceArray = self.handleArray;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"]; //出列可重用的cell
    if (cell == nil) {
        cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
    }
	[cell setCommonBusinessFlowDetailWithDictionary:self.dataSourceArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
