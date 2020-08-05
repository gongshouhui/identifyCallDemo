//
//  YSPMSPlanProgressListHeaderView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/10.
//

#import "YSPMSPlanProgressListHeaderView.h"

@interface YSPMSPlanProgressListHeaderView ()


//@property (nonatomic, strong) UIButton *button;


@end

@implementation YSPMSPlanProgressListHeaderView

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
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = kUIColor(126, 126, 126, 1.0);
    [view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(12);
        make.left.mas_equalTo(view.mas_left).offset(100*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(65*kWidthScale, 25*kHeightScale));
    }];
    
    self.button = [[QMUIButton alloc]init];
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.button setTitleColor:kUIColor(153, 153, 153, 1) forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
    
    [self.button setTitle:[NSString stringWithFormat:@"%ld-%@",comp.year, comp.month < 10 ?[NSString stringWithFormat:@"0%ld",comp.month]:[NSString stringWithFormat:@"%ld",comp.month]] forState:UIControlStateNormal];
        //设置button文字的位置
//    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //    //调整与边距的距离
        //    self.timeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.button.imagePosition = QMUIButtonImagePositionRight;
    self.button.spacingBetweenImageAndTitle = 8;
    [view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(12);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(13);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 25*kHeightScale));
    }];
    
  
    
    self.textFiled = [[UITextField alloc]init];
    self.textFiled.textAlignment = NSTextAlignmentCenter;
    self.textFiled.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textFiled];
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.button.mas_bottom).offset(35*kHeightScale);
        make.left.mas_equalTo(view.mas_left).offset(150*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 25*kHeightScale));
    }];
    
    self.symbollabel = [[UILabel alloc]init];
    self.symbollabel.text = @"%";
    self.symbollabel.textColor = kUIColor(42, 138, 219, 1);
    [self addSubview:self.symbollabel];
    [self.symbollabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.button.mas_bottom).offset(35*kHeightScale);
        make.left.mas_equalTo(self.textFiled.mas_right).offset(10*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(20*kWidthScale, 25*kHeightScale));
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.textFiled addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textFiled.mas_bottom).offset(-1);
        make.left.mas_equalTo(self.textFiled.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 1));
    }];
    
}

@end
