//
//  YSHRMSummaryHeaderView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

// 汇总界面
#import "YSHRMSummaryHeaderView.h"
#import "YSSummaryModel.h"

@interface YSHRMSummaryHeaderView ()<PGDatePickerDelegate>
@property (nonatomic, strong) UIButton *yearButton;
@property (nonatomic, strong) UILabel *titLab;
@property (nonatomic, strong) UILabel *attendanceLab;
@property (nonatomic, strong) UILabel *attendanceTimeLab;

//@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;



@end

@implementation YSHRMSummaryHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}


- (void)loadSubViews {
    
    
    self.yearButton = [[UIButton alloc]init];
    self.yearButton.frame = CGRects(16*kWidthScale, 23*kHeightScale, 100*kWidthScale, 20*kHeightScale);
    self.yearButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    self.yearButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.yearButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    [self.yearButton setTitle:[NSString stringWithFormat:@"%ld %ld",(long)[[[NSDate date] dateByAddingHours:0] year],(long)[[[NSDate date] dateByAddingHours:0] month]] forState:UIControlStateNormal];
    [self.yearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yearButton sizeToFit];
    self.yearButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.yearButton.imageView.frame.size.width - self.yearButton.frame.size.width + self.yearButton.titleLabel.frame.size.width, 0, 0);
    
    self.yearButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -self.yearButton.titleLabel.frame.size.width - self.yearButton.frame.size.width + self.yearButton.imageView.frame.size.width);
    @weakify(self);
    [[self.yearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [strongSelf.rightPopupMenuView showWithAnimated:YES];
//        [strongSelf.rightPopupMenuView layoutWithTargetView:strongSelf.yearButton];
        @strongify(self);
        [self addTimeChosePicker];
        
    }];
    [self addSubview:self.yearButton];
    
    self.titLab = [[UILabel alloc] init];
    self.titLab.text = @"亚厦集团";
    self.titLab.textColor = [[UIColor colorWithHexString:@"#191F25"] colorWithAlphaComponent:0.8];
    self.titLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:self.titLab];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23*kHeightScale);
        make.right.mas_equalTo(self.mas_right).offset(-16*kWidthScale);
    }];
    
    // 数据展示
    UILabel *dataLab = [[UILabel alloc] initWithFrame:(CGRectMake(16*kWidthScale, 69*kHeightScale, 80*kWidthScale, 22*kHeightScale))];
    dataLab.textColor = [UIColor colorWithHexString:@"#333333"];
    dataLab.text = @"数据展示";
    dataLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(16)];
    [self addSubview:dataLab];
    
    // 出勤率
    self.attendanceLab = [[UILabel alloc] initWithFrame:(CGRectMake(16*kWidthScale, 112*kHeightScale, kSCREEN_WIDTH/2-20, 59*kHeightScale))];
    self.attendanceLab.textAlignment = NSTextAlignmentLeft;
    self.attendanceLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(42)];
    self.attendanceLab.attributedText = [self changeTitleStrWithLeftStr:@"0.0" withRightStr:@"%"];
    [self addSubview:self.attendanceLab];
    
    UILabel *showAttendLab = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetMinX(self.attendanceLab.frame), CGRectGetMaxY(self.attendanceLab.frame), CGRectGetWidth(self.attendanceLab.frame), 20*kHeightScale))];
    showAttendLab.textAlignment = NSTextAlignmentLeft;
    showAttendLab.textColor = [UIColor colorWithHexString:@"#A3A5A8"];
    showAttendLab.text = @"员工出勤率";
    showAttendLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:showAttendLab];
    
    UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetMidX(self.frame)-1, 138*kHeightScale, 2, 28*kHeightScale))];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self addSubview:lineLab];
    
    // 平均工作时长
    self.attendanceTimeLab = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetMaxX(lineLab.frame)+51, 112*kHeightScale, kSCREEN_WIDTH/2-60, 59*kHeightScale))];
    self.attendanceTimeLab.textAlignment = NSTextAlignmentLeft;
    self.attendanceTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(42)];
    self.attendanceTimeLab.attributedText = [self changeTitleStrWithLeftStr:@"0.0" withRightStr:@"h"];
    [self addSubview:self.attendanceTimeLab];
    
    UILabel *showTimeLab = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetMinX(self.attendanceTimeLab.frame), CGRectGetMaxY(self.attendanceTimeLab.frame), CGRectGetWidth(self.attendanceTimeLab.frame), 20*kHeightScale))];
    showTimeLab.textColor = [UIColor colorWithHexString:@"#A3A5A8"];
    showTimeLab.text = @"员工平均工作时长";
    showTimeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    showTimeLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:showTimeLab];
   
    // 考勤统计
    UILabel *dataAttendanceLab = [[UILabel alloc] initWithFrame:(CGRectMake(16*kWidthScale, 220*kHeightScale, 80*kWidthScale, 22*kHeightScale))];
    dataAttendanceLab.textColor = [UIColor colorWithHexString:@"#333333"];
    dataAttendanceLab.text = @"考勤统计";
    dataAttendanceLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(16)];
    [self addSubview:dataAttendanceLab];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 260*kHeightScale, kSCREEN_WIDTH, 60*kHeightScale)];
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setContentSize:CGSizeMake(96*kWidthScale*6+6+36, 60*kHeightScale)];
    [self addSubview:scrollView];
    NSArray *titleArray = @[@"请假(次)",@"出差(次)" , @"加班(次)", @"因公外出(次)",@"迟到早退(次)",@"旷工(次)"];
    for (int i = 0; i < titleArray.count; i++) {
        CGFloat btn_x = 97*kWidthScale*i;
        if (i == 4 || i == 3) {
            btn_x = CGRectGetMaxX([[scrollView viewWithTag:i+314] frame])+12;
        }else if (i > 4) {
            btn_x = CGRectGetMaxX([[scrollView viewWithTag:i+314] frame])+1;
        }
        DLog(@"位置是多少:%f", btn_x);
        CustomMBtnView *btnView = [[CustomMBtnView alloc] initWithFrame:(CGRectMake(btn_x, 5, 96*kWidthScale, 60))];
        btnView.backBtn.tag = i+115;
        btnView.topLab.text = @"0";
        btnView.topLab.textColor = [UIColor colorWithHexString:@"#333333"];
        btnView.bottomLab.text = titleArray[i];
        if (i != 5) {
            UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetMaxX(btnView.frame), CGRectGetMidY(btnView.frame), 1, 16))];
            lineLab.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.08];
            if (i == 4 || i ==3) {
                lineLab.frame = CGRectMake(CGRectGetMaxX(btnView.frame)+12, CGRectGetMidY(btnView.frame), 1, 16);
            }
            lineLab.tag = i+315;
            [scrollView addSubview:lineLab];
        }
        [btnView.backBtn addTarget:self action:@selector(attendanceType:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btnView];
        
    }
}

#pragma mark--更新视图数据
- (void)upSubViewDataWith:(YSSummaryModel*)model {
    self.titLab.text = model.typeName;
    
    self.attendanceLab.attributedText = [self changeTitleStrWithLeftStr:[NSString stringWithFormat:@"%.2f", [model.attendance floatValue]] withRightStr:@"%"];
    self.attendanceTimeLab.attributedText = [self changeTitleStrWithLeftStr:[NSString stringWithFormat:@"%.2f", model.avgWorkHour] withRightStr:@"h"];
    NSArray *numberArray = @[[self handelGetDataWith:model.leaveCount], [self handelGetDataWith:model.travelCount], [self handelGetDataWith:model.jiaBanCount], [self handelGetDataWith:model.goOutCount], [self handelGetDataWith:model.lateOrEarlyleave], [self handelGetDataWith:model.absenteeismCount]];
    for (int i = 0; i<numberArray.count; i++) {
        UIButton *btn = [self viewWithTag:115+i];
        CustomMBtnView *btnView = (CustomMBtnView *)[btn superview];
        btnView.topLab.text = numberArray[i];
    }
}

// 处理空数据
- (NSString*)handelGetDataWith:(NSString*)str {
    if ([str isEqual:[NSNull null]] || str == nil) {
        return @"0";
    }else {
        return str;
    }
}

- (void)attendanceType:(UIButton*)sender {

    if ([self.delegate respondsToSelector:@selector(choseBtnActionType:)]) {
        [self.delegate choseBtnActionType:(sender.tag-115)];
    }
}

// 修改字体大小
- (NSMutableAttributedString*)changeTitleStrWithLeftStr:(NSString*)leftStr withRightStr:(NSString*)rightStr {
    
    NSString *completeStr = [NSString stringWithFormat:@"%@%@", leftStr, rightStr];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:completeStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[[UIColor colorWithHexString:@"#191F25"] colorWithAlphaComponent:0.8] range:[completeStr rangeOfString:leftStr]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"##848484"] range:[completeStr rangeOfString:rightStr]];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size: Multiply(18)] range:[completeStr rangeOfString:rightStr]];
    
    return attributeStr;
}

- (void)addTimeChosePicker {
    
    PGDatePicker *datePicker = [[PGDatePicker alloc] init];
    datePicker.delegate = self;
    [datePicker showWithShadeBackgroud];
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    // 设置显示最大时间（此处为当前时间）
    datePicker.maximumDate = [NSDate date];
    
}

#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPerfYear" object:nil userInfo:@{@"time":[NSString stringWithFormat:@"%zd-%zd", dateComponents.year, dateComponents.month]}];

    [self.yearButton setTitle:[NSString stringWithFormat:@"%zd %zd", dateComponents.year, dateComponents.month] forState:UIControlStateNormal];

}
/*
- (QMUIPopupMenuView *)rightPopupMenuView {
    if (!_rightPopupMenuView) {
        _rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        _rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        _rightPopupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
        _rightPopupMenuView.maximumWidth = 80*kWidthScale;
        _rightPopupMenuView.shouldShowItemSeparator = YES;
        _rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, _rightPopupMenuView.padding.left, 0, _rightPopupMenuView.padding.right);
        YSWeak;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSInteger i = [[[NSDate date] dateByAddingHours:8] year]; i >= 2016 ; i --) {
            QMUIPopupMenuItem *popupMenuItem = [QMUIPopupMenuItem itemWithImage:UIImageMake(@"") title:[NSString stringWithFormat:@"%zd", i] handler:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPerfYear" object:[NSString stringWithFormat:@"%zd", i] userInfo:nil];
                [weakSelf.yearButton setTitle:[NSString stringWithFormat:@"%zd", i] forState:UIControlStateNormal];
                [weakSelf.rightPopupMenuView hideWithAnimated:YES];
            }];
            [mutableArray addObject:popupMenuItem];
        }
        _rightPopupMenuView.items = [mutableArray copy];
        _rightPopupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
    }
    return _rightPopupMenuView;
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation CustomMBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _topLab = [[UILabel alloc] init];
        _topLab.font = [UIFont fontWithName:@"PingFang-SC-Semibold" size:Multiply(14)];
        _topLab.text = @"123123";
        _topLab.textColor = kUIColor(24, 144, 255, 1);
        [self addSubview:_topLab];
        [_topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_centerY).offset(1);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.text = @"你猜";
        _bottomLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
        _bottomLab.textColor = kUIColor(163, 164, 168, 1);
        [self addSubview:_bottomLab];
        [_bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_centerY).offset(1);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        _backBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _backBtn.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:_backBtn];
    }
    return self;
}

@end
