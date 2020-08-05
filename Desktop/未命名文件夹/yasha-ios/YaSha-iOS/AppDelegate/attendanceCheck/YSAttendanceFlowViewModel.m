//
//  YSAttendanceFlowViewModel.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAttendanceFlowViewModel.h"

@interface YSAttendanceFlowViewModel ()


@end

@implementation YSAttendanceFlowViewModel

- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getFlowDataForMobile, self.flowModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        DLog(@"新版考勤流程详情:%@", response);
        if ([response[@"code"] intValue] == 1) {
            
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
//            self.goodsApplyModel = [YSFlowGoodsApplyModel yy_modelWithJSON:self.flowFormModel.info[@"apply"]];
//            self.goodsAttachArray = [NSArray yy_modelArrayWithClass:[YSNewsAttachmentModel class] json:self.flowFormModel.info[@"fileListFormMobile"]];
            [self setUpData];//重组数据
            //关联文档
            for (NSDictionary *dic in self.flowFormModel.info[@"fileList"]) {
                YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
                [self.attachArray addObject:model];
            }
            if (self.attachArray.count > 0) {
                self.documentBtnTitle = [NSString stringWithFormat:@"关联文档(%lu)",(unsigned long)self.attachArray.count];
            }
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
    if ([[self.flowFormModel.info objectForKey:@"type"] isEqualToString:@"jb"]) {
        // 加班详情
        [self.dataSourceArray addObject:@{@"title":@"开始时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginTime"] andFormatter:@"yyyy-MM-dd"]}];
        [self.dataSourceArray addObject:@{@"title":@"结束时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endTime"] andFormatter:@"yyyy-MM-dd"]}];
    }else if ([[self.flowFormModel.info objectForKey:@"type"] isEqualToString:@"ygwc"]) {
        //因公外出
        [self handelCellModelData];
        [self.dataSourceArray addObject:@{@"title":@"申请天数",@"content":[NSString stringWithFormat:@"%.1f",[[self.flowFormModel.info objectForKey:@"totalTime"] floatValue]]}];
        [self.dataSourceArray addObject:@{@"title":@"上级领导",@"content":[self.flowFormModel.info objectForKey:@"leaderName"]}];
               [self.dataSourceArray addObject:@{@"title":@"是否项目部",@"content":[[self.flowFormModel.info objectForKey:@"isProject"] integerValue]==1?@"是":@"否"}];
               
               if ([[self.flowFormModel.info objectForKey:@"isProject"]integerValue]==1) {
                   //项目信息
                      [self.dataSourceArray addObject:@{@"title":@"项目名称",@"content":[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"projectName"]]}];
                      [self.dataSourceArray addObject:@{@"title":@"项目经理",@"content":[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"projectManager"]]}];
               }
    }else if ([[self.flowFormModel.info objectForKey:@"type"] isEqualToString:@"qj"]) {
        //请假
        [self.dataSourceArray addObject:@{@"title":@"申请人员",@"content":[self.flowFormModel.info objectForKey:@"employName"]}];
        [self.dataSourceArray addObject:@{@"title":@"申请人工号",@"content":[self.flowFormModel.info objectForKey:@"employCode"]}];
        [self.dataSourceArray addObject:@{@"title":@"申请人职级",@"content":[self.flowFormModel.info objectForKey:@"positionName"]}];
        [self.dataSourceArray addObject:@{@"title":@"上级领导",@"content":[self.flowFormModel.info objectForKey:@"leaderName"]}];
        [self.dataSourceArray addObject:@{@"title":@"是否项目部",@"content":[[self.flowFormModel.info objectForKey:@"isProject"] integerValue]==1?@"是":@"否"}];
        
        if ([[self.flowFormModel.info objectForKey:@"isProject"]integerValue]==1) {
            //项目信息
               [self.dataSourceArray addObject:@{@"title":@"项目名称",@"content":[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"projectName"]]}];
               [self.dataSourceArray addObject:@{@"title":@"项目经理",@"content":[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"projectManager"]]}];
        }
        NSString *typeStr = @"请假";
        if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"shj"]) {
            typeStr = @"事假";
            [self handelCellModelData];
        }else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"bj"]) {
            typeStr = @"病假";
            [self handelCellModelData];
        }else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"hj"]) {
            typeStr = @"婚假";
//            [self handelCellModelData];
            [self.dataSourceArray addObject:@{@"title":@"开始时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginTime"] andFormatter:@"yyyy-MM-dd"]}];
            [self.dataSourceArray addObject:@{@"title":@"结束时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endTime"] andFormatter:@"yyyy-MM-dd"]}];
        }else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"cjj"]) {
            typeStr = @"产检假";
            [self handelCellModelData];
        }else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"phj"]) {
            typeStr = @"陪产假";
            [self handelCellModelData];
        }else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"gsj"]) {
            typeStr = @"工伤假";
            [self handelCellModelData];
        }else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"tj"]) {
            typeStr = @"调休";
            [self handelCellModelData];
        }
        else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"sj"]) {
            typeStr = @"丧假";
//            [self handelCellModelData];
            [self.dataSourceArray addObject:@{@"title":@"开始时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginTime"] andFormatter:@"yyyy-MM-dd"]}];
            [self.dataSourceArray addObject:@{@"title":@"结束时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endTime"] andFormatter:@"yyyy-MM-dd"]}];
            [self.dataSourceArray addObject:@{@"title":@"亲属类别",@"content":[self.flowFormModel.info objectForKey:@"relativeCategoryTrans"]}];
            [self.dataSourceArray addObject:@{@"title":@"工作所在地",@"content":[self.flowFormModel.info objectForKey:@"workPlace"]}];
            [self.dataSourceArray addObject:@{@"title":@"丧事所在地",@"content":[self.flowFormModel.info objectForKey:@"funeralPlace"]}];
        }else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"xsj"]) {
            typeStr = @"带薪小时假";
            [self.dataSourceArray addObject:@{@"title":@"开始时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginTime"] andFormatter:@"yyyy-MM-dd HH:mm"]}];
            [self.dataSourceArray addObject:@{@"title":@"结束时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endTime"] andFormatter:@"yyyy-MM-dd HH:mm"]}];

        }else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"brj"]) {
            typeStr = @"哺乳假";
            [self.dataSourceArray addObject:@{@"title":@"开始时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginTime"] andFormatter:@"yyyy-MM-dd"]}];
            [self.dataSourceArray addObject:@{@"title":@"结束时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endTime"] andFormatter:@"yyyy-MM-dd"]}];
            [self.dataSourceArray addObject:@{@"title":@"生育年度",@"content":[self.flowFormModel.info objectForKey:@"year"]}];

            [self.dataSourceArray addObject:@{@"title":@"胞胎数",@"content":[self.flowFormModel.info objectForKey:@"birthsNumTrans"]}];
            [self.dataSourceArray addObject:@{@"title":@"哺乳时间段",@"content":[self.flowFormModel.info objectForKey:@"burPeriodTrans"]}];
            
        }else if ([[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"cj"]) {
            typeStr = @"产假";
            [self.dataSourceArray addObject:@{@"title":@"开始时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginTime"] andFormatter:@"yyyy-MM-dd"]}];
            [self.dataSourceArray addObject:@{@"title":@"结束时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endTime"] andFormatter:@"yyyy-MM-dd"]}];
            [self.dataSourceArray addObject:@{@"title":@"生育年度",@"content":[self.flowFormModel.info objectForKey:@"year"]}];

            [self.dataSourceArray addObject:@{@"title":@"社保缴纳地",@"content":[self.flowFormModel.info objectForKey:@"socialPlace"]}];
            [self.dataSourceArray addObject:@{@"title":@"产假类别",@"content":[self.flowFormModel.info objectForKey:@"produceCategoryTrans"]}];
            
            if ([[self.flowFormModel.info objectForKey:@"produceCategory"] isEqualToString:@"sycj"]) {
                [self.dataSourceArray addObject:@{@"title":@"胞胎数",@"content":[self.flowFormModel.info objectForKey:@"birthsNumTrans"]}];
                [self.dataSourceArray addObject:@{@"title":@"生育方式",@"content":[self.flowFormModel.info objectForKey:@"bearTypeTrans"]}];

            }
        }
        
        [self.dataSourceArray insertObject:@{@"title":@"请假类型",@"content":typeStr} atIndex:4];
        if (![[self.flowFormModel.info objectForKey:@"childType"] isEqualToString:@"xsj"]) {
            //不是 带薪小时假 有申请天数
            [self.dataSourceArray insertObject:@{@"title":@"申请天数",@"content":[NSString stringWithFormat:@"%.1f",[[self.flowFormModel.info objectForKey:@"totalTime"] floatValue]]} atIndex:5];
        }
        
    }
    else if ([[self.flowFormModel.info objectForKey:@"type"] isEqualToString:@"xmtx"]) {
        //项目调休申请
        [self.dataSourceArray addObject:@{@"title":@"申请人员",@"content":[self.flowFormModel.info objectForKey:@"employName"]}];
        [self.dataSourceArray addObject:@{@"title":@"申请人工号",@"content":[self.flowFormModel.info objectForKey:@"employCode"]}];
        [self.dataSourceArray addObject:@{@"title":@"申请人职级",@"content":[self.flowFormModel.info objectForKey:@"positionName"]}];
        //项目信息
        [self.dataSourceArray addObject:@{@"title":@"项目名称",@"content":[self.flowFormModel.info objectForKey:@"projectName"]}];
        [self.dataSourceArray addObject:@{@"title":@"项目经理",@"content":[self.flowFormModel.info objectForKey:@"projectManager"]}];
        [self.dataSourceArray addObject:@{@"title":@"上级领导",@"content":[self.flowFormModel.info objectForKey:@"leaderName"]}];

        [self.dataSourceArray addObject:@{@"title":@"申请天数",@"content":[NSString stringWithFormat:@"%.1f",[[self.flowFormModel.info objectForKey:@"totalTime"] floatValue]]}];

        [self handelCellModelData];
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


@implementation YSComplainFlowViewModel

- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
//    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getFlowDataForMobile, self.flowModel.businessKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", YSDomain, getAppealFlowDataForMobile];
    NSDictionary *paramDic = @{@"flowCode":self.flowModel.businessKey};
    [YSNetManager ys_request_POSTWithUrlString:urlString isNeedCache:NO parameters:paramDic successBlock:^(id response) {
        DLog(@"异常申诉考勤流程详情:%@", response);
        if ([response[@"code"] intValue] == 1) {
            
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
            [self setUpData];//重组数据
            //关联文档
            for (NSDictionary *dic in self.flowFormModel.info[@"fileList"]) {
                YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
                [self.attachArray addObject:model];
            }
            if (self.attachArray.count > 0) {
                self.documentBtnTitle = [NSString stringWithFormat:@"关联文档(%lu)",(unsigned long)self.attachArray.count];
            }
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
    [self.dataSourceArray addObject:@{@"title":@"异常日期", @"holderStr":@"自动带出", @"content":[YSUtility cancelNullData:[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"appealDate"] andFormatter:@"yyyy-MM-dd"]]}];
    [self.dataSourceArray addObject:@{@"title":@"打卡时间",@"content":[NSString stringWithFormat:@"%@~%@", [YSUtility judgeIsEmpty:[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"checkStartTime"]]] ? @"未打卡" : [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"checkStartTime"]], [YSUtility judgeIsEmpty:[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"checkEndTime"]]] ? @"未打卡" : [YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"checkEndTime"]]]}];
    
    
    [self.dataSourceArray addObject:@{@"title":@"申诉时间",@"content":[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"startPeriodTrans"]]}];
    [self.dataSourceArray addObject:@{@"title":@"上级领导",@"content":[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"leaderName"]]}];
    [self.dataSourceArray addObject:@{@"title":@"项目部",@"content":[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"isProjectStr"]]}];
    
    if ([[self.flowFormModel.info objectForKey:@"isProject"]integerValue]==1) {
        //项目信息
           [self.dataSourceArray addObject:@{@"title":@"项目名称",@"content":[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"projectName"]]}];
           [self.dataSourceArray addObject:@{@"title":@"项目经理",@"content":[YSUtility cancelNullData:[self.flowFormModel.info objectForKey:@"projectManager"]]}];
    }
   
    //有8小时 时差
//    [self.dataSourceArray addObject:@{@"title":@"上班申诉时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"beginTime"] andFormatter:@"yyyy-MM-dd HH:mm"]}];
//    [self.dataSourceArray addObject:@{@"title":@"下班申诉时间",@"content":[YSUtility timestampSwitchTime:[self.flowFormModel.info objectForKey:@"endTime"] andFormatter:@"yyyy-MM-dd HH:mm"]}];
    [self.dataSourceArray addObject:@{@"title":@"异常原因",@"content":[self.flowFormModel.info objectForKey:@"excepReasonTrans"]}];
    [self.dataSourceArray addObject:@{@"title":@"事由说明",@"content":[self.flowFormModel.info objectForKey:@"remark"]}];
    
}


@end
