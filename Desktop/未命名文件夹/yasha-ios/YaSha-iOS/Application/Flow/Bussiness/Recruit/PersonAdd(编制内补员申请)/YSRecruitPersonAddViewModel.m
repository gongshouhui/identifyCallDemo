//
//  YSRecruitPersonAddViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/10/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRecruitPersonAddViewModel.h"
#import "YSFlowJobDelineateViewController.h"
@implementation YSRecruitPersonAddViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",YSDomain, getPersonnelRecruitByIdApi, self.flowModel.businessKey, self.flowModel.processInstanceId];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			[self setUpData:self.flowFormModel.info];//重组数据
			//附件
			for (NSDictionary *dic in self.flowFormModel.info[@"mobileFiles"]) {
				YSNewsAttachmentModel *model = [YSNewsAttachmentModel yy_modelWithJSON:dic];
				[self.attachArray addObject:model];
			}
			if ([self.flowFormModel.info[@"personnelRecruitFiles"] count] > 0) {
				for (NSDictionary *dic in self.flowFormModel.info[@"personnelRecruitFiles"]) {
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
	//self.jobDelineateArr = dic[@"positions"];
	[self.dataSourceArray addObject:@{@"title":@"申请信息",@"special":@(BussinessFlowCellHead)}];
	for (int i = 0; i <[dic[@"personnelRecruitInfos"] count] ; i++) {
		NSDictionary *dic1  =  dic[@"personnelRecruitInfos"][i];
		[self.dataSourceArray addObject:@{@"title":@"编制部门",@"content":dic1[@"departmentName"]}];
		[self.dataSourceArray addObject:@{@"title":@"编制类型",@"content":dic1[@"originalType"]}];
		[self.dataSourceArray addObject:@{@"title":@"岗位名称",@"content":dic1[@"positionName"]}];
		[self.dataSourceArray addObject:@{@"title":@"职级",@"content":dic1[@"rankName"]}];
		[self.dataSourceArray addObject:@{@"title":@"总数",@"content":[NSString stringWithFormat:@"%@",dic1[@"totalNum"]]}];
		[self.dataSourceArray addObject:@{@"title":@"期望时间",@"content":dic1[@"expectedDate"]}];
		[self.dataSourceArray addObject:@{@"title":@"岗位职责与要求",@"content":dic1[@"requirement"],@"expand":@(0),@"special":@(BussinessFlowCellExtend)}];//这里把展开项的内容放在contentl里了
		[self.dataSourceArray addObject:@{@"title":@"岗位描述",@"file":dic[@"positions"][i],@"special":@(BussinessFlowCellTurn)}];
	}
	
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
