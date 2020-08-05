//
//  YSFlowPresentBackViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/3/6.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowBussinessPresentBackViewModel.h"

@implementation YSFlowBussinessPresentBackViewModel

- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, @"/flowCenter/assets/getPresentReturnApplyInfo", self.flowModel.businessKey];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"apply"][@"fileListFormMobile"]) {
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
	[self.dataSourceArray removeAllObjects];
	NSDictionary *detailDic = dic[@"apply"];
	
	[self.dataSourceArray addObject:@{@"title":@"申请信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"申请单号",@"content":detailDic[@"applyNo"]}];
	[self.dataSourceArray addObject:@{@"title":@"申请日期",@"content":detailDic[@"applyDateStr"]}];
	[self.dataSourceArray addObject:@{@"title":@"申请类型",@"content":detailDic[@"applyTypeStr"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"申请人",@"content":detailDic[@"creator"]}];
	[self.dataSourceArray addObject:@{@"title":@"实际使用人",@"content":detailDic[@"useManName"]}];
	[self.dataSourceArray addObject:@{@"title":@"员工级别",@"content":detailDic[@"useManLevel"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"实际使用部门",@"content":detailDic[@"useDept"]}];
	[self.dataSourceArray addObject:@{@"title":@"实际使用公司",@"content":detailDic[@"useCompany"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"费用归属项目",@"content":[detailDic[@"ifOwnProject"] boolValue]?@"是":@"否"}];
	if ([detailDic[@"ifOwnProject"] boolValue]) {//费用归属项目
		[self.dataSourceArray addObject:@{@"title":@"所属项目",@"content":detailDic[@"ownProject"]}];
		
		[self.dataSourceArray addObject:@{@"title":@"项目经理",@"content":detailDic[@"managerName"]}];
		[self.dataSourceArray addObject:@{@"title":@"项目类型",@"content":detailDic[@"proNature"]}];
		
	}
	
	[self.dataSourceArray addObject:@{@"title":@"是否营销条线",@"content":[detailDic[@"ifSalesMan"] boolValue]?@"是":@"否"}];
	if ([detailDic[@"ifSalesMan"] boolValue]) {
		[self.dataSourceArray addObject:@{@"title":@"是否区域营销公司",@"content":[detailDic[@"ifAreaCompany"] boolValue]?@"是":@"否"}];
	}
	
	[self.dataSourceArray addObject:@{@"title":@"申请原因",@"content":detailDic[@"reason"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"退回原因",@"content":detailDic[@"returnReason"]}];
	
   [self.dataSourceArray addObject:@{@"title":@"退回明细",@"special":@(BussinessFlowCellHead)}];
	float total = 0;
	for (NSDictionary *goodDic in detailDic[@"applyInfos"]) {
		total += [goodDic[@"totalPrice"] floatValue];
		
	}
	[self.dataSourceArray addObject:@{@"title":@"总金额（元）",@"content":[NSString stringWithFormat:@"%.2f",total]}];
	
	for (NSDictionary *goodDic in detailDic[@"applyInfos"]) {
		[self.dataSourceArray addObject:@{@"title":@"金额合计（元）",@"content":[NSString stringWithFormat:@"%.2f",[goodDic[@"totalPrice"] floatValue]]}];
		
		[self.dataSourceArray addObject:@{@"title":@"物品名称",@"content":goodDic[@"goodsName"]}];
		[self.dataSourceArray addObject:@{@"title":@"数量",@"content":[NSString stringWithFormat:@"%d",[goodDic[@"applyNumber"] intValue]]}];
		[self.dataSourceArray addObject:@{@"title":@"参考价（元）",@"content":[NSString stringWithFormat:@"%.2f",[goodDic[@"refPrice"] floatValue]]}];
		if (!(goodDic == [detailDic[@"applyInfos"] lastObject])) {
			[self.dataSourceArray addObject:@{@"title":@"",@"bgColor":kGrayColor(245), @"special":@(BussinessFlowCellEmpty)}];
		}
		
		
		
	}
	
	
}
@end
