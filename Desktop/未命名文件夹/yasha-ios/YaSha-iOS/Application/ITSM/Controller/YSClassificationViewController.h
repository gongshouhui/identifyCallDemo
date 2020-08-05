//
//  YSClassificationViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/1/29.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCommonViewController.h"
typedef void  (^myBlock)(NSString *classStr, NSString *linkCode, NSString *classCode, NSString *str);

@interface YSClassificationViewController : YSCommonViewController

@property (nonatomic,copy) myBlock block;
- (void)initPoints:(NSArray *)dataSourceArray;

@end
