//
//  YSHRManagerPerformanceGSView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/3.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerPerformanceGSView.h"

@implementation YSHRManagerPerformanceGSView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    NSArray *nameArray = @[@"S", @"A", @"B", @"C", @"D", @"E"];
    NSArray *widthArray = @[@52.0, @112.0, @168.0, @224.0, @280.0, @338.0];
    for (int i = 0; i < nameArray.count; i++) {
        YSLineTriangleView *lineTriangView = [[YSLineTriangleView alloc] initWithFrame:(CGRectMake(0, 86+i*(47*kHeightScale), self.frame.size.width, 40*kHeightScale))];
        lineTriangView.titleLab.text = nameArray[i];
        lineTriangView.tag = 1152+i;
        [lineTriangView.lineLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(widthArray[i]);
        }];
        [self addSubview:lineTriangView];
    }
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
    shouldTimeLab.text = @"半年度绩效";
    shouldTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    shouldTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:shouldTimeLab];
    [shouldTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    _shouldNumLab = [[UILabel alloc] init];
    _shouldNumLab.text = @"";
    _shouldNumLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(22)];
    _shouldNumLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:_shouldNumLab];
    [_shouldNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shouldTimeLab.mas_right).offset(13*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    UILabel *shouldUnitLab1 = [[UILabel alloc] init];
    shouldUnitLab1.text = @"级";
    shouldUnitLab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    shouldUnitLab1.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:shouldUnitLab1];
    [shouldUnitLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_shouldNumLab.mas_right).offset(9*kWidthScale);
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
    finishTimeLab.text = @"年度绩效";
    finishTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    finishTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:finishTimeLab];
    [finishTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineLab.mas_right).offset(19*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    _finishTimeLab = [[UILabel alloc] init];
    _finishTimeLab.text = @"";
    _finishTimeLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(22)];
    _finishTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:_finishTimeLab];
    [_finishTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(finishTimeLab.mas_right).offset(11*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    UILabel *finishUnitLab1 = [[UILabel alloc] init];
    finishUnitLab1.text = @"级";
    finishUnitLab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    finishUnitLab1.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:finishUnitLab1];
    [finishUnitLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_finishTimeLab.mas_right).offset(11*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    // 底部标题
    _bottomTitleLab = [[UILabel alloc] init];
    _bottomTitleLab.text = @"荣获“十佳明日之星“";
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


- (void)upSubViewsValueWith:(NSArray*)indexArray {
    if (indexArray.count < 2) {
        return;
    }
    NSInteger index = 0;
    if ([indexArray[1] isEqualToString:@"A"]){
        index = 1;
    }else if ([indexArray[1] isEqualToString:@"B"]){
        index = 2;
    }else if ([indexArray[1] isEqualToString:@"C"]){
        index = 3;
    }else if ([indexArray[1] isEqualToString:@"D"]){
        index = 4;
    }else if ([indexArray[1] isEqualToString:@"E"]){
        index = 5;
    }
    YSLineTriangleView *lineTriangViewHeight = [self viewWithTag:index+1152];
    if ([indexArray[0] integerValue] == 1) {
        // 年度
        lineTriangViewHeight.titleLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        lineTriangViewHeight.lineLab.backgroundColor = [UIColor colorWithHexString:@"#E6E423"];
    }else if ([indexArray[0] integerValue] == 2) {
        // 半年
        lineTriangViewHeight.titleLab.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.79];
        lineTriangViewHeight.lineLab.backgroundColor = [[UIColor colorWithHexString:@"#E6E423"] colorWithAlphaComponent:0.50];
    }
    lineTriangViewHeight.titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(24)];
    lineTriangViewHeight.lineLab.layer.shadowColor = [UIColor colorWithHexString:@"#E6E423"].CGColor;
    
    /*
    YSLineTriangleView *lineTriangView = [self viewWithTag:[indexArray[1] integerValue]+1152];
    lineTriangView.titleLab.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.795];
    lineTriangView.titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(24)];
    lineTriangView.lineLab.backgroundColor = [UIColor colorWithHexString:@"#E6E423"];
     */
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation YSLineTriangleView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(21)];
    _titleLab.text = @"S";
    _titleLab.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.318];
    [self addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(29*kHeightScale);
    }];
    
    _lineLab = [[UILabel alloc] init];
    _lineLab.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.0918];
    _lineLab.layer.cornerRadius = 5;
    _lineLab.layer.masksToBounds = YES;
    _lineLab.layer.shadowColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    _lineLab.layer.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:_lineLab];
    [_lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_titleLab.mas_bottom);
        make.height.mas_equalTo(10*kHeightScale);
        make.width.mas_equalTo(52*kHeightScale);
    }];
}

@end
