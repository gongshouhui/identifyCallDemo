//
//  YSExpenseTransportController.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/15.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseTransportController.h"
#import "YSFlowScoreTableViewCell.h"
#import "YSExpenseAccessoryCell.h"
#import "YSFlowExpenseDetailModel.h"
#import "YSFlowRecheckScoreHeaderView.h"
#import "YSNewsAttachmentViewController.h"
#import "YSExpenseInvoiceDetailController.h"
@interface YSExpenseTransportController ()<UITableViewDelegate,UITableViewDataSource,YSExpenseAccessoryCellDelegate>

@end

@implementation YSExpenseTransportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initTableView {
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self hideMJRefresh];
    [self doNetworking];
   
}   
- (void)doNetworking {
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithCapacity:5];
    [paraDic setValue:self.expenseID forKey:@"expAccountInfoId"];
    if (self.trantype <=2 ) {
        [paraDic setValue:@(self.trantype) forKey:@"tranTypeMobile"];
    }
     [QMUITips showLoadingInView:self.view];
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,getExpAccountDetailApi] isNeedCache:NO parameters:paraDic successBlock:^(id response) {
        [QMUITips hideAllTipsInView:self.view];
        if ([response[@"code"] integerValue] == 1) {
            self.dataSourceArray = [[NSArray yy_modelArrayWithClass:[YSFlowExpenseDetailModel class] json:response[@"data"]] copy];
            switch (self.trantype) {
                case 0:
                    [self travelData];
                    break;
                case 1:
                    [self subsidyData];
                    break;
                case 2:
                    [self houseData];
                    break;
                case 3:
                    [self bussiessData];
                    break;
                case 4:
                    [self personData];
                    break;
                case 5:
                    [self publicDetail];
                    break;
                
                default:
                    break;
            }
        }
        [self ys_reloadData];
        
        
    } failureBlock:^(NSError *error) {
        [QMUITips hideAllTipsInView:self.view];
    } progress:nil];
}
- (void)doWithData {
    
}
#pragma mark - 数据重组
//差旅
- (void)travelData {
    for (YSFlowExpenseDetailModel *model in self.dataSourceArray) {
        NSMutableArray *redataArr = [NSMutableArray array];
        for (YSFlowExpenseCostDetailModel *detailModel in model.info) {
            [redataArr addObject:@{@"name":@"购买方式",@"content":detailModel.buyModeStr,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"座位等级",@"content":detailModel.seatGradeStr,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"费用日期",@"content":detailModel.startTime,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"出发地",@"content":detailModel.startAreaStr,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"目的地",@"content":detailModel.endAreaStr,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"发票号码",@"content":detailModel.invoiceNum,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"金额",@"content":[NSString stringWithFormat:@"￥%.2f",detailModel.money],@"data":detailModel}];
            [redataArr addObject:@{@"name":@"备注",@"content":detailModel.remark,@"data":detailModel,@"end":@(!detailModel.warningMsg.length)}];
            if (detailModel.warningMsg.length) {
                [redataArr addObject:@{@"name":@"警告",@"content":detailModel.warningMsg,@"data":detailModel,@"end":@1}];
            }
        }
        model.redata = redataArr;
    }
}
//住宿
- (void)houseData {
    for (YSFlowExpenseDetailModel *model in self.dataSourceArray) {
        NSMutableArray *redataArr = [NSMutableArray array];
        for (YSFlowExpenseCostDetailModel *detailModel in model.info) {
            [redataArr addObject:@{@"name":@"购买方式",@"content":detailModel.buyModeStr,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"入住时间",@"content":detailModel.startTime,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"退房时间",@"content":detailModel.endTime,@"data":detailModel}];
            //[redataArr addObject:@{@"name":@"住宿天数",@"content": [NSString stringWithFormat:@"%ld",detailModel.businessDay],@"data":detailModel}];
            [redataArr addObject:@{@"name":@"入住地",@"content":detailModel.startAreaStr,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"同住人员",@"content":detailModel.dPersonNameStr,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"金额",@"content": [NSString stringWithFormat:@"￥%.2f",detailModel.money],@"data":detailModel}];
            [redataArr addObject:@{@"name":@"发票号码",@"content":detailModel.invoiceNum,@"data":detailModel}];
            //[redataArr addObject:@{@"name":@"费用归属",@"content":detailModel.proTypeStr,@"data":detailModel}];
            //[redataArr addObject:@{@"name":@"费用归属信息",@"content":detailModel.proName,@"data":detailModel}];
            //[redataArr addObject:@{@"name":@"张数",@"content": [NSString stringWithFormat:@"%ld",detailModel.sheet],@"data":detailModel}];
            //[redataArr addObject:@{@"name":@"附件",@"content":@"",@"data":detailModel}];
            [redataArr addObject:@{@"name":@"备注",@"content":detailModel.remark,@"data":detailModel,@"end":@(!detailModel.warningMsg.length)}];
            if (detailModel.warningMsg.length) {
                [redataArr addObject:@{@"name":@"警告",@"content":detailModel.warningMsg,@"data":detailModel,@"end":@1}];
            }
            
        }
        model.redata = redataArr;
    }
}
//补助
- (void)subsidyData {
    for (YSFlowExpenseDetailModel *model in self.dataSourceArray) {
        NSMutableArray *redataArr = [NSMutableArray array];
        for (YSFlowExpenseCostDetailModel *detailModel in model.info) {
            [redataArr addObject:@{@"name":@"出差地点",@"content":detailModel.startAreaStr,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"出差日期",@"content":detailModel.startTime,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"返程日期",@"content":detailModel.endTime,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"出差天数",@"content":[NSString stringWithFormat:@"%ld",detailModel.businessDay],@"data":detailModel}];
            [redataArr addObject:@{@"name":@"金额",@"content": [NSString stringWithFormat:@"￥%.2f",detailModel.money],@"data":detailModel}];
           // [redataArr addObject:@{@"name":@"费用归属",@"content":detailModel.proTypeStr,@"data":detailModel}];
            //[redataArr addObject:@{@"name":@"费用归属信息",@"content":detailModel.proName,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"备注",@"content":detailModel.remark,@"data":detailModel,@"end":@(!detailModel.warningMsg.length)}];
            if (detailModel.warningMsg.length) {
                [redataArr addObject:@{@"name":@"警告",@"content":detailModel.warningMsg,@"data":detailModel,@"end":@1}];
            }
        }
        model.redata = redataArr;
    }
}
//个人
//拼完数据感觉还不如cell里面嵌套tableview
- (void)personData {
    for (YSFlowExpenseDetailModel *model in self.dataSourceArray) {
        NSMutableArray *redataArr = [NSMutableArray array];
        for (YSFlowExpenseCostDetailModel *detailModel in model.info) {
            [redataArr addObject:@{@"name":@"费用日期",@"content":detailModel.startTime,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"费用地点",@"content":detailModel.startAreaStr,@"data":detailModel}];
            if (!detailModel.expenseNum) {
                [redataArr addObject:@{@"name":@"消费人数",@"content":@"-",@"data":detailModel}];
            }else{
                [redataArr addObject:@{@"name":@"消费人数",@"content":[NSString stringWithFormat:@"%ld",(long)detailModel.expenseNum],@"data":detailModel}];
            }
           
            [redataArr addObject:@{@"name":@"发票号码",@"content":detailModel.invoiceNum,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"车牌号码",@"content":detailModel.plateNum,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"金额",@"content": [NSString stringWithFormat:@"￥%.2f",detailModel.money],@"data":detailModel}];
//            [redataArr addObject:@{@"name":@"费用归属",@"content":detailModel.proTypeStr,@"data":detailModel}];
//            [redataArr addObject:@{@"name":@"费用归属信息",@"content":detailModel.proName,@"data":detailModel}];
//            [redataArr addObject:@{@"name":@"张数",@"content": [NSString stringWithFormat:@"%ld",detailModel.sheet],@"data":detailModel}];
//            [redataArr addObject:@{@"name":@"附件",@"content":@"",@"data":detailModel}];
            [redataArr addObject:@{@"name":@"备注",@"content":detailModel.remark,@"data":detailModel,@"end":@(!detailModel.warningMsg.length)}];
            if (detailModel.warningMsg.length) {
                [redataArr addObject:@{@"name":@"警告",@"content":detailModel.warningMsg,@"data":detailModel,@"end":@1}];
            }
        }
        model.redata = redataArr;
    }
    
}
//业务
- (void)bussiessData {
    [self personData];
}
//对公冲账明细
- (void)publicDetail {
    for (YSFlowExpenseDetailModel *model in self.dataSourceArray) {
        NSMutableArray *redataArr = [NSMutableArray array];
        for (YSFlowExpenseCostDetailModel *detailModel in model.info) {
            [redataArr addObject:@{@"name":@"费用日期",@"content":detailModel.startTime,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"车牌号码",@"content":detailModel.plateNum,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"金额",@"content":[NSString stringWithFormat:@"￥%.2f",detailModel.money],@"data":detailModel}];
            [redataArr addObject:@{@"name":@"发票号码",@"content":detailModel.invoiceNum,@"data":detailModel}];
            [redataArr addObject:@{@"name":@"备注",@"content":detailModel.remark,@"data":detailModel,@"end":@(!detailModel.warningMsg.length)}];
            if (detailModel.warningMsg.length) {
                [redataArr addObject:@{@"name":@"警告",@"content":detailModel.warningMsg,@"data":detailModel,@"end":@1}];
            }
        }
        model.redata = redataArr;
    }
}
#pragma mark - tableViewDataSource,tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSFlowExpenseDetailModel *model = self.dataSourceArray[section];
    return model.redata.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFlowExpenseDetailModel *model = self.dataSourceArray[indexPath.section];
    NSDictionary *dic = model.redata[indexPath.row];
    //取出标题key
    NSString *title = dic[@"name"];
    if ([title isEqualToString:@"附件"]) {//附件
        NSArray *accessArr = [dic[@"data"] mobileFiles];
        YSExpenseAccessoryCell *cell = [[YSExpenseAccessoryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSExpenseAccessoryCell"];
        cell.delegate = self;
        cell.accessoryArray = accessArr;
        return cell;
    }else {
        YSFlowScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFlowScoreTableViewCell"];
        if (cell == nil) {
            cell = [[YSFlowScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSFlowScoreTableViewCell"];
        }
        [cell setExpenseDetailWithData:model.redata andIndexPath:indexPath];
        return cell;

    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSFlowExpenseDetailModel *model = self.dataSourceArray[indexPath.section];
    NSDictionary *dic = model.redata[indexPath.row];
    //取出每个cell标题key
    NSString *title = dic[@"name"];//字典无序遍历key,一共就两个key
    if ([title isEqualToString:@"发票号码"]) {
        YSFlowExpenseCostDetailModel *model = dic[@"data"];
        YSExpenseInvoiceDetailController *VC = [[YSExpenseInvoiceDetailController alloc]init];
        VC.detailID = model.id;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   YSFlowExpenseDetailModel *model = self.dataSourceArray[section];
    YSFlowRecheckScoreHeaderView *headerView = [[YSFlowRecheckScoreHeaderView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.nameLb.text = model.emsType;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 47*kHeightScale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
