//
//  YSFlowGoodsApplyModel.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YSFlowGoodsDetailModel : NSObject
@property (nonatomic,strong) NSString *goodsNo;
@property (nonatomic,strong) NSString *brandName;
@property (nonatomic,strong) NSString *proModel;
@property (nonatomic,strong) NSString *buyUnit;
@property (nonatomic,assign) CGFloat totalPrice;
@property (nonatomic,strong) NSString *feeTypeStr;
@property (nonatomic,strong) NSString *remark;

@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,strong) NSString *thirdCate;
@property (nonatomic,assign) NSInteger applyNumber;
@property (nonatomic,assign) CGFloat refPrice;
@end
@interface YSFlowGoodsApplyModel : NSObject
@property (nonatomic,strong) NSString *applyManName;
@property (nonatomic,strong) NSString *useManName;
@property (nonatomic,strong) NSString *useCompany;
@property (nonatomic,strong) NSString *useDept;

@property (nonatomic,strong) NSString *useManLevel;
@property (nonatomic,strong) NSString *projectDirectorName;
@property (nonatomic,strong) NSString *ownProject;

@property (nonatomic,strong) NSString *managerName;
@property (nonatomic,strong) NSString *proNature;
@property (nonatomic,strong) NSString *projectAddress;
@property (nonatomic,strong) NSString *recipient;
@property (nonatomic,strong) NSString *recipientTel;
@property (nonatomic,strong) NSString *reason;


@property (nonatomic,assign) CGFloat companyFee;
@property (nonatomic,assign) CGFloat projectFee;
@property (nonatomic,assign) CGFloat laborClassFee;
@property (nonatomic,assign) CGFloat totalPrice;
@property (nonatomic,strong) NSArray *applyInfos;
@property (nonatomic,strong) NSArray *fileListFormMobile;


@end

NS_ASSUME_NONNULL_END
