//
//  YSMonthListView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMonthListView.h"
#import "UIImage+YSImage.h"
@interface YSMonthListView()
@property (nonatomic,strong) NSMutableArray *monthArr;
@end
@implementation YSMonthListView
- (NSMutableArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        
        //当前时间字符串
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        [_monthArr addObject:currentDateStr];
        
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        //时间容器类，年月日时分秒
        NSDateComponents *comps = nil;
        comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentDate];
        for (int i = -1; i > -6; i--) {
            NSDateComponents *adcomps = [[NSDateComponents alloc] init];
            
            [adcomps setYear:0];
            
            [adcomps setMonth:i];
            
            [adcomps setDay:0];
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:currentDate options:0];
            NSString *nextDateStr = [dateFormatter stringFromDate:newdate];
            [_monthArr addObject:nextDateStr];
        }
    }
    return _monthArr;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    //self.backgroundColor = [UIColor colorWithHexString:@"#FF667AFF"];
    [self setUpGradualChangeColor];
   
    UIButton *lastBtn = nil;
    for (int i = 0; i < self.monthArr.count; i++) {
        UIButton *monthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        monthBtn.tag = 100 + i;
        monthBtn.layer.cornerRadius = 35/2;
        monthBtn.layer.masksToBounds = YES;
        monthBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [monthBtn setTitle:[self getMonthString:self.monthArr[i]] forState:UIControlStateNormal];
        [monthBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#40FFFFFF"]] forState:UIControlStateSelected];
        [self addSubview:monthBtn];
        [monthBtn addTarget:self action:@selector(monthClick:) forControlEvents:UIControlEventTouchUpInside];
        [monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.mas_equalTo(10);
            }else{
                make.left.mas_equalTo(lastBtn.mas_right).mas_equalTo(5);
                make.width.mas_equalTo(lastBtn);
            }
            
            if (i == self.monthArr.count -1) {
                make.right.mas_equalTo(-10);
            }
            make.top.mas_equalTo(5 + kTopHeight);
            make.bottom.mas_equalTo(-5);
            make.height.mas_equalTo(35);
        }];
        if (i == 0) {
            monthBtn.selected = YES;
            monthBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        lastBtn = monthBtn;
    }
}
- (NSString *)getMonthString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSDateFormatter *dateFormatterOther = [[NSDateFormatter alloc]init];
    [dateFormatterOther setDateFormat:@"yyyy-MM"];
    
    NSString *mounth = [dateFormatter stringFromDate:[dateFormatterOther dateFromString:dateString]];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    if ([mounth isEqualToString:currentDateStr]) {
        return @"本月";
    }else{
        return [NSString stringWithFormat:@"%@月",mounth];
    }
    
}
- (void)monthClick:(UIButton *)button {
    if (button.selected) {
        return;
    }
    
    button.selected = YES;
    for (UIButton *subBtn in self.subviews) {
        
        if (button == subBtn) {
            subBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }else{
            subBtn.selected = NO;
            subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    if (self.dateBlock) {
        self.dateBlock(self.monthArr[button.tag - 100]);
    }
}
- (void)resetState {
    for (UIButton *subBtn in self.subviews) {
        subBtn.selected = NO;
    }
    
}
//设置渐变色，根据外部使用view的尺寸来设置（因为他需要确定的尺寸，并且在添加控件前）
- (void)setUpGradualChangeColor {
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 45 + kTopHeight);
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"729BFF"].CGColor,
                             (__bridge id)[UIColor colorWithHexString:@"667AFF"].CGColor];
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
}
@end
