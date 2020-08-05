//
//  YSExpenseInvoiceBaseInfoController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/12.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseInvoiceBaseInfoController.h"
#import "YSFlowExpenseInvoiceModel.h"
#import "YSFlowScoreTableViewCell.h"
#import "YSExpenseAccessoryCell.h"
#import "YSNewsAttachmentViewController.h"
@interface YSExpenseInvoiceBaseInfoController ()
@property (nonatomic,strong) YSFlowExpenseInvoiceModel *invoiceModel;
@end

@implementation YSExpenseInvoiceBaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"发票详情";
}
- (void)initSubviews {
    [super initSubviews];
    
}
- (void)initTableView {
    [super initTableView];
    [self hideMJRefresh];
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self doNetworking];
}
- (void)doNetworking {
    [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getAllExpInvoiceDetaiListApi] isNeedCache:NO parameters:@{@"expAccountDetailId":self.detailID?self.detailID:@""} successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            self.invoiceModel = [YSFlowExpenseInvoiceModel yy_modelWithJSON:response[@"data"]];
            [self doWithData];
        }

    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];
    } progress:nil];
}
- (void)doWithData {
    
    [self.dataSourceArray addObject:@{@"name":@"发票类型",@"content":_invoiceModel.typeStr?_invoiceModel.typeStr:@""}];
    [self.dataSourceArray addObject:@{@"name":@"对方单位名称",@"content":_invoiceModel.orgName?_invoiceModel.orgName:@""}];
    [self.dataSourceArray addObject:@{@"name":@"纳税人识别号",@"content":_invoiceModel.taxpayerNum?_invoiceModel.taxpayerNum:@""}];
    [self.dataSourceArray addObject:@{@"name":@"发票日期",@"content":[YSUtility timestampSwitchTime:_invoiceModel.invoiceDate andFormatter:@"yyyy-MM-dd"]}];
    [self.dataSourceArray addObject:@{@"name":@"发票代码",@"content":_invoiceModel.code?_invoiceModel.code:@""}];
    [self.dataSourceArray addObject:@{@"name":@"发票号码 ",@"content":_invoiceModel.num?_invoiceModel.num:@""}];
    [self.dataSourceArray addObject:@{@"name":@"发票章单位",@"content":_invoiceModel.drawer?_invoiceModel.drawer:@""}];
    if (_invoiceModel.actualTax > 0) {
         [self.dataSourceArray addObject:@{@"name":@"税额合计",@"content":[NSString stringWithFormat:@"%.2f",_invoiceModel.actualTax]}];
    }else{
         [self.dataSourceArray addObject:@{@"name":@"税额合计",@"content":@"-   "}];
    }
    if (_invoiceModel.exTaxAmount > 0) {
         [self.dataSourceArray addObject:@{@"name":@"不含税合计",@"content":[NSString stringWithFormat:@"%.2f",_invoiceModel.exTaxAmount]}];
    }else{
        [self.dataSourceArray addObject:@{@"name":@"不含税合计",@"content":@"-   "}];
    }
    if (_invoiceModel.taxAmountTatol > 0) {
        [self.dataSourceArray addObject:@{@"name":@"价税合计金额",@"content":[NSString stringWithFormat:@"%.2f",_invoiceModel.taxAmountTatol]}];
    }else{
        [self.dataSourceArray addObject:@{@"name":@"价税合计金额",@"content":@"-   "}];
    }
    [self.dataSourceArray addObject:@{@"name":@"发票",@"content":_invoiceModel.mobileFiles}];
    [self ys_reloadData];
    
}
#pragma mark - tableViewDataSource,tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dic = self.dataSourceArray[indexPath.row];
    //取出标题key
    NSString *title = dic[@"name"];
    if ([title isEqualToString:@"发票"]) {//附件
        YSExpenseAccessoryCell *cell = [[YSExpenseAccessoryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSExpenseAccessoryCell"];
        cell.titleLabel.text = @"发票";
        cell.delegate = self;
        cell.accessoryArray = self.invoiceModel.mobileFiles;
        return cell;
    }else {
        YSFlowScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowScoreTableViewCell"];
        if (cell == nil) {
            cell = [[YSFlowScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSFlowScoreTableViewCell"];
        }
        [cell setExpenseDetailWithData:self.dataSourceArray andIndexPath:indexPath];
        return cell;
    
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10*kHeightScale;
}

#pragma mark YSExpenseAccessoryCellDelegate
- (void)expenseAccessoryCellAccessoryViewDidClickWithModel:(YSNewsAttachmentModel *)model {
    YSNewsAttachmentViewController *NewsAttachmentViewController = [[YSNewsAttachmentViewController alloc]init];
    NewsAttachmentViewController.attachmentModel = model;
    [self.navigationController pushViewController:NewsAttachmentViewController animated:YES];
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
