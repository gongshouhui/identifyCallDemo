//
//  YSFlowBeOfficialViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/6.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowBeOfficialViewModel.h"
#import "YSOpinionEditController.h"
@implementation YSFlowBeOfficialViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, queryPersonnelPositive, self.flowModel.businessKey, self.flowModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info[@"recruitFormals"]];//重组数据
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
	[self.dataSourceArray addObject:@{@"title":@"申请信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"申请人",@"content":dic[@"applicant"]}];
	[self.dataSourceArray addObject:@{@"title":@"所属部门",@"content":dic[@"fatherDepartmentName"]}];
	[self.dataSourceArray addObject:@{@"title":@"职务级别",@"content":dic[@"pkJobRank"]}];
	[self.dataSourceArray addObject:@{@"title":@"试用期长",@"content":dic[@"expectedDate"]}];
	[self.dataSourceArray addObject:@{@"title":@"部门负责人",@"content":dic[@"evaluator"]}];
	[self.dataSourceArray addObject:@{@"title":@"是否是项目部人员",@"content":[dic[@"isProjectPersonnel"] intValue] > 0 ? @"是" : @"否"}];
	if (dic[@"isProjectPersonnel"]) {
		[self.dataSourceArray addObject:@{@"title":@"项目名称",@"content":dic[@"projectName"]}];
		[self.dataSourceArray addObject:@{@"title":@"项目经理",@"content":dic[@"projectManager"]}];
	}
	[self.dataSourceArray addObject:@{@"title":@"是否为区域或经营人员",@"content":[dic[@"isMember"] intValue] > 0 ? @"是" : @"否"}];
	[self.dataSourceArray addObject:@{@"title":@"是否为仓管员",@"content":[dic[@"isWarehouseKeeper"] intValue] > 0 ? @"是" : @"否"}];
	[self.dataSourceArray addObject:@{@"title":@"上级领导人",@"content":dic[@"projectLeader"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"工作内容",@"special":@(BussinessFlowCellTurn),@"file":dic[@"jobDescription"]}];
	[self.dataSourceArray addObject:@{@"title":@"试用期小结（工作成果）",@"special":@(BussinessFlowCellTurn),@"file":dic[@"summary"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"发展规划",@"special":@(BussinessFlowCellTurn),@"file":dic[@"developmentPlan"]}];
	[self.dataSourceArray addObject:@{@"title":@"对公司意见或建议",@"special":@(BussinessFlowCellTurn),@"file":dic[@"opinion"]}];
	[self.dataSourceArray addObject:@{@"title":@"备注",@"content":dic[@"remarks"]}];

	
	
	//审批意见
	[self.dataSourceArray addObject:@{@"title":@"评估人意见",@"special":@(BussinessFlowCellHead)}];
	//状态标识(1草稿，2提交, 3审批结束)
	//
	if ([dic[@"state"] intValue] == 2 && [dic[@"projectLeaderNo"] isEqualToString:[YSUtility getUID]] && self.flowType == YSFlowTypeTodo) {//编辑，评估人填写意见
		[self.dataSourceArray addObject:@{@"title":@"评估人意见",@"special":@(BussinessFlowCellEdit)}];
	}else{
		NSString *regularType = nil;
		if ([dic[@"regularType"] integerValue] == 1) {
			regularType = @"正常转正";
		}else if ([dic[@"regularType"] integerValue] == 4){
			regularType = @"不予转正";
		}else if([dic[@"regularType"] integerValue] == 2){
			regularType = @"提前转正";
		}else if([dic[@"regularType"] integerValue] == 0){
			regularType = @"延迟转正";
		}
		[self.dataSourceArray addObject:@{@"title":@"转正方式",@"content":regularType}];
		if ([dic[@"regularType"] integerValue] == 0) {
			[self.dataSourceArray addObject:@{@"title":@"延缓期限",@"content":dic[@"deferralPeriod"]}];
		}

		[self.dataSourceArray addObject:@{@"title":@"拟转正时间",@"content":[YSUtility timestampSwitchTime:dic[@"quasiExpectedDate"] andFormatter:@"yyyy-MM-dd"]}];
		[self.dataSourceArray addObject:@{@"title":@"工作能力（30分）",@"content":dic[@"gradeAbility"]}];
		if ([dic[@"workAbility"] length]) {
			[self.dataSourceArray addObject:@{@"title":@"工作能力",@"special":@(BussinessFlowCellText),@"content":dic[@"workAbility"]}];
		}

		[self.dataSourceArray addObject:@{@"title":@"",@"bgColor":kGrayColor(245), @"special":@(BussinessFlowCellEmpty)}];
		[self.dataSourceArray addObject:@{@"title":@"工作绩效(30分)",@"content":dic[@"gradePerformance"]}];
		if ([dic[@"workPerformance"] length]) {
			[self.dataSourceArray addObject:@{@"title":@"工作绩效",@"special":@(BussinessFlowCellText),@"content":dic[@"workPerformance"]}];
		}

		[self.dataSourceArray addObject:@{@"title":@"",@"bgColor":kGrayColor(245), @"special":@(BussinessFlowCellEmpty)}];
		[self.dataSourceArray addObject:@{@"title":@"工作态度(20分)",@"content":dic[@"gradeAttitude"]}];
		if ([dic[@"workAttitude"] length]) {
			[self.dataSourceArray addObject:@{@"title":@"工作态度",@"special":@(BussinessFlowCellText),@"content":dic[@"workAttitude"]}];
		}

		[self.dataSourceArray addObject:@{@"title":@"",@"bgColor":kGrayColor(245), @"special":@(BussinessFlowCellEmpty)}];
		[self.dataSourceArray addObject:@{@"title":@"工作总结(20分)",@"content":dic[@"gradeSummary"]}];
		if ([dic[@"workSummary"] length]) {
			[self.dataSourceArray addObject:@{@"title":@"工作总结",@"special":@(BussinessFlowCellText),@"content":dic[@"workSummary"]}];

		}

		[self.dataSourceArray addObject:@{@"title":@"评估总分合计",@"content":dic[@"gradeTotal"]}];
		[self.dataSourceArray addObject:@{@"title":@"",@"special":@(BussinessFlowCellText),@"content":@"上述评估得分在70分以下，视为员工不能够胜任该岗位。若员工对评分及结果有异议，请员工在流程结束后三个工作日内向人力资源部进行反馈， 逾期不反馈，将视为认可此次评分及结果。"}];
	}
}



- (void)editComeplete:(fetchDataCompleteBlock)comepleteBlock failue:(fetchDataFailueBlock)failueBlock{
	NSDictionary *dic = self.flowFormModel.info[@"recruitFormals"];
	if ([dic[@"projectLeaderNo"] isEqualToString:[YSUtility getUID]]) {
		
		if ([dic[@"workAbility"] length]) {
			comepleteBlock();
		}else{
			failueBlock(@"编辑后才可以提交");
		}
	}else{
		comepleteBlock();
	}
}
@end
