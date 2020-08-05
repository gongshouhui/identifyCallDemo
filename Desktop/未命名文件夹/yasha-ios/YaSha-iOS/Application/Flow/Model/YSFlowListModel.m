//
//  YSFlowListModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/25.
//

#import "YSFlowListModel.h"

@implementation YSFlowListModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _flowStatus = [self transFormFlowStringToIntWithString:dic[@"flowStatus"]];
    return YES;
}
- (NSInteger)transFormFlowStringToIntWithString:(NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {//防止后台类型是int
        if ([string isEqualToString:@"SPZ"]) {
            return FlowHandleStatusSPZ;
        }
        if ([string isEqualToString:@"BH"]) {
            return FlowHandleStatusBH;
        }
        if ([string isEqualToString:@"CH"]) {
            return FlowHandleStatusCH;
        }
        if ([string isEqualToString:@"JQ"]) {
            return FlowHandleStatusJQ;
        }
        if ([string isEqualToString:@"ZC"]) {
            return FlowHandleStatusZC;
        }
        if ([string isEqualToString:@"ZB"]) {
            return FlowHandleStatusZB;
        }
        if ([string isEqualToString:@"BJ"]) {
            return FlowHandleStatusBJ;
        }
        if ([string isEqualToString:@"ZZ"]) {
            return FlowHandleStatusZZ;
        }
        return 0;
    }else{
        return string;
    }
}

@end
