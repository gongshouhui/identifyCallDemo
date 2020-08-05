//
//  NSDictionary+PropertyCode.h
//
//  Copyright © 2015年 sunzhaoling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PropertyCode)

// 生成属性代码
- (void)createPropetyCode;
// httpBody传输数组
- (NSMutableArray *)NSDictionaryChangetoArrayWithHTTP;
@end
