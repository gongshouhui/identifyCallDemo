//
//  YSFolderBackImgHolderView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/14.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFolderBackImgHolderView.h"

@implementation YSFolderBackImgHolderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crmFolderBackAddImg"]];
    [self addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 130*kHeightScale));
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-12*kWidthScale);
    }];
    UIImageView *middleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crmFolderBackSearchImg"]];
    [self addSubview:middleImg];
    [middleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(220*kWidthScale, 220*kHeightScale));
        make.top.mas_equalTo(24);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *topLab = [[UILabel alloc] init];
    topLab.textColor = [UIColor colorWithHexString:@"#111A34"];
    topLab.text = @"什么都没有";
    topLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(20)];
    [self addSubview:topLab];
    [topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(middleImg.mas_bottom).mas_offset(18*kHeightScale);
    }];
    UILabel *bottomLab = [[UILabel alloc] init];
    bottomLab.textColor = [UIColor colorWithHexString:@"#C5CAD5"];
    bottomLab.text = @"暂无任何附件，如要上传请点击右上“+”";
    bottomLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:Multiply(14)];
    [self addSubview:bottomLab];
    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(topLab.mas_bottom).mas_offset(12*kHeightScale);
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
