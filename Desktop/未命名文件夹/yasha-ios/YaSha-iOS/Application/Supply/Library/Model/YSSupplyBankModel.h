//
//  YSSupplyBankModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/3.
//

#import <Foundation/Foundation.h>

@interface YSSupplyBankModel : NSObject

@property (nonatomic, strong) NSString *code;//银行编码
@property (nonatomic, strong) NSString *name;//银行名称
@property (nonatomic, strong) NSString *account;//银行账号
@property (nonatomic, strong) NSString *accountName;//银行账户名称
@property (nonatomic, strong) NSString *isMainStr;//是否主要

@end
