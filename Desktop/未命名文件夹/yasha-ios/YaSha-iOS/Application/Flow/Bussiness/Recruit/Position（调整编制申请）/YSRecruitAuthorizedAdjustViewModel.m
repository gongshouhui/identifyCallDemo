//
//  YSRecruitAuthorizedAdjustViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/10/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRecruitAuthorizedAdjustViewModel.h"
#import "YSFormLinkViewController.h"
#import "YSFlowInterviewTableViewController.h"
@implementation YSRecruitAuthorizedAdjustViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, getAdjustOriginalByIdApi, self.flowModel.businessKey, self.flowModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"mobileFiles"]) {
				YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
				[self.attachArray addObject:model];
			}
			if ([self.flowFormModel.info[@"adjustOriginalFiles"] count] > 0) {
				for (NSDictionary *dic in self.flowFormModel.info[@"adjustOriginalFiles"]) {
					YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
					[self.attachArray addObject:model];
				}
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
	[self.dataSourceArray addObject:@{@"title":@"编制信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"编制部门",@"content":dic[@"departmentName"]}];
	[self.dataSourceArray addObject:@{@"title":@"编制类型",@"content":dic[@"originalType"]}];
	/**调整编制类型：1、公司总编制增加2、公司总编制减少3、公司总编制不变（从其他部门调入）；*/
	if ([dic[@"adjustTypeName"] containsString:@"公司总编制不变"]) {
		[self.dataSourceArray addObject:@{@"title":@"调整编制类型",@"content":dic[@"adjustTypeName"]}];
		[self.dataSourceArray addObject:@{@"title":@"",@"content":[NSString stringWithFormat:@"从 %@ 调入",dic[@"transferDepartmentName"]],@"special":@(BussinessFlowCellText)}];
		
		[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"编制减少部门:%@",dic[@"transferDepartmentName"]],@"special":@(BussinessFlowCellHead)}];
		for (NSDictionary *dic1 in dic[@"decreaseAdjustOriginalPositions"]) {
			for (NSDictionary *dic2 in dic1[@"adjustOriginalPositionRanks"]) {
				[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"%@序列-%@",dic2[@"rankCode"],dic1[@"positionName"]]}];
				[self.dataSourceArray addObject:@{@"title":@"原有编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankNumOld"]]}];
				[self.dataSourceArray addObject:@{@"title":@"现有人数",@"content":[NSString stringWithFormat:@"%@人",dic1[@"nowNum"]]}];
				[self.dataSourceArray addObject:@{@"title":@"招聘中",@"content":[NSString stringWithFormat:@"%@人",dic1[@"recruitingNum"]]}];
				
				[self.dataSourceArray addObject:@{@"title":@"调整编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankSum"]]}];
				[self.dataSourceArray addObject:@{@"title":@"调整过后编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankNum"]]}];
			}
		}
		
		[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"编制增加部门:%@",dic[@"departmentName"]],@"special":@(BussinessFlowCellHead)}];
		for (NSDictionary *dic1 in dic[@"adjustOriginalPositions"]) {
			for (NSDictionary *dic2 in dic1[@"adjustOriginalPositionRanks"]) {
				[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"%@序列-%@",dic2[@"rankCode"],dic1[@"positionName"]]}];
				[self.dataSourceArray addObject:@{@"title":@"原有编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankNumOld"]]}];
				[self.dataSourceArray addObject:@{@"title":@"现有人数",@"content":[NSString stringWithFormat:@"%@人",dic1[@"nowNum"]]}];
				[self.dataSourceArray addObject:@{@"title":@"招聘中",@"content":[NSString stringWithFormat:@"%@人",dic1[@"recruitingNum"]]}];
				
				[self.dataSourceArray addObject:@{@"title":@"调整编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankSum"]]}];
				[self.dataSourceArray addObject:@{@"title":@"调整过后编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankNum"]]}];
			}
		}
	}
	
	if ([dic[@"adjustTypeName"] containsString:@"公司总编制增加"]) {
		[self.dataSourceArray addObject:@{@"title":@"调整编制类型",@"content":dic[@"adjustTypeName"]}];
		[self.dataSourceArray addObject:@{@"title":@"编制详情",@"special":@(BussinessFlowCellHead)}];
		for (NSDictionary *dic1 in dic[@"adjustOriginalPositions"]) {
			for (NSDictionary *dic2 in dic1[@"adjustOriginalPositionRanks"]) {
				[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"%@序列-%@",dic2[@"rankCode"],dic1[@"positionName"]]}];
				[self.dataSourceArray addObject:@{@"title":@"原有编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankNumOld"]]}];
				[self.dataSourceArray addObject:@{@"title":@"现有人数",@"content":[NSString stringWithFormat:@"%@人",dic1[@"nowNum"]]}];
				[self.dataSourceArray addObject:@{@"title":@"招聘中",@"content":[NSString stringWithFormat:@"%@人",dic1[@"recruitingNum"]]}];
				
				[self.dataSourceArray addObject:@{@"title":@"调整编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankSum"]]}];
				[self.dataSourceArray addObject:@{@"title":@"调整过后编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankNum"]]}];
			}
		}
		
	}
	
	if ([dic[@"adjustTypeName"] containsString:@"公司总编制减少"]) {
		[self.dataSourceArray addObject:@{@"title":@"调整编制类型",@"content":dic[@"adjustTypeName"]}];
		[self.dataSourceArray addObject:@{@"title":@"编制详情",@"special":@(BussinessFlowCellHead)}];
		for (NSDictionary *dic1 in dic[@"adjustOriginalPositions"]) {
			for (NSDictionary *dic2 in dic1[@"adjustOriginalPositionRanks"]) {
				[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"%@序列-%@",dic2[@"rankCode"],dic1[@"positionName"]]}];
				[self.dataSourceArray addObject:@{@"title":@"原有编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankNumOld"]]}];
				[self.dataSourceArray addObject:@{@"title":@"现有人数",@"content":[NSString stringWithFormat:@"%@人",dic1[@"nowNum"]]}];
				[self.dataSourceArray addObject:@{@"title":@"招聘中",@"content":[NSString stringWithFormat:@"%@人",dic1[@"recruitingNum"]]}];
				
				[self.dataSourceArray addObject:@{@"title":@"调整编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankSum"]]}];
				[self.dataSourceArray addObject:@{@"title":@"调整过后编制",@"content":[NSString stringWithFormat:@"%@人",dic2[@"rankNum"]]}];
			}
		}
	}
	
	[self.dataSourceArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"备注",@"content":dic[@"remarks"]}];
	[self.dataSourceArray addObject:@{@"title":@"提交者附言",@"content":dic[@"postscript"]}];
}
@end
