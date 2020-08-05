//
//  YSContractStampedViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/7/29.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContractStampedViewModel.h"
#import "YSAttachmentClassificationVC.h"

@implementation YSContractStampedViewModel
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock{
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",YSDomain, getSealOfContractInfoApi, self.flowModel.businessKey];
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
	
	NSMutableArray *infoArr = [NSMutableArray array];
	[infoArr addObject:@{@"title":@"基本信息",@"content":@" ",@"special":@(BussinessFlowCellHead)}];
	[infoArr addObject:@{@"title":@"表单编号",@"content":dic[@"code"]}];
	[infoArr addObject:@{@"title":@"采购合同名称",@"content":dic[@"name"]}];
	[infoArr addObject:@{@"title":@"合同编号",@"content":dic[@"contractNum"]}];
	
	[infoArr addObject:@{@"title":@"是否线上盖章",@"content":dic[@"isOnlineStr"]}];
	[infoArr addObject:@{@"title":@"用章单位",@"content":dic[@"isQp"]}];
	[infoArr addObject:@{@"title":@"是否过产业园",@"content":dic[@"isIndustrialParkStr"]}];
	[infoArr addObject:@{@"title":@"所属业务",@"content":dic[@"beloneBusiness"] }];
	[infoArr addObject:@{@"title":@"采购范围",@"content":dic[@"purchaseScope"]}];
	[infoArr addObject:@{@"title":@"合同类型",@"content":dic[@"contractType"]}];
	[infoArr addObject:@{@"title":@"主从合同",@"content":dic[@"psContract"]}];
	[infoArr addObject:@{@"title":@"采购内容",@"content":dic[@"purchaseMaterial"]}];
	[infoArr addObject:@{@"title":@"采购类型",@"content":dic[@"purchaseType"]}];
	if ([dic[@"isOnlineStr"] isEqualToString:@"否"]) {
		[infoArr addObject:@{@"title":@"盖章份数",@"content":[dic[@"contractCount"] stringValue]}];
	}
	[infoArr addObject:@{@"title":@"申请事由",@"content":dic[@"applyReason"]}];
	[infoArr addObject:@{@"title":@"备注",@"content":dic[@"remark"]}];
	
	[infoArr addObject:@{@"title":@"项目信息",@"content":@" ",@"special":@"1"}];
	[infoArr addObject:@{@"title":@"项目名称",@"content":dic[@"proName"]}];
	[infoArr addObject:@{@"title":@"项目编码",@"content":dic[@"proCode"]}];
	[infoArr addObject:@{@"title":@"项目线条",@"content":dic[@"proLine"]}];
	[infoArr addObject:@{@"title":@"工程地址",@"content":dic[@"proAddress"]}];
	[infoArr addObject:@{@"title":@"所属部门",@"content":dic[@"proDeptName"]}];
	[infoArr addObject:@{@"title":@"项目经理",@"content":dic[@"proManagerName"]}];
	[infoArr addObject:@{@"title":@"项目性质",@"content":dic[@"proNature"]}];
	[infoArr addObject:@{@"title":@"是否重点项目",@"content":dic[@"isKeyProjectStr"]}];
	[infoArr addObject:@{@"title":@"工程管理模式",@"content":dic[@"proManageMode"]}];
	[infoArr addObject:@{@"title":@"供应商信息",@"content":@" ",@"special":@"1"}];
	[infoArr addObject:@{@"title":@"供应商名称",@"content":dic[@"franName"]}];
	[infoArr addObject:@{@"title":@"主要联系人",@"content":dic[@"franContacts"]}];
	[infoArr addObject:@{@"title":@"联系方式",@"content":dic[@"franMobile"]}];
	[infoArr addObject:@{@"title":@"合同信息",@"content":@" ",@"special":@"1"}];
	[infoArr addObject:@{@"title":@"合同总价/暂定(元)",@"content":[YSUtility thousandsFormat:[dic[@"contractPrice"] floatValue]]}];
	[infoArr addObject:@{@"title":@"是否为公司版本",@"content":dic[@"isCompanyVersionStr"]}];
	[infoArr addObject:@{@"title":@"是否为年度协议合同",@"content":dic[@"isYearContractStr"]}];
	[infoArr addObject:@{@"title":@"签订日期",@"content":[dic[@"signDate"] substringToIndex:10]}];
	[infoArr addObject:@{@"title":@"安装方式",@"content":dic[@"installMethod"] }];
	[infoArr addObject:@{@"title":@"正文页次",@"content":[dic[@"textPage"] stringValue]}];
	[infoArr addObject:@{@"title":@"附件页次",@"content":[dic[@"attachmentPage"] stringValue]}];
	[infoArr addObject:@{@"title":@"目标成本价",@"content":[YSUtility thousandsFormat:[dic[@"targetCastPrice"] floatValue]]}];
	[infoArr addObject:@{@"title":@"限价",@"content":[YSUtility thousandsFormat:[dic[@"limitPrice"] floatValue]]}];
	//    if ([dic[@"isQp"] isEqualToString:@"全品"] ||[dic[@"isQp"] isEqualToString:@"蘑菇加"]) {
	//        [infoArr addObject:@{@"title":@"全品/蘑菇加合同总价",@"content":[dic[@"qpContractPrice"] stringValue]}];
	//    }
	[infoArr addObject:@{@"title":@"合同主要付款条件",@"content":dic[@"contractCondition"]}];
	[infoArr addObject:@{@"title":@"合同条款说明",@"content":dic[@"contractExplain"]}];
	NSMutableArray *accessaryArr = [NSMutableArray array];
	//额外附件
	[accessaryArr addObject:[NSArray yy_modelArrayWithClass:[YSNewsAttachmentModel class] json:self.flowFormModel.info[@"pubAttList"]]];
	[accessaryArr addObject:[NSArray yy_modelArrayWithClass:[YSNewsAttachmentModel class] json:self.flowFormModel.info[@"supplierList"]]];
	[accessaryArr addObject:[NSArray yy_modelArrayWithClass:[YSNewsAttachmentModel class] json:self.flowFormModel.info[@"qpList"]]];
	[infoArr addObject:@{@"title":@"附件" ,@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",[self.flowFormModel.info[@"pubAttList"] count] + [self.flowFormModel.info[@"supplierList"] count] + [self.flowFormModel.info[@"qpList"] count]],@"file":accessaryArr}];
	self.dataSourceArray = infoArr;
}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
	if ([cellDic[@"title"] isEqualToString:@"附件"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		if (![cellDic[@"content"] integerValue]) {
			[QMUITips showInfo:@"暂无附件"];
			return;
		}
		YSAttachmentClassificationVC *vc = [[YSAttachmentClassificationVC alloc]init];
		vc.dataSourceArray =  cellDic[@"file"];
		[viewController.navigationController pushViewController:vc animated:YES];
		
	}
}
@end
