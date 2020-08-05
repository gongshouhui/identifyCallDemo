//
//  NSDictionary+PropertyCode.m
//
//  Copyright © 2015年 sunzhaoling. All rights reserved.
//

#import "NSDictionary+PropertyCode.h"

@implementation NSDictionary (PropertyCode)


// 自动生成属性代码
- (void)createPropetyCode
{
    // 模型中属性根据字典的key
    // 有多少个key,生成多少个属性
    NSMutableString *codes = [NSMutableString string];
    // 遍历字典
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSString *code = nil;
        
        if ([value isKindOfClass:[NSString class]]) {
          code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",key];
        } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        } else if ([value isKindOfClass:[NSNumber class]]) {
             code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
        } else if ([value isKindOfClass:[NSArray class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
        }
        
        // 拼接字符串
        [codes appendFormat:@"\n%@\n",code];

    }];
    
    
}
- (NSMutableArray *)NSDictionaryChangetoArrayWithHTTP
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in self.allKeys) {
        if ([self[key] isKindOfClass:[NSArray class]]) {
            for (NSString *value in self[key]) {
                [array addObject:key];
                [array addObject:value];
            }
        } else {
            [array addObject:key];
            [array addObject:self[key]];
        }
    }
    return array;
}

@end
