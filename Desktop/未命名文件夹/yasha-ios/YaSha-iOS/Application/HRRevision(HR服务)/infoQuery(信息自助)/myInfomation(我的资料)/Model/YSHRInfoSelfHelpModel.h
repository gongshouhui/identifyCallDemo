//
//  YSInfoSelfHelpModel.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/12.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSPersonalInformationModel.h"
#import "YSHRProfileModel.h"
#import "YSHREduModel.h"
#import "YSHRFamilyModel.h"
#import "YSHRLanguageModel.h"
#import "YSHRLinkManModel.h"
@interface YSHRInfoSelfHelpModel : NSObject
@property (nonatomic, strong) NSArray *familys;

/**
 语言
 */
@property (nonatomic, strong) NSArray *langs;

/**
 紧急联系人
 */
@property (nonatomic, strong) NSArray *linkmans;

/**
 个人基本信息
 */
@property (nonatomic, strong) YSPersonalInformationModel *cover;

/**
 个人信息
 */
@property (nonatomic, strong) YSHRProfileModel *profile;

/**
 学历
 */
@property (nonatomic, strong) YSHREduModel *edus;

///**
// 组织
// */
@property (nonatomic, strong) NSArray *psnorgs;
/**
 入职信息
 */
@property (nonatomic, strong) NSDictionary *entry;

@end
