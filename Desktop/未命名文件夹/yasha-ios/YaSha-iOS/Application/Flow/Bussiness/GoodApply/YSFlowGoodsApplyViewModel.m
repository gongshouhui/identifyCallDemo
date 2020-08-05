//
//  YSFlowGoodsApplyViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowGoodsApplyViewModel.h"
#import "YSFlowGoodsApplyModel.h"
#import "YSFlowAttachmentViewController.h"
#import "YSFlowGoodsDetailController.h"
@interface YSFlowGoodsApplyViewModel()
@property (nonatomic,strong) YSFlowGoodsApplyModel *goodsApplyModel;
@property (nonatomic,strong) NSArray *goodsAttachArray;
@end
@implementation YSFlowGoodsApplyViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getGoodsCategory, self.flowModel.businessKey];
	[YSNetManager ys_request_GETWithUrlString:urlString isNeedCache:NO parameters:nil successBlock:^(id response) {
		if ([response[@"code"] intValue] == 1) {
			self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			self.goodsApplyModel = [YSFlowGoodsApplyModel yy_modelWithJSON:self.flowFormModel.info[@"apply"]];
			self.goodsAttachArray = [NSArray yy_modelArrayWithClass:[YSNewsAttachmentModel class] json:self.flowFormModel.info[@"fileListFormMobile"]];
			[self setUpData];//重组数据
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
- (void)setUpData {
	[self.dataSourceArray removeAllObjects];
	[self.dataSourceArray addObject:@{@"title":@"申请信息",@"special":@(BussinessFlowCellHead)}];
	[self.dataSourceArray addObject:@{@"title":@"申请人",@"content":self.goodsApplyModel.applyManName}];
	[self.dataSourceArray addObject:@{@"title":@"实际使用人" ,@"content":self.goodsApplyModel.useManName}];
	[self.dataSourceArray addObject:@{@"title":@"实际使用公司" ,@"content":self.goodsApplyModel.useCompany}];
	[self.dataSourceArray addObject:@{@"title":@"实际使用部门" ,@"content":self.goodsApplyModel.useDept}];
	[self.dataSourceArray addObject:@{@"title":@"员工级别" ,@"content":self.goodsApplyModel.useManLevel}];
	[self.dataSourceArray addObject:@{@"title":@"工管公司负责人" ,@"content":self.goodsApplyModel.projectDirectorName}];
	[self.dataSourceArray addObject:@{@"title":@"项目名称" ,@"content":self.goodsApplyModel.ownProject}];
	[self.dataSourceArray addObject:@{@"title":@"项目经理" ,@"content":self.goodsApplyModel.managerName}];
	[self.dataSourceArray addObject:@{@"title":@"项目类别" ,@"content":self.goodsApplyModel.proNature}];

	[self.dataSourceArray addObject:@{@"title":@"收件(项目)地址" ,@"content":self.goodsApplyModel.projectAddress }];
	[self.dataSourceArray addObject:@{@"title":@"收件人" ,@"content":self.goodsApplyModel.recipient}];
	
	[self.dataSourceArray addObject:@{@"title":@"收件人联系方式" ,@"content":self.goodsApplyModel.recipientTel}];
	[self.dataSourceArray addObject:@{@"title":@"申请原因" ,@"content":self.goodsApplyModel.reason}];
	[self.dataSourceArray addObject:@{@"title":@"归属公司费用合计 (元)" ,@"content":[NSString stringWithFormat:@"%.2f",self.goodsApplyModel.companyFee]}];
	[self.dataSourceArray addObject:@{@"title":@"归属项目费用合计 (元)" ,@"content":[NSString stringWithFormat:@"%.2f",self.goodsApplyModel.projectFee]}];
	[self.dataSourceArray addObject:@{@"title":@"归属劳务班组费用合计(元)" ,@"content":[NSString stringWithFormat:@"%.2f",self.goodsApplyModel.laborClassFee]}];
	[self.dataSourceArray addObject:@{@"title":@"合计(元)" ,@"content":[NSString stringWithFormat:@"%.2f",self.goodsApplyModel.companyFee + self.goodsApplyModel.projectFee + self.goodsApplyModel.laborClassFee]}];
	[self.dataSourceArray addObject:@{@"title":@"申请工地物资类" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.goodsApplyModel.applyInfos.count],@"file":self.goodsApplyModel.applyInfos}];
	[self.dataSourceArray addObject:@{@"title":@"品名附件" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.goodsAttachArray.count],@"file":self.goodsAttachArray}];

}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
	if ([cellDic[@"title"] isEqualToString:@"申请工地物资类"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		YSFlowGoodsDetailController *vc = [[YSFlowGoodsDetailController alloc]init];
		vc.goodsArray = cellDic[@"file"];
		vc.totalMoney = self.goodsApplyModel.companyFee + self.goodsApplyModel.projectFee + self.goodsApplyModel.laborClassFee;
		vc.title = @"申请工地物资类";
		[viewController.navigationController pushViewController:vc animated:YES];
		
	}
	if ([cellDic[@"title"] isEqualToString:@"品名附件"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		if (![cellDic[@"file"] count]) {
			[QMUITips showInfo:@"暂无附件"];
			return;
		}
		YSFlowAttachmentViewController *vc = [[YSFlowAttachmentViewController alloc]init];
		vc.attachMentArray =  cellDic[@"file"];
		[viewController.navigationController pushViewController:vc animated:YES];
		
	}
}
@end
