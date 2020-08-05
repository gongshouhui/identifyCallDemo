//
//  YSHRMDTraiHeaderView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMDTraiHeaderView.h"

@implementation YSHRMDTraiHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:(CGRectMake(16*kWidthScale, 10*kHeightScale, 200, 22*kHeightScale))];
    titleLab.text = @"培训详情";
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(16)];
    titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:titleLab];
    // 课程 计划 学时 开课时间
    UILabel *courseLab = [[UILabel alloc] init];
    courseLab.textColor = [UIColor colorWithHexString:@"#111518"];
    courseLab.text = @"课程";
    courseLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:courseLab];
    [courseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(53*kHeightScale);
        make.left.mas_equalTo(16*kWidthScale);
    }];
    
    UILabel *planLab = [[UILabel alloc] init];
    planLab.textColor = [UIColor colorWithHexString:@"#111518"];
    planLab.text = @"计划";
    planLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:planLab];
    [planLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(courseLab.mas_top);
        make.left.mas_equalTo(courseLab.mas_right).offset(105*kWidthScale);
    }];
    
    UILabel *hoursLab = [[UILabel alloc] init];
    hoursLab.textColor = [UIColor colorWithHexString:@"#111518"];
    hoursLab.text = @"学时";
    hoursLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:hoursLab];
    [hoursLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(courseLab.mas_top);
        make.left.mas_equalTo(planLab.mas_right).offset(33*kWidthScale);
    }];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.textColor = [UIColor colorWithHexString:@"#111518"];
    timeLab.text = @"开课时间";
    timeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(courseLab.mas_top);
        make.left.mas_equalTo(hoursLab.mas_right).offset(28*kWidthScale);
    }];
    
    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.right.mas_equalTo(-16*kWidthScale);
        make.height.mas_equalTo(1*kHeightScale);
        make.bottom.mas_equalTo(0);
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
