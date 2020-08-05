//
//  YSFlowFormSectionHeaderView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/27.
//

#import "YSFlowFormSectionHeaderView.h"

@implementation YSFlowFormSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 30*kHeightScale);
        self.backgroundColor = kGrayColor(247);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.00];
    _titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

@end
