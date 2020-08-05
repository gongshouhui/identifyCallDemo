//
//  YSSupplyBidDetailModel.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSupplyBidDetailModel.h"

@implementation YSSupplyBidDetailModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"mobileFiles":[YSNewsAttachmentModel class],
             @"mobileFilesList":[YSNewsAttachmentModel class],
             @"mobileFilesQpList":[YSNewsAttachmentModel class],
             };
}
@end

