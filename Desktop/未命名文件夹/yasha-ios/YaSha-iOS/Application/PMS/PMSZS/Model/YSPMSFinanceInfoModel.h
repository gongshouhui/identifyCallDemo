//
//  YSPMSFinanceInfoModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/7.
//
//

#import <Foundation/Foundation.h>

@interface YSPMSFinanceInfoModel : NSObject

@property (nonatomic, strong) NSString *isPerBond;    //是否有保证金
@property (nonatomic, strong) NSString *perBondCurrency; //保证金的币种
@property (nonatomic, strong) NSString *perBondPrice;  //保证金金额
@property (nonatomic, strong) NSArray *letters;         //保函信息
@property (nonatomic, strong) NSArray *payments;        //付款信息

@end
