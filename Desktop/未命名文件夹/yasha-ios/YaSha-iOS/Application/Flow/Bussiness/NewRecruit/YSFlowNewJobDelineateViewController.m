//
//  YSFlowJobDelineateViewController.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/10/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowNewJobDelineateViewController.h"
#import "YSFlowFormListCell.h"

@interface YSFlowNewJobDelineateViewController ()
@property (nonatomic,strong) NSMutableArray *handleArray;
@end

@implementation YSFlowNewJobDelineateViewController
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
    self.title = @"岗位描述";
}
#pragma mark -- 数据封装
- (void)setUpData:(NSDictionary *)dic {
    
    [self.handleArray addObject:@{@"title":@"岗位名称",@"content":self.dic[@"positionName"]}];
    [self.handleArray addObject:@{@"title":@"所属中心/部门",@"content":self.dic[@"departmentName"]}];
    [self.handleArray addObject:@{@"title":@"岗位职级",@"content":[NSString stringWithFormat:@"%@",self.dic[@"num"]] }];
    [self.handleArray addObject:@{@"title":@"岗位编号",@"content":[NSString stringWithFormat:@"%@",self.dic[@"positionId"]]}];
    [self.handleArray addObject:@{@"title":@"直接上级",@"content":@" "}];
    [self.handleArray addObject:@{@"title":@"直接下级",@"content":@" "}];
    [self.handleArray addObject:@{@"title":@"岗位职责",@"content":dic[@"postStatement"]}];
	[self.handleArray addObject:@{@"title":@"任职资格",@"special":@(BussinessFlowCellHead)}];
    [self.handleArray addObject:@{@"title":@"学历",@"content":@" "}];
    [self.handleArray addObject:@{@"title":@"专业",@"content":@" "}];
    [self.handleArray addObject:@{@"title":@"工作经验",@"content":@" "}];
    [self.handleArray addObject:@{@"title":@"知识",@"content":@" "}];
    [self.handleArray addObject:@{@"title":@"能力",@"content":dic[@"ability"]}];
    [self.handleArray addObject:@{@"title":@"其他",@"content":@" "}];
    [self.handleArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellHead)}];
    [self.handleArray addObject:@{@"title":@"备注",@"content":dic[@"others"]}];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 44;
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
