//
//  YSCustomManagerBtnView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCustomManagerBtnView.h"

@implementation YSCustomManagerBtnView


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _topLab = [[UILabel alloc] init];
        _topLab.font = [UIFont fontWithName:@"PingFang-SC-Semibold" size:Multiply(14)];
        _topLab.text = @"123123";
        _topLab.textColor = kUIColor(24, 144, 255, 1);
        [self addSubview:_topLab];
        [_topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_centerY).offset(1);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.text = @"你猜";
        _bottomLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
        _bottomLab.textColor = kUIColor(163, 164, 168, 1);
        [self addSubview:_bottomLab];
        [_bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_centerY).offset(1);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        _backBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _backBtn.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:_backBtn];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
