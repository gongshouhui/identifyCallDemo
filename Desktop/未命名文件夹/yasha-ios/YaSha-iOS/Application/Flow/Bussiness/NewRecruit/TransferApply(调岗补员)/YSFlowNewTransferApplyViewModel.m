//
//  YSFlowTransferApplyViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/10/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowNewTransferApplyViewModel.h"
@implementation YSFlowNewTransferApplyViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, getNewPersonnelRecruitByIdApi, self.flowModel.businessKey, self.flowModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"mobileFiles"]) {
				YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
				[self.attachArray addObject:model];
			}
			
			if ([self.flowFormModel.info[@"personnelRecruitInfoList"] count] > 0) {
				for (NSDictionary *dic in self.flowFormModel.info[@"personnelRecruitInfoList"]) {
					for (NSDictionary *attachDic in dic[@"files"]) {
						YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:attachDic];
						[self.attachArray addObject:model];
					}
					
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
	for (int i = 0; i < [dic[@"personnelRecruitInfoList"] count]; i++) {
		[self.dataSourceArray addObject:@{@"title":[NSString stringWithFormat:@"申请信息%d",i+1],@"special":@(BussinessFlowCellHead)}];
		NSDictionary *detailDic = dic[@"personnelRecruitInfoList"][i];
		[self.dataSourceArray addObject:@{@"title":@"编制类型",@"content":detailDic[@"originalTypeStr"]}];
		[self.dataSourceArray addObject:@{@"title":@"编制部门",@"content":detailDic[@"deptName"]}];
		[self.dataSourceArray addObject:@{@"title":@"调岗人员姓名",@"content":detailDic[@"personnelName"]}];
		[self.dataSourceArray addObject:@{@"title":@"调岗人员岗位",@"content":detailDic[@"personnelPostName"]}];
		[self.dataSourceArray addObject:@{@"title":@"调往单位",@"content":detailDic[@"transferToDeptName"]}];
		[self.dataSourceArray addObject:@{@"title":@"调岗日期",@"content":detailDic[@"personnelDate"]}];
		[self.dataSourceArray addObject:@{@"title":@"期望时间",@"content":detailDic[@"expectedDate"]}];
		[self.dataSourceArray addObject:@{@"title":@"任职资格",@"special":@(BussinessFlowCellHead)}];
		[self.dataSourceArray addObject:@{@"title":@"岗位职责",@"content":detailDic[@"postStatement"]}];
		[self.dataSourceArray addObject:@{@"title":@"学历要求",@"content":detailDic[@"educationalRequirementsStr"]}];
		[self.dataSourceArray addObject:@{@"title":@"工作经验",@"content":detailDic[@"workExperienceStr"]}];
		[self.dataSourceArray addObject:@{@"title":@"职业资格证书",@"content":detailDic[@"certName"]}];
		
		[self.dataSourceArray addObject:@{@"title":@"其他",@"content":detailDic[@"others"]}];
		[self.dataSourceArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellHead)}];
		[self.dataSourceArray addObject:@{@"title":@"备注",@"content":detailDic[@"remarks"]}];
	}
	
}
@end
