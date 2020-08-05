//
//  YSFlowRecheckScoreHeaderView.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2017/12/28.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowRecheckScoreHeaderView.h"

@implementation YSFlowRecheckScoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = kUIColor(37, 134, 216, 1.0);
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(10*kWidthScale);
        make.width.mas_equalTo(2);
        make.bottom.mas_equalTo(-14*kHeightScale);
    }];
    
    self.nameLb = [[UILabel alloc]init];
    self.nameLb.font = [UIFont systemFontOfSize:15];
    self.nameLb.textColor = kUIColor(51, 51, 51, 1.0);
    [self addSubview:self.nameLb];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(lineLabel.mas_right).mas_equalTo(10*kWidthScale);
    }];
    self.detailLb = [[UILabel alloc]init];
    self.detailLb.font =  [UIFont systemFontOfSize:15];
    self.detailLb.textColor = kGrayColor(51);
    [self addSubview:_detailLb];
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    //线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = kGrayColor(224);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    self.arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.arrowBtn.hidden = YES;
    [self.arrowBtn setImage:[UIImage imageNamed:@"向上箭头"] forState:UIControlStateSelected];
    [self.arrowBtn setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    [self.arrowBtn addTarget:self action:@selector(clickToExpand) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(30);
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToExpand)];
    [self addGestureRecognizer:tapGes];
    
    
}
- (void)clickToExpand {
    
    if ([self.delegate respondsToSelector:@selector(expandButtonDidClick:)]) {
        [self.delegate expandButtonDidClick:self];
    }
}
@end
