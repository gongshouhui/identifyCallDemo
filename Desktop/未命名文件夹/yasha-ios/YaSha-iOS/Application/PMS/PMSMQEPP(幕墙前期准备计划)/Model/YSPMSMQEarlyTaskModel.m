//
//  YSPMSMQEarlyTaskModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/2.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQEarlyTaskModel.h"

@implementation YSPMSMQEarlyTaskModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"planPrepareStageList" : [YSPMSMQEarlyChildTaskModel class]};
}
@end
@implementation YSPMSMQEarlyChildTaskModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"files" : [YSPMSImageModel class]};
}
@end
@implementation YSPMSImageModel

@end

