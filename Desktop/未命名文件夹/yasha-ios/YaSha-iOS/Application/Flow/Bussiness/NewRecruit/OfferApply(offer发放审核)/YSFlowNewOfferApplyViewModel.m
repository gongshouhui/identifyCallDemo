//
//  YSFlowOfferApplyViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/10/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowNewOfferApplyViewModel.h"
#import "YSNewFormLinkViewController.h"
#import "YSFlowNewInterviewTableViewController.h"
@implementation YSFlowNewOfferApplyViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, getNewOfferApplyApi, self.flowModel.businessKey, self.flowModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"files"]) {
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
	[self.dataSourceArray addObject:@{@"title":@"基本信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"姓名",@"content":dic[@"name"]}];
	[self.dataSourceArray addObject:@{@"title":@"性别",@"content":dic[@"sex"]}];
	[self.dataSourceArray addObject:@{@"title":@"身份证号码",@"content":dic[@"idCardNumber"]}];
	[self.dataSourceArray addObject:@{@"title":@"出生年月",@"content":dic[@"birthday"]}];
	[self.dataSourceArray addObject:@{@"title":@"毕业日期",@"content":dic[@"graducationTime"]}];
	[self.dataSourceArray addObject:@{@"title":@"毕业院校",@"content":dic[@"schoolName"]}];
	[self.dataSourceArray addObject:@{@"title":@"毕业专业",@"content":dic[@"major"]}];
	[self.dataSourceArray addObject:@{@"title":@"全日制学历",@"content":dic[@"degree"]}];
	[self.dataSourceArray addObject:@{@"title":@"职称/证书",@"content":dic[@"titleCertificate"]}];
	[self.dataSourceArray addObject:@{@"title":@"招聘渠道",@"content":dic[@"channel"]}];
	
	//录用信息
	[self.dataSourceArray addObject:@{@"title":@"录用信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"岗位",@"content":dic[@"postName"]}];
	[self.dataSourceArray addObject:@{@"title":@"部门",@"content":dic[@"deptName"]}];
	[self.dataSourceArray addObject:@{@"title":@"任务",@"content":dic[@"recruitTaskNo"]}];
	[self.dataSourceArray addObject:@{@"title":@"所属业务",@"content":dic[@"orgName"]}];
	[self.dataSourceArray addObject:@{@"title":@"编制类型",@"content":dic[@"originalType"]}];
	[self.dataSourceArray addObject:@{@"title":@"劳动合同类型",@"content":dic[@"contractType"]}];
	[self.dataSourceArray addObject:@{@"title":@"劳动合同年限",@"content":dic[@"contractYears"]}];
	[self.dataSourceArray addObject:@{@"title":@"合同主体单位",@"content":dic[@"contractCompany"]}];
	[self.dataSourceArray addObject:@{@"title":@"人员类别",@"content":dic[@"staffType"]}];
	[self.dataSourceArray addObject:@{@"title":@"是否属于工业化",@"content":dic[@"isIndustrialization"]}];
	[self.dataSourceArray addObject:@{@"title":@"是否为仓管员",@"content":dic[@"isWarehouse"]}];
	[self.dataSourceArray addObject:@{@"title":@"岗位序列",@"content":dic[@"postSequence"]}];
	[self.dataSourceArray addObject:@{@"title":@"所带领导",@"content":dic[@"leaderName"]}];
	[self.dataSourceArray addObject:@{@"title":@"职级",@"content":dic[@"postLevelOld"]}];
	[self.dataSourceArray addObject:@{@"title":@"亚厦职级",@"content":dic[@"postLevel"]}];
	[self.dataSourceArray addObject:@{@"title":@"录用部门负责人",@"content":dic[@"deptDutyName"]}];
	[self.dataSourceArray addObject:@{@"title":@"录用部门中心副总",@"content":dic[@"deptVpName"]}];
	[self.dataSourceArray addObject:@{@"title":@"录用部门总经理",@"content":dic[@"deptGmName"]}];
	[self.dataSourceArray addObject:@{@"title":@"报道地点",@"content":dic[@"reportSite"]}];
	[self.dataSourceArray addObject:@{@"title":@"办公地点",@"content":dic[@"officeSite"]}];
	[self.dataSourceArray addObject:@{@"title":@"社保缴纳地",@"content":dic[@"socialPlace"]}];

	//试用信息
	[self.dataSourceArray addObject:@{@"title":@"试用信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"拟到岗日期",@"content":dic[@"arrivalPlanDate"]}];
	[self.dataSourceArray addObject:@{@"title":@"试用期至",@"content":dic[@"probationEndDate"]}];
	[self.dataSourceArray addObject:@{@"title":@"试用期",@"content":dic[@"probationDuration"]}];
	[self.dataSourceArray addObject:@{@"title":@"试用工资",@"content":[NSString stringWithFormat:@"%@元/月",dic[@"probationSalary"]]}];
	[self.dataSourceArray addObject:@{@"title":@"其他",@"content":dic[@"probationRemarks"]}];
	
	[self.dataSourceArray addObject:@{@"title":@"转正信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"转正工资",@"content":[NSString stringWithFormat:@"%@元/月",dic[@"formalSalary"]]}];
	[self.dataSourceArray addObject:@{@"title":@"目标全薪",@"content":[NSString stringWithFormat:@"%@元/年",dic[@"expectSalary"]]}];
	[self.dataSourceArray addObject:@{@"title":@"薪制",@"content":dic[@"wageType"]}];
	[self.dataSourceArray addObject:@{@"title":@"其他",@"content":dic[@"formalRemarks"]}];
	[self.dataSourceArray addObject:@{@"title":@"新进员工评估内容",@"content":dic[@"evaluationContent"]}];
	
	
	//面试评价表
	[self.dataSourceArray addObject:@{@"title":@"面试评价表",@"special":@(BussinessFlowCellHead)}];
	for (NSDictionary *detailDic in dic[@"interviewEvaluates"]) {
		[self.dataSourceArray addObject:@{@"title":@"阶段",@"content":detailDic[@"evaluateStatus"]}];
		[self.dataSourceArray addObject:@{@"title":@"面试官",@"content":detailDic[@"managerUserName"]}];
		[self.dataSourceArray addObject:@{@"title":@"面试时间",@"content":detailDic[@"interviewTime"]}];
		[self.dataSourceArray addObject:@{@"title":@"面试结果",@"content":detailDic[@"evaluateStatus"]}];
		[self.dataSourceArray addObject:@{@"title":@"面试评价 ",@"content":detailDic[@"evaluate"]}];
	}
	
	[self.dataSourceArray addObject:@{@"title":@"应聘登记表",@"file":dic[@"interviewRegUrl"],@"special":@(BussinessFlowCellTurn)}];
}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
	if ([cellDic[@"title"] isEqualToString:@"应聘登记表"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		if ([cellDic[@"file"] isEqualToString:@""]) {
			[QMUITips showWithText:@"暂无登记表"];
			return;
		}
		YSNewFormLinkViewController *flowMapViewController = [[YSNewFormLinkViewController alloc] init];
		flowMapViewController.urlString = cellDic[@"file"];
		[viewController.navigationController pushViewController:flowMapViewController animated:YES];
		
	}
	if ([cellDic[@"title"] isEqualToString:@"面试评价表"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		YSFlowNewInterviewTableViewController *flowInterviewTableViewController = [[YSFlowNewInterviewTableViewController alloc]init];
		flowInterviewTableViewController.dic = cellDic[@"file"];
		[viewController.navigationController pushViewController:flowInterviewTableViewController animated:YES];
		
	}
	
}
@end
