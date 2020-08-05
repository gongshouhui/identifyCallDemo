//
//  YSFlowValuationViewModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBaseBussinessFlowViewModel.h"
typedef NS_ENUM(NSInteger, ValuationEditType) {
	ValuationEditNone = 0,//无编辑
	ValuationEditPersonSYDepartNode = 1,                         //计价软件个人申请使用所在部门资产管理员节点
	ValuationEditPersonSYITNode = 2,  //计价软件个人申请信息部资产管理员节点
	ValuationEditPersonSJDepartNode = 3,//计价软件个人升级部门资产管理员节点
	ValuationEditPersonSJITNode = 4,//计价软件个人升级信息部资产管理员节点
	ValuationEditDutyCGITNode = 5,  //计价软件责任申请新购信息部资产管理员节点
	ValuationEditDutySJITNode = 6,//计价软件责任升级信息部资产管理员节点
	ValuationEditDutySJAndCG = 7
	
};

//责任申请类型分为采购和借用，申请类型为采购时（采购类型g分为采购，升级，升级+采购），借用暂时不考虑
typedef NS_ENUM(NSInteger,ValuationFlowType) {
	ValuationFlowNone = 0,
	ValuationFlowPersonSY,//计价个人使用
	ValuationFlowPersonSJ,//f个人升级
	ValuationFlowDutyCG,//责任采购
	ValuationFlowDutySJ,//责任升级
	ValuationFlowDutySJAndCG,//责任升级加新购
	
};

NS_ASSUME_NONNULL_BEGIN

@interface YSFlowValuationViewModel : YSBaseBussinessFlowViewModel
- (void)editValuationComeplete:(fetchDataCompleteBlock)comepleteBlock failue:(fetchDataFailueBlock) failueBlock;
@end

NS_ASSUME_NONNULL_END
