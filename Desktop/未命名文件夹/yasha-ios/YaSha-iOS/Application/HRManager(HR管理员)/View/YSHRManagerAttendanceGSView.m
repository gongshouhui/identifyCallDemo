//
//  YSHRManagerAttendanceGSView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/1.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerAttendanceGSView.h"


@interface YSHRManagerAttendanceGSView ()


@end

@implementation YSHRManagerAttendanceGSView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attendanceBackImg"]];
    [self addSubview:backImg];
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(330*kWidthScale, 330*kHeightScale));
        make.top.mas_equalTo(67*kHeightScale);
    }];
    
    /*参数：
     clocwise:逆时针还是顺时针
     shadow:剩下的百分数现显示的颜色
     overrideLineWidth：宽度
     */
    self.circleChart = [[PNCircleChart alloc] initWithFrame:(CGRectMake((kSCREEN_WIDTH-238*kWidthScale)/2, 113*kHeightScale, 238*kWidthScale, 238*kHeightScale)) total:@(100) current:@(0) clockwise:YES shadow:YES shadowColor:kUIColor(241, 241, 241, 0.36) displayCountingLabel:NO overrideLineWidth:@(10)];
    self.circleChart.chartType = PNChartFormatTypePercent;
    self.circleChart.displayAnimated = NO;
    self.circleChart.strokeColor = kUIColor(230, 228, 35, 1);
//    self.circleChart.duration = 3;//进度条持续时间
    [self.circleChart strokeChart];
    [self addSubview:self.circleChart];
    
    //覆盖掉circleChart的标题
    self.currentLab = [[UILabel alloc] init];
    self.currentLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(70)];
    self.currentLab.text = @"0.0";
    self.currentLab.textColor = kUIColor(255, 255, 255, 1);
    [self addSubview:self.currentLab];
    [self.currentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backImg).offset(-4);
        make.top.mas_equalTo(backImg.mas_top).offset(98*kHeightScale);
        make.height.mas_equalTo(98*kHeightScale);
    }];
    
    //百分号 出勤率
    UILabel *ratioLab = [[UILabel alloc] init];
    ratioLab.text = @"%";
    ratioLab.textColor = kUIColor(255, 255, 255, 0.76);
    ratioLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(27)];
    [self addSubview:ratioLab];
    [ratioLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImg.mas_top).offset(114*kHeightScale);
        make.left.mas_equalTo(_currentLab.mas_right).offset(-4*kWidthScale);
    }];
    UILabel *attendanceLab = [[UILabel alloc] init];
    attendanceLab.text = @"出勤率";
    attendanceLab.textColor = kUIColor(255, 255, 255, 0.5);
    attendanceLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(20)];
    [self addSubview:attendanceLab];
    [attendanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(backImg.mas_bottom).offset(-114*kHeightScale);
        make.centerX.mas_equalTo(_currentLab);
    }];
    
    UIView *backAlphaView = [[UIView alloc] init];
    backAlphaView.backgroundColor = kUIColor(255, 255, 255, 0.102);
    backAlphaView.layer.cornerRadius = 22;
    backAlphaView.layer.masksToBounds = YES;
    [self addSubview:backAlphaView];
    [backAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(324*kWidthScale, 44*kHeightScale));
        make.top.mas_equalTo(backImg.mas_bottom).offset(39*kHeightScale);
        
    }];
    
    // 应出勤
    UILabel *shouldTimeLab = [[UILabel alloc] init];
    shouldTimeLab.text = @"应出勤";
    shouldTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    shouldTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:shouldTimeLab];
    [shouldTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    _shouldDay = [[UILabel alloc] init];
    _shouldDay.text = @"0.0";
    _shouldDay.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(20)];
    _shouldDay.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:_shouldDay];
    [_shouldDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shouldTimeLab.mas_right).offset(6*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    UILabel *shouldUnitLab1 = [[UILabel alloc] init];
    shouldUnitLab1.text = @"天";
    shouldUnitLab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    shouldUnitLab1.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:shouldUnitLab1];
    [shouldUnitLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_shouldDay.mas_right).offset(6*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.16];
    [backAlphaView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(2*kWidthScale, 30*kHeightScale));
        make.center.mas_equalTo(0);
    }];
    
    // 已出勤
    UILabel *finishTimeLab = [[UILabel alloc] init];
    finishTimeLab.text = @"已出勤";
    finishTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    finishTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:finishTimeLab];
    [finishTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineLab.mas_right).offset(18*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    _finishDay = [[UILabel alloc] init];
    _finishDay.text = @"0.0";
    _finishDay.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(20)];
    _finishDay.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:_finishDay];
    [_finishDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(finishTimeLab.mas_right).offset(6*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    UILabel *finishUnitLab1 = [[UILabel alloc] init];
    finishUnitLab1.text = @"天";
    finishUnitLab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    finishUnitLab1.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:finishUnitLab1];
    [finishUnitLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_finishDay.mas_right).offset(6*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    // 底部标题
    _bottomTitleLab = [[UILabel alloc] init];
    _bottomTitleLab.text = @"高于88%的YASHAers";
    _bottomTitleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _bottomTitleLab.textColor = kUIColor(255, 255, 255, 1);
    [self addSubview:_bottomTitleLab];
    [_bottomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backAlphaView.mas_bottom).offset(48*kWidthScale);
        make.centerX.mas_equalTo(backAlphaView);
    }];
    
    // 底部按钮
    UIImageView *bottomImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HMangerGDownInfo"]];
//    bottomImg.frame = CGRectMake((kSCREEN_WIDTH-18*kWidthScale)/2, CGRectGetHeight(self.frame)-60*kHeightScale, 18*kWidthScale, 30*kHeightScale);
    [self addSubview:bottomImg];
    [bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0); make.size.mas_equalTo(CGSizeMake(18*kWidthScale, 30*kHeightScale));
        make.top.mas_equalTo(_bottomTitleLab.mas_bottom).offset(10*kHeightScale);
    }];
    
    _bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _bottomBtn.frame = CGRectMake((kSCREEN_WIDTH-18*kWidthScale)/2, CGRectGetHeight(self.frame)-40*kHeightScale, kSCREEN_WIDTH, 30*kHeightScale);
    [self addSubview:_bottomBtn];
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomImg.mas_top);
        make.bottom.mas_equalTo(bottomImg.mas_bottom);
        make.width.mas_equalTo(self);
    }];
    [self updateNumberByStr:@"0.0"];
}

// 更新百分比数目
- (void)updateNumberByStr:(NSString*)numberStr {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:numberStr];
    NSShadow *shadow = [[NSShadow alloc] init];
    //阴影半径，默认值3
    shadow.shadowBlurRadius = 1.0;
    shadow.shadowOffset = CGSizeMake(0, 1);
    shadow.shadowColor = [UIColor whiteColor];
    [attributedString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, attributedString.length)];
    self.currentLab.attributedText = attributedString;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
