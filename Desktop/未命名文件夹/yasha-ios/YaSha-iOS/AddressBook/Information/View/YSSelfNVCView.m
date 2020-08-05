//
//  YSSelfNVCView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/8/3.
//
//

#import "YSSelfNVCView.h"

@implementation YSSelfNVCView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _letfButton = [[UIButton alloc]init];
        [_letfButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [self addSubview:_letfButton];
        [_letfButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(20*kHeightScale);
            make.left.mas_equalTo(self.mas_left).offset(15*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(40*kWidthScale, 40*kHeightScale));
        }];

        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(25*kHeightScale);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(260*kWidthScale, 30*kHeightScale));
        }];
        
        _rightButton = [[UIButton alloc]init];
        [self addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(22*kHeightScale);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(10*kWidthScale);
            make.size.mas_equalTo(CGSizeMake(40*kWidthScale, 40*kHeightScale));
        }];
    }
    return self;
}

@end
