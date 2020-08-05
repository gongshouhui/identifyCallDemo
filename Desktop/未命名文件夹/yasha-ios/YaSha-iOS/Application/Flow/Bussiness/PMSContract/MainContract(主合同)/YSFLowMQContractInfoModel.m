//
//  YSFLowMQContractInfoModel.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFLowMQContractInfoModel.h"
#import "YSNewsAttachmentModel.h"
@implementation YSFLowMQContractInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"contractInfo":[YSSubContractInfoModel class],
             @"contractManagement":[YSFLowMQContractManagementModel class],
             @"contractSupervision":[YSFLowMQContractSupervisionModel class],
             @"contractSealMaterial":[YSNewsAttachmentModel class],
             @"psFileListForMobile":[YSNewsAttachmentModel class],
             @"qtzlFileListForMobile":[YSNewsAttachmentModel class],
             @"contractLoaningList" :[YSFLowMQCheckPayInfo class],
             };
}
@end
@implementation YSSubContractInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"sealMaterialsForMobile":[YSNewsAttachmentModel class]
             };
}
@end
@implementation YSFLowMQContractManagementModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"crmdFileListForMobile":[YSNewsAttachmentModel class],
             };
}
@end
@implementation YSFLowMQContractSupervisionModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"filePszlListForMobile":[YSNewsAttachmentModel class],
             @"fileQtzlListForMobile":[YSNewsAttachmentModel class],
             };
}

@end
@implementation YSFLowMQContractCheckDeal

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"filePszlListForMobile":[YSNewsAttachmentModel class],
             @"fileQtzlListForMobile":[YSNewsAttachmentModel class],
             };
}

@end
@implementation YSFLowMQCheckPayInfo
@end

