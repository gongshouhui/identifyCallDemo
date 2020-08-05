//
//  YSPMSProgressBarView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/26.
//

#import "YSPMSProgressBarView.h"

@interface YSPMSProgressBarView ()

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIView *progressBarViewBottom;
@property (nonatomic, strong) UIView *progressBarViewTop;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *bottomColor;
@property (nonatomic, assign) float time;

@end

@implementation YSPMSProgressBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = kUIColor(42, 138, 219, 1);
    self.titleLabel.text = @"计划形象进度";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(17);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(94*kWidthScale, 15*kHeightScale));
    }];
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.font = [UIFont systemFontOfSize:15];
    self.progressLabel.textColor = kUIColor(42, 138, 219, 1);
    self.progressLabel.text = @"80%";
    [self addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(17);
    make.left.mas_equalTo(self.titleLabel.mas_right).offset(35*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 15*kHeightScale));
    }];
    
    self.progressBarViewBottom = [[UIView alloc]init];
    self.progressBarViewBottom.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.progressBarViewBottom.layer.cornerRadius = 3;
    self.progressBarViewBottom.layer.masksToBounds = YES;
    [self addSubview:self.progressBarViewBottom];
    [self.progressBarViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(21);
    make.left.mas_equalTo(self.progressLabel.mas_right).offset(15*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(158*kWidthScale, 6*kHeightScale));
    }];
    
    self.progressBarViewTop = [[UIView alloc]init];
    self.progressBarViewTop.backgroundColor = kUIColor(42, 138, 219, 1);
    self.progressBarViewTop.layer.cornerRadius = 3;
    self.progressBarViewTop.layer.masksToBounds = YES;
    [self.progressBarViewBottom addSubview:self.progressBarViewTop];
    [self.progressBarViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.progressBarViewBottom);
        make.height.mas_equalTo(6);
    }];
    
}

- (void)setTime:(float)time {
    _time = time;
}

- (void)setProgressValue:(NSString *)progressValue {
    if (!_time) {
        _time = 3.0f;
    }
    _progressValue = progressValue;
    [UIView animateWithDuration:_time animations:^{
        [self.progressBarViewTop mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self.progressBarViewBottom);
            make.size.mas_equalTo(CGSizeMake(158*kWidthScale*[_progressValue floatValue], 6*kHeightScale));
        }];
    }];
}

- (void)setBottomColor:(UIColor *)bottomColor {
    _bottomColor = bottomColor;
    self.progressBarViewBottom.backgroundColor = _bottomColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.progressBarViewTop.backgroundColor = _progressColor;
}

@end
