//
//  YSNewsAttachmentModel.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/30.
//

#import "YSNewsAttachmentModel.h"

@implementation YSNewsAttachmentModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([dic[@"fileSize"] isKindOfClass:[NSString class]]) {
        _fileSize = [dic[@"fileSize"] floatValue];
    }
    return YES;
}

@end
