//
//  YSMaterialInfoModel.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/29.
//

#import <Foundation/Foundation.h>

@interface YSMaterialInfoModel : NSObject
@property (nonatomic, strong) NSString *creator;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *mtrlFourId;

@property (nonatomic, strong) NSString *mtrlFourCode;

/**
 采购单位
 */
@property (nonatomic, strong) NSString *purUnit;

@property (nonatomic, strong) NSArray *ids;

/**
 材质
 */
@property (nonatomic, strong) NSString *quality;

/**
 备注
 */
@property (nonatomic, strong) NSString *remark;

/**
 辅助单位
 */
@property (nonatomic, strong) NSString *assistUnit;

@property (nonatomic, strong) NSString *unitCode;

@property (nonatomic, strong) NSString *updator;

@property (nonatomic, strong) NSString *mtrlType;

/**
 使用单位
 */
@property (nonatomic, strong) NSString *useCompany;

@property (nonatomic, strong) NSString *useCompanyname;

@property (nonatomic, strong) NSArray *snList;

/**
 材料类别3
 */
@property (nonatomic, strong) NSString *mtrlThree;

/**
 容量
 */
@property (nonatomic, strong) NSString *capacity;

@property (nonatomic, strong) NSString *groupBy;

/**
 规格
 */
@property (nonatomic, strong) NSString *standard;

/**
 材料编号
 */
@property (nonatomic, strong) NSString *no;

/**
 主单位
 */
@property (nonatomic, strong) NSString *unit;

@property (nonatomic, strong) NSString *mtrlOneId;

/**
 供货周期
 */
@property (nonatomic, strong) NSString *cycle;

@property (nonatomic, assign) NSInteger delFlag;

@property (nonatomic, strong) NSString *mtrlThreeCode;

/**
 品牌
 */
@property (nonatomic, strong) NSString *brand;

@property (nonatomic, strong) NSString *mtrlThreeId;

@property (nonatomic, strong) NSString *mtrlTwoCode;

@property (nonatomic, assign) NSInteger updateTime;

@property (nonatomic, strong) NSString *mtrlTwoId;

/**
 材料名称
 */
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray *files;

/**
 供方型号
 */
@property (nonatomic, strong) NSString *model;

@property (nonatomic, strong) NSString *assistUnitCode;

@property (nonatomic, strong) NSString *optType;

@property (nonatomic, strong) NSString *color;


/**
 采购转换率
 */
@property (nonatomic, assign) CGFloat purRate;
/**
 库存转换率
 */
@property (nonatomic, assign) CGFloat stockRate;
/**
 是否启用 10 启用 20 禁用
 */
@property (nonatomic, assign) NSInteger status;


/**
 材料类别4
 */
@property (nonatomic, strong) NSString *mtrlFour;

@property (nonatomic, strong) NSArray *threeMtrlId;

/**
 材料类别1
 */
@property (nonatomic, strong) NSString *mtrlOne;

@property (nonatomic, strong) NSString *materialTypeOrderType;

@property (nonatomic, strong) NSString *brandId;

@property (nonatomic, strong) NSString *mtrlOneCode;

@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, strong) NSString *purUnitCode;
@property (nonatomic, strong) NSString *useCompanyStr;
@property (nonatomic, strong) NSString *pack;

/**
 材料类别2
 */
@property (nonatomic, strong) NSString *mtrlTwo;
@end
