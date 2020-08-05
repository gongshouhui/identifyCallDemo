//
//  YSPMSPlanImageListModel.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/10.
//

#import "YSPMSPlanImageListModel.h"

@implementation YSPMSPlanImageListModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    self.progress = [dic[@"Percent"] floatValue];
    return YES;
}
@end
