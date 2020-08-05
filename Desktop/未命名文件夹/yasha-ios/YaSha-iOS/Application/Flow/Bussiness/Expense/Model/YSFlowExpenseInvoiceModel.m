//
//  YSFlowExpenseInvoiceModel.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowExpenseInvoiceModel.h"

@implementation YSFlowExpenseInvoiceModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"mobileFiles":[YSNewsAttachmentModel class]};
}
//- (NSString *)invoiceDate {
//    if (!_invoiceDate) {
//        _invoiceDate = @"";
//    }else {
//        _invoiceDate = [YSUtility timestampSwitchTime:_invoiceDate andFormatter:@"yyyy-MM-dd"];
//    }
//    return _invoiceDate;
//}

@end
