//
//  YSHRManagerTGTrainingView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/1.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerTGTrainingView.h"
#import "UIView+Extension.h"
#import "YSHRMTrainingChartView.h"


@interface YSHRManagerTGTrainingView ()

@end

@implementation YSHRManagerTGTrainingView


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadNewSubViews];
    }
    return self;
}

- (void)loadNewSubViews {
    
    _lineChatView = [[YSHRMTrainingChartView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width-20, 230)];
    [self addSubview:_lineChatView];
    _lineChatView.dataArrOfY = @[@"100",@"65",@"35",@"0"];//Y轴坐标
    _lineChatView.dataArrOfX = @[@"第一季度",@"第二季度",@"第三季度",@"第四季度"];//X轴坐标
    _lineChatView.dataArrOfPoint = @[@"0",@"0",@"0",@"0"];
    [self loadBottomSubViews];
    
}

- (void)loadBottomSubViews {
    
    UIView *backAlphaView = [[UIView alloc] init];
    backAlphaView.backgroundColor = kUIColor(255, 255, 255, 0.102);
    backAlphaView.layer.cornerRadius = 22;
    backAlphaView.layer.masksToBounds = YES;
    [self addSubview:backAlphaView];
    [backAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(324*kWidthScale, 44*kHeightScale));
        make.top.mas_equalTo(436*kHeightScale);
        
    }];
    
    // 应出勤
    UILabel *shouldTimeLab = [[UILabel alloc] init];
    shouldTimeLab.text = @"培训";
    shouldTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    shouldTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:shouldTimeLab];
    [shouldTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    _shouldNumLab = [[UILabel alloc] init];
    _shouldNumLab.text = @"0";
    _shouldNumLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(20)];
    _shouldNumLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:_shouldNumLab];
    [_shouldNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shouldTimeLab.mas_right).offset(12*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    UILabel *shouldUnitLab1 = [[UILabel alloc] init];
    shouldUnitLab1.text = @"次";
    shouldUnitLab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    shouldUnitLab1.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:shouldUnitLab1];
    [shouldUnitLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_shouldNumLab.mas_right).offset(11*kWidthScale);
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
    finishTimeLab.text = @"完成";
    finishTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    finishTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:finishTimeLab];
    [finishTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineLab.mas_right).offset(19*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    _finishTimeLab = [[UILabel alloc] init];
    _finishTimeLab.text = @"0.0";
    _finishTimeLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(20)];
    _finishTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:_finishTimeLab];
    [_finishTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(finishTimeLab.mas_right).offset(12*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    UILabel *finishUnitLab1 = [[UILabel alloc] init];
    finishUnitLab1.text = @"学时";
    finishUnitLab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    finishUnitLab1.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:finishUnitLab1];
    [finishUnitLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_finishTimeLab.mas_right).offset(11*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    // 底部标题
    _bottomTitleLab = [[UILabel alloc] init];
    _bottomTitleLab.text = @"培训目标达成率90%";
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
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


