//
//  YSPictureBtnView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/13.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPictureBtnView.h"

@implementation YSPictureBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    _choseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_choseBtn setImage:[UIImage imageNamed:@"completeAddImg"] forState:(UIControlStateNormal)];
    [self addSubview:_choseBtn];
    [_choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(85*kWidthScale, 85*kHeightScale));
    }];
    
    _clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_clearBtn setImage:[UIImage imageNamed:@"close"] forState:(UIControlStateNormal)];
    _clearBtn.hidden = YES;
    [self addSubview:_clearBtn];
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_choseBtn.mas_top).offset(-5*kWidthScale);
        make.right.mas_equalTo(_choseBtn.mas_right).offset(5*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(18*kWidthScale, 18*kWidthScale));
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
