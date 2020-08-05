//
//  YSClockTimeTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/10.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSClockTimeTableViewCell.h"
@interface YSClockTimeTableViewCell ()
@property (nonatomic,strong)UILabel *dayLabel;
@property (nonatomic,strong)UILabel *weekLabel;
@property (nonatomic,strong)UILabel *morningLabel;
@property (nonatomic,strong)UILabel *afternoonLabel;

@end

@implementation YSClockTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    self.dayLabel = [[UILabel alloc]init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"29"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size: 20],NSForegroundColorAttributeName: [UIColor colorWithRed:25/255.0 green:31/255.0 blue:37/255.0 alpha:1.0]}];
    
    self.dayLabel.attributedText = string;
    [self addSubview:self.dayLabel];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.mas_left).offset(26*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 24*kHeightScale));
    }];
    
    self.weekLabel = [[UILabel alloc]init];
    self.weekLabel.text = @"WED";
    self.weekLabel.font = [UIFont systemFontOfSize:9];
    self.weekLabel.textColor =[UIColor colorWithRed:24/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    [self addSubview:self.weekLabel];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dayLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(self.mas_left).offset(28*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(23*kWidthScale, 13*kHeightScale));
    }];
   
    // 新增分割线
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YSGAttLineImg"]];
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dayLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(18*kWidthScale, 50*kHeightScale));
    }];
    
    self.morningLabel = [[UILabel alloc]init];
    self.morningLabel.text = @"上班打卡: 09:00";
    self.morningLabel.font = [UIFont systemFontOfSize:14];
    self.morningLabel.textColor = kUIColor(25, 31, 37, 1);
    [self addSubview:self.morningLabel];
    [self.morningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.weekLabel.mas_right).offset(40*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 17*kHeightScale));
    }];
    
    self.afternoonLabel = [[UILabel alloc]init];
    self.afternoonLabel.text = @"下班打卡: 06:00";
    self.afternoonLabel.font = [UIFont systemFontOfSize:14];
    self.afternoonLabel.textColor = kUIColor(25, 31, 37, 1);
    [self addSubview:self.afternoonLabel];
    [self.afternoonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.morningLabel.mas_right).offset(40*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 17*kHeightScale));
    }];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.left.mas_equalTo(self.mas_right).offset(16);
        make.size.mas_equalTo(CGSizeMake(343*kWidthScale, 1));
    }];
    
    //新增的底部分割线
    UILabel *labLineBottm = [[UILabel alloc] init];
    labLineBottm.backgroundColor = kUIColor(242, 242, 242, 1);
    [self addSubview:labLineBottm];
    [labLineBottm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

- (void)setClockTimeData:(NSDictionary *)dic {
	
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[YSUtility timestampSwitchTime:dic[@"day"] andFormatter:@"dd"] attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size: 20],NSForegroundColorAttributeName: [UIColor colorWithRed:25/255.0 green:31/255.0 blue:37/255.0 alpha:1.0]}];
    self.dayLabel.attributedText = string;
    self.weekLabel.text = [self getWeekDay:dic[@"day"]];
    if ([dic[@"sb"] length]>0) {
        self.morningLabel.text = [NSString stringWithFormat:@"上班打卡: %@",dic[@"sb"]];
    }else{
        self.morningLabel.text = @"--";
    }
    if ([dic[@"xb"] length]>0) {
        self.afternoonLabel.text = [NSString stringWithFormat:@"下班打卡: %@",dic[@"xb"]];
    }else{
        self.afternoonLabel.text = @"--";
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (NSString*)getWeekDay:(NSString*)currentStr{
	
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[currentStr doubleValue]];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周六", @"周日", @"周一", @"周二", @"周三", @"周四", @"周五",  nil];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//
//    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nd];
//    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[currentStr doubleValue]];
//    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null],@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",nil];
//
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
//
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//
//    [calendar setTimeZone: timeZone];
//
//    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
//
//    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:nd];
   
    
    return [weekdays objectAtIndex:theComponents.weekday==7?7:7-theComponents.weekday];
    
}
  

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
