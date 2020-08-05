//
//  YSHRTrainDataView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/1/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRTrainDataView.h"

@implementation YSHRTrainDataView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.numLb = [[UILabel alloc]init];
    self.numLb.font = [UIFont systemFontOfSize:12];
    self.numLb.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.8];
    [self addSubview:self.numLb];
    [self.numLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
        
    }];
    self.detailLb = [[UILabel alloc]init];
    self.detailLb.font = [UIFont systemFontOfSize:12];
    self.detailLb.textColor = [UIColor colorWithHexString:@"#191F25" alpha:0.4];
    [self addSubview:self.detailLb];
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.numLb.mas_bottom).mas_equalTo(15);
    }];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.08];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(1);
    }];
}
@end
