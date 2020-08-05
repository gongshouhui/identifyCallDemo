//
//  YSNoMoreDataBottomView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSNoMoreDataBottomView.h"

@implementation YSNoMoreDataBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    UILabel *topLab = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, CGRectGetWidth(self.frame), 7*kHeightScale))];
    topLab.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self addSubview:topLab];
    UIImageView *noDataImg = [[UIImageView alloc] initWithImage:UIImageMake(@"hrNoMoreDataImg1")];
    [self addSubview:noDataImg];
    [noDataImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(topLab.mas_bottom).mas_offset(25*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(285*kWidthScale, 181*kHeightScale));
    }];
    /*
    UILabel *messageLab = [[UILabel alloc] init];
    messageLab.text = @"暂无数据～";
    messageLab.textColor = [UIColor colorWithHexString:@"#C2C2C2"];
    messageLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)];
    [self addSubview:messageLab];
    [messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(noDataImg.mas_bottom).offset(4*kHeightScale);
    }];
     */
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
