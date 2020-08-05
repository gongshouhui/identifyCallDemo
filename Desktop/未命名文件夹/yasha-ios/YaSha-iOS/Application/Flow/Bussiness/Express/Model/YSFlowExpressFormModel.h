//
//  YSFlowExpressFormModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/4.
//

#import <Foundation/Foundation.h>
#import "YSFlowFormModel.h"

@class YSFlowExpressFormModel, YSFlowFormModel, YSFlowExpressListModel;

@interface YSFlowExpressFormModel : NSObject

@property (nonatomic, strong) YSFlowFormHeaderModel *baseInfo;
@property (nonatomic, strong) YSFlowExpressListModel *info;

@end

@interface YSFlowExpressListModel : NSObject

@property (nonatomic, strong) NSString *businessType;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *senderMobile;
@property (nonatomic, strong) NSString *senderCompany;
@property (nonatomic, strong) NSString *senderAddress;

@property (nonatomic, strong) NSString *receiver;
@property (nonatomic, strong) NSString *receiverMobile;
@property (nonatomic, strong) NSString *receiverCompany;
@property (nonatomic, strong) NSString *receiverProvince;
@property (nonatomic, strong) NSString *receiverCity;
@property (nonatomic, strong) NSString *receiverArea;
@property (nonatomic, strong) NSString *receiverAddress;

@end
