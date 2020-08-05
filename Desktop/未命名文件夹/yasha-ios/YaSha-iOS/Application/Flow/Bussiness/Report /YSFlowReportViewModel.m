//
//  YSFlowReportViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/12.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowReportViewModel.h"

@implementation YSFlowReportViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock {
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain,getProReportInfoApi,self.flowModel.businessKey];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info];
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"crmProFilesList"]) {
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
	
	[self.dataSourceArray addObject:@{@"title":@"基本信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"项目名称",@"content":dic[@"projectName"]}];
	[self.dataSourceArray addObject:@{@"title":@"工程类别",@"content":dic[@"programmeTypeStr"]}];
	[self.dataSourceArray addObject:@{@"title":@"项目类型",@"content":dic[@"projectTypeStr"]}];
	[self.dataSourceArray addObject:@{@"title":@"招标方式",@"content":dic[@"tenderTypeStr"]}];
	[self.dataSourceArray addObject:@{@"title":@"招标内容",@"content":dic[@"tenderContentStr"]}];
	[self.dataSourceArray addObject:@{@"title":@"预计投标日期",@"content":[YSUtility timestampSwitchTime:dic[@"tenderExpectDate"] andFormatter:@"yyyy-MM-dd"] }];
	[self.dataSourceArray addObject:@{@"title":@"工程造价(万元)",@"content":[NSString stringWithFormat:@"%@ %@",dic[@"projectCostCurrencyStr"],dic[@"projectCost"]]}];
	[self.dataSourceArray addObject:@{@"title":@"工程面积(平方米)",@"content":[YSUtility cancelNullData:dic[@"projectArea"]]}];
	[self.dataSourceArray addObject:@{@"title":@"工程地址",@"content":[NSString stringWithFormat:@"%@%@%@",[YSUtility cancelNullData:dic[@"proProvinceName"]],[YSUtility cancelNullData:dic[@"proCityName"]],[YSUtility cancelNullData:dic[@"proAreaName"]]]}];
	[self.dataSourceArray addObject:@{@"title":@"详细地址",@"content":[NSString stringWithFormat:@"%@",[YSUtility cancelNullData:dic[@"proAddress"]]]}];
	[self.dataSourceArray addObject:@{@"title":@"甲方单位",@"content":[YSUtility cancelNullData:dic[@"firstPartyCompany"]]}];
	[self.dataSourceArray addObject:@{@"title":@"甲方项目对接人",@"content":[YSUtility cancelNullData:dic[@"firstPartyUser"]]}];
	[self.dataSourceArray addObject:@{@"title":@"甲方项目对接人联系方式",@"content":[YSUtility cancelNullData:dic[@"firstPartyUserLink"]]}];
	[self.dataSourceArray addObject:@{@"title":@"甲方项目对接人职务",@"content":[YSUtility cancelNullData:dic[@"firstPartyUserPost"]]}];
	[self.dataSourceArray addObject:@{@"title":@"项目所属区域/团队",@"content":[YSUtility cancelNullData:dic[@"deptName"]]}];
	[self.dataSourceArray addObject:@{@"title":@"所属团队负责人",@"content":[YSUtility cancelNullData:dic[@"deptLeader"]]}];
	[self.dataSourceArray addObject:@{@"title":@"所属区域/团队所在公司",@"content":[YSUtility cancelNullData:dic[@"companyName"]]}];
	[self.dataSourceArray addObject:@{@"title":@"对接人",@"content":[YSUtility cancelNullData:dic[@"pickUpUserName"]]}];
	[self.dataSourceArray addObject:@{@"title":@"是否工管联动",@"content":[YSUtility judgeWhetherOrNot:dic[@"isManagementLinkage"]]}];
	//进场/完成日期 是否需要智能化支持
	/*[self.dataSourceArray addObject:@{@"title":@"是否需要智能化支持",@"content":[YSUtility judgeWhetherOrNot:dic[@"isNeedIntelligentSupport"]]}];
	 [self.dataSourceArray addObject:@{@"title":@"预计进场日期",@"content":[YSUtility timestampSwitchTime:dic[@"planEnterDate"] andFormatter:@"yyyy-MM-dd"]}];
	 [self.dataSourceArray addObject:@{@"title":@"预计完成日期",@"content":[YSUtility timestampSwitchTime:dic[@"planFinishDate"] andFormatter:@"yyyy-MM-dd"]}];
	 */
	[self.dataSourceArray addObject:@{@"title":@"项目自评级",@"content":[YSUtility cancelNullData:dic[@"projectSelfGradeStr"]]}];
	[self.dataSourceArray addObject:@{@"title":@"预计定标日期",@"content":[YSUtility timestampSwitchTime:dic[@"preWinnDate"] andFormatter:@"yyyy-MM-dd"]}];
	if ([[YSUtility cancelNullData:dic[@"projectSelfGradeStr"]] isEqualToString:@"AA"]) {
		[self.dataSourceArray addObject:@{@"title":@"预计中标金额(万元)",@"content":[NSString stringWithFormat:@"%@ %@",[YSUtility cancelNullData:dic[@"preWinnMoneyStr"]],[YSUtility cancelNullData:dic[@"preWinnMoney"]]]}];
		[self.dataSourceArray addObject:@{@"title":@"项目推进情况",@"content":[YSUtility cancelNullData:dic[@"projectProgressRemark"]]}];
		[self.dataSourceArray addObject:@{@"title":@"问题与支持",@"content":[YSUtility cancelNullData:dic[@"questionSupportRemark"]]}];
	}
	
	
	[self.dataSourceArray addObject:@{@"title":@"是否含有工业化装配式",@"content":[YSUtility judgeWhetherOrNot:dic[@"isIndustryConf"]]}];
	if ([[YSUtility cancelNullData:dic[@"isIndustryConf"]] isEqualToString:@"1"]) {
		[self.dataSourceArray addObject:@{@"title":@"工业装配式体量(平方米)",@"content":[YSUtility cancelNullData:dic[@"industryConfArea"]]}];
		[self.dataSourceArray addObject:@{@"title":@"工业化装配式单方造价 (元/平方米)",@"content":[NSString stringWithFormat:@"%@ %@",[[YSUtility cancelNullData:dic[@"industryConfPrice"]] length] > 0 ? dic[@"industryConfPriceCurrencyStr"]:@"",[YSUtility  cancelNullData:dic[@"industryConfPrice"]]]}];
		[self.dataSourceArray addObject:@{@"title":@"预计竣工日期",@"content":[YSUtility timestampSwitchTime:dic[@"planCompleteDate"] andFormatter:@"yyyy-MM-dd"]}];
		[self.dataSourceArray addObject:@{@"title":@"订单总套数",@"content":[YSUtility cancelNullData:dic[@"orderCount"]]}];
		[self.dataSourceArray addObject:@{@"title":@"订单户型个数",@"content":[YSUtility cancelNullData:dic[@"orderApartmentCount"]]}];
		[self.dataSourceArray addObject:@{@"title":@"预付款比例 (%)",@"content":[YSUtility cancelNullData:dic[@"advanceChargeProportion"]]}];
	}
	
}
@end
