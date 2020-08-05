//
//  YSBottomTwoBtnCGView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/6/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSBottomTwoBtnCGView.h"

@implementation YSBottomTwoBtnCGView


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    _leftBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_leftBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    _leftBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)];
    [_leftBtn setTitleColor:[UIColor colorWithHexString:@"#2F86F6"] forState:(UIControlStateNormal)];
    _leftBtn.backgroundColor = [UIColor colorWithHexString:@"#2F86F6" alpha:0.1];
    _leftBtn.layer.cornerRadius = 2;
    _leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#2F86F6" alpha:0.1].CGColor;
    _leftBtn.layer.borderWidth = 1;
    [self addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(167*kWidthScale, 50*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_centerX).offset(-5*kWidthScale);
    }];
    
    _rightBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_rightBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    _rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)];
    [_rightBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
    _rightBtn.backgroundColor = [UIColor colorWithHexString:@"#2F86F6"];
    _rightBtn.layer.cornerRadius = 2;
    [self addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(167*kWidthScale, 50*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.mas_centerX).offset(5*kWidthScale);
    }];

}
- (void)changeSubViewsWith:(NSInteger)type {
    if (type == 1) {
        _rightBtn.hidden = YES;
        [_leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
        
        return;
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
