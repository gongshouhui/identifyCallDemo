//
//  YSPMSMQPlanProgressListHeaderView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/21.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQPlanProgressListHeaderView.h"

@implementation YSPMSMQPlanProgressListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, 118*kHeightScale));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"进度日期";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = kUIColor(126, 126, 126, 1.0);
    [view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(12);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(65*kWidthScale, 25*kHeightScale));
    }];
    
    self.button = [[QMUIButton alloc]init];
    self.button.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.button setTitleColor:kUIColor(153, 153, 153, 1) forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
    
    [self.button setTitle:[NSString stringWithFormat:@"%ld-%@-%@",comp.year, comp.month < 10 ?[NSString stringWithFormat:@"0%ld",comp.month]:[NSString stringWithFormat:@"%ld",comp.month],comp.day < 10 ?[NSString stringWithFormat:@"0%ld",comp.day]:[NSString stringWithFormat:@"%ld",comp.day]] forState:UIControlStateNormal];
    //设置button文字的位置
    //    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    //调整与边距的距离
    //    self.timeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.button.imagePosition = QMUIButtonImagePositionRight;
    self.button.spacingBetweenImageAndTitle = 8;
    [view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
            make.centerX.mas_equalTo(view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(200*kWidthScale, 25*kHeightScale));
    }];

}


@end
