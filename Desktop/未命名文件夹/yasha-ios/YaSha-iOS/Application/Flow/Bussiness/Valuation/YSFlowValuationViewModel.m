//
//  YSFlowValuationViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowValuationViewModel.h"
#import "YSFlowValuationModel.h"
#import "YSValuationSoftwareDetailController.h"
#import "YSValuationSoftwareDetailViewModel.h"
@interface YSFlowValuationViewModel()
@property (nonatomic,strong)YSFlowValuationModel *valuationModel;
@property (nonatomic,strong) NSMutableArray *paraArray;
@property (nonatomic,strong) NSArray *sqArray;
@property (nonatomic,strong) NSArray *sjArray;
@property (nonatomic,strong) NSArray *xgArray;
@end
@implementation YSFlowValuationViewModel
- (NSMutableArray *)paraArray {
	if (!_paraArray) {
		_paraArray = [NSMutableArray array];
	}
	return _paraArray;
}
- (void)getFlowlistComplete:(fetchDataCompleteBlock)comleteBlock failue:(fetchDataFailueBlock)fetchFailueBlock {
    [YSNetManager ys_request_GETWithUrlString:[NSString stringWithFormat:@"%@%@/%@?taskId=%@",YSDomain,getValuationApplysp,self.flowModel.businessKey,self.flowModel.taskId] isNeedCache:NO parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            self.flowFormModel = [YSFlowFormModel yy_modelWithJSON:response[@"data"]];
			self.valuationModel = [YSFlowValuationModel yy_modelWithJSON:self.flowFormModel.info];
            [self setUpData];
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
        
    } progress:nil];
}
- (void)setUpData {
	
        NSMutableArray *infoArray = [NSMutableArray array];
        [infoArray addObject:@{@"title":@"基本信息",@"special":@(BussinessFlowCellHead)}];
        [infoArray addObject:@{@"title":@"申请人",@"content":self.valuationModel.applyMan}];
        [infoArray addObject:@{@"title":@"使用人" ,@"content":self.valuationModel.receptionMan}];
        [infoArray addObject:@{@"title":@"使用公司" ,@"content":self.valuationModel.applyCompany}];
        [infoArray addObject:@{@"title":@"使用部门" ,@"content":self.valuationModel.applyDept}];
        [infoArray addObject:@{@"title":@"申请类型" ,@"content":self.valuationModel.applyTypeStr}];
	[infoArray addObject:@{@"title":@"是否区域公司投标" ,@"content":self.valuationModel.ifCompanyArea?@"是":@"否"}];
        [infoArray addObject:@{@"title":@"是否有部门资产管理员" ,@"content":self.valuationModel.ifAssetsManager?@"是":@"否"}];
        [infoArray addObject:@{@"title":@"部门资产管理员" ,@"content":self.valuationModel.accountManager }];
	[infoArray addObject:@{@"title":@"是否项目地使用" ,@"content":self.valuationModel.ifProjectUse?@"是":@"否"}];
	[infoArray addObject:@{@"title":@"关联项目" ,@"content":self.valuationModel.ownProject}];
	[infoArray addObject:@{@"title":@"申请理由" ,@"content":self.valuationModel.applyReason}];
	[infoArray addObject:@{@"title":@"预计使用日期" ,@"content":self.valuationModel.useTimeStr}];
	[infoArray addObject:@{@"title":@"预估金额(元)" ,@"content":[NSString stringWithFormat:@"%.2f",self.valuationModel.predictMoney]}];
	
	[infoArray addObject:@{@"title":@"费用归口" ,@"content":self.valuationModel.belongCost}];
	[infoArray addObject:@{@"title":@"收件人" ,@"content":self.valuationModel.receiver}];
	[infoArray addObject:@{@"title":@"收件人联系电话" ,@"content":self.valuationModel.receiverPhone}];
	[infoArray addObject:@{@"title":@"邮寄地址" ,@"content":self.valuationModel.address}];
	
	[infoArray addObject:@{@"title":@"软件信息",@"special":@(BussinessFlowCellHead)}];
	if ([self getValuationFlowType] == ValuationFlowDutyCG) {
		[infoArray addObject:@{@"title":@"软件新购申请详情",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.valuationModel.valuationXGApplyInfos.count],@"file":self.valuationModel.valuationXGApplyInfos}];
	}else if ([self getValuationFlowType] == ValuationFlowDutySJ){
		[infoArray addObject:@{@"title":@"软件升级申请详情",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.valuationModel.valuationSJApplyInfos.count],@"file":self.valuationModel.valuationSJApplyInfos}];
	}else if ([self getValuationFlowType] == ValuationFlowDutySJAndCG){
		[infoArray addObject:@{@"title":@"软件新购申请详情",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.valuationModel.valuationXGApplyInfos.count],@"file":self.valuationModel.valuationXGApplyInfos}];
		[infoArray addObject:@{@"title":@"软件升级申请详情",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.valuationModel.valuationSJApplyInfos.count],@"file":self.valuationModel.valuationSJApplyInfos}];
	}else{
		[infoArray addObject:@{@"title":@"软件申请详情",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",self.valuationModel.valuationApplyInfos.count],@"file":self.valuationModel.valuationApplyInfos}];
	}
	
	
	self.dataSourceArray = infoArray;
	
}

- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath {
	  NSDictionary *cellDic = self.dataSourceArray[indexPath.row];
	if ([cellDic[@"title"] isEqualToString:@"软件申请详情"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		
		YSValuationSoftwareDetailViewModel *detailViewModel = [[YSValuationSoftwareDetailViewModel alloc]initWithValuationValuationFormID:self.valuationModel.id EditType:[self getValuationEditType] applyInfo:cellDic[@"file"] valuationFlowType:[self getValuationFlowType]];
		detailViewModel.changeBlock = ^(NSArray * _Nonnull paraArray) {
			self.sqArray = paraArray;
		};
		YSValuationSoftwareDetailController *vc = [[YSValuationSoftwareDetailController alloc]initWithViewModel:detailViewModel];
		vc.title = @"软件申请详情";
		[viewController.navigationController pushViewController:vc animated:YES];
	}
	if ([cellDic[@"title"] isEqualToString:@"软件升级申请详情"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {//根据点击的cell确定编辑类型
		ValuationEditType editType= ValuationEditNone;
		if (self.valuationModel.ifEditData) {
			editType = ValuationEditDutySJITNode;
		}
		YSValuationSoftwareDetailViewModel *detailViewModel = [[YSValuationSoftwareDetailViewModel alloc]initWithValuationValuationFormID:self.valuationModel.id EditType:editType applyInfo:cellDic[@"file"] valuationFlowType:[self getValuationFlowType]];
		detailViewModel.changeBlock = ^(NSArray * _Nonnull paraArray) {
			self.sjArray = paraArray;
		};
		YSValuationSoftwareDetailController *vc = [[YSValuationSoftwareDetailController alloc]initWithViewModel:detailViewModel];
		vc.title = @"软件升级申请详情";
		[viewController.navigationController pushViewController:vc animated:YES];
	}
	if ([cellDic[@"title"] isEqualToString:@"软件新购申请详情"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		ValuationEditType editType= ValuationEditNone;
		if (self.valuationModel.ifEditData) {
			editType = ValuationEditDutyCGITNode;
		}
		YSValuationSoftwareDetailViewModel *detailViewModel = [[YSValuationSoftwareDetailViewModel alloc]initWithValuationValuationFormID:self.valuationModel.id EditType:editType applyInfo:cellDic[@"file"] valuationFlowType:[self getValuationFlowType]];
		detailViewModel.changeBlock = ^(NSArray * _Nonnull paraArray) {
			self.xgArray = paraArray;
		};
		YSValuationSoftwareDetailController *vc = [[YSValuationSoftwareDetailController alloc]initWithViewModel:detailViewModel];
		vc.title = @"软件新购申请详情";
		[viewController.navigationController pushViewController:vc animated:YES];
	}
	
	
	
}
- (ValuationEditType)getValuationEditType {
	
	if (self.flowType == YSFlowTypeTodo && self.valuationModel.ifEditData) {
//		valuation-apply 计价软件个人申请，使用和升级
//		valuation-administrators-apply 计价软件责任申请，资产申请（由信息部直接申请）

		if ([self.flowModel.processDefinitionKey isEqualToString:@"valuation-apply"]) {//计价软件个人申请
			
			if ([self.valuationModel.applyType isEqualToString:@"SY"]) {//使用
				if ([self.valuationModel.activityName isEqualToString:@"部门资产管理员"]) {
					return ValuationEditPersonSYDepartNode;
				}else{//信息部资产管理员
					return ValuationEditPersonSYITNode;
				}
			}else{//升级
				if ([self.valuationModel.activityName isEqualToString:@"部门资产管理员"]) {
					return ValuationEditPersonSJDepartNode;
				}else{//信息部资产管理员
					return ValuationEditPersonSJITNode;
				}
			}
			
			
			
		}
		
		if ([self.flowModel.processDefinitionKey isEqualToString:@"valuation-administrators-apply"]) {//责任申请
			if ([self.valuationModel.purchaseType isEqualToString:@"XG"]) {//采购
				return ValuationEditDutyCGITNode;
			}else if ([self.valuationModel.purchaseType isEqualToString:@"SJ"]){//升级
				return ValuationEditDutySJITNode;
			}else{
				return ValuationEditDutySJAndCG;
			}
		}
		
		
	}else{
		return ValuationEditNone;
	}
	
	return ValuationEditNone;
}
- (ValuationFlowType)getValuationFlowType {
	if ([self.flowModel.processDefinitionKey isEqualToString:@"valuation-apply"]) {//计价软件个人申请
		
		if ([self.valuationModel.applyType isEqualToString:@"SY"]) {//使用
			return ValuationFlowPersonSY;
		}else{//升级
			return ValuationFlowPersonSJ;
		}
	}
	
	if ([self.flowModel.processDefinitionKey isEqualToString:@"valuation-administrators-apply"]) {//责任申请
		// "purchaseType": "XG",//采购类型  SJ 升级  XG 新购 SJJXG 升级+新购
		if ([self.valuationModel.purchaseType isEqualToString:@"XG"]) {//采购
			return ValuationFlowDutyCG;
		}else if([self.valuationModel.purchaseType isEqualToString:@"SJ"]){//升级
			return ValuationFlowDutySJ;
		}else{//SJJXG
			return ValuationFlowDutySJAndCG;
		}
	}
	return ValuationFlowNone;
}

- (void)editValuationComeplete:(fetchDataCompleteBlock)comepleteBlock failue:(fetchDataFailueBlock)failueBlock {

	[self.paraArray removeAllObjects];
	[self.paraArray addObjectsFromArray:self.sqArray];
	[self.paraArray addObjectsFromArray:self.sjArray];
	[self.paraArray addObjectsFromArray:self.xgArray];
	
	if (!self.paraArray.count && [self getValuationEditType] != ValuationEditNone) {
		failueBlock(@"请先编辑");
		return;
	}
	
	
	if ([self getValuationEditType] == ValuationEditPersonSYDepartNode || [self getValuationEditType] == ValuationEditPersonSJDepartNode) {
		for (NSDictionary *dic in self.paraArray) {
			if (![dic[@"handleType"] length]) {
				failueBlock(@"请先选择处理方式");
			    return;
			}
		}
		
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationApplyInfos) {
//			if (!softModel.handleType.length) {
//				failueBlock(@"请先选择处理方式");
//				return;
//			}
//		}
//
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationSJApplyInfos) {
//			if (!softModel.handleType.length) {
//				failueBlock(@"请先选择处理方式");
//				return;
//			}
//		}
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationXGApplyInfos) {
//			if (!softModel.handleType.length) {
//				failueBlock(@"请先选择处理方式");
//				return;
//			}
//		}
		
	}else if ([self getValuationEditType] == ValuationEditPersonSYITNode || [self getValuationEditType] == ValuationEditDutyCGITNode){
		for (NSDictionary *dic in self.paraArray) {
			if (![dic[@"lockNumber"] length]) {
				failueBlock(@"请先选择锁号");
					return;
			}
			if ([dic[@"purchMoney"] floatValue] <= 0) {
				failueBlock(@"请先填写采购金额");
				 return;
			}
		}
		
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationApplyInfos) {
//			if (softModel.purchMoney <= 0) {
//				failueBlock(@"请先填写采购金额");
//				return;
//			}
//			if (!softModel.lockNumber.length) {
//				failueBlock(@"请先选择锁号");
//				return;
//			}
//		}
//
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationSJApplyInfos) {
//			if (softModel.purchMoney <= 0) {
//				failueBlock(@"请先填写采购金额");
//				return;
//			}
//			if (!softModel.lockNumber.length) {
//				failueBlock(@"请先选择锁号");
//				return;
//			}
//		}
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationXGApplyInfos) {
//			if (softModel.purchMoney <= 0) {
//				failueBlock(@"请先填写采购金额");
//				return;
//			}
//			if (!softModel.lockNumber.length) {
//				failueBlock(@"请先选择锁号");
//				return;
//			}
//		}
	}else if ([self getValuationEditType] == ValuationEditPersonSJITNode || [self getValuationEditType] == ValuationEditDutySJITNode){
		for (NSDictionary *dic in self.paraArray) {
			
			if ([dic[@"purchMoney"] floatValue] <= 0) {
				failueBlock(@"请先填写采购金额");
				return;
			}
		}
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationApplyInfos) {
//			if (softModel.purchMoney <= 0) {
//				failueBlock(@"请先填写采购金额");
//				return;
//			}
//		}
//
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationSJApplyInfos) {
//			if (softModel.purchMoney <= 0) {
//				failueBlock(@"请先填写采购金额");
//				return;
//			}
//
//		}
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationXGApplyInfos) {
//			if (softModel.purchMoney <= 0) {
//				failueBlock(@"请先填写采购金额");
//				return;
//			}
//		}
	}else if ([self getValuationEditType] == ValuationEditDutySJAndCG){
		for (NSDictionary *dic in self.paraArray) {
			if (![dic[@"lockNumber"] length]) {
				failueBlock(@"请先选择锁号");
				return;
			}
			if ([dic[@"purchMoney"] floatValue] <= 0) {
				failueBlock(@"请先填写软件升级采购金额");
				return;
			}
		}
//		for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationSJApplyInfos) {
//			if (softModel.purchMoney <= 0) {
//				failueBlock(@"请先填写软件升级采购金额");
//				return;
//			}
//
//			for (YSFlowSoftUpdateModel *softModel in self.valuationModel.valuationXGApplyInfos) {
//				if (softModel.purchMoney <= 0) {
//					failueBlock(@"请先填写采购金额");
//					return;
//				}
//				if (!softModel.lockNumber.length) {
//					failueBlock(@"请先选择锁号");
//					return;
//				}
//			}
//
//		}
	}
	
	
	//提交修改
	if ([self getValuationEditType] == ValuationEditNone) {
		comepleteBlock();
	}else{
		NSDictionary *paraDic = @{@"id":self.valuationModel.id,
								  @"datas":[self getJsonString:self.paraArray],
								  };
		[YSNetManager ys_request_POSTWithUrlString:[NSString stringWithFormat:@"%@%@",YSDomain,saveValuationGRXZsp] isNeedCache:NO parameters:paraDic successBlock:^(id response) {
			if ([response[@"code"] intValue] == 1) {
				comepleteBlock();
				
			}
		} failureBlock:^(NSError *error) {
			failueBlock(@"提交失败");
		} progress:nil];
	}
	
	
	
	
}


- (NSString *)getJsonString:(NSArray *)array {
	if (!array) {
		return nil;
	}
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:(NSJSONWritingPrettyPrinted) error:nil];
	NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
	return jsonStr;
}
@end
