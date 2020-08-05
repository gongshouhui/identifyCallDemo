//
//  YSFlowValuationModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/5.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowValuationModel.h"

@implementation YSFlowValuationModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
	return @{@"valuationApplyInfos":[YSFlowSoftUpdateModel class],
			 @"valuationSJApplyInfos":[YSFlowSoftUpdateModel class],
			 @"valuationXGApplyInfos":[YSFlowSoftUpdateModel class],
			 };
}
@end
@implementation YSFlowSoftUpdateModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
	NSString *updatesJson = dic[@"updatesJson"];
	//NSString *updatesJson =@"[{\"roperate\":\"delete\",\"demandTypeCode\":\"DESJ\",\"demandTypeName\":\"定额升级\",\"upgradeContent\":\"666\"}]";
	NSData *jsonData = [updatesJson dataUsingEncoding:NSUTF8StringEncoding];
NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
	_updatesJson = array;
	NSString *useMsgJson = dic[@"useMsgJson"];
	//NSString *updatesJson =@"[{\"roperate\":\"delete\",\"demandTypeCode\":\"DESJ\",\"demandTypeName\":\"定额升级\",\"upgradeContent\":\"666\"}]";
	NSData *useMsgData = [useMsgJson dataUsingEncoding:NSUTF8StringEncoding];
	NSArray *useMsgArray = [NSJSONSerialization JSONObjectWithData:useMsgData options:NSJSONReadingMutableContainers error:nil];
	_useMsgJson = useMsgArray;
	
	return YES;
}


@end
