//
//  YSFlowReduceTaskViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/12/13.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowReduceTaskViewModel.h"

@implementation YSFlowReduceTaskViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, getRecruitTaskChangeByIdApi, self.flowModel.businessKey, self.flowModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"mobileFiles"]) {
				YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
				[self.attachArray addObject:model];
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
	[self.dataSourceArray addObject:@{@"title":@"任务信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"编制部门",@"content":dic[@"deptName"]}];
	[self.dataSourceArray addObject:@{@"title":@"任务类型",@"content":dic[@"recruitTypeStr"]}];
	[self.dataSourceArray addObject:@{@"title":@"编制类型",@"content":dic[@"originalTypeStr"]}];
	[self.dataSourceArray addObject:@{@"title":@"任务编号",@"content":dic[@"taskNo"]}];
	[self.dataSourceArray addObject:@{@"title":@"岗位名称",@"content":dic[@"postName"]}];
	[self.dataSourceArray addObject:@{@"title":@"申请人",@"content":dic[@"submitterName"]}];
	[self.dataSourceArray addObject:@{@"title":@"计划招聘人数",@"content":[NSString stringWithFormat:@"%@",dic[@"needRecruitNum"]]}];
	
	[self.dataSourceArray addObject:@{@"title":@"调整信息",@"special":@(BussinessFlowCellHead)}];
	
	[self.dataSourceArray addObject:@{@"title":@"减少人数",@"content":[NSString stringWithFormat:@"%d",[dic[@"needRecruitNum"] intValue] - [dic[@"adjustedRecruitNums"] intValue]]}];
									  
	[self.dataSourceArray addObject:@{@"title":@"调整后招聘人数",@"content":[NSString stringWithFormat:@"%@",dic[@"adjustedRecruitNums"]]}];
	
	[self.dataSourceArray addObject:@{@"title":@"调整原因",@"special":@(BussinessFlowCellHead)}];
	
	[self.dataSourceArray addObject:@{@"content":dic[@"adjustReason"],@"special":@(BussinessFlowCellText)}];
}
@end
