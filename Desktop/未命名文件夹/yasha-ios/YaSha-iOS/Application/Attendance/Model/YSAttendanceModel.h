//
//  YSAttendanceModel.h
//  YaSha-iOS
//
//  Created by mHome on 2017/5/3.
//
//

#import <Foundation/Foundation.h>

@interface YSAttendanceModel : NSObject

@property(nonatomic,strong) NSString *sdate;

@property(nonatomic,strong) NSString *type;

//@property(nonatomic,assign) NSString *type;

@property(nonatomic,strong) NSString *lateStatus;

@property(nonatomic,strong) NSString *leaveEarlyStatus;

@property(nonatomic,strong) NSString *monNotPunch;

@property(nonatomic,strong) NSString *aftNotPunch;

@property(nonatomic,strong) NSString *monAbnormalFlow;

@property(nonatomic,strong) NSString *aftAbnormalFlow;

@property(nonatomic,strong) NSArray *staticDayList;

@property(nonatomic,strong) NSArray *flowDataList;

@property(nonatomic,strong) NSString *aftFlowStatus;

@property(nonatomic,strong) NSString *monFlowStatus;


@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *companyId;
@property(nonatomic,strong) NSString *deptId;
@property(nonatomic,strong) NSString *personId;
@property(nonatomic,strong) NSString *code;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *isWorkday;
@property(nonatomic,strong) NSString *startGwork;
@property(nonatomic,strong) NSString *endGwork;
@property(nonatomic,strong) NSString *startXwork;
@property(nonatomic,strong) NSString *endXwork;
@property(nonatomic,strong) NSString *startCwork;
@property(nonatomic,strong) NSString *endCwork;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,strong) NSString *creator;
@property(nonatomic,strong) NSString *updateTime;
@property(nonatomic,strong) NSString *updator;
@property(nonatomic,strong) NSString *delFlag;
@property (nonatomic, copy) NSString *startRwork;
@property (nonatomic, copy) NSString *endRwork;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *headImage;


@end
