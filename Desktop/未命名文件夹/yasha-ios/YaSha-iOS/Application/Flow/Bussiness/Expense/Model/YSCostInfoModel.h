//
//  YSCostInfoModel.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/15.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YSCostInfoModelDetail : NSObject
/**税额*/
@property (nonatomic,assign) CGFloat actualTax;
/**数量*/
@property (nonatomic,assign) NSInteger amount;
/**不含税金额*/
@property (nonatomic,assign) CGFloat exTaxAmount;
@property (nonatomic,strong) NSString *name;
/**规格型号*/
@property (nonatomic,strong) NSString *specModel;
/**价税金额*/
@property (nonatomic,assign) CGFloat taxAmountTatol;
/**税率*/
@property (nonatomic,strong) NSString *taxRate;
/**单位*/
@property (nonatomic,strong) NSString *unit;
/**单价*/
@property (nonatomic,assign) CGFloat unitPrice;
@end

@interface YSCostInfoModel : NSObject
@property (nonatomic,strong) YSCostInfoModelDetail *info;
@property (nonatomic,strong) NSString *name;
/**价税金额*/
@property (nonatomic,assign) CGFloat taxAmountTatol;
@end



