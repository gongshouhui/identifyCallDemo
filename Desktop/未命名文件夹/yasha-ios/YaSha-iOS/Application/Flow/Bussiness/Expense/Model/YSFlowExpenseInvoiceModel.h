//
//  YSFlowExpenseInvoiceModel.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSNewsAttachmentModel.h"
@interface YSFlowExpenseInvoiceModel : NSObject
@property (nonatomic, strong) NSString *id;
/**价税合计金额*/
@property (nonatomic, assign) CGFloat actualTax;
/**不含税金额*/
@property (nonatomic, assign) CGFloat exTaxAmount;
/**价税合计金额*/
@property (nonatomic, assign) CGFloat taxAmountTatol;
@property (nonatomic, assign) NSInteger delFlag;
/**发票类型*/
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *updator;
/**不含税金额*/
@property (nonatomic, assign) CGFloat amount;
/**对方单位名称*/
@property (nonatomic, strong) NSString *orgName;
/**发票章单位*/
@property (nonatomic,strong) NSString *drawer;
/**纳税人识别号*/
@property (nonatomic,strong) NSString *taxpayerNum;
/**发票日期*/
@property (nonatomic, strong) NSString *invoiceDate;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic, strong) NSString *type;
/**发票代码*/
@property (nonatomic, strong) NSString *code;
/**发票号码*/
@property (nonatomic,strong) NSString *invoiceNum;
@property (nonatomic, strong) NSString *creator;
/**发票号码*/
@property (nonatomic, strong) NSString *num;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSString *expAccountDetailId;

@property (nonatomic, strong) NSString *taxRate;
/**税率*/
@property (nonatomic, strong) NSString *taxRateStr;

@property (nonatomic, strong) NSArray *fileList;
@property (nonatomic,strong) NSArray *mobileFiles;
@end
