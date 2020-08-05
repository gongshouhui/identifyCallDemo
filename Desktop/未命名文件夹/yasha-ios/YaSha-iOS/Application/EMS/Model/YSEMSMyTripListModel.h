//
//  YSEMSMyTripListModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/14.
//

#import <Foundation/Foundation.h>

@interface YSEMSMyTripListModel : NSObject

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *businessPname;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *businessDay;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *processInstanceId;
@property (nonatomic, strong) NSArray *businessTripList;

@end

@interface YSEMSMyTripSubListModel : NSObject

@property (nonatomic, strong) NSString *businessArea;
@property (nonatomic, strong) NSString *startProvince;
@property (nonatomic, strong) NSString *startCity;
@property (nonatomic, strong) NSString *endProvince;
@property (nonatomic, strong) NSString *endCity;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *businessId;

@end
