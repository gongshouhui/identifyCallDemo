//
//  YSFlowGoodsApplyModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowGoodsApplyModel.h"
#import "YSNewsAttachmentModel.h"
@implementation YSFlowGoodsApplyModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
	return @{@"applyInfos":[YSFlowGoodsDetailModel class],
			 @"fileListFormMobile":[YSNewsAttachmentModel class],
			 };
}
@end
@implementation YSFlowGoodsDetailModel

@end

