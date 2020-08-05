//
//  YSMQMaterialViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQMaterialViewModel.h"
#import "YSBussinessMaterialModel.h"
@implementation YSMQMaterialViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getMaterialDemandFlowDetail, self.flowModel.businessKey];
    [YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
           
            [self setUpData:self.flowFormModel.info];//重组数据
            //附件
            for (NSDictionary *dic in self.flowFormModel.info[@"mobileFiles"]) {
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
- (void)setUpData:(NSDictionary *)dic {
    self.expensePersonArr = [NSMutableArray array];
    YSBussinessMaterialModel *materModel = [YSBussinessMaterialModel yy_modelWithJSON:dic];
    [self.expensePersonArr addObject:@{@"title":@"基本信息",@"special":@(BussinessFlowCellHead)}];
    [self.expensePersonArr addObject:@{@"title":@"项目名称",@"content":materModel.proName}];
    [self.expensePersonArr addObject:@{@"title":@"项目编码" ,@"content":materModel.proCode}];
    [self.expensePersonArr addObject:@{@"title":@"材料需求编号" ,@"content":materModel.code}];
    [self.expensePersonArr addObject:@{@"title":@"项目经理" ,@"content":materModel.managerName}];
    [self.expensePersonArr addObject:@{@"title":@"材料类型" ,@"content":materModel.mtrlTypeStr}];
    [self.expensePersonArr addObject:@{@"title":@"三级类别" ,@"content":materModel.threeTypeName}];
    [self.expensePersonArr addObject:@{@"title":@"是否甲供材" ,@"content":materModel.isSupply ? @"是":@"否"}];
    [self.expensePersonArr addObject:@{@"title":@"需求类别" ,@"content":materModel.requireTypeStr}];
    if (![materModel.requireTypeStr isEqualToString:@"正常下单"]) {
        [self.expensePersonArr addObject:@{@"title":@"补料原因" ,@"content":materModel.feedReason}];
    }
    
    [self.expensePersonArr addObject:@{@"title":@"收货人" ,@"content":materModel.receiverName }];
    [self.expensePersonArr addObject:@{@"title":@"收货人联系电话" ,@"content":materModel.receiverMobile}];
    [self.expensePersonArr addObject:@{@"title":@"收货地址",@"content":[NSString stringWithFormat:@"%@%@%@%@",materModel.province,materModel.city,materModel.area,materModel.address]}];
    
    [self.expensePersonArr addObject:@{@"title":@"备注" ,@"content":materModel.remark}];
    self.dataSourceArray = self.expensePersonArr;
    
}
@end
