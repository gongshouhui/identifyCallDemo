//
//  YSFlowEmployeeLeaveViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/7.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowEmployeeLeaveViewModel.h"

@implementation YSFlowEmployeeLeaveViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, @"flowCenter/personnelAllot/queryDimissionInfo", self.flowModel.businessKey, self.flowModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info[@"recruitLeave"]];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"recruitFiles"]) {
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
- (void)setUpData:(NSDictionary *)detailDic {
	[self.dataSourceArray removeAllObjects];
	
    [self.dataSourceArray addObject:@{@"title":@"申请信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"申请人",@"content":detailDic[@"applicant"]}];
	[self.dataSourceArray addObject:@{@"title":@"申请人工号",@"content":detailDic[@"applicantEmployeeCode"]}];
	[self.dataSourceArray addObject:@{@"title":@"申请人职级",@"content":detailDic[@"pkJobRank"]}];
	[self.dataSourceArray addObject:@{@"title":@"入职时间",@"content":[YSUtility timestampSwitchTime:detailDic[@"initiationTime"] andFormatter:@"yyyy-MM-dd"]}];
	[self.dataSourceArray addObject:@{@"title":@"全日制学历",@"content":detailDic[@"qualifications"]}];
	[self.dataSourceArray addObject:@{@"title":@"毕业院校",@"content":detailDic[@"school"]}];
	[self.dataSourceArray addObject:@{@"title":@"毕业专业",@"content":detailDic[@"major"]}];
	[self.dataSourceArray addObject:@{@"title":@"毕业时间",@"content":[YSUtility timestampSwitchTime:detailDic[@"graduationTime"] andFormatter:@"yyyy-MM-dd"]}];
	[self.dataSourceArray addObject:@{@"title":@"备注",@"content":detailDic[@"remarks"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"离职申请信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"调入单位>部门",@"content":[NSString stringWithFormat:@"%@>%@",detailDic[@"companyName"],detailDic[@"fatherDepartmentName"]]}];
	[self.dataSourceArray addObject:@{@"title":@"离职时间",@"content":[YSUtility timestampSwitchTime:detailDic[@"leaveDate"] andFormatter:@"yyyy-MM-dd"]}];
	[self.dataSourceArray addObject:@{@"title":@"是否为装饰仓管员或幕墙材料员",@"content": [detailDic[@"isWarehouseKeeper"] boolValue]?@"是":@"否"}];
	
	
   [self.dataSourceArray addObject:@{@"title":@"是否为项目部人员",@"content":[detailDic[@"isProjectDept"] intValue] > 0?@"是":@"否"}];
	if (detailDic[@"isProjectDept"]) {
		[self.dataSourceArray addObject:@{@"title":@"项目名称",@"content":detailDic[@"projectName"]}];
		[self.dataSourceArray addObject:@{@"title":@"项目经理",@"content":detailDic[@"projectManager"]}];
	}
	[self.dataSourceArray addObject:@{@"title":@"上级领导人",@"content":detailDic[@"projectLeader"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"最近一次年度绩效等级",@"content":detailDic[@"performanceLevel"]}];

	[self.dataSourceArray addObject:@{@"title":@"离职原因",@"content":detailDic[@"leaveReason"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"工作资料交接安排",@"content":detailDic[@"dataHandoverArrange"]}];
	[self.dataSourceArray addObject:@{@"title":@"工作职责/内容",@"content":detailDic[@"jobDuty"]}];
}
- (BOOL)isEditing {
	NSString *userid = [YSUtility getUID];
	NSString *hrbpNum = self.flowFormModel.info[@"hrbp"];
	NSString *zpbpNum = self.flowFormModel.info[@"zpbp"];
	
	if ([hrbpNum containsString:userid] || [zpbpNum containsString:userid]) {
		return YES;
	}else{
		return NO;
	}
}


- (void)editWithConsensus:(NSString *)consensus Comeplete:(fetchDataCompleteBlock)comepleteBlock failue:(fetchDataFailueBlock)failueBlock{
//	{"initiator":{"bizId":"LZSS20200219008"},"recruitLeave":{"isConsensus":"1","state":"3"}}
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setValue:@{@"bizId":self.flowModel.businessKey} forKey:@"initiator"];
	[dic setValue:@{@"isConsensus":consensus,@"state":@"3"} forKey:@"recruitLeave"];
	[YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,@"flowCenter/personnelAllot/saveLZsp"] isNeedCache:NO parameters:dic successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			if (comepleteBlock) {
				comepleteBlock();
			}
		}
	} failureBlock:^(NSError *error) {
		
	} progress:nil];
}

@end
