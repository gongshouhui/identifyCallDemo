//
//  YSEMSExpenseSelectCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSEMSExpenseSelectCell.h"
#import "UIImage+YSImage.h"
@interface YSEMSExpenseSelectCell()
@property (nonatomic,strong) QMUIButton *dateButton;

@end
@implementation YSEMSExpenseSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico-datepicker"]];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
       
    }];
    
    self.dateButton = [[QMUIButton alloc]init];
    self.dateButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.dateButton setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comp = [gregorian components: unitFlags fromDate:dt];
    
    [self.dateButton setTitle:[NSString stringWithFormat:@"%ld-%02ld月",comp.year, comp.month] forState:UIControlStateNormal];
    self.dateButton.imagePosition = QMUIButtonImagePositionRight;
    self.dateButton.spacingBetweenImageAndTitle = 8;
    [self.contentView addSubview:self.dateButton];
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).mas_equalTo(8);
        make.centerY.mas_equalTo(imageView.mas_centerY);
    }];
    [self.dateButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    //分段控制器
    self.segControl = [[UISegmentedControl alloc]initWithItems:@[@"",@""]];
    self.segControl.layer.borderColor = [UIColor colorWithHexString:@"#FFE5E5E5"].CGColor;
    self.segControl.layer.borderWidth = 1;
    self.segControl.layer.cornerRadius = 15;
    self.segControl.layer.masksToBounds = YES;
    self.segControl.selectedSegmentIndex = 0;
    // 设置文字样式
    [ self.segControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#73000000"]} forState:UIControlStateNormal]; //正常
    //[self.segControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateHighlighted]; //按下
    [self.segControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected]; //选中
    
    // 设置背景图
    [self.segControl setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.segControl setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF5A95FF"]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segControl addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    [self.segControl setDividerImage:[UIImage new] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.contentView addSubview:self.segControl];
    [self.segControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(150);
        make.centerY.mas_equalTo(0);
       
    }];
    
}
- (void)setDateButtonTitle:(NSString *)title {
    [self.dateButton setTitle:title forState:UIControlStateNormal];
}
- (void)switchChange:(UISegmentedControl *)control {
    if (self.switchBlock) {
        self.switchBlock(control.selectedSegmentIndex);
    }
}
- (void)clickSelect:(UIButton *)button {
    PGDatePicker *datePicker = [[PGDatePicker alloc] init];
    datePicker.delegate = self;
    [datePicker showWithShadeBackgroud];
    //    datePicker.minimumDate = self.cellModel.minimumDate;
    //    datePicker.maximumDate = self.cellModel.maximumDate;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
}
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSString *dateStr = [NSString stringWithFormat:@"%02ld-%02ld", (long)dateComponents.year, (long)dateComponents.month];
    [self.dateButton setTitle:[NSString stringWithFormat:@"%@月",dateStr] forState:UIControlStateNormal];
    if (self.dateBlock) {
        self.dateBlock(dateStr);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
