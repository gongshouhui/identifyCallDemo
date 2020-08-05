//
//  YSFlowEmployeeExchangeViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/7.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowEmployeeExchangeViewModel.h"

@implementation YSFlowEmployeeExchangeViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, @"/flowCenter/personnelAllot/queryPersonnelAllot", self.flowModel.businessKey, self.flowModel.processInstanceId];
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
	[self.dataSourceArray removeAllObjects];
		NSDictionary *detailDic = dic[@"recruitTransfer"];
		
		[self.dataSourceArray addObject:@{@"title":@"申请信息",@"special":@(BussinessFlowCellHead)}];
		[self.dataSourceArray addObject:@{@"title":@"申请人",@"content":detailDic[@"applicant"]}];
		[self.dataSourceArray addObject:@{@"title":@"申请人工号",@"content":detailDic[@"applicantEmployeeCode"]}];
		[self.dataSourceArray addObject:@{@"title":@"申请人职级",@"content":detailDic[@"pkJobRank"]}];
		
		[self.dataSourceArray addObject:@{@"title":@"调出单位>部门",@"content":[NSString stringWithFormat:@"%@>%@",dic[@"companyStr"],dic	[@"deptStr"]]}];
		[self.dataSourceArray addObject:@{@"title":@"调出岗位",@"content":detailDic[@"postName"]}];
		[self.dataSourceArray addObject:@{@"title":@"是否为项目部人员",@"content":[detailDic[@"isProjectDept"] intValue] > 0?@"是":@"否"}];
		
		if ([detailDic[@"isProjectDept"] intValue]) {//是项目人员
			[self.dataSourceArray addObject:@{@"title":@"上级领导",@"content": detailDic[@"projectLeader"]}];
		}
		
		[self.dataSourceArray addObject:@{@"title":@"全日制学历",@"content":detailDic[@"qualifications"]}];
		[self.dataSourceArray addObject:@{@"title":@"毕业院校",@"content":detailDic[@"school"]}];
		[self.dataSourceArray addObject:@{@"title":@"毕业专业",@"content":detailDic[@"major"]}];
		
		[self.dataSourceArray addObject:@{@"title":@"毕业时间",@"content":[YSUtility timestampSwitchTime:detailDic[@"graduationTime"] andFormatter:@"yyyy-MM-dd"]}];
		
		[self.dataSourceArray addObject:@{@"title":@"是否为区域或经营团队人员（调出）",@"content": [detailDic[@"isBusinessStaffBefore"] boolValue]?@"是":@"否"}];
		[self.dataSourceArray addObject:@{@"title":@"申请事由",@"content":detailDic[@"applicationReason"]}];
		
		[self.dataSourceArray addObject:@{@"title":@"工作资料交接安排",@"content":detailDic[@"jobHandover"]}];
		
		
		[self.dataSourceArray addObject:@{@"title":@"调入信息",@"special":@(BussinessFlowCellHead)}];
		[self.dataSourceArray addObject:@{@"title":@"调入单位>部门",@"content":[NSString stringWithFormat:@"%@>%@",detailDic[@"transferUnit"],detailDic[@"transferDept"]]}];
		[self.dataSourceArray addObject:@{@"title":@"拟调岗位",@"content":detailDic[@"proposedAdjust"]}];
		[self.dataSourceArray addObject:@{@"title":@"调岗到岗日期",@"content":[YSUtility timestampSwitchTime:detailDic[@"trueArrivalDate"] andFormatter:@"yyyy-MM-dd"]}];
		[self.dataSourceArray addObject:@{@"title":@"是否为区域或经营团队人员(调入)",@"content":[detailDic[@"isBusinessStaff"] boolValue]?@"是":@"否"}];
	//	[self.dataSourceArray addObject:@{@"title":@"调出岗位",@"content":detailDic[@"postName"]}];
		[self.dataSourceArray addObject:@{@"title":@"是否为项目部人员",@"content":[detailDic[@"isProjectDeptTransfer"] intValue] > 0?@"是":@"否"}];
		if ([detailDic[@"isProjectDept"] intValue]) {//是项目人员
			[self.dataSourceArray addObject:@{@"title":@"上级领导",@"content": detailDic[@"projectLeaderTransfer"]}];
		}
		
		[self.dataSourceArray addObject:@{@"title":@"调入部门负责人",@"content":detailDic[@"transferDeptHead"]}];
		[self.dataSourceArray addObject:@{@"title":@"调入部门区域负责人",@"content":detailDic[@"transferDeptAreaHead"]}];
		
		[self.dataSourceArray addObject:@{@"title":@"调入部门中心总经理",@"content":detailDic[@"transferDeptGeneralManager"]}];
		
		[self.dataSourceArray addObject:@{@"title":@"调入部门中心副总",@"content":detailDic[@"transferDeptDeputyManager"]}];
		[self.dataSourceArray addObject:@{@"title":@"福利待遇",@"content":detailDic[@"welfareTreatment"]}];
		
		[self.dataSourceArray addObject:@{@"title":@"其他说明",@"content":detailDic[@"remarks"]}];

}
@end
