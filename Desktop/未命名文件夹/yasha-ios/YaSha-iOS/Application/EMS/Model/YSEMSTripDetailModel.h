//
//  YSEMSTripDetailModel.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/15.
//

#import <Foundation/Foundation.h>

@interface YSEMSTripDetailModel : NSObject

@property (nonatomic, strong) NSString *businessPname;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *businessNature;

@property (nonatomic, strong) NSString *jobLevelName;
@property (nonatomic, strong) NSString *areaCompany;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *proPerson;
@property (nonatomic, strong) NSString *proName;
@property (nonatomic, strong) NSString *proManagerName;
@property (nonatomic, strong) NSArray *businessTripList;

@end

@interface YSEMSTripDetailListModel : NSObject

@property (nonatomic, strong) NSString *businessArea;
@property (nonatomic, assign) NSInteger businessAreaCode;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *startAddress;
@property (nonatomic, strong) NSString *endCity;
@property (nonatomic, strong) NSString *endAddress;
@property (nonatomic, strong) NSString *proType;
@property (nonatomic, strong) NSString *proName;
@property (nonatomic, strong) NSString *tripMode;
@property (nonatomic, strong) NSString *buyTickets;
@property (nonatomic,strong) NSString *ownCompany;
@property (nonatomic,strong) NSString *proManagerName;
@property (nonatomic, strong) NSString *bookHotal;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *proNature;
@property (nonatomic, strong) NSString *orgName;


@end

