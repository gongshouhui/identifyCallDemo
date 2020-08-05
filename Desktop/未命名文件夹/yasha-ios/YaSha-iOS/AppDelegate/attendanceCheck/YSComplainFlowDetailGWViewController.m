//
//  YSComplainFlowDetailGWViewController.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/20.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSComplainFlowDetailGWViewController.h"
#import "YSAttendanceFlowViewModel.h"
#import "YSFlowFormModel.h"
#import "YSFlowDetailsHeaderView.h"
#import "YSFlowDetailsConerNavView.h"
#import "YSFlowRecordListCell.h"
#import "LCSelectMenuView.h"
#import "YSFlowFormHeaderView.h"
#import "YSFlowFormBottomView.h"
#import "YSBaseBussinessFlowViewModel.h"
#import "YSFlowRecordListCell.h"
#import "UIView+Extension.h"
#import "LCSelectMenuView.h"
#import "YSContactModel.h"
#import "YSFlowAssociatedViewController.h"
#import "YSFlowDocumentationViewController.h"
#import "YSFlowMapViewController.h"

#import "YSFlowFormBottomView.h"
#import "YSFlowHandleViewController.h"
#import "YSFlowFormListCell.h"
#import "YSFlowEditCell.h"
#import "YSFlowBackGroundCell.h"
#import "YSFlowEmptyCell.h"

@interface YSComplainFlowDetailGWViewController ()

@end

@implementation YSComplainFlowDetailGWViewController

- (void)loadView {
    [super loadView];
    self.viewModel = [[YSComplainFlowViewModel alloc]initWithFlowTpe:self.flowType andflowInfo:self.flowModel];// 早于视图下载完前创建viewModel
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [QMUITips showLoadingInView:self.view];
    [self.viewModel getFlowlistComplete:^{
        [QMUITips hideAllTipsInView:self.view];
        self.coverNavView.titleLabel.text = self.viewModel.flowFormModel.baseInfo.title;
        [self.functionHeaderView setHeaderModel:self.viewModel.flowFormModel.baseInfo];
        [self.functionHeaderView.documentButton setTitle:self.viewModel.documentBtnTitle forState:UIControlStateNormal];
        
        [self.tableView reloadData];
        //定位当前的标题位置（该计算要在tableView刷新之后计算来保证header位置的准确）
        [self markSectionHeaderLocation];
        
    } failue:^(NSString * _Nonnull message) {
        [QMUITips hideAllTipsInView:self.view];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel turnOtherViewControllerWith:self andIndexPath:indexPath];
    
    
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0://表单内容
        {
            NSDictionary *dataDic = self.viewModel.dataSourceArray[indexPath.row];
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
                YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"];
                
                if (cell == nil) {
                    cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
                }
                [cell setCommonBusinessFlowDetailWithDictionary:self.viewModel.dataSourceArray[indexPath.row]];
                NSDictionary *dataDic = self.viewModel.dataSourceArray[indexPath.row];
//                if (indexPath.row == 1 && [[dataDic objectForKey:@"special"] integerValue] == 0) {
//                    // BussinessFlowCellNormal 0
//                    //打开时间 从左侧显示
//                    cell.valueLabel.textAlignment = NSTextAlignmentLeft;
//                }
                return cell;
            }
            
        }
            break;
        case 1://提交者附言
        {
            YSFlowFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowFormListCell"]; //出列可重用的cell
            if (cell == nil) {
                cell = [[YSFlowFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowFormListCell"];
            }
            [cell setCommonBusinessFlowDetailWithDictionary:self.viewModel.postscriptArray[indexPath.row]];
            return cell;
        }
            break;
        case 2://处理记录
        {
            YSFlowRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowRecordListCell"]; //出列可重用的cell
            cell.delegate = self;
            if (cell == nil) {
                cell = [[YSFlowRecordListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowRecordListCell"];
            }
            if (self.viewModel.handleRecordArray.count > 0) {
                YSFlowRecordListModel *model = self.viewModel.handleRecordArray[indexPath.row];
                [cell setRecordListCellModel:model andIndexPath:indexPath];

            }
            return cell;
        }
            break;
        default://转阅记录
        {
            YSFlowRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowRecordListCell"]; //出列可重用的cell
            if (cell == nil) {
                cell = [[YSFlowRecordListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSFlowRecordListCell"];
            }
            if (self.viewModel.turnReadArray.count > 0) {
                YSFlowRecordListModel *cellModel = self.viewModel.turnReadArray[indexPath.row];
                [cell setRecordListCellModel:cellModel andIndexPath:indexPath];
            }
            return cell;
        }
            break;
    }
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
