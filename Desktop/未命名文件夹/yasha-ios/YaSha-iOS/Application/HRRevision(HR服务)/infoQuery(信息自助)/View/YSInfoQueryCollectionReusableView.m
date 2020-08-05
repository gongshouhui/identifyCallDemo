//
//  YSInfoQueryCollectionReusableView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/14.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSInfoQueryCollectionReusableView.h"
#import "YSWaterRippleView.h"
#import "YSHRCircleView.h"
#import "UIView+MLMBorderPath.h"
#import "YSProgressView.h"
#import "YSPageControlWithView.h"

@interface YSInfoQueryCollectionReusableView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) YSPageControlWithView *pageView;
@property (nonatomic,strong) UILabel *inductionTimeLabel;
@property (nonatomic,strong) UIImageView *performanceImage;
@property (nonatomic,strong) UILabel *performanceLabel;
@property (nonatomic,strong)UILabel *cumulativePerformance;
@property (nonatomic,strong)UILabel *shouldPerformance;
@property (nonatomic,strong)YSWaterRippleView *waterView;
@property (nonatomic,strong)YSProgressView *leaveView;
@property (nonatomic,strong)YSProgressView *tripView;
@property (nonatomic,strong)YSProgressView *goOutView;
@property (nonatomic,strong)YSProgressView *lateView;
@property (nonatomic,strong)YSProgressView *absenteeismView;
@property (nonatomic,strong)UILabel *cumulativeLeave;
@property (nonatomic,strong)UILabel *shouldLeave;
@property (nonatomic,strong)YSHRCircleView *targetRateView;
@property (nonatomic,strong)UILabel *cumulativeTarget;
@property (nonatomic,strong)UILabel *shouldTarget;
@property (nonatomic,strong)YSProgressView *hoursView;
@property (nonatomic,strong)YSProgressView *numberView;
@property (nonatomic,strong)UILabel *cumulativeTraining;
@property (nonatomic,strong)UILabel *shouldTraining;
@property (nonatomic,strong)YSHRCircleView *personalView;
@property (nonatomic,strong)UILabel *cumulativePersonal;
@property (nonatomic,strong)UILabel *shouldPersonal;
@property (nonatomic,strong)YSHRCircleView *responsibilityView;
@property (nonatomic,strong)UILabel *cumulativeResponsibility;
@property (nonatomic,strong)UILabel *shouldResponsibility;
@end

@implementation YSInfoQueryCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 249*kHeightScale);
//        self.backgroundColor = [UIColor redColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 249*kHeightScale);
    imageView.image = [UIImage imageNamed:@"背景图"];
    [self addSubview:imageView];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 249*kHeightScale)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*5, 0);
    [self addSubview:self.scrollView];
    CGRect rectValue=CGRectMake(0, self.frame.size.height*0.85, kSCREEN_WIDTH, 52);
    UIImage *currentImage=[UIImage imageNamed:@"蓝点"];
    UIImage *pageImage=[UIImage imageNamed:@"灰点"];;
    self.pageView=[YSPageControlWithView cusPageControlWithView:rectValue pageNum:5 currentPageIndex:0 currentShowImage:currentImage pageIndicatorShowImage:pageImage];
    [self addSubview:self.pageView];
    [self createInductionTimeLabel];//入职
    [self createPerformanceUI];//绩效
    [self createAttendanceUI];//考勤
    [self createTrainingUI];//培训
    [self createAssetsUI];//资产
    
}
- (void)createInductionTimeLabel {
    self.inductionTimeLabel = [[UILabel alloc]init];
    self.inductionTimeLabel.font = [UIFont systemFontOfSize:14];
    self.inductionTimeLabel.backgroundColor = [UIColor clearColor];
    self.inductionTimeLabel.numberOfLines = 0;
    self.inductionTimeLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"你于2016年8月8日，加入亚厦，作为这个大家庭的一员，我们共同度过2年。"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    
    self.inductionTimeLabel.attributedText = string;
    [self.scrollView addSubview:self.inductionTimeLabel];
    [self.inductionTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top).offset(55*kHeightScale);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(16*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(341*kWidthScale, 52*kHeightScale));
    }];
}
- (void)createPerformanceUI {
    self.performanceImage = [[UIImageView alloc]init];
    self.performanceImage.image = [UIImage imageNamed:@"A"];
    [self.scrollView addSubview:self.performanceImage];
    [self.performanceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top).offset(10); make.left.mas_equalTo(self.scrollView.mas_left).offset(kSCREEN_WIDTH+70*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(237*kWidthScale, 124*kHeightScale));
    }];
    
    self.performanceLabel = [[UILabel alloc]init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"你的上一年度的绩效评定为 A。"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    
    self.performanceLabel.attributedText = string;
    [self.scrollView addSubview:self.performanceLabel];
    [self.performanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.performanceImage.mas_bottom).offset(0);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(kSCREEN_WIDTH+89*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(197*kWidthScale, 20*kHeightScale));
    }];
}

- (void)createAttendanceUI {
    YSHRCircleView *view = [[YSHRCircleView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*2+36*kWidthScale, 20*kHeightScale, 74*kWidthScale, 74*kHeightScale)];
    view.lineWidth = 2.0;
    view.strokeStart = 0;
    view.strokeEnd = 1;
    view.lineColr = [UIColor whiteColor];
    [self.scrollView addSubview:view];
    
    self.waterView = [[YSWaterRippleView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*2+39*kWidthScale, 23*kHeightScale, 68*kWidthScale,68*kWidthScale)];
    self.waterView.layer.masksToBounds = YES;
    self.waterView.layer.cornerRadius = 34*BIZ;
    self.waterView.progress = 0.5;
    
    self.waterView.changeFrame = self.waterView.bounds;
    self.waterView.borderPath = [UIView circlePathRect:self.waterView.frame lineWidth:0];
//    self.waterView.border_fillColor = [UIColor whiteColor];
    self.waterView.backgroundColor = [UIColor clearColor];
    self.waterView.topColor = [UIColor colorWithRed:39/255.0 green:227/255.0 blue:250/255.0 alpha:1];
    self.waterView.bottomColor = [UIColor colorWithRed:39/255.0 green:227/255.0 blue:250/255.0 alpha:.3];
    [self.scrollView addSubview:self.waterView];
    
    self.cumulativePerformance = [[UILabel alloc]init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"0/0"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativePerformance.attributedText = string;
    self.cumulativePerformance.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.cumulativePerformance];
    [self.cumulativePerformance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left).offset(kSCREEN_WIDTH*2+30*kWidthScale);
        make.top.mas_equalTo(self.waterView.mas_bottom).offset(15*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(95*kWidthScale, 20*kHeightScale));
    }];
    self.shouldPerformance = [[UILabel alloc]init];
    self.shouldPerformance.textAlignment = NSTextAlignmentCenter;
    self.shouldPerformance.text = @"累计出勤/应出勤";
    self.shouldPerformance.textColor = [UIColor whiteColor];
    self.shouldPerformance.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:self.shouldPerformance];
    [self.shouldPerformance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left).offset(kSCREEN_WIDTH*2+30*kWidthScale);
        make.top.mas_equalTo(self.cumulativePerformance.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(94*kWidthScale, 17*kHeightScale));
    }];
    
    self.leaveView = [[YSProgressView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*2+159*kWidthScale, 28*kHeightScale,  178*kWidthScale, 6)];
    //    ysView.progressHeight = 10;
    self.leaveView.progressTintColor = kGrayColor(245);
    self.leaveView.trackTintColor = [UIColor colorWithRed:39.0/255.0 green:227.0/255.0 blue:250.0/255.0 alpha:1.0];
//    self.leaveView.progressValue = 80;
    [self.scrollView addSubview:self.leaveView];
    
    self.tripView = [[YSProgressView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*2+159*kWidthScale, 42*kHeightScale,  178*kWidthScale, 6)];
    //    ysView.progressHeight = 10;
    self.tripView.progressTintColor = kGrayColor(245);
    self.tripView.trackTintColor = [UIColor colorWithRed:39.0/255.0 green:227.0/255.0 blue:250.0/255.0 alpha:1.0];
    //    self.leaveView.progressValue = 80;
    [self.scrollView addSubview:self.tripView];
    
    self.goOutView = [[YSProgressView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*2+159*kWidthScale, 56*kHeightScale,  178*kWidthScale, 6)];
    //    ysView.progressHeight = 10;
    self.goOutView.progressTintColor = kGrayColor(245);
    self.goOutView.trackTintColor = [UIColor colorWithRed:39.0/255.0 green:227.0/255.0 blue:250.0/255.0 alpha:1.0];
    //    self.leaveView.progressValue = 80;
    [self.scrollView addSubview:self.goOutView];
    
    self.lateView = [[YSProgressView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*2+159*kWidthScale, 70*kHeightScale,  178*kWidthScale, 6)];
    //    ysView.progressHeight = 10;
    self.lateView.progressTintColor = kGrayColor(245);
    self.lateView.trackTintColor = [UIColor colorWithRed:39.0/255.0 green:227.0/255.0 blue:250.0/255.0 alpha:1.0];
    //    self.leaveView.progressValue = 80;
    [self.scrollView addSubview:self.lateView];
    
    self.absenteeismView = [[YSProgressView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*2+159*kWidthScale, 84*kHeightScale,  178*kWidthScale, 6)];
    //    ysView.progressHeight = 10;
    self.absenteeismView.progressTintColor = kGrayColor(245);
    self.absenteeismView.trackTintColor = [UIColor colorWithRed:39.0/255.0 green:227.0/255.0 blue:250.0/255.0 alpha:1.0];
    //    self.leaveView.progressValue = 80;
    [self.scrollView addSubview:self.absenteeismView];
    
    
    self.cumulativeLeave = [[UILabel alloc]init];
    NSMutableAttributedString *stringLeave = [[NSMutableAttributedString alloc] initWithString:@"35/8/3/23/9"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativeLeave.attributedText = stringLeave;
    self.cumulativeLeave.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.cumulativeLeave];
    [self.cumulativeLeave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cumulativePerformance.mas_right).offset(95*kWidthScale);
        make.top.mas_equalTo(self.waterView.mas_bottom).offset(15*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 20*kWidthScale));
    }];
    self.shouldLeave = [[UILabel alloc]init];
    self.shouldLeave.textAlignment = NSTextAlignmentCenter;
    self.shouldLeave.text = @"请假/出差/因公外出/迟到早退/旷工";
    self.shouldLeave.textColor = [UIColor whiteColor];
    self.shouldLeave.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:self.shouldLeave];
    [self.shouldLeave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shouldPerformance.mas_right).offset(30*kWidthScale);
        make.top.mas_equalTo(self.cumulativePerformance.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(200*kWidthScale, 17*kWidthScale));
    }];
}

- (void)createTrainingUI {
    YSHRCircleView *targetView = [[YSHRCircleView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*3+36*kWidthScale, 28*kHeightScale, 74*kWidthScale, 74*kWidthScale)];
    targetView.lineWidth = 2.0;
    targetView.lineColr = [UIColor whiteColor];
    targetView.strokeEnd = 1;
    targetView.strokeStart = 0;
    [self.scrollView addSubview:targetView];
    
    self.targetRateView = [[YSHRCircleView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*3+36*kWidthScale, 28*kHeightScale, 74*kWidthScale, 74*kHeightScale)];
    self.targetRateView.lineWidth = 6.0;
    self.targetRateView.strokeEnd = 0.8;
    self.targetRateView.strokeStart = 0;
    self.targetRateView.lineColr = [UIColor cyanColor];
    [self.scrollView addSubview:self.targetRateView];
    
    self.cumulativeTarget = [[UILabel alloc]init];
    NSMutableAttributedString *stringTarget = [[NSMutableAttributedString alloc] initWithString:@"80%"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativeTarget.attributedText = stringTarget;
    self.cumulativeTarget.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.cumulativeTarget];
    [self.cumulativeTarget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_right).offset(kSCREEN_WIDTH*3+51*kWidthScale);
        make.top.mas_equalTo(self.waterView.mas_bottom).offset(20*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(43*kWidthScale, 20*kWidthScale));
    }];
    self.shouldTarget = [[UILabel alloc]init];
    self.shouldTarget.textAlignment = NSTextAlignmentCenter;
    self.shouldTarget.text = @"目标达成率";
    self.shouldTarget.textColor = [UIColor whiteColor];
    self.shouldTarget.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:self.shouldTarget];
    [self.shouldTarget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_right).offset(kSCREEN_WIDTH*3+36*kWidthScale);
        make.top.mas_equalTo(self.cumulativeTarget.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(63*kWidthScale, 17*kWidthScale));
    }];
    
    self.hoursView = [[YSProgressView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*3+159*kWidthScale, 28,  178*kWidthScale, 6)];
    //    ysView.progressHeight = 10;
    self.hoursView.progressTintColor = kGrayColor(245);
    self.hoursView.trackTintColor = [UIColor colorWithRed:39.0/255.0 green:227.0/255.0 blue:250.0/255.0 alpha:1.0];
    //    self.leaveView.progressValue = 80;
    [self.scrollView addSubview:self.hoursView];
    
    self.numberView = [[YSProgressView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*3+159*kWidthScale, 42*kHeightScale,  178*kWidthScale, 6)];
    //    ysView.progressHeight = 10;
    self.numberView.progressTintColor = kGrayColor(245);
    self.numberView.trackTintColor = [UIColor colorWithRed:39.0/255.0 green:227.0/255.0 blue:250.0/255.0 alpha:1.0];
    //    self.leaveView.progressValue = 80;
    [self.scrollView addSubview:self.numberView];
    
    self.cumulativeTraining = [[UILabel alloc]init];
    NSMutableAttributedString *stringTraining = [[NSMutableAttributedString alloc] initWithString:@"46/38"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativeTraining.attributedText = stringTraining;
    self.cumulativeTraining.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.cumulativeTraining];
    [self.cumulativeTraining mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cumulativeTarget.mas_right).offset(150*kWidthScale);
        make.top.mas_equalTo(self.waterView.mas_bottom).offset(20*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(53*kWidthScale, 20*kWidthScale));
    }];
    self.shouldTraining = [[UILabel alloc]init];
    self.shouldTraining.textAlignment = NSTextAlignmentCenter;
    self.shouldTraining.text = @"完成培训学时（小时）/完成培训（次）";
    self.shouldTraining.textColor = [UIColor whiteColor];
    self.shouldTraining.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:self.shouldTraining];
    [self.shouldTraining mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shouldTarget.mas_right).offset(36*kWidthScale);
        make.top.mas_equalTo(self.cumulativeTraining.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(218*kWidthScale, 17*kWidthScale));
    }];
}

- (void)createAssetsUI {
    YSHRCircleView *targetView = [[YSHRCircleView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*4+64*kWidthScale, 28*kHeightScale, 74*kWidthScale, 74*kHeightScale)];
    targetView.lineWidth = 2.0;
    targetView.lineColr = [UIColor whiteColor];
    targetView.strokeEnd = 1;
    targetView.strokeStart = 0;
    [self.scrollView addSubview:targetView];
    
    self.personalView = [[YSHRCircleView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*4+64*kWidthScale, 28*kHeightScale, 74*kWidthScale, 74*kHeightScale)];
    self.personalView.lineWidth = 6.0;
    self.personalView.strokeEnd = 0.8;
    self.personalView.strokeStart = 0;
    self.personalView.lineColr = [UIColor cyanColor];
    [self.scrollView addSubview:self.personalView];
    
    self.cumulativePersonal = [[UILabel alloc]init];
    NSMutableAttributedString *stringTarget = [[NSMutableAttributedString alloc] initWithString:@"13 : 10/3"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativePersonal.attributedText = stringTarget;
    self.cumulativePersonal.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.cumulativePersonal];
    [self.cumulativePersonal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_right).offset(kSCREEN_WIDTH*4+70*kWidthScale);
        make.top.mas_equalTo(self.personalView.mas_bottom).offset(20*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(65*kWidthScale, 20*kWidthScale));
    }];
    self.shouldPersonal = [[UILabel alloc]init];
    self.shouldPersonal.textAlignment = NSTextAlignmentCenter;
    self.shouldPersonal.text = @"个人资产：软件/硬件（件）";
    self.shouldPersonal.textColor = [UIColor whiteColor];
    self.shouldPersonal.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:self.shouldPersonal];
    [self.shouldPersonal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_right).offset(kSCREEN_WIDTH*4+22*kWidthScale);
        make.top.mas_equalTo(self.cumulativePersonal.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(156*kWidthScale, 17*kWidthScale));
    }];
    
    YSHRCircleView *responsibilityView = [[YSHRCircleView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*4+247*kWidthScale, 28*kHeightScale, 74*kWidthScale, 74*kWidthScale)];
    responsibilityView.lineWidth = 2.0;
    responsibilityView.lineColr = [UIColor whiteColor];
    responsibilityView.strokeEnd = 1;
    responsibilityView.strokeStart = 0;
    [self.scrollView addSubview:responsibilityView];
    
    self.responsibilityView = [[YSHRCircleView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*4+247*kWidthScale, 28*kHeightScale, 74*kWidthScale, 74*kHeightScale)];
    self.responsibilityView.lineWidth = 6.0;
    self.responsibilityView.strokeEnd = 0.8;
    self.responsibilityView.strokeStart = 0;
    self.responsibilityView.lineColr = [UIColor cyanColor];
    [self.scrollView addSubview:self.responsibilityView];
    
    self.cumulativeResponsibility = [[UILabel alloc]init];
    NSMutableAttributedString *stringresponsibilityt = [[NSMutableAttributedString alloc] initWithString:@"13 : 10/3"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativeResponsibility.attributedText = stringresponsibilityt;
    self.cumulativeResponsibility.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.cumulativeResponsibility];
    [self.cumulativeResponsibility mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cumulativePersonal.mas_right).offset(110*kWidthScale);
        make.top.mas_equalTo(self.responsibilityView.mas_bottom).offset(20*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(65*kWidthScale, 20*kWidthScale));
    }];
    self.shouldResponsibility = [[UILabel alloc]init];
    self.shouldResponsibility.textAlignment = NSTextAlignmentCenter;
    self.shouldResponsibility.text = @"责任资产：软件/硬件（件）";
    self.shouldResponsibility.textColor = [UIColor whiteColor];
    self.shouldResponsibility.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:self.shouldResponsibility];
    [self.shouldResponsibility mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shouldPersonal.mas_right).offset(22*kWidthScale);
        make.top.mas_equalTo(self.cumulativeResponsibility.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(156*kWidthScale, 17*kWidthScale));
    }];
    
}
- (void)setCollectionReusableVieData:(NSDictionary *)dic {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你于%@，加入亚厦，作为这个大家庭的一员，我们共同度过%@年。",[YSUtility timestampSwitchTime:dic[@"enterTime"] andFormatter:@"yyyy年MM月dd日"],dic[@"years"]]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    self.inductionTimeLabel.attributedText = string;
    
    self.performanceImage.image = [UIImage imageNamed:dic[@"yearPer"]];
    NSMutableAttributedString *strPerformance = [[NSMutableAttributedString alloc] initWithString:[NSString  stringWithFormat:@"你的上一年度的绩效评定为 %@。",dic[@"yearPer"]]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    
    self.performanceLabel.attributedText = strPerformance;
    
    //考勤
    self.waterView.progress = [dic[@"attendance"] floatValue]/100.0;
    NSMutableAttributedString *stringPerformance = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",dic[@"normalWorkday"],dic[@"shouldWorkday"]]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativePerformance.attributedText = stringPerformance;
    
    NSMutableAttributedString *stringLeave = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",dic[@"leaveDay"],dic[@"travelDay"],dic[@"goOutCount"],dic[@"lateOrEarlyleave"],dic[@"absenteeism"]]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativeLeave.attributedText = stringLeave;
    
    NSInteger num = [dic[@"leaveDay"] floatValue] + [dic[@"travelDay"] floatValue] +[dic[@"goOutCount"] floatValue]+[dic[@"lateOrEarlyleave"] floatValue]+[dic[@"absenteeism"] floatValue];
    self.leaveView.progressValue = ([dic[@"leaveDay"] floatValue]/num)*178;
    self.tripView .progressValue = ([dic[@"travelDay"] floatValue]/num)*178;
    self.goOutView.progressValue = ([dic[@"goOutCount"] floatValue]/num)*178;
    self.lateView.progressValue = ([dic[@"lateOrEarlyleave"] floatValue]/num)*178;
    self.absenteeismView.progressValue = ([dic[@"absenteeism"] floatValue]/num)*178;
    
    //培训
    NSMutableAttributedString *stringTarget = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",dic[@"completionRate"],@"%"]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativeTarget.attributedText = stringTarget;
    self.targetRateView.strokeEnd = [dic[@"completionRate"] floatValue];
    NSMutableAttributedString *stringTraining = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",dic[@"totalHours"],dic[@"trainNum"]]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativeTraining.attributedText = stringTraining;
    
    self.hoursView.progressValue = [dic[@"completionRate"] floatValue]*178;
    self.numberView.progressValue =  ([dic[@"trainNum"] floatValue]/30.0)*178;
    
    //资产
    NSMutableAttributedString *stringPersonal = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld:%@/%@",([dic[@"personalHardware"] integerValue]+[dic[@"personalSoftware"] integerValue]),dic[@"personalSoftware"],dic[@"personalHardware"]]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativePersonal.attributedText = stringPersonal;
    
    self.personalView.strokeEnd = [dic[@"personalHardware"] floatValue]/([dic[@"personalHardware"] floatValue]+[dic[@"personalSoftware"] floatValue]);
    
    NSMutableAttributedString *stringresponsibilityt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld:%@/%@",([dic[@"responsibilityHardware"] integerValue]+[dic[@"responsibilitySoftware"] integerValue]),dic[@"responsibilitySoftware"],dic[@"responsibilityHardware"]]attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.cumulativeResponsibility.attributedText = stringresponsibilityt;
    self.responsibilityView.strokeEnd =  [dic[@"responsibilityHardware"] floatValue]/([dic[@"responsibilityHardware"] floatValue]+[dic[@"responsibilitySoftware"] floatValue]);
}
#pragma mark ScrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat  getNum=scrollView.contentOffset.x/scrollView.frame.size.width;
    NSInteger pageValue=(NSInteger)(getNum+0.5);
    
    self.pageView.indexNumWithSlide=pageValue; // 这个属性中的Setting会调用很多次,所以在其里面判断前后值
}
@end
