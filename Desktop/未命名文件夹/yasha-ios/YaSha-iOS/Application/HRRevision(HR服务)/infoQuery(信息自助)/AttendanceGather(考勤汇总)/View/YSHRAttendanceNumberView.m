//
//  YSHRAttendanceNumberView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/22.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRAttendanceNumberView.h"

@interface YSHRAttendanceNumberView ()

@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIImageView *middleBackImg;
@property (nonatomic, strong) UIImageView *frontImg;


@end

@implementation YSHRAttendanceNumberView


- (instancetype)initWithFrame:(CGRect)frame withImgNameArray:(NSArray *)imageNameArray withLabelTitle:(NSArray *)titleArray {
    if ([super initWithFrame:frame]) {
        _backImg = [[UIImageView alloc] initWithFrame:CGRectFlatMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _backImg.image = [UIImage imageNamed:imageNameArray[0]];
        [self addSubview:_backImg];
        
        _middleBackImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNameArray[1]]];
        [self addSubview:_middleBackImg];
        [_middleBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 50*kHeightScale));
            make.left.mas_equalTo(self.mas_left).offset(10*kWidthScale);
            make.centerY.mas_equalTo(self);
        }];
        
        _frontImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNameArray[2]]];
        [self addSubview:_frontImg];
        [_frontImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(27*kWidthScale, 27*kHeightScale));
            make.center.mas_equalTo(_middleBackImg);
        }];
        
        _topTitle = [[UILabel alloc] init];
        _topTitle.font = [UIFont systemFontOfSize:Multiply(27)];
        _topTitle.text = @"0.0";
        [self addSubview:_topTitle];
        [_topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(70*kWidthScale);
            make.top.mas_equalTo(self.middleBackImg.mas_top).offset(-6*kHeightScale);
            make.height.mas_equalTo(38*kHeightScale);
        }];
        _subTitle = [[UILabel alloc] init];
        _subTitle.text = titleArray[2];
        _subTitle.textColor = kUIColor(90, 90, 90, 1);
        _subTitle.font = [UIFont systemFontOfSize:Multiply(14)];
        [self addSubview:_subTitle];
        [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topTitle.mas_left);
            make.top.mas_equalTo(_topTitle.mas_bottom);
        }];
        
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
