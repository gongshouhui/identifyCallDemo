//
//  YSExpenseShareHeaderView.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/7.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseShareHeaderView.h"

@interface YSExpenseShareHeaderView()


@end
@implementation YSExpenseShareHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    self.titleLb = label;
    label.text = @"办公费";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    label.textColor = kGrayColor(51);
    [self addSubview:label];
    self.arrowBtn = [YSRightImageButton buttonWithType:UIButtonTypeCustom];
    [self.arrowBtn setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateSelected];
    [self.arrowBtn setImage:[UIImage imageNamed:@"向上箭头"] forState:UIControlStateNormal];
    [self.arrowBtn setTitleColor:kGrayColor(51) forState:UIControlStateNormal];
    self.arrowBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.arrowBtn addTarget:self action:@selector(clickToExpand) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.arrowBtn];
    
    UIView *lineView = [[UIView alloc]init];
    self.lineView = lineView;
    lineView.backgroundColor = kGrayColor(229);
    [self addSubview:lineView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToExpand)];
    [self addGestureRecognizer:tapGes];
    
    //约束
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
        //make.width.mas_equalTo(30);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    
}
- (void)updateConstraintForExpenseHeader {
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = kUIColor(42, 139, 220, 1.0);
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14*kHeightScale);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(2);
        make.bottom.mas_equalTo(-14*kHeightScale);
    }];
    self.titleLb.numberOfLines = 0;
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(lineLabel.mas_right).mas_equalTo(10);
    }];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
    }];
    self.titleLb.textColor = kGrayColor(153);
    self.titleLb.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
}
- (void)setModel:(YSFlowExpensePexpShareModel *)model {
    _model = model;
    self.arrowBtn.selected = model.isexpand;
    self.titleLb.text = model.emsTypeName;
    NSString *title = [YSUtility positiveFormat:[NSString stringWithFormat:@"%.2f",model.money]];
    [self.arrowBtn setTitle:[NSString stringWithFormat:@"￥%@",title] forState:UIControlStateNormal];
   
}
- (void)clickToExpand {
    if ([self.delegate respondsToSelector:@selector(expandButtonDidClick:)]) {
        [self.delegate expandButtonDidClick:self];
    }
}

@end
