//
//  YSManagerPositionHeaderView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/28.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSManagerPositionHeaderView.h"

@implementation YSManagerPositionHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = kUIColor(230, 247, 255, 1);
    [self addSubview:backView];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 3;
    backView.layer.borderColor = kUIColor(186, 231, 255, 1).CGColor;
    backView.layer.borderWidth = 1;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.right.mas_equalTo(-16*kWidthScale);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(25*kHeightScale);
    }];
    
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.text = @"共有";
    leftLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(12)];
    leftLab.textColor = kUIColor(86, 86, 86, 1);
    [backView addSubview:leftLab];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*kWidthScale);
        make.centerY.mas_equalTo(backView);
    }];
    
    self.numberLab = [[UILabel alloc] init];
    self.numberLab.text = @"0";
    self.numberLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(12)];
    self.numberLab.textColor = kUIColor(24, 144, 255, 1);
    [backView addSubview:self.numberLab];
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftLab.mas_right);
        make.centerY.mas_equalTo(backView);
    }];
    
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.text = @"条数据";
    rightLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(12)];
    rightLab.textColor = kUIColor(86, 86, 86, 1);
    [backView addSubview:rightLab];
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberLab.mas_right);
        make.centerY.mas_equalTo(backView);
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
