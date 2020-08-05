//
//  YSFlowRecruitJobApplyViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/10/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowRecruitJobApplyViewModel.h"
#import "YSFlowJobDelineateViewController.h"
@implementation YSFlowRecruitJobApplyViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, getPositionPostByIdApi, self.flowModel.businessKey, self.flowModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"mobileFiles"]) {
				YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
				[self.attachArray addObject:model];
			}
			
			if ([self.flowFormModel.info[@"files1"] count] > 0) {
				for (NSDictionary *dic in self.flowFormModel.info[@"files1"]) {
					YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
					[self.attachArray addObject:model];
				}
			}
			if ([self.flowFormModel.info[@"files2"] count] > 0) {
				for (NSDictionary *dic in self.flowFormModel.info[@"files1"]) {
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
	[self.dataSourceArray addObject:@{@"title":@"岗位信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"编制部门",@"content":dic[@"fatherDepartmentName"]}];
	[self.dataSourceArray addObject:@{@"title":@"编制类型",@"content":dic[@"originalType"]}];
	[self.dataSourceArray addObject:@{@"title":@"岗位名称",@"content":dic[@"positionName"]}];
	[self.dataSourceArray addObject:@{@"title":@"所属中心/部门",@"content":dic[@"departmentName"]}];
	[self.dataSourceArray addObject:@{@"title":@"职务",@"content":dic[@"pkJob"]}];
	[self.dataSourceArray addObject:@{@"title":@"直属上级",@"content":dic[@"directSupervisor"]}];
	[self.dataSourceArray addObject:@{@"title":@"直属下级",@"content":dic[@"subordinate"]}];
	[self.dataSourceArray addObject:@{@"title":@"序列",@"content":dic[@"rankName"]}];
	[self.dataSourceArray addObject:@{@"title":@"总编制",@"content":[NSString stringWithFormat:@"%@",dic[@"totalNumHis"]]}];
	[self.dataSourceArray addObject:@{@"title":@"期望时间",@"content":dic[@"expectedDate"]}];
	[self.dataSourceArray addObject:@{@"title":@"岗位职责与要求",@"content":dic[@"postStatement"],@"expand":@(0),@"special":@(BussinessFlowCellExtend)}];
	[self.dataSourceArray addObject:@{@"title":@"任职资格",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"学历要求",@"content":dic[@"educationalRequirements"]}];
	[self.dataSourceArray addObject:@{@"title":@"专业",@"content":dic[@"major"]}];
	[self.dataSourceArray addObject:@{@"title":@"工作经验",@"content":dic[@"workExperience"]}];
	[self.dataSourceArray addObject:@{@"title":@"知识要求",@"content":dic[@"knowledge"]}];
	[self.dataSourceArray addObject:@{@"title":@"能力",@"content":dic[@"ability"]}];
	[self.dataSourceArray addObject:@{@"title":@"其他",@"content":dic[@"others"]}];
	[self.dataSourceArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"备注",@"content":dic[@"remarks"]}];
	[self.dataSourceArray addObject:@{@"title":@"提交者附言",@"content":dic[@"postscript"]}];
	
}
- (void)tableViewCellButtonClick:(NSIndexPath *)indexPath ExtendState:(BOOL)extend Complete:(void (^)())completeBlock{
	NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
	NSMutableDictionary	*dic = [[NSMutableDictionary alloc]initWithDictionary:cellDic];
	
	if (extend == YES) {
		dic[@"expand"] = @(1);
		[self.dataSourceArray replaceObjectAtIndex:indexPath.row withObject:dic];
		[self.dataSourceArray insertObject:@{@"title":@"",@"content":cellDic[@"content"],@"special":@(BussinessFlowCellText)} atIndex:indexPath.row+1];
	}else{
		dic[@"expand"] = @(0);
		[self.dataSourceArray replaceObjectAtIndex:indexPath.row withObject:dic];
		[self.dataSourceArray removeObjectAtIndex:indexPath.row+1];
	}
	if (completeBlock) {
		completeBlock();
	}
	
}

- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
	if ([cellDic[@"title"] isEqualToString:@"岗位描述"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		
		YSFlowJobDelineateViewController *flowJobDelineateViewController = [[YSFlowJobDelineateViewController alloc]init];
		flowJobDelineateViewController.dic = cellDic[@"file"];
		[viewController.navigationController pushViewController:flowJobDelineateViewController animated:YES];
	}
	
	
}
@end
