//
//  YSHRMSSubSctionHeaderAllView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMSSubSctionHeaderAllView.h"

@implementation YSHRMSSubSctionHeaderAllView

- (instancetype)initWithFrame:(CGRect)frame withViewType:(NSInteger)type{
    if ([super initWithFrame:frame]) {
        [self loadSubViewWith:type];
    }
    return self;
}

- (void)loadSubViewWith:(NSInteger)type {
    
    UILabel *headerLab = [[UILabel alloc] init];
    headerLab.text = @"头像";
    headerLab.textColor = [UIColor colorWithHexString:@"#111518"];
    headerLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:headerLab];
    [headerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
        make.left.mas_equalTo(16*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = @"姓名";
    nameLab.textColor = [UIColor colorWithHexString:@"#111518"];
    nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
        make.left.mas_equalTo(headerLab.mas_right).offset(23*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    
    UILabel *typeLab = [[UILabel alloc] init];
    typeLab.text = @"类型";
    typeLab.textColor = [UIColor colorWithHexString:@"#111518"];
    typeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    if (type == 2 || type == 4) {
        typeLab.hidden = YES;
    }
    CGFloat typeWidth_y = 40*kWidthScale;
    if (type == 3) {
        typeWidth_y = 57*kWidthScale;
    }
    [self addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20*kHeightScale);
        make.left.mas_equalTo(nameLab.mas_right).offset(typeWidth_y);
        make.centerY.mas_equalTo(0);
    }];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.text = @"时间";
    timeLab.textColor = [UIColor colorWithHexString:@"#111518"];
    timeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    CGFloat width_y = 93*kWidthScale;
    if (type == 2 || type == 4) {
        width_y = 67*kWidthScale;
    }else if (type == 3) {
        width_y = 128*kWidthScale;
    }
    [self addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(29*kWidthScale, 20*kHeightScale));
        make.left.mas_equalTo(nameLab.mas_right).offset(width_y);
        make.centerY.mas_equalTo(0);
    }];
    
    // 时长
    UILabel *hoursLab = [[UILabel alloc] init];
    hoursLab.text = @"时长";
    hoursLab.textColor = [UIColor colorWithHexString:@"#111518"];
    hoursLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    CGFloat hoursLabWidth_y = 97*kWidthScale;
    if (type == 2) {
        hoursLabWidth_y = 123*kWidthScale;
    }else if (type == 4){
        hoursLabWidth_y = 123*kWidthScale;
        hoursLab.hidden = YES;
    }else if (type == 3) {
        hoursLabWidth_y = 58*kWidthScale;
    }
    [self addSubview:hoursLab];
    [hoursLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20*kHeightScale);
        make.left.mas_equalTo(timeLab.mas_right).offset(hoursLabWidth_y);
        make.centerY.mas_equalTo(0);
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
