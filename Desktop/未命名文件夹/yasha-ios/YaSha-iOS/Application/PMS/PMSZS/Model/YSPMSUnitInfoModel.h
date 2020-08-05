//
//  YSPMSUnitInfoModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/6.
//
//

#import <Foundation/Foundation.h>

@interface YSPMSUnitInfoModel : NSObject

@property (nonatomic, strong) NSString *name;//单位名称
@property (nonatomic, strong) NSArray *comPersons;//人员数组
@property (nonatomic, strong) NSString *creator;//责任人
@property (nonatomic, strong) NSString *mobile;//人员号码
@property (nonatomic, strong) NSString *typeStr;//单位类型


@end
