//
//  YSPosittionSectionHeaderVIew.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/28.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPosittionSectionHeaderVIew.h"

@interface YSPosittionSectionHeaderVIew ()

@property (nonatomic, strong) UILabel *positiLab;
@property (nonatomic, strong) UILabel *timeLab;


@end

@implementation YSPosittionSectionHeaderVIew


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    UILabel *typeLab = [[UILabel alloc] init];
    typeLab.text = @"头像";
    typeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    typeLab.textColor = kUIColor(17, 21, 24, 1);
    [self addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
    }];
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = @"姓名";
    nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    nameLab.textColor = kUIColor(17, 21, 24, 1);
    [self addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(typeLab.mas_right).offset(23*kWidthScale);
        make.centerY.mas_equalTo(typeLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
    }];
    
    _positiLab = [[UILabel alloc] init];
    _positiLab.text = @"岗位";
    _positiLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _positiLab.textColor = kUIColor(17, 21, 24, 1);
    [self addSubview:_positiLab];
    [_positiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLab.mas_right).offset(31*kWidthScale);
        make.centerY.mas_equalTo(typeLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
    }];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"离职时间";
    _timeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _timeLab.textColor = kUIColor(17, 21, 24, 1);
    [self addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_positiLab.mas_right).offset(114*kWidthScale);
        make.centerY.mas_equalTo(typeLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(58*kWidthScale, 20*kHeightScale));
    }];
}

- (void)updateConstraintsAndDataWithType:(NSInteger)type {
    
    switch (type) {
        case 0://编制详情
            {
                _timeLab.text = @"职级";
                [_timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(_positiLab.mas_right).offset(142*kWidthScale);                    make.size.mas_equalTo(CGSizeMake(29*kWidthScale, 20*kHeightScale));
                }];
            }
            break;
        case 1://入职
        {
            _timeLab.text = @"入职时间";
        }
            break;
        case 2://离职
        {
            _timeLab.text = @"离职时间";
        }
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
