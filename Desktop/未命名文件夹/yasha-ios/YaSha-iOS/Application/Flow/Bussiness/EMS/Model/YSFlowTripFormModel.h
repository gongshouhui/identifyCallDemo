//
//  YSFlowTripFormModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/6.
//

#import <Foundation/Foundation.h>
#import "YSFlowFormModel.h"

@class YSFlowExpressFormModel, YSFlowTripFormListModel;

@interface YSFlowTripFormModel : NSObject

@property (nonatomic, strong) YSFlowFormHeaderModel *baseInfo;
@property (nonatomic, strong) YSFlowTripFormListModel *info;

@end

@interface YSFlowTripFormListModel : NSObject

@property (nonatomic, strong) NSString *businessPname;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, strong) NSString *jobLevelName;
@property (nonatomic, strong) NSString *areaCompany;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *proPerson;
@property (nonatomic, strong) NSString *proName;
@property (nonatomic, strong) NSString *proManagerName;
@property (nonatomic, strong) NSArray *businessTripList;

@end

@interface YSFlowBusinessTripListModel : NSObject

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *startProvince;
@property (nonatomic, strong) NSString *startCity;
@property (nonatomic, strong) NSString *endProvince;
@property (nonatomic, strong) NSString *endCity;
@property (nonatomic, strong) NSString *buyTickets;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *proType;
@property (nonatomic, strong) NSString *proName;
@property (nonatomic, strong) NSString *tripMode;
@property (nonatomic, strong) NSString *bookHotal;

@end
