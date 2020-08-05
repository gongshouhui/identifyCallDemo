//
//  YSFlowExpensePexpShareModel.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/14.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSFlowExpensePexpShareModel : NSObject
/**总额*/
@property (nonatomic,assign) CGFloat money;

@property (nonatomic,strong) NSString *emsTypeName;
/**营销费用分摊详情*/
@property (nonatomic,strong) NSArray *marketShareDetailList;
/**分摊详情*/
@property (nonatomic,strong) NSArray *dShareDetailList;
/**费用分摊基本信息ID*/
@property (nonatomic,strong) NSString *id;
/**默认展开，所以no的状态是展开*/
@property (nonatomic,assign) BOOL isexpand;
@end

@interface YSFlowExpenseShareDetailModel : NSObject
/**费用分摊信息详情ID*/
@property (nonatomic,strong) NSString *id;
/**f费用归属公司*/
@property (nonatomic,strong) NSString *company;
/**部门*/
@property (nonatomic,strong) NSString *costOwnerDept;
/**费用归属人*/
@property (nonatomic,strong) NSString *costOwnerName;
@property (nonatomic,assign) CGFloat money;
/**公司承担*/
@property (nonatomic,assign) CGFloat compBear;
/**固定补贴*/
@property (nonatomic,assign) CGFloat fixedSubsidy;
/**非经营性费用*/
@property (nonatomic,assign) CGFloat noOperateCost;
/**经营性费用*/
//@property (nonatomic,assign) CGFloat exFinaOperateCost;
/**经营性费用*/
@property (nonatomic,assign) CGFloat operateCost;

@property (nonatomic,strong) NSMutableArray *detailItem;

//exFinaCompBear = "80.25";
//exFinaFixedSubsidy = 200;
//exFinaNoOperateCost = 170;
//exFinaOperateCost = 130;
@end
@interface YSFlowExpenseDetailItemModel : NSObject
/**经营性费用*/
@property (nonatomic,assign) CGFloat operateCost;
/**非经营性费用*/
@property (nonatomic,assign) CGFloat noOperateCost;
/**固定补贴费用*/
@property (nonatomic,assign) CGFloat fixedSubsidy;
/**公司承担费用*/
@property (nonatomic,assign) CGFloat compBear;

@end
