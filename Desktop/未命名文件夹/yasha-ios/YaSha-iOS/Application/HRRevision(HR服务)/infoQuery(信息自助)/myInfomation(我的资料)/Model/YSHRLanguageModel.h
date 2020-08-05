//
//  YSLanguageModel.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSHRLanguageModel : NSObject

/**
 证书编码
 */
@property (nonatomic,strong) NSString *certifcode;

/**
 获证日期
 */
@property (nonatomic,strong) NSString *certifdate;

/**
 证书名字
 */
@property (nonatomic,strong) NSString *certifname;
@property (nonatomic,strong) NSString *langlev;

/**
 熟练度
 */
@property (nonatomic,strong) NSString *langskill;

/**
 语言
 */
@property (nonatomic,strong) NSString *langsort;


@end
