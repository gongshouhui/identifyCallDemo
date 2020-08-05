//
//  YSFlowOfferApplyViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/10/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowOfferApplyViewModel.h"
#import "YSFormLinkViewController.h"
#import "YSFlowInterviewTableViewController.h"
@implementation YSFlowOfferApplyViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, getOfferApplyApi, self.flowModel.businessKey, self.flowModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"mobileFiles"]) {
				YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
				[self.attachArray addObject:model];
			}
			if ([self.flowFormModel.info[@"fileInfos"][@"file1"] count] > 0) {
				for (NSDictionary *dic in self.flowFormModel.info[@"fileInfos"][@"file1"]) {
					YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
					[self.attachArray addObject:model];
				}
			}
			if ([self.flowFormModel.info[@"remarks"][@"file2"] count] > 0) {
				for (NSDictionary *dic in self.flowFormModel.info[@"remarks"][@"file2"]) {
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
	//老板数据
	//self.interviewDic = dic[@"interViewInfo"];
	[self.dataSourceArray addObject:@{@"title":@"基本信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"姓名",@"content":dic[@"applicant"][@"applicantName"]}];
	[self.dataSourceArray addObject:@{@"title":@"性别",@"content":dic[@"applicant"][@"gender"]}];
	[self.dataSourceArray addObject:@{@"title":@"身份证号码",@"content":dic[@"applicant"][@"IdNumber"]}];
	[self.dataSourceArray addObject:@{@"title":@"出生年月",@"content":dic[@"applicant"][@"birthday"]}];
	[self.dataSourceArray addObject:@{@"title":@"毕业日期",@"content":dic[@"applicant"][@"graduationDate"]}];
	[self.dataSourceArray addObject:@{@"title":@"毕业院校",@"content":dic[@"applicant"][@"graduationSchool"]}];
	[self.dataSourceArray addObject:@{@"title":@"毕业专业",@"content":dic[@"applicant"][@"graduationMajor"]}];
	[self.dataSourceArray addObject:@{@"title":@"全日制学历",@"content":dic[@"applicant"][@"education"]}];
	[self.dataSourceArray addObject:@{@"title":@"职称/证书",@"content":dic[@"applicant"][@"certificate"]}];
	[self.dataSourceArray addObject:@{@"title":@"劳动合同类型",@"content":dic[@"applicant"][@"contractType"]}];
	[self.dataSourceArray addObject:@{@"title":@"招聘渠道",@"content":dic[@"applicant"][@"channel"]}];
	[self.dataSourceArray addObject:@{@"title":@"任务编号",@"content":dic[@"applicant"][@"taskNumber"]}];
	[self.dataSourceArray addObject:@{@"title":@"录用部门信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"所属业务",@"content":dic[@"applicantDepartment"][@"businessName"]}];
	if([dic[@"applicantDepartment"][@"businessName"] rangeOfString:@"装饰"].location !=NSNotFound){
		[self.dataSourceArray addObject:@{@"title":@"是否属于工业化",@"content":dic[@"applicantDepartment"][@"isIndustrialization"]}];
	}
	[self.dataSourceArray addObject:@{@"title":@"编制类型",@"content":dic[@"applicantDepartment"][@"establishmentName"]}];
	[self.dataSourceArray addObject:@{@"title":@"是否为仓管员",@"content":dic[@"applicantDepartment"][@"isWarehouse"]}];
	[self.dataSourceArray addObject:@{@"title":@"录用部门",@"content":dic[@"applicantDepartment"][@"department"]}];
	[self.dataSourceArray addObject:@{@"title":@"所带领导",@"content":dic[@"applicantDepartment"][@"leaderName"]}];
	[self.dataSourceArray addObject:@{@"title":@"职级",@"content":dic[@"applicantDepartment"][@"postLevel"]}];
	[self.dataSourceArray addObject:@{@"title":@"职务名称",@"content":dic[@"applicantDepartment"][@"postName"]}];
	[self.dataSourceArray addObject:@{@"title":@"录用部门负责人",@"content":dic[@"applicantDepartment"][@"departmentPrincipalName"]}];
	[self.dataSourceArray addObject:@{@"title":@"录用部门中心副总",@"content":dic[@"applicantDepartment"][@"departmentVpName"]}];
	[self.dataSourceArray addObject:@{@"title":@"录用部门总经理",@"content":dic[@"applicantDepartment"][@"departmentGmName"]}];
	[self.dataSourceArray addObject:@{@"title":@"报道地点",@"content":dic[@"applicantDepartment"][@"reportSite"]}];
	[self.dataSourceArray addObject:@{@"title":@"试用期信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"拟到岗日期",@"content":dic[@"applicantProbation"][@"arrivalPlanDate"]}];
	[self.dataSourceArray addObject:@{@"title":@"试用期限",@"content":dic[@"applicantProbation"][@"probationEndDate"]}];
	[self.dataSourceArray addObject:@{@"title":@"试用工资",@"content":dic[@"applicantProbation"][@"probationSalary"]}];
	[self.dataSourceArray addObject:@{@"title":@"其他",@"content":dic[@"applicantProbation"][@"probationAnnualSalary"]}];
	[self.dataSourceArray addObject:@{@"title":@"转正信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"目标全薪",@"content":dic[@"applicantConversion"][@"expectSalary"]}];
	[self.dataSourceArray addObject:@{@"title":@"转正工资",@"content":dic[@"applicantConversion"][@"conversionSalary"]}];
	[self.dataSourceArray addObject:@{@"title":@"其他",@"content":dic[@"applicantConversion"][@"conversionAnnualSalary"]}];
	[self.dataSourceArray addObject:@{@"title":@"新进员工评估内容",@"content":dic[@"applicantConversion"][@"evaluationContent"]}];
	[self.dataSourceArray addObject:@{@"title":@"附件信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"面试评价表",@"file":dic[@"interViewInfo"],@"special":@(BussinessFlowCellTurn)}];
	[self.dataSourceArray addObject:@{@"title":@"应聘登记表",@"file":dic[@"interViewInfo"][@"ulApplyUrl"],@"special":@(BussinessFlowCellTurn)}];
	[self.dataSourceArray addObject:@{@"title":@"提交者附言",@"content":dic[@"remarks"][@"remarks"]}];
									 
	
}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
	if ([cellDic[@"title"] isEqualToString:@"应聘登记表"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		YSFormLinkViewController *flowMapViewController = [[YSFormLinkViewController alloc] init];
		flowMapViewController.urlString = cellDic[@"file"];
		[viewController.navigationController pushViewController:flowMapViewController animated:YES];
		
	}
	if ([cellDic[@"title"] isEqualToString:@"面试评价表"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		YSFlowInterviewTableViewController *flowInterviewTableViewController = [[YSFlowInterviewTableViewController alloc]init];
		flowInterviewTableViewController.dic = cellDic[@"file"];
		[viewController.navigationController pushViewController:flowInterviewTableViewController animated:YES];
		
	}
	
}
@end
