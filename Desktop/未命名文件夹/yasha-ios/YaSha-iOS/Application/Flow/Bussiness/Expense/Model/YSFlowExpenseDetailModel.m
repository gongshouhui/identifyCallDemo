//
//  YSFlowExpenseDetailModel.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/18.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowExpenseDetailModel.h"
#import "YSNewsAttachmentModel.h"
@implementation YSFlowExpenseDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"info" : [YSFlowExpenseCostDetailModel class]};
}
@end
@implementation YSFlowExpenseCostDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"mobileFiles" : [YSNewsAttachmentModel class]};
}
- (NSString *)startTime {
    if (!_startTime) {
        _startTime = @"";
    }else {
        _startTime = [YSUtility timestampSwitchTime:_startTime andFormatter:@"yyyy-MM-dd"];
    }
    return _startTime;
}
- (NSString *)endTime {
    if (!_endTime) {
        _endTime = @"";
    }else {
        _endTime = [YSUtility timestampSwitchTime:_endTime andFormatter:@"yyyy-MM-dd"];
    }
    return _endTime;
}
- (NSString *)startAreaStr {
    if (!_startAreaStr) {
        _startAreaStr = @"";
    }
    return _startAreaStr;
}
- (NSString *)endAreaStr {
    if (!_endAreaStr) {
        _endAreaStr = @"";
    }
    return _endAreaStr;
}
- (NSString *)seatGradeStr {
    if (!_seatGradeStr) {
        _seatGradeStr = @"";
    }
    return _seatGradeStr;
}
- (NSString *)buyModeStr {
    if (!_buyModeStr) {
        _buyModeStr = @"";
    }
    return _buyModeStr;
}
- (NSString *)invoiceNum {
    if (!_invoiceNum) {
        _invoiceNum = @"";
    }
    return _invoiceNum;
}
- (NSString *)proName {
    if (!_proName) {
        _proName = @"";
    }
    return _proName;
}
- (NSString *)proTypeStr {
    if (!_proTypeStr) {
        _proTypeStr = @"无";
    }
    return _proTypeStr;
}
- (NSString *)remark {
    if (!_remark) {
        _remark = @"";
    }
    return _remark;
}
- (NSString *)warningMsg {
    if (!_warningMsg) {
        _warningMsg = @"";
    }
    return _warningMsg;
}
@end
