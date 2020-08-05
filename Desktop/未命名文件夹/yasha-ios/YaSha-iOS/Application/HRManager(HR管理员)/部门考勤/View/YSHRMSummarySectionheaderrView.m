//
//  YSHRMSummarySectionheaderrView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMSummarySectionheaderrView.h"

@interface YSHRMSummarySectionheaderrView ()

@property (nonatomic, strong) UILabel *lineLab;
@property (nonatomic, strong) UILabel *deptLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *proportionLab;

@end

@implementation YSHRMSummarySectionheaderrView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    // 考勤统计
    UILabel *dataAttendanceLab = [[UILabel alloc] initWithFrame:(CGRectMake(16*kWidthScale, 0, 80*kWidthScale, 22*kHeightScale))];
    dataAttendanceLab.textColor = [UIColor colorWithHexString:@"#333333"];
    dataAttendanceLab.text = @"考勤统计";
    dataAttendanceLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(16)];
    [self addSubview:dataAttendanceLab];
    
    NSArray *btnNameArray = @[@"下属部门", @"部门直属人员", @"月度统计"];
    for (int i = 0; i < btnNameArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [btn setTitle:btnNameArray[i] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)];
        [btn setTitleColor:[UIColor colorWithHexString:@"#AFAFAF"] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(changeChoseOptionAction:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.tag = 380+i;
        btn.frame = CGRectMake(kSCREEN_WIDTH/3*i, CGRectGetMaxY(dataAttendanceLab.frame)+21*kHeightScale, kSCREEN_WIDTH/3, 21*kHeightScale);
        if (i == 0) {
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16*kWidthScale, 0, 0);
//            [btn setTitleColor:[UIColor colorWithHexString:@"#1890FF"] forState:(UIControlStateNormal)];
        }else if (i == 2) {
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20*kWidthScale);
        }else if (i == 1) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#1890FF"] forState:(UIControlStateNormal)];
            self.lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(btn.frame)+12*kHeightScale, 24, 2))];
            self.lineLab.center = CGPointMake(CGRectGetMidX(btn.frame), self.lineLab.center.y);
            self.lineLab.backgroundColor = [UIColor colorWithHexString:@"#1890FF"];
            [self addSubview:self.lineLab];
        }
        [self addSubview:btn];
    }
    
//    self.lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(34*kWidthScale, CGRectGetMaxY(dataAttendanceLab.frame)+54*kHeightScale, 24, 2))];
//    self.lineLab.backgroundColor = [UIColor colorWithHexString:@"#1890FF"];
//    [self addSubview:self.lineLab];
    
    // 部门 平均工时 出勤率
    _deptLab = [[UILabel alloc] init];
    _deptLab.text = @"姓名";
    _deptLab.textColor = [UIColor colorWithHexString:@"#111518"];
    _deptLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:_deptLab];
    [_deptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(123*kWidthScale, 20*kHeightScale));
        make.top.mas_equalTo(self.lineLab.mas_bottom).offset(18*kHeightScale);
    }];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"平均工时";
    _timeLab.textColor = [UIColor colorWithHexString:@"#111518"];
    _timeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [self addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_deptLab.mas_right).offset(65*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(56*kWidthScale, 20*kHeightScale));
        make.top.mas_equalTo(self.lineLab.mas_bottom).offset(18*kHeightScale);
    }];
    
    _proportionLab = [[UILabel alloc] init];
    _proportionLab.text = @"出勤率";
    _proportionLab.textColor = [UIColor colorWithHexString:@"#111518"];
    _proportionLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [self addSubview:_proportionLab];
    [_proportionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timeLab.mas_right).offset(53*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(42*kWidthScale, 20*kHeightScale));
        make.top.mas_equalTo(self.lineLab.mas_bottom).offset(18*kHeightScale);
    }];
    
    UILabel *lineLab2 = [[UILabel alloc] init];
    lineLab2.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self addSubview:lineLab2];
    [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.right.mas_equalTo(-16*kWidthScale);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1*kHeightScale);
    }];
    
}

- (void)changeChoseOptionAction:(UIButton*)sender {
    for (int i = 0; i < 3; i++) {
        UIButton *btn = (UIButton*)[self viewWithTag:380+i];
        [btn setTitleColor:[UIColor colorWithHexString:@"#AFAFAF"] forState:(UIControlStateNormal)];
    }
    [sender setTitleColor:[UIColor colorWithHexString:@"#1890FF"] forState:(UIControlStateNormal)];
    [UIView animateWithDuration:0.3 animations:^{
        switch (sender.tag) {
            case 380:
                {
                    _deptLab.text = @"部门";
                    [UIView animateWithDuration:0.5 animations:^{
                        self.lineLab.frame = CGRectMake(34*kWidthScale, self.lineLab.frame.origin.y, 24, 2);
                    }];
                    

                }
                break;
            case 381:
                {
                    _deptLab.text = @"姓名";
                    [UIView animateWithDuration:0.5 animations:^{
                        self.lineLab.center = CGPointMake(CGRectGetMidX(sender.frame), self.lineLab.center.y);
                    }];
                    
                }
                break;
            case 382:
                {
                    _deptLab.text = @"月份";
                    [UIView animateWithDuration:0.5 animations:^{
                        self.lineLab.frame = CGRectMake(kSCREEN_WIDTH-60*kWidthScale, self.lineLab.frame.origin.y, 24, 2);
                    }];
                    

                }
                break;
            default:
                break;
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"teamSummaryBtn" object:nil userInfo:@{@"index":@(sender.tag-380)}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
