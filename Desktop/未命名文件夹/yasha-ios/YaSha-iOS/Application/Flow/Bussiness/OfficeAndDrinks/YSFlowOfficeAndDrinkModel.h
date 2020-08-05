//
//  YSFlowOfficeAndDrinkModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YSFlowOfficeAndDrinkApplyInfoModel : NSObject
@property (nonatomic,strong) NSString *applyManName;
@property (nonatomic,strong) NSString *useManName;
@property (nonatomic,strong) NSString *useCompany;
@property (nonatomic,strong) NSString *useDept;
@property (nonatomic,strong) NSString *useManLevel;
@property (nonatomic,strong) NSString *useManParentDept;
@property (nonatomic,strong) NSString *demandDateStr;
@property (nonatomic,strong) NSString *demandContent;
@property (nonatomic,strong) NSString *reason;
@property (nonatomic,strong) NSArray *fileListFormMobile;
@property (nonatomic,strong) NSString *acceptMode;
@property (nonatomic,strong) NSString *receiveMoney;
@property (nonatomic,strong) NSString *prospectMoney;
@property (nonatomic,assign) NSInteger purchaseNumber;
@property (nonatomic,assign) NSInteger actualPurchaseNumber;
@property (nonatomic,strong) NSString *actualPurchaseMoney;
@property (nonatomic,strong) NSString *id;


@end
@interface YSFlowOfficeAndDrinkModel : NSObject
@property (nonatomic,strong)YSFlowOfficeAndDrinkApplyInfoModel*apply;
@property (nonatomic,assign) BOOL isEditData;
@property (nonatomic,strong) NSString *activityName;
@end

NS_ASSUME_NONNULL_END
