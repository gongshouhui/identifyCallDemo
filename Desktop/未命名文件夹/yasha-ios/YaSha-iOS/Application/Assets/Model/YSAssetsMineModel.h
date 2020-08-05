//
//  YSAssetsMineModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/13.
//
//

#import <Foundation/Foundation.h>

@interface YSAssetsMineModel : NSObject

@property (nonatomic, strong) NSString *assetsStatusStr;  // 资产状态
@property (nonatomic, strong) NSString *goodsLevelName;  // 资产等级
@property (nonatomic, strong) NSString *proModel;  // 产品型号
@property (nonatomic, strong) NSString *goodsName;  // 资产名
@property (nonatomic, strong) NSString *assetsNo;  // 资产编码
@property (nonatomic, strong) NSString *id;  // 资产id
@property (nonatomic, strong) NSString *filePath;  // 资产图片地址
@property (nonatomic, assign) int assetsStatus;

@end
