//
//  YSFlowMultiDepartEditController.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowMultiDepartEditController.h"
#import "YSFlowEditCell.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"
#import "YSFlowFormListCell.h"
@interface YSFlowMultiDepartEditController ()
@property (nonatomic,strong) YSMultiDepartEditViewModel *viewModel;
@end

@implementation YSFlowMultiDepartEditController
- (instancetype)initWithViewModel:(YSMultiDepartEditViewModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"各部门资料明细";
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];//暂时放在这里刷新，因为cell的数据绑定没有做，变为数据驱动
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.viewDataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.viewDataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSDictionary *dataDic = self.viewModel.viewDataArr[indexPath.section][indexPath.row];
        if ([dataDic[@"special"] integerValue] == BussinessFlowCellEdit) {
            YSFlowEditCell *cell = [[YSFlowEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.titleLb.text = dataDic[@"title"];
            return cell;
        }else if([dataDic[@"special"] integerValue] == BussinessFlowCellBG){
            YSFlowBackGroundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowBackGroundCell"];
            if (cell == nil) {
                cell = [[YSFlowBackGroundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowBackGroundCell"];
            }
            cell.lableNameLabel.text = dataDic[@"title"];
            cell.valueLabel.text = dataDic[@"content"];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
            return cell;
            
        }else if([dataDic[@"special"] integerValue] == BussinessFlowCellEmpty){
            YSFlowEmptyCell *cell = [[YSFlowEmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
            return cell;
            
        }else{
            YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"]; //出列可重用的cell
            
            if (cell == nil) {
                cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
            }
            [cell setCommonBusinessFlowDetailWithDictionary:dataDic];
            return cell;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel turnOtherViewControllerWith:self andIndexPath:indexPath];
}

@end
