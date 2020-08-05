//
//  YSAttendanceDetailCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/19.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAttendanceDetailCell.h"
@interface YSAttendanceDetailCell()
@end
@implementation YSAttendanceDetailCell
- (void)setModel:(YSSummaryModel *)model {
    _model = model;
    
    self.attendTypeLb.text = [self getTypeStrWithAttendType:model.type withSubType:model.subType];
    self.timeLb.text = [self getTimeStrWithAttendType:model.type];
    self.dayLb.text = [self getDurationStrWithAttendType:model.type];
    
}
//10:请假;20:出差;30:因公外出;40:加班;50:忘记打卡;70或者80:迟到早退;110:旷工
- (NSString *)getTypeStrWithAttendType:(NSInteger)attendType withSubType:(NSInteger)subType{
    if (attendType == 10) {
        switch (subType) {
            case 10:
                return @"事假";
                break;
            case 20:
                return @"病假";
                break;
            case 30:
                return @"婚假";
                break;
            case 40:
                return @"产假";
                break;
            case 50:
                return @"哺乳假";
                break;
            case 60:
                return @"陪产假";
                break;
            case 70:
                return @"丧假";
                break;
            case 80:
                return @"工伤假";
                break;
            case 90:
                return @"调休";
                break;
            case 100:
                return @"其他";
                break;
            default:
                return @"请假";
                break;
        }
    }else {
        switch (attendType) {
            case 20:
                return @"出差";
                break;
            case 30:
                return @"因公外出";
                break;
            case 40:
                return @"加班";
                break;
            case 50:
                return @"忘记打卡";
                break;
            case 70:
                return @"迟到";
                break;
            case 80:
                return @"早退";
                break;
            case 110:
                return @"旷工";
                break;
            default:
                return nil;
                break;
        }

    }
    
}

- (NSString *)getTimeStrWithAttendType:(NSInteger)attendType{
    if (attendType == 70 || attendType == 80 ) {
        return [YSUtility timestampSwitchTime:_model.sdate andFormatter:@"yyyy-MM-dd"];
    }else if (attendType == 110){
         return [YSUtility timestampSwitchTime:_model.absenteeismTime andFormatter:@"yyyy-MM-dd"];
    }else if (attendType == 40){//加班
        return [NSString stringWithFormat:@"%@~%@",[YSUtility timestampSwitchTime:_model.startTime andFormatter:@"MM-dd HH:mm"],[YSUtility timestampSwitchTime:_model.endTime andFormatter:@"MM-dd HH:mm"]];
    }else{
        return [NSString stringWithFormat:@"%@~%@",[YSUtility timestampSwitchTime:_model.startTime andFormatter:@"yyyy-MM-dd"],[YSUtility timestampSwitchTime:_model.endTime andFormatter:@"yyyy-MM-dd"]];
    }
}
- (NSString *)getDurationStrWithAttendType:(NSInteger)attendType{
    if (attendType == 70 || attendType == 80 ) {
        return [NSString stringWithFormat:@"%ldm",_model.lateOrLeaveEarlyMinutes];
    }else if (attendType == 110){
        return [NSString stringWithFormat:@"%@d",_model.absenteeismDay.length?_model.absenteeismDay:@""];
    }else if (attendType == 40){//加班
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@d",_model.day.length?_model.day:@""];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
