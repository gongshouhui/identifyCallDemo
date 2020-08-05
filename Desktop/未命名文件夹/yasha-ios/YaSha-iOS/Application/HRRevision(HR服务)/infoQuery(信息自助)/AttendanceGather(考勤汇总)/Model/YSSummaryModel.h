//
//  YSSummaryModel.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/10.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSSummaryModel : NSObject
/**10:请假;20:出差;30:因公外出;40:加班;50:忘记打卡;70或者80:迟到早退;110:旷工*/
@property (nonatomic,assign) NSInteger type;
/**迟到早退时间*/
@property (nonatomic,strong) NSString *sdate;
/**迟到早退时间*/
@property (nonatomic,assign) NSInteger lateOrLeaveEarlyMinutes;
/**请假时长*/
@property (nonatomic,strong) NSString *day;
/**旷工时间*/
@property (nonatomic,strong) NSString *absenteeismDay;
@property (nonatomic, strong) NSString *shouldWorkday; //应出勤天数
@property (nonatomic, strong) NSString *normalWorkday; //正常出勤天数
@property (nonatomic, strong) NSString *attendance; //出勤率
@property (nonatomic, assign) double avgWorkHour;//平均工作时长

@property (nonatomic, strong) NSString *leaveCount; //请假次数
@property (nonatomic, strong) NSString *travelCount; //出差次数
@property (nonatomic, strong) NSString *goOutCount; //因公外出次数
@property (nonatomic, strong) NSString *lateOrEarlyleave; //迟到/早退次数
@property (nonatomic, strong) NSString *absenteeismCount; //旷工次数
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *startTime;//开始时间
@property (nonatomic, strong) NSString *endTime;//结束时间
@property (nonatomic, strong) NSString *absenteeismTime;//旷工时间
@property (nonatomic, strong) NSString *billCode;//流程key
@property (nonatomic, strong) NSString *billId;
@property (nonatomic, assign) NSInteger subType;//请假的子类型
@property (nonatomic, strong) NSString *subTypeStr;
@property (nonatomic, strong) NSString *jiaBanCount;//加班 应该用整型 预防返回是null
// HR管理者
@property (nonatomic, strong) NSString *name;//人名
@property (nonatomic, strong) NSString *time;//时间
@property (nonatomic, strong) NSString *typeTime;//迟到时长
@property (nonatomic, strong) NSString *personCode;
@property (nonatomic, strong) NSString *hour;//时长
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *headImage;


@end

NS_ASSUME_NONNULL_END
