//
//  YSYSPMSMQEarilyPrePlanPresent.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/18.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQEarilyPrePlanPresent.h"
#import "YSPMSPlanInfoModel.h"
#import "YSPMSMQEarilyPrePlanController.h"
@interface YSPMSMQEarilyPrePlanPresent()

@end
@implementation YSPMSMQEarilyPrePlanPresent
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@{@"name":@"3日内需执行任务",@"type":@(MQExecuteTaskWithinThreeDay)},
                     @{@"name":@"未开工任务",@"type":@(MQNotStartTask)},
                     @{@"name":@"进行中任务",@"type":@(MQIsDoingTask)},
                     @{@"name":@"已完工任务",@"type":@(MQCompletedTask)},
                     ];
    }
    return _dataArr;
}
- (NSMutableArray *)startDelayArray {
    if (!_startDelayArray) {
        _startDelayArray = [NSMutableArray array];
    }
    return _startDelayArray;
}
- (NSMutableArray *)endDelayArray {
    if (!_endDelayArray) {
        _endDelayArray = [NSMutableArray array];
    }
    return _endDelayArray;
}
- (void)getListDataWithProjectCode:(NSString *)code Complete:(void (^)(id result,NSString *msg))completeBlock failure:(void (^)(NSError *error))failureBlock {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@/%@",getEarlyPrepareInfo,code] isNeedCache:NO parameters:nil successBlock:^(id response) {
            completeBlock(response,response[@"msg"]);
        YSPMSPlanInfoModel *model = [YSPMSPlanInfoModel yy_modelWithJSON:response[@"data"]];
        [self dealWithData:model];
        //通过代理来g更新view
        [self.view earilyPrePlanPresent:self didGetData:response];
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    } progress:nil];
}
- (void)dealWithData:(YSPMSPlanInfoModel *)model {
    //开工延期(饼图用)
    //以后用字典，或者重组模型
    [self.startDelayArray removeAllObjects];
    [self.startDelayArray addObject:[NSString stringWithFormat:@"%d",model.commencementOfDelayNormal]];//开工延期正常
    [self.startDelayArray addObject:[NSString stringWithFormat:@"%d",model.commencementOfDelayToFifteen]];//开工延期0~15
    [self.startDelayArray addObject:[NSString stringWithFormat:@"%d",model.commencementOfDelayToThirty]];//开工延期15~30
    [self.startDelayArray addObject:[NSString stringWithFormat:@"%d",model.commencementOfDelayMoreThirty]];//开工延期30~
    //完工延期（饼图用）
    [self.endDelayArray removeAllObjects];
    [self.endDelayArray addObject:[NSString stringWithFormat:@"%d",model.completionDelayNormal]];
    [self.endDelayArray addObject:[NSString stringWithFormat:@"%d",model.completionDelayToFifteen]];
    [self.endDelayArray addObject:[NSString stringWithFormat:@"%d",model.completionDelayToThirty]];
    [self.endDelayArray addObject:[NSString stringWithFormat:@"%d",model.completionDelayMoreThirty]];
}
@end
