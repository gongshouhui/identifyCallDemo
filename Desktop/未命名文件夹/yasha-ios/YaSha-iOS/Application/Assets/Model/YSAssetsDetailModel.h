//
//  YSAssetsDetailModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import <Foundation/Foundation.h>

@interface YSAssetsDetailModel : NSObject

@property (nonatomic, strong) NSString *assetsNo;    // 资产编码
@property (nonatomic, strong) NSString *goodsName;    // 资产名称
@property (nonatomic, strong) NSString *firstCateName;    // 物品分类1
@property (nonatomic, strong) NSString *secondCateName;    // 物品分类2
@property (nonatomic, strong) NSString *thirdCateName;    // 物品分类3
@property (nonatomic, strong) NSString *assetsStatusStr;    // 资产状态
@property (nonatomic, strong) NSString *proModel;    // 规格型号
@property (nonatomic, strong) NSString *goodsLevel;    // 物品等级
@property (nonatomic, strong) NSString *serialNo;    // 序列化
@property (nonatomic, strong) NSString *produDate;    // 生产日期
@property (nonatomic, strong) NSString *ownCompany;    // 所属公司
@property (nonatomic, strong) NSString *useMan;    // 使用人
@property (nonatomic, strong) NSString *useJobStation;    // 使用人岗位
@property (nonatomic, strong) NSString *useDept;    // 使用部门
@property (nonatomic, strong) NSString *useCompany;    // 使用公司
@property (nonatomic, strong) NSString *storePlace;    // 使用地点
@property (nonatomic, strong) NSString *scanType;
@property (nonatomic, strong) NSString *remark;    // 备注
@property (nonatomic, assign) BOOL hasRent;    // 是否租赁
@property (nonatomic, strong) NSString *filePath;  // 资产图片地址

@end
