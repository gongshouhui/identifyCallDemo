//
//  YSMaterialInfoModel.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/29.
//

#import "YSMaterialInfoModel.h"
#import "YSMaterialImageModel.h"
@implementation YSMaterialInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"files" : [YSMaterialImageModel class]};
}
@end
