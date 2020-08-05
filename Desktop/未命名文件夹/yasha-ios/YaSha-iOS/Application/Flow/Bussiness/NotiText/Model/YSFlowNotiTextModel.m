//
//  YSFlowNotiTextModel.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowNotiTextModel.h"
#import "YSNewsAttachmentModel.h"
@implementation YSFlowNotiTextModel

@end
@implementation YSFlowNotiTextListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"fileList" : [YSNewsAttachmentModel class]
             
             };
}
@end
