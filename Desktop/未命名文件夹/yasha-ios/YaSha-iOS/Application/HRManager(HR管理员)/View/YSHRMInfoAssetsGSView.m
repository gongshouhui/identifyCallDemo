//
//  YSHRMInfoAssetsGSView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMInfoAssetsGSView.h"

@interface YSHRMInfoAssetsGSView ()

@property (nonatomic, strong) UIImageView *lineImg1;
@property (nonatomic, strong) UIImageView *lineImg2;


@end

@implementation YSHRMInfoAssetsGSView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    
    NSArray *nameArray = @[@"个人资产", @"固定资产", @"软件资产"];
    for (int i = 0; i < nameArray.count; i++) {
        YSHRAssetsLineView *lineView = [[YSHRAssetsLineView alloc] initWithFrame:(CGRectMake(0, 61*kHeightScale+(45*kHeightScale*i), CGRectGetWidth(self.frame), 30*kHeightScale)) withType:i];
        lineView.tag = 2130+i;
        switch (i) {
            case 0:
            case 1:
                {
                    lineView.titLab.text = nameArray[i];
                    lineView.numberLab.text = @"0件";
                }
                break;
            case 2:
            {
                lineView.numberLab.text = nameArray[i];
                lineView.titLab.text = @"0件";
            }
                break;
            default:
                break;
        }
        [self addSubview:lineView];
    }
    
    NSArray *nameArray2 = @[@"责任资产", @"固定资产", @"软件资产"];
    for (int i = 0; i < nameArray2.count; i++) {
        YSHRAssetsLineView *lineView = [[YSHRAssetsLineView alloc] initWithFrame:(CGRectMake(0, 251*kHeightScale+(45*kHeightScale*i), CGRectGetWidth(self.frame), 30*kHeightScale)) withType:i];
        lineView.tag = 2230+i;
        switch (i) {
            case 0:
            case 1:
            {
                lineView.titLab.text = nameArray2[i];
                lineView.numberLab.text = @"0件";
            }
                break;
            case 2:
            {
                lineView.numberLab.text = nameArray2[i];
                lineView.titLab.text = @"0件";
            }
                break;
            default:
                break;
        }
        [self addSubview:lineView];
    }
    
    _lineImg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HRMVerline"]];
    [self addSubview:_lineImg1];
    [_lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1*kWidthScale, 145*kHeightScale));
        make.top.mas_equalTo(50*kHeightScale);
        make.left.mas_equalTo(0);
    }];
    
    _lineImg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HRMVerline"]];
    [self addSubview:_lineImg2];
    [_lineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1*kWidthScale, 145*kHeightScale));
        make.top.mas_equalTo(230*kHeightScale);
        make.left.mas_equalTo(0);
    }];
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
    shouldTimeLab.text = @"个人资产";
    shouldTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    shouldTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:shouldTimeLab];
    [shouldTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    _personLab = [[UILabel alloc] init];
    _personLab.text = @"";
    _personLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(22)];
    _personLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:_personLab];
    [_personLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shouldTimeLab.mas_right).offset(11*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    UILabel *shouldUnitLab1 = [[UILabel alloc] init];
    shouldUnitLab1.text = @"件";
    shouldUnitLab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    shouldUnitLab1.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:shouldUnitLab1];
    [shouldUnitLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_personLab.mas_right).offset(9*kWidthScale);
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
    finishTimeLab.text = @"责任资产";
    finishTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    finishTimeLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:finishTimeLab];
    [finishTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineLab.mas_right).offset(19*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    _dutyLab = [[UILabel alloc] init];
    _dutyLab.text = @"";
    _dutyLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(22)];
    _dutyLab.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:_dutyLab];
    [_dutyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(finishTimeLab.mas_right).offset(11*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    UILabel *finishUnitLab1 = [[UILabel alloc] init];
    finishUnitLab1.text = @"件";
    finishUnitLab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    finishUnitLab1.textColor = kUIColor(255, 255, 255, 1);
    [backAlphaView addSubview:finishUnitLab1];
    [finishUnitLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_dutyLab.mas_right).offset(11*kWidthScale);
        make.centerY.mas_equalTo(backAlphaView);
    }];
    
    // 底部标题
    UILabel *bottomTitleLab = [[UILabel alloc] init];
    bottomTitleLab.text = @"返回顶部";
    bottomTitleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    bottomTitleLab.textColor = kUIColor(255, 255, 255, 1);
    [self addSubview:bottomTitleLab];
    [bottomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backAlphaView.mas_bottom).offset(48*kWidthScale);
        make.centerX.mas_equalTo(backAlphaView);
    }];
    
    // 底部按钮
    UIImageView *bottomImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HMangerGUpInfo"]];
//    bottomImg.frame = CGRectMake((kSCREEN_WIDTH-18*kWidthScale)/2, CGRectGetHeight(self.frame)-40*kHeightScale, 18*kWidthScale, 30*kHeightScale);
    [self addSubview:bottomImg];
    [bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(bottomTitleLab.mas_bottom).mas_offset(12*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(18*kWidthScale, 30*kHeightScale));
        
    }];
    
    _bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _bottomBtn.frame = CGRectMake((kSCREEN_WIDTH-18*kWidthScale)/2, CGRectGetHeight(self.frame)-40*kHeightScale, kSCREEN_WIDTH, 30*kHeightScale);
    [self addSubview:_bottomBtn];
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomTitleLab.mas_top);
        make.bottom.mas_equalTo(bottomImg.mas_bottom);
        make.width.mas_equalTo(self);
    }];
    
}

#pragma mark--更新布局
- (void)upSubViewsWith:(NSArray*)dataArray withType:(int)type {
    NSInteger tag = type*100+2030;
    if ([dataArray[0] floatValue] == 0.0) {
        if (type == 1) {
            _lineImg1.hidden = YES;
        }else {
            _lineImg2.hidden = YES;
        }
        for (int i = 0; i < 3; i++) {
            YSHRAssetsLineView *lineView = [self viewWithTag:tag+i];
            switch (i) {
                case 0:
                    {
                        lineView.numberLab.text = @"0件";
                        lineView.lineLab.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.30];
                    }
                    break;
                case 1:
                    {
                        lineView.hiddenNumLab.hidden = NO;
                        lineView.lineLab.hidden = YES;
                        lineView.numberLab.hidden = YES;
                    }
                    break;
                case 2:
                    {
                        lineView.hiddenNumLab.hidden = NO;
                        lineView.titLab.hidden = YES;
                        [lineView.hiddenNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(lineView.lineLab.mas_right).offset(-20*kWidthScale);
                        }];
                        lineView.lineLab.hidden = YES;
                    }
                    break;
                default:
                    break;
            }
        }
        return;
    }
    for (int i = 0; i<3 ; i++) {
        YSHRAssetsLineView *lineView = [self viewWithTag:tag+i];
        CGFloat number = [dataArray[i] floatValue];
        switch (i) {
            case 0:
            {
                lineView.numberLab.text = [NSString stringWithFormat:@"%.0f件", number];
            }
                break;
            case 1:
            {
                lineView.numberLab.text = [NSString stringWithFormat:@"%.0f件", number];
                CGFloat width = number / [dataArray[0] floatValue];
                // 硬件资产
                if (width == 0.0) {
                    lineView.hiddenNumLab.hidden = NO;
                    lineView.lineLab.hidden = YES;
                    lineView.numberLab.hidden = YES;
                }else {
                    [lineView.lineLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(width*211*kWidthScale);
                    }];
                }
                // 中间分割线
                if (type == 1) {
                    // 个人资产
                    if (width == 0) {
                        // 以 硬件资产 判断
                        [_lineImg1 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(self.mas_left).offset(82*kWidthScale+4*kWidthScale);
                        }];
                    }else if (width == 1){
                        [_lineImg1 mas_updateConstraints:^(MASConstraintMaker *make) {
                            
                            make.left.mas_equalTo(self.mas_left).offset(kSCREEN_WIDTH-80*kWidthScale+5*kWidthScale);
                        }];
                    }else{
                        // 以 硬件资产 判断
                        [_lineImg1 mas_updateConstraints:^(MASConstraintMaker *make) {
                           make.left.mas_equalTo(self.mas_left).offset(82*kWidthScale+width*211*kWidthScale+6*kWidthScale);
                            
                        }];
                    }
                    
                }else {
                    //责任资产
                    if (width == 0) {
                        //以 硬件资产 判断
                        [_lineImg2 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(self.mas_left).offset(82*kWidthScale+4*kWidthScale);
                        }];
                    }else if(width == 1){
                        [_lineImg2 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(self.mas_left).offset(kSCREEN_WIDTH-80*kWidthScale+5*kWidthScale);
                        }];
                    }else {
                        // 以 硬件资产 判断
                        [_lineImg2 mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(self.mas_left).offset(82*kWidthScale+width*211*kWidthScale+6*kWidthScale);
                        }];

                    }
                }
                
            }
                break;
            case 2:
            {
                lineView.titLab.text = [NSString stringWithFormat:@"%.0f件", number];
                CGFloat width = [dataArray[1] floatValue] / [dataArray[0] floatValue];
                //责任
                if (width == 1.0) {
                    // 以硬件资产判断
                    lineView.hiddenNumLab.hidden = NO;
                    lineView.titLab.hidden = YES;
                    [lineView.hiddenNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(lineView.lineLab.mas_right).offset(-20*kWidthScale);
                    }];
                    lineView.lineLab.hidden = YES;
                }else {
                    [lineView.lineLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(211*kWidthScale-width*211*kWidthScale-2);
                    }];
                }
                
            }
                break;
            default:
                break;
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation YSHRAssetsLineView

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
        if (type == 2) {
            [self setSubViewsNewLayout];
        }
    }
    return self;
}

- (void)loadSubViews {
    
    _titLab = [[UILabel alloc] init];
    _titLab.textColor = [UIColor colorWithHexString:@"#AEE1FF"];
    _titLab.textAlignment = NSTextAlignmentRight;
    _titLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _titLab.text = @"个人资产";
    [self addSubview:_titLab];
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65*kWidthScale, 20*kHeightScale));
        make.left.mas_equalTo(16*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    
    _lineLab = [[UILabel alloc] init];
    _lineLab.backgroundColor = [UIColor colorWithHexString:@"#E6E423"];
    _lineLab.layer.shadowColor = [UIColor colorWithHexString:@"#E6E423"].CGColor;
    _lineLab.shadowOffset = CGSizeMake(2, 2);
    _lineLab.layer.cornerRadius = 5;
    _lineLab.layer.masksToBounds = YES;
    [self addSubview:_lineLab];
    [_lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(211*kWidthScale);
        make.height.mas_equalTo(10*kHeightScale);
        make.left.mas_equalTo(_titLab.mas_right).offset(10*kWidthScale);
    }];
    
    _numberLab = [[UILabel alloc] init];
    _numberLab.textColor = [UIColor colorWithHexString:@"#AEE1FF"];
    _numberLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _numberLab.text = @"个人资产";
    _numberLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_numberLab];
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_lineLab.mas_right).offset(10*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    
    _hiddenNumLab = [[UILabel alloc] init];
    _hiddenNumLab.textColor = [UIColor colorWithHexString:@"#AEE1FF"];
    _hiddenNumLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _hiddenNumLab.hidden = YES;
    _hiddenNumLab.text = @"0件";
    [self addSubview:_hiddenNumLab];
    [_hiddenNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(_lineLab.mas_left);
    }];
}

- (void)setSubViewsNewLayout {
    _numberLab.textAlignment = NSTextAlignmentRight;
    [_numberLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(65*kWidthScale, 20*kHeightScale));
        make.right.mas_equalTo(-5*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    [_lineLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(211*kWidthScale);
        make.height.mas_equalTo(10*kHeightScale);
        make.right.mas_equalTo(_numberLab.mas_left).offset(-6*kWidthScale);
    }];
    [_titLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_lineLab.mas_left).offset(-10*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
}


@end
