//
//  YSValuationSoftwareDetailViewModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSValuationSoftwareDetailViewModel.h"
#import "YSValuationSoftWareUpdateDetailController.h"
#import "YSFlowValSoftWareEditController.h"
#import "YSValuationSoftUseInfoController.h"
@interface YSValuationSoftwareDetailViewModel()
@property (nonatomic,strong) NSMutableArray *applyInfoArr;
@property (nonatomic,assign) ValuationFlowType flowType;
@property (nonatomic,strong) NSString *ValuationFormID;
/**待提交数据*/
@property (nonatomic,strong) NSMutableArray *paraArr;
@end
@implementation YSValuationSoftwareDetailViewModel
- (NSMutableArray *)paraArr {
	if (!_paraArr) {
		_paraArr = [NSMutableArray array];
	}
	return _paraArr;
}
- (NSMutableArray *)viewDataArr {
	if (!_viewDataArr) {
		_viewDataArr = [NSMutableArray array];
	}
	return _viewDataArr;
}
- (id)initWithValuationValuationFormID:(NSString *)valuationFormID EditType:(ValuationEditType)editType applyInfo:(NSMutableArray*)applyInfo valuationFlowType:(ValuationFlowType)valuationFlowType{
	if (self = [super init]) {
		self.editType = editType;
		self.flowType = valuationFlowType;
		self.applyInfoArr = applyInfo;
		self.ValuationFormID = valuationFormID;
		[self setUpData];
	}
	return self;
}
- (void)setUpData {
	[self.viewDataArr removeAllObjects];
	for (YSFlowSoftUpdateModel *softModel in self.applyInfoArr) {
		NSMutableArray *infoArray = [NSMutableArray array];
		NSString *title = [NSString stringWithFormat:@"软件（%ld）",([self.applyInfoArr indexOfObject:softModel] + 1)];
		if (self.editType == ValuationEditNone) {//无编辑
				NSString *title = [NSString stringWithFormat:@"软件（%ld）",([self.applyInfoArr indexOfObject:softModel] + 1)];
			[infoArray addObject:@{@"title":title,@"special":@(BussinessFlowCellHeadWhite)}];
		}else{
		
			[infoArray addObject:@{@"title":title,@"special":@(BussinessFlowCellEdit)}];
		}
			
//			switch (self.editType) {
//				case ValuationEditPersonSYDepartNode:
					if ([softModel.handleType isEqualToString:@"CG"]) {
						[infoArray addObject:@{@"title":@"处理方式",@"content":@"采购"}];
					}
					if ([softModel.handleType isEqualToString:@"DB"]) {
						[infoArray addObject:@{@"title":@"处理方式",@"content":@"调拨"}];
					}
//					break;
//					case ValuationEditPersonSJDepartNode:
//					if ([softModel.handleType isEqualToString:@"CG"]) {
//						[infoArray addObject:@{@"title":@"处理方式",@"content":@"采购"}];
//					}
//					if ([softModel.handleType isEqualToString:@"DB"]) {
//						[infoArray addObject:@{@"title":@"处理方式",@"content":@"调拨"}];
//					}
//					break;
//				case ValuationEditPersonSYITNode:
					if (softModel.lockNumber.length) {
						[infoArray addObject:@{@"title":@"锁号",@"content":softModel.lockNumber}];
					}
					if (softModel.purchMoney > 0) {
						[infoArray addObject:@{@"title":@"采购金额（元）",@"content":[NSString stringWithFormat:@"%.2f",softModel.purchMoney]}];
					}
					
//					break;
//					case ValuationEditDutyCGITNode:
//					if (softModel.lockNumber.length) {
//						[infoArray addObject:@{@"title":@"锁号",@"content":softModel.lockNumber}];
//					}
//					if (softModel.purchMoney > 0) {
//						[infoArray addObject:@{@"title":@"采购金额（元）",@"content":[NSString stringWithFormat:@"%.2f",softModel.purchMoney]}];
//					}
//					break;
//				case ValuationEditPersonSJITNode:
//					if (softModel.purchMoney > 0) {
//						[infoArray addObject:@{@"title":@"采购金额（元）",@"content":[NSString stringWithFormat:@"%.2f",softModel.purchMoney]}];
//					}
//					break;
//					case ValuationEditDutySJITNode:
//					if (softModel.purchMoney > 0) {
//						[infoArray addObject:@{@"title":@"采购金额（元）",@"content":[NSString stringWithFormat:@"%.2f",softModel.purchMoney]}];
//					}
//					break;
//
//				default:
//					break;
//			}
//		}
		
		
		if (self.flowType == ValuationFlowDutySJ || self.flowType == ValuationFlowPersonSJ || self.flowType == ValuationFlowDutySJAndCG) {
			if (softModel.updatesJson.count) {
				[infoArray addObject:@{@"title":@"软件升级内容",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",softModel.updatesJson.count],@"file":softModel.updatesJson}];
			}
			
		}
		
		
		if (self.flowType == ValuationFlowDutySJ || self.flowType == ValuationFlowDutyCG || self.flowType == ValuationFlowDutySJAndCG) {
			if (softModel.useMsgJson.count) {
				[infoArray addObject:@{@"title":@"使用信息",@"special":@(BussinessFlowCellTurn),@"content":[NSString stringWithFormat:@"%ld",softModel.useMsgJson.count],@"file":softModel.useMsgJson}];
			}
			
		}
		[infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
		[infoArray addObject:@{@"title":@"软件品牌",@"special":@(BussinessFlowCellBG),@"content":softModel.brandName}];
		[infoArray addObject:@{@"title":@"软件类型",@"special":@(BussinessFlowCellBG),@"content":softModel.softwareTypeStr}];
		[infoArray addObject:@{@"title":@"软件版本" ,@"special":@(BussinessFlowCellBG),@"content":softModel.version}];
		[infoArray addObject:@{@"title":@"规格" ,@"special":@(BussinessFlowCellBG),@"content":softModel.proModelStr}];
		[infoArray addObject:@{@"title":@"配套服务",@"special":@(BussinessFlowCellBG),@"content":softModel.serviceStr}];
		if (self.flowType == ValuationFlowDutySJ || self.flowType == ValuationFlowDutyCG || self.flowType == ValuationFlowDutySJAndCG) {//责任申请
			
			if (![softModel.purchaseType isEqualToString:@"SJ"]) {
				if (softModel.nodeNumber > 0) {
					[infoArray addObject:@{@"title":@"节点数/个数",@"special":@(BussinessFlowCellBG),@"content":[NSString stringWithFormat:@"%ld",softModel.nodeNumber]}];
				}
				
				[infoArray addObject:@{@"title":@"地区与专业",@"special":@(BussinessFlowCellBG),@"content":softModel.professionsJsonName}];
				[infoArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellBG),@"content":softModel.remark}];
			}
		}else{//个人申请
			if (self.flowType == ValuationFlowPersonSY) {
				if (softModel.nodeNumber > 0) {
					[infoArray addObject:@{@"title":@"节点数/个数",@"special":@(BussinessFlowCellBG),@"content":[NSString stringWithFormat:@"%ld",softModel.nodeNumber]}];
				}
				
				[infoArray addObject:@{@"title":@"地区与专业",@"special":@(BussinessFlowCellBG),@"content":softModel.professionsJsonName}];
				[infoArray addObject:@{@"title":@"备注",@"special":@(BussinessFlowCellBG),@"content":softModel.remark}];
			}
		}
		if (softModel.lockNumber.length) {
			[infoArray addObject:@{@"title":@"锁号" ,@"special":@(BussinessFlowCellBG),@"content":softModel.lockNumber}];
		}
		
		[infoArray addObject:@{@"special":@(BussinessFlowCellEmpty)}];
		[self.viewDataArr addObject:infoArray];
	}
}
- (void)turnOtherViewControllerWith:(UIViewController *)viewController andIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *cellDic = self.viewDataArr[indexPath.section][indexPath.row];
	if ([cellDic[@"title"] isEqualToString:@"软件升级内容"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		YSValuationSoftWareUpdateDetailController *vc = [[YSValuationSoftWareUpdateDetailController alloc]init];
		vc.title = @"软件升级内容";
		vc.updateDataArr = cellDic[@"file"];
		[viewController.navigationController pushViewController:vc animated:YES];
	}
	if ([cellDic[@"title"] isEqualToString:@"使用信息"] && [cellDic[@"special"] integerValue] == BussinessFlowCellTurn) {
		YSValuationSoftUseInfoController *vc = [[YSValuationSoftUseInfoController alloc]init];
		vc.title = @"软件使用信息";
		vc.userArr = cellDic[@"file"];
		[viewController.navigationController pushViewController:vc animated:YES];
	}
	
	if ([cellDic[@"special"] integerValue] == BussinessFlowCellEdit) {
		YSFlowValSoftWareEditController *vc = [[YSFlowValSoftWareEditController alloc]init];
		vc.title = @"软件明细";
		vc.softwareModel = self.applyInfoArr[indexPath.section];
		vc.editType = self.editType;
		vc.formId = self.ValuationFormID;
		vc.editValuationSuccessBlock = ^(NSString * _Nonnull handleType, CGFloat purchMoney, NSString * _Nonnull lockNumber) {
			//改数据源
			YSFlowSoftUpdateModel *model = self.applyInfoArr[indexPath.section];
			if (model.handleType.length) {
				model.handleType = handleType;
				self.handType = handleType;
			}
			if (model.purchMoney > 0) {
				model.purchMoney = purchMoney;
				self.purchMoney = purchMoney;
			}
			if (model.lockNumber.length) {
				model.lockNumber = lockNumber;
				self.lockNumber = lockNumber;
			}
			self.applyInfoArr[indexPath.section] = model;
			[self setUpData];//刷新数据
		};
		[viewController.navigationController pushViewController:vc animated:YES];
	}
	
	
}
- (void)turnBack {
	[self.paraArr removeAllObjects];
	if (!(self.editType == ValuationEditNone)) {
		for (YSFlowSoftUpdateModel *softModel in self.applyInfoArr) {
			NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
			[paraDic setValue:softModel.id forKey:@"id"];
			[paraDic setValue:softModel.handleType forKey:@"handleType"];
			[paraDic setValue:@(softModel.purchMoney) forKey:@"purchMoney"];
			[paraDic setValue:softModel.lockNumber forKey:@"lockNumber"];
			[self.paraArr addObject:paraDic];
		}
		if (self.changeBlock) {
			self.changeBlock(self.paraArr);
		}
		
	}
	
}
@end
