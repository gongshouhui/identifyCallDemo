//
//  YSModifyFlowGWaterViewModel.m
//  YaSha-iOS
//
//  Created by GZl on 2020/2/21.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSModifyFlowGWaterViewModel.h"

@implementation YSModifyFlowGWaterViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",YSDomain, getProcessDataForMobile, self.flowModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"考勤修正流程详情:%@", response);
        if ([response[@"code"] intValue] == 1) {
            
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];

            [self setUpData];//重组数据
            if (comleteBlock) {
                comleteBlock();
            }
        }else{
            if (fetchFailueBlock) {
                fetchFailueBlock(@"");//错误提示语由网络请求中心实现
            }
        }
    } failureBlock:^(NSError *error) {
        if (fetchFailueBlock) {
            fetchFailueBlock(@"");
        }
    } progress:nil];
    
}


- (void)setUpData {
    [self.dataSourceArray removeAllObjects];
    
    [self.dataSourceArray addObject:@{@"title":@"申请信息",@"special":@(BussinessFlowCellHead)}];
    if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"qj"]) {
        [self.dataSourceArray addObject:@{@"title":@"流程类型",@"content":@"请假/调休申请"}];
    }else if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"jb"]) {
        [self.dataSourceArray addObject:@{@"title":@"流程类型",@"content":@"加班申请"}];

    }else if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"ygwc"]) {
        [self.dataSourceArray addObject:@{@"title":@"流程类型",@"content":@"因公外出申请"}];

    }else if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"yc"]) {
        [self.dataSourceArray addObject:@{@"title":@"流程类型",@"content":@"异常申诉申请"}];

    }else if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"cc"]) {
        [self.dataSourceArray addObject:@{@"title":@"流程类型",@"content":@"出差申请"}];

    }else if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"xmtx"]) {
        [self.dataSourceArray addObject:@{@"title":@"流程类型",@"content":@"项目调休"}];

    }
    [self.dataSourceArray addObject:@{@"title":@"流程单号",@"content":[self.flowFormModel.info objectForKey:@"processCode"]}];
    // 因异常申诉 修改时间的beginData没有返回值 不使用下面的方法
//    if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"xmtx"]) {//项目调休
//        [self.dataSourceArray addObject:@{@"title":@"开始日期",@"content":[NSString stringWithFormat:@"%@ %@", [YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginTime"] andFormatter:@"yyyy-MM-dd"], [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"startPeriodStr"]]]}];
//
//        [self.dataSourceArray addObject:@{@"title":@"结束日期",@"content":[NSString stringWithFormat:@"%@ %@", [YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endTime"] andFormatter:@"yyyy-MM-dd"], [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"endPeriodStr"]]]}];
//        [self.dataSourceArray addObject:@{@"title":@"天数",@"content":[NSString stringWithFormat:@"%.1f",[[self.flowFormModel.info objectForKey:@"beforeTotalTime"] floatValue]]}];
//    }else
    if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"yc"]) {//异常申诉
        [self.dataSourceArray addObject:@{@"title":@"申诉时段",@"content":[NSString stringWithFormat:@"%@", [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"startPeriodStr"]]]}];
        
    }else{
        [self.dataSourceArray addObject:@{@"title":@"开始日期",@"content":[NSString stringWithFormat:@"%@ %@", [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"beginTimeStr"]], [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"startPeriodStr"]]]}];
        [self.dataSourceArray addObject:@{@"title":@"结束日期",@"content":[NSString stringWithFormat:@"%@ %@", [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"endTimeStr"]], [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"endPeriodStr"]]]}];
        [self.dataSourceArray addObject:@{@"title":@"天数",@"content":[NSString stringWithFormat:@"%.1f",[[self.flowFormModel.info objectForKey:@"beforeTotalTime"] floatValue]]}];
    }
    //*********************修改信息****************************
    [self.dataSourceArray addObject:@{@"title":@"修改信息",@"special":@(BussinessFlowCellHead)}];
    [self.dataSourceArray addObject:@{@"title":@"申请信息",@"content":[[self.flowFormModel.info objectForKey:@"processStamp"] isEqualToString:@"10"] ? @"撤销申请流程" : @"调整申请日期"}];
    //// 因异常申诉 修改时间的beginData没有返回值 不使用下面的方法
//    if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"xmtx"]) {//项目调休
//        [self.dataSourceArray addObject:@{@"title":@"开始日期",@"content":[NSString stringWithFormat:@"%@ %@", [YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginDate"] andFormatter:@"yyyy-MM-dd"], [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"startPeriodStr"]]]}];
//
//        [self.dataSourceArray addObject:@{@"title":@"结束日期",@"content":[NSString stringWithFormat:@"%@ %@", [YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endDate"] andFormatter:@"yyyy-MM-dd"], [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"endPeriodTrans"]]]}];
//        [self.dataSourceArray addObject:@{@"title":@"天数",@"content":[NSString stringWithFormat:@"%.1f",[[self.flowFormModel.info objectForKey:@"beforeTotalTime"] floatValue]]}];
//    }else
    if ([[self.flowFormModel.info objectForKey:@"processType"] isEqualToString:@"yc"]) {
        //异常申诉的修正信息
        [self.dataSourceArray addObject:@{@"title":@"申诉时段",@"content":[NSString stringWithFormat:@"%@", [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"startPeriodTrans"]]]}];
    }else {
        [self.dataSourceArray addObject:@{@"title":@"开始日期",@"content":[NSString stringWithFormat:@"%@ %@", [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"beginDateStr"]], [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"startPeriodTrans"]]]}];
        [self.dataSourceArray addObject:@{@"title":@"结束日期",@"content":[NSString stringWithFormat:@"%@ %@", [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"endDateStr"]], [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"endPeriodTrans"]]]}];
        [self.dataSourceArray addObject:@{@"title":@"天数",@"content":[NSString stringWithFormat:@"%.1f",[[self.flowFormModel.info objectForKey:@"totalTime"] floatValue]]}];
    }
    [self.dataSourceArray addObject:@{@"title":@"事由说明",@"content":[self.flowFormModel.info objectForKey:@"remark"]}];
    
}

#pragma mark--时间cell模型处理
- (void)handelCellModelData {
           
    [self.dataSourceArray addObject:@{@"title":@"开始时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginTime"] andFormatter:@"yyyy-MM-dd"]}];
    [self.dataSourceArray addObject:@{@"title":@"开始时间时段",@"content":[self.flowFormModel.info objectForKey:@"startPeriodTrans"]}];

    [self.dataSourceArray addObject:@{@"title":@"结束时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endTime"] andFormatter:@"yyyy-MM-dd"]}];
    [self.dataSourceArray addObject:@{@"title":@"结束时间时段",@"content":[self.flowFormModel.info objectForKey:@"endPeriodTrans"]}];


}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath{}


@end
