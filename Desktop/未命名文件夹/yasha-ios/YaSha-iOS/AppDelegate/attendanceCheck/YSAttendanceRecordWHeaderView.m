//
//  YSAttendanceRecordWHeaderView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/12/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSAttendanceRecordWHeaderView.h"

@implementation YSAttendanceRecordWHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    _timeChoseLab = [[UILabel alloc] init];
    NSString *timeStr = [NSString stringWithFormat:@"%ld-%02ld",(long)[[[NSDate date] dateByAddingHours:0] year],(long)[[[NSDate date] dateByAddingHours:0] month]];
    _timeChoseLab.text = timeStr;
    _timeChoseLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)];
    _timeChoseLab.textColor = [UIColor colorWithHexString:@"#273D52"];
    [self addSubview:_timeChoseLab];
    [_timeChoseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    
    _labIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"向下箭头"]];
    [self addSubview:_labIcon];
    [_labIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timeChoseLab.mas_right).offset(14*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(14, 8));
        make.centerY.mas_equalTo(0);
        
    }];
    
    _choseBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_choseBtn];
    [_choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
