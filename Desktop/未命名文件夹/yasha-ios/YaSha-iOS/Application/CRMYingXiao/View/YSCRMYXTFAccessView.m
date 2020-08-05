//
//  YSCRMYXTFAccessView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/22.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCRMYXTFAccessView.h"
#import "YSAliNumberKeyboard.h"

@implementation YSCRMYXTFAccessView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    _currencyBtn = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
    [_currencyBtn setImage:[UIImage imageNamed:@"向下箭头"] forState:(UIControlStateNormal)];
    [_currencyBtn setTitle:@"人民币" forState:(UIControlStateNormal)];
    _currencyBtn.imagePosition = QMUIButtonImagePositionRight;
    _currencyBtn.spacingBetweenImageAndTitle = 14*kWidthScale;
    [_currencyBtn setTitleColor:[UIColor colorWithHexString:@"#111A34"] forState:(UIControlStateNormal)];
    _currencyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(18)];
    [self addSubview:_currencyBtn];
    [_currencyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(141*kWidthScale, 57*kHeightScale));
    }];
    UILabel *labeLine = [[UILabel alloc] init];
    labeLine.backgroundColor = [UIColor colorWithHexString:@"#E2E4EA"];
    [self addSubview:labeLine];
    [labeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_currencyBtn.mas_right);
        make.width.mas_equalTo(1*kWidthScale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    _numberTF = [[UITextField alloc] init];
    _numberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _numberTF.textAlignment = NSTextAlignmentRight;
    _numberTF.textColor = [UIColor colorWithHexString:@"#333333"];
    _numberTF.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(24)];
    [self addSubview:_numberTF];
    [_numberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labeLine.mas_right);
        make.bottom.top.mas_equalTo(0);
        make.right.mas_equalTo(-43*kWidthScale);
    }];
    _clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _clearBtn.hidden = YES;
    [_clearBtn setImage:[UIImage imageNamed:@"CRMYXClearBtn"] forState:(UIControlStateNormal)];
    [self addSubview:_clearBtn];
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.right.mas_equalTo(-14);
        make.size.mas_equalTo(CGSizeMake(20, 20));
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
