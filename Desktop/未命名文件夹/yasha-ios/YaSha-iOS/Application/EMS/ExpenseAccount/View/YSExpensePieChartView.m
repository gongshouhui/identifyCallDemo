//
//  YSExpensePieChartView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/5.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpensePieChartView.h"

@implementation YSExpensePieChartView
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items {
    if (self = [super initWithFrame:frame items:items]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = kUIColor(0, 0, 0, 0.45);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}
- (void)recompute {
    [super recompute];
    self.innerCircleRadius = 50;
    self.outerCircleRadius = 62;
}
@end
