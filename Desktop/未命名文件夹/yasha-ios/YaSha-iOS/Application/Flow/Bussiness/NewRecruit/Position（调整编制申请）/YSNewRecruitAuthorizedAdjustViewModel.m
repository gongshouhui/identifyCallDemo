//
//  YSRecruitAuthorizedAdjustViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/10/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSNewRecruitAuthorizedAdjustViewModel.h"
#import "YSNewFormLinkViewController.h"
#import "YSFlowNewInterviewTableViewController.h"
@implementation YSNewRecruitAuthorizedAdjustViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, getNewAdjustOriginalByIdApi, self.flowModel.businessKey, self.flowModel.processInstanceId];
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
			
			if ([self.flowFormModel.info[@"files"] count] > 0) {
				for (NSDictionary *dic in self.flowFormModel.info[@"files"]) {
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
	[self.dataSourceArray addObject:@{@"title":@"调整信息",@"special":@(BussinessFlowCellHead)}];
	//	[self.dataSourceArray addObject:@{@"title":@"编制部门",@"content":dic[@"departmentName"]}];
	[self.dataSourceArray addObject:@{@"title":@"编制类型",@"content":dic[@"originalTypeStr"]}];
	[self.dataSourceArray addObject:@{@"title":@"调整类型",@"content":dic[@"adjustTypeStr"]}];
	
	//编制详情
	[self.dataSourceArray addObject:@{@"title":@"编制详情",@"special":@(BussinessFlowCellHead)}];
	/**调整编制类型：1、公司总编制增加2、公司总编制减少3、公司总编制不变（从其他部门调入）；*/
	if ([dic[@"adjustTypeStr"] containsString:@"公司总编制不变"]) {
		
		[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"增加编制部门:%@",dic[@"addDeptName"]],@"special":@(BussinessFlowCellHead)}];
		for (NSDictionary *detailDic in dic[@"addBudgetAdjustPosts"]) {
			[self.dataSourceArray addObject:@{@"title":@"调整岗位",@"content":[NSString stringWithFormat:@"%@",detailDic[@"postName"]]}];
			[self.dataSourceArray addObject:@{@"title":@"原有编制",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetOld"]]}];
			[self.dataSourceArray addObject:@{@"title":@"占编人数",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetActual"]]}];
			[self.dataSourceArray addObject:@{@"title":@"招聘中",@"content":[NSString stringWithFormat:@"%@",detailDic[@"recruitingNum"]]}];
			[self.dataSourceArray addObject:@{@"title":@"增加人数",@"content":[NSString stringWithFormat:@"%@",detailDic[@"adjustNum"]]}];
			[self.dataSourceArray addObject:@{@"title":@"调整过后编制",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetNew"]]}];
		}
		
		
		[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"减少编制部门:%@",dic[@"reduceDeptName"]],@"special":@(BussinessFlowCellHead)}];
		for (NSDictionary *detailDic in dic[@"reduceBudgetAdjustPosts"]) {
			
			[self.dataSourceArray addObject:@{@"title":@"调整岗位",@"content":[NSString stringWithFormat:@"%@",detailDic[@"postName"]]}];
			[self.dataSourceArray addObject:@{@"title":@"原有编制",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetOld"]]}];
			[self.dataSourceArray addObject:@{@"title":@"占编人数",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetActual"]]}];
			[self.dataSourceArray addObject:@{@"title":@"招聘中",@"content":[NSString stringWithFormat:@"%@",detailDic[@"recruitingNum"]]}];
			[self.dataSourceArray addObject:@{@"title":@"减少人数",@"content":[NSString stringWithFormat:@"%@",detailDic[@"adjustNum"]]}];
			[self.dataSourceArray addObject:@{@"title":@"调整过后编制",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetNew"]]}];
			
		}
	}
	
	if ([dic[@"adjustTypeStr"] containsString:@"公司总编制增加"]) {
		
		[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"增加编制部门:%@",dic[@"addDeptName"]],@"special":@(BussinessFlowCellHead)}];
		for (NSDictionary *detailDic in dic[@"addBudgetAdjustPosts"]) {
			[self.dataSourceArray addObject:@{@"title":@"调整岗位",@"content":[NSString stringWithFormat:@"%@",detailDic[@"postName"]]}];
			[self.dataSourceArray addObject:@{@"title":@"原有编制",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetOld"]]}];
			[self.dataSourceArray addObject:@{@"title":@"占编人数",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetActual"]]}];
			[self.dataSourceArray addObject:@{@"title":@"招聘中",@"content":[NSString stringWithFormat:@"%@",detailDic[@"recruitingNum"]]}];
			[self.dataSourceArray addObject:@{@"title":@"增加人数",@"content":[NSString stringWithFormat:@"%@",detailDic[@"adjustNum"]]}];
			[self.dataSourceArray addObject:@{@"title":@"调整过后编制",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetNew"]]}];
		}
		
	}
	
	if ([dic[@"adjustTypeStr"] containsString:@"公司总编制减少"]) {
		[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"减少编制部门:%@",dic[@"reduceDeptName"]],@"special":@(BussinessFlowCellHead)}];
		for (NSDictionary *detailDic in dic[@"reduceBudgetAdjustPosts"]) {
			
			[self.dataSourceArray addObject:@{@"title":@"调整岗位",@"content":[NSString stringWithFormat:@"%@",detailDic[@"postName"]]}];
			[self.dataSourceArray addObject:@{@"title":@"原有编制",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetOld"]]}];
			[self.dataSourceArray addObject:@{@"title":@"占编人数",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetActual"]]}];
			[self.dataSourceArray addObject:@{@"title":@"招聘中",@"content":[NSString stringWithFormat:@"%@",detailDic[@"recruitingNum"]]}];
			[self.dataSourceArray addObject:@{@"title":@"减少人数",@"content":[NSString stringWithFormat:@"%@",detailDic[@"adjustNum"]]}];
			[self.dataSourceArray addObject:@{@"title":@"调整过后编制",@"content":[NSString stringWithFormat:@"%@",detailDic[@"budgetNew"]]}];
			
		}
	}
	
	[self.dataSourceArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"备注",@"content":dic[@"remarks"]}];
}
@end
