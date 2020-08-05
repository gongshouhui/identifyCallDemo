//
//  YSCrystalBallView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/8.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSCrystalBallView.h"
#import "YSHRCircleView.h"
#import "YSWaterRippleView.h"
#import "UIView+MLMBorderPath.h"
#import "YSHRAttendanceNumberView.h"


@interface YSCrystalBallView ()
@property (nonatomic,strong)CAShapeLayer *shapeLayer;
@property (nonatomic,strong)YSWaterRippleView *waterView;
@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UILabel *cumulativelabel;
@property (nonatomic,strong)UILabel *shouldLabel;
@property (nonatomic, strong) YSHRAttendanceNumberView *numberTopView;
@property (nonatomic, strong) YSHRAttendanceNumberView *numberSubView;

@end

@implementation YSCrystalBallView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initUI];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)initUI {
   YSHRCircleView *view = [[YSHRCircleView alloc] initWithFrame:CGRectMake(18*kWidthScale, 85*kHeightScale, 153*kWidthScale, 153*kHeightScale)];
    view.lineColr = [UIColor colorWithRed:24.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0];
    view.strokeEnd = 1;
    view.strokeStart = 0;
    view.lineWidth = 4.0;
    view.strokeColor = [UIColor colorWithRed:24.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0];
    view.layer.shadowColor = [UIColor colorWithRed:24.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0].CGColor;
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowRadius = 1.5;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:view];
    
    
    self.waterView = [[YSWaterRippleView alloc] initWithFrame:CGRectMake(24*kWidthScale, 93*kHeightScale, 143*kWidthScale,143*kHeightScale)];
    self.waterView.center = view.center;
    self.waterView.layer.masksToBounds = YES;
//    self.waterView.layer.cornerRadius = 100*BIZ;
    self.waterView.backgroundColor = [UIColor clearColor];
    self.waterView.progress = 0;
    self.waterView.topColor = [UIColor colorWithRed:195/255.0 green:226/255.0 blue:255/255.0 alpha:1];
    self.waterView.bottomColor = [UIColor colorWithRed:195/255.0 green:226/255.0 blue:255/255.0 alpha:.3];
    self.waterView.changeFrame = self.waterView.bounds;
    self.waterView.borderPath = [UIView circlePathRect:self.waterView.frame lineWidth:0];
    self.waterView.border_fillColor = [UIColor whiteColor];
    [self addSubview:self.waterView];
    
    self.cumulativelabel = [[UILabel alloc]init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"0/0"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: Multiply(28)],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8]}];
    self.cumulativelabel.attributedText = string;
    self.cumulativelabel.textAlignment = NSTextAlignmentCenter;
    [self.waterView addSubview:self.cumulativelabel];
    [self.cumulativelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.waterView.mas_centerX);
        make.bottom.mas_equalTo(self.waterView.mas_bottom).offset(-52*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(120*kWidthScale, 40*kHeightScale));
    }];
    self.shouldLabel = [[UILabel alloc]init];
    NSMutableAttributedString *shouldLabelString = [[NSMutableAttributedString alloc] initWithString:@"累计出勤/应出勤(天)"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]}];
    self.shouldLabel. attributedText = shouldLabelString;
    self.shouldLabel.textAlignment = NSTextAlignmentCenter;
    [self.waterView addSubview:self.shouldLabel];
    [self.shouldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.waterView.mas_centerX);
        make.top.mas_equalTo(self.cumulativelabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(140*kWidthScale, 17*kHeightScale));
    }];
    
    
    self.numberTopView = [[YSHRAttendanceNumberView alloc] initWithFrame:(CGRectMake(186*kWidthScale, 86*kHeightScale, 173*kWidthScale, 70*kHeightScale)) withImgNameArray:@[@"ysBackGZLImg", @"ysMiddleGZLImg", @"ysfrontGZLImg"] withLabelTitle:@[@"0.0", @"%", @"出勤率"]];
    self.numberTopView.topTitle.textColor = kUIColor(82, 101, 255, 1);
    [self addSubview:self.numberTopView];
    
    self.numberSubView = [[YSHRAttendanceNumberView alloc] initWithFrame:(CGRectMake(CGRectGetMinX(self.numberTopView.frame), CGRectGetMaxY(self.numberTopView.frame)+12*kHeightScale, 173*kWidthScale, 70*kHeightScale)) withImgNameArray:@[@"ysBackImgGZ", @"ysMiddleImgGZ", @"zonggongshi"] withLabelTitle:@[@"0.0", @"h", @"平均工作时长"]];
    self.numberSubView.topTitle.textColor = kUIColor(29, 191, 255, 1);
    [self addSubview:self.numberSubView];
    
    self.yearButton = [[UIButton alloc]init];
    self.yearButton.frame = CGRects(16, 18*kHeightScale, 85, 20);
    self.yearButton.titleLabel.font = [UIFont systemFontOfSize:18];
    self.yearButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.yearButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    [self.yearButton setTitle:[NSString stringWithFormat:@"%ld",(long)[[[NSDate date] dateByAddingHours:8] year]] forState:UIControlStateNormal];
    [self.yearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yearButton sizeToFit];
    self.yearButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.yearButton.imageView.frame.size.width - self.yearButton.frame.size.width + self.yearButton.titleLabel.frame.size.width, 0, 0);
    
    self.yearButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -self.yearButton.titleLabel.frame.size.width - self.yearButton.frame.size.width + self.yearButton.imageView.frame.size.width);
    YSWeak;
    [[self.yearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YSStrong;
        [strongSelf.rightPopupMenuView showWithAnimated:YES];
        [strongSelf.rightPopupMenuView layoutWithTargetView:strongSelf.yearButton];
    }];
    [self addSubview:self.yearButton];
    
     self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(16*kWidthScale, 290*kHeightScale, kSCREEN_WIDTH, 70*kHeightScale)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.backgroundColor = [UIColor redColor];
    [self.scrollView setContentSize:CGSizeMake((75*6+30*5)*kWidthScale, 70*kHeightScale)];
    [self addSubview:self.scrollView];
    NSArray *titleArray = @[@"0\n\n请假(次)",@"0\n\n出差(次)",@"0\n\n加班(次)",@"0\n\n因公外出(次)",@"0\n\n迟到早退(次)",@"0\n\n旷工(次)"];
    for (int i = 0; i <= 5; i++) {
        self.button = [[UIButton alloc]init];
        self.button.frame = CGRects(105*i, 5, 75, 60);
        self.button.backgroundColor = [UIColor whiteColor];
        self.button.titleLabel.numberOfLines = 0;
        self.button.tag = i+5;
        [self.button setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i != 5) {
            UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetMaxX(self.button.frame)+15, 40, 1, 16))];
            lineLab.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.08];
            [self.scrollView addSubview:lineLab];
        }
        if (i == 0) {
            [self.button setTitleColor:kUIColor(24, 144, 255, 1) forState:UIControlStateNormal];
        }else {
            [self.button setTitleColor:kUIColor(25, 31, 37, 1) forState:UIControlStateNormal];
        }
        self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.button addTarget:self action:@selector(attendanceType:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.button];
        
    }
}

- (void)setHeaderData:(YSSummaryModel *)headerModel {
    NSMutableAttributedString *string;
    NSMutableArray *countArray = [NSMutableArray array];
    CGFloat numberFont = Multiply(28);
    if ([[NSString stringWithFormat:@"%@/%@",[YSUtility cancelNullData:headerModel.normalWorkday],[YSUtility cancelNullData:headerModel.shouldWorkday]] length] >= 9) {
        numberFont = Multiply(21);
    }
    if (headerModel) {
        self.waterView.progress = [headerModel.attendance floatValue]/100.0;
        string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",headerModel.normalWorkday,headerModel.shouldWorkday]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: numberFont],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n请假(次)",headerModel.leaveCount]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n出差(次)",headerModel.travelCount]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n加班(次)",headerModel.jiaBanCount]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n因公外出(次)",headerModel.goOutCount]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n迟到早退(次)",headerModel.lateOrEarlyleave]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n旷工(次)",headerModel.absenteeismCount]];
        
        self.numberTopView.topTitle.attributedText = [self changeTitleStrWithLeftStr:[NSString stringWithFormat:@"%.2f",headerModel.attendance.doubleValue] withRightStr:@"%"];
        self.numberSubView.topTitle.attributedText = [self changeTitleStrWithLeftStr:[NSString stringWithFormat:@"%.2f", headerModel.avgWorkHour] withRightStr:@"h"];
        
    }else{
        self.waterView.progress = 0;
        string = [[NSMutableAttributedString alloc] initWithString:@"0/0"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: numberFont],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n请假(次)",@"0"]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n出差(次)",@"0"]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n加班(次)",@"0"]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n因公外出(次)",@"0"]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n迟到早退(次)",@"0"]];
        [countArray addObject:[NSString stringWithFormat:@"%@\n\n旷工(次)",@"0"]];
        self.numberTopView.topTitle.attributedText = [self changeTitleStrWithLeftStr:@"0.0" withRightStr:@"%"];
        self.numberSubView.topTitle.attributedText = [self changeTitleStrWithLeftStr:@"0.0" withRightStr:@"h"];
    }
   
    self.cumulativelabel.attributedText = string;
    
  
    for (int i = 0; i <= 4; i++) {
        UIButton *find_button = (UIButton *)[self.scrollView viewWithTag:i+5];
        [find_button setTitle:countArray[i] forState:UIControlStateNormal];
    }
}

- (void)attendanceType:(UIButton *)sender {
    for (int i = 0; i <= 5; i++) {
        UIButton *find_button = (UIButton *)[self.scrollView viewWithTag:i+5];
        if (sender.tag == i+5) {
             [find_button setTitleColor:kUIColor(24, 144, 255, 1) forState:UIControlStateNormal];
        }else{
            [find_button setTitleColor:kUIColor(25, 31, 37, 1) forState:UIControlStateNormal];
        }
    }
    //type>10:请假;20:出差;30:因公外出;40:加班;50:忘记打卡;70或者80:迟到早退;110:旷工
    NSString *type;
    if (sender.tag == 5) {
        type = @"10";
    }else if (sender.tag == 6) {
        type = @"20";
    }else if (sender.tag == 7) {
        type = @"40";
    }else if (sender.tag == 8) {
        type = @"30";
    }else if (sender.tag == 9) {
        type = @"80";
    }else if (sender.tag == 10) {
        type = @"110";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"attendanceType" object:type userInfo:nil];
    
    
}

// 修改label字体的大小颜色
- (NSMutableAttributedString*)changeTitleStrWithLeftStr:(NSString*)leftStr withRightStr:(NSString*)rightStr {
    
    NSString *completeStr = [NSString stringWithFormat:@"%@%@", leftStr, rightStr];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:completeStr];
    [attributeStr setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: Multiply(27)]} range:[completeStr rangeOfString:leftStr]];
    [attributeStr setAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: Multiply(20)]} range:[completeStr rangeOfString:rightStr]];
    
    return attributeStr;
}
// 向下弹出
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
/*
 // 向上弹出
- (QMUIPopupMenuView *)rightPopupMenuView {
    if (!_rightPopupMenuView) {
        _rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        _rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        _rightPopupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
        _rightPopupMenuView.maximumWidth = 80*kWidthScale;
//        _rightPopupMenuView.maximumHeight = 40*kHeightScale;
        _rightPopupMenuView.shouldShowItemSeparator = YES;
        _rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, _rightPopupMenuView.padding.left, 0, _rightPopupMenuView.padding.right);
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSInteger i = [[[NSDate date] dateByAddingHours:8] year]; i >= 2018 ; i --) {
            QMUIPopupMenuItem *popupMenuItem = [QMUIPopupMenuItem itemWithImage:UIImageMake(@"") title:[NSString stringWithFormat:@"%zd", i] handler:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPerfYear" object:[NSString stringWithFormat:@"%zd", i] userInfo:nil];
                [self.yearButton setTitle:[NSString stringWithFormat:@"%zd", i] forState:UIControlStateNormal];
                [_rightPopupMenuView hideWithAnimated:YES];
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
@end
