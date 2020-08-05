//
//  YSHRMDTrainingGTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMDTrainingGTableViewCell.h"

@interface YSHRMDTrainingGTableViewCell ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *numFirstLab;
@property (nonatomic, strong) UILabel *nameFirstLab;

@property (nonatomic, strong) UILabel *numSecondLab;
@property (nonatomic, strong) UILabel *nameSecondLab;

@property (nonatomic, strong) UILabel *numThirdLab;
@property (nonatomic, strong) UILabel *nameThirdLab;

@property (nonatomic, strong) UILabel *numThirdLab1;
@property (nonatomic, strong) UILabel *nameThirdLab1;

@property (nonatomic, strong) UILabel *numFourthLab;
@property (nonatomic, strong) UILabel *nameFourthLab;

@property (nonatomic, strong) UILabel *numFifthLab;
@property (nonatomic, strong) UILabel *nameFifthLab;


@end

@implementation YSHRMDTrainingGTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadSubViews];
    }
    return self;
}
- (void)loadSubViews {
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.text = @"培训课程";
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(16)];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15*kHeightScale);
        make.left.mas_equalTo(16*kWidthScale);
    }];
    
    _backTopView = [[UIView alloc] init];
    _backTopView.layer.borderColor = [UIColor colorWithHexString:@"#F6F6F6"].CGColor;
    _backTopView.layer.borderWidth = 2;
    _backTopView.layer.cornerRadius  = 4;
    _backTopView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backTopView];
    [_backTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343*kWidthScale, 126*kHeightScale));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(21*kHeightScale);
    }];
    [_backTopView layoutIfNeeded];
    
    CellShowSubView *firthView = [[CellShowSubView alloc] init];
    firthView.tag = 531;
    [_backTopView addSubview:firthView];
    [firthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160*kWidthScale, 58*kHeightScale));
        make.left.top.mas_equalTo(0);
    }];
    
    CellShowSubView *secondView = [[CellShowSubView alloc] init];
    secondView.tag = 532;
    [_backTopView addSubview:secondView];
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140*kWidthScale, 58*kHeightScale));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(firthView.mas_bottom);
    }];
    [secondView layoutIfNeeded];
    // 示意图
    _schematicImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hrmdTrinSUpImg"]];
    [_backTopView addSubview:_schematicImg];
    [_schematicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16*kWidthScale, 16*kHeightScale));
        make.bottom.mas_equalTo(secondView.mas_bottom).offset(-2*kHeightScale);
        make.left.mas_equalTo(secondView.mas_right).offset(8*kWidthScale);
        
    }];
    // 进度条
    self.circleChart = [[PNCircleChart alloc] initWithFrame:(CGRectMake(218*kWidthScale, (_backTopView.mj_h-93*kHeightScale)/2, 93*kWidthScale, 93*kHeightScale)) total:@(100) current:@(0) clockwise:YES shadow:YES shadowColor:[UIColor colorWithHexString:@"#F0F0F0"] displayCountingLabel:NO overrideLineWidth:@(6)];
    self.circleChart.chartType = PNChartFormatTypePercent;
    self.circleChart.strokeColor = [UIColor colorWithHexString:@"#FFBD3B"];
    self.circleChart.duration = 3;//进度条持续时间
    [self.circleChart strokeChart];
    [_backTopView addSubview:self.circleChart];
    // updateChartByCurrent 更新百分比
    
    //覆盖掉circleChart的标题
    self.currentLab = [[UILabel alloc] init];
    self.currentLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(21)];
    self.currentLab.text = @"0.0";
    self.currentLab.textColor = [[UIColor colorWithHexString:@"#191F25"] colorWithAlphaComponent:0.8];
    [_backTopView addSubview:self.currentLab];
    [self.currentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.circleChart.mas_centerX);
        make.top.mas_equalTo(self.circleChart.mas_top).offset(24*kHeightScale);
        make.height.mas_equalTo(29*kHeightScale);
    }];
    
    //百分号 完成率
    UILabel *ratioLab = [[UILabel alloc] init];
    ratioLab.text = @"%";
    ratioLab.textColor = [UIColor colorWithHexString:@"#848484"];
    ratioLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(12)];
    [_backTopView addSubview:ratioLab];
    [ratioLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleChart.mas_top).offset(27*kHeightScale);
        make.left.mas_equalTo(_currentLab.mas_right);
    }];
    UILabel *attendanceLab = [[UILabel alloc] init];
    attendanceLab.text = @"完成率";
    attendanceLab.textColor = [UIColor colorWithHexString:@"#A3A5A8"];
    attendanceLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [_backTopView addSubview:attendanceLab];
    [attendanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_currentLab.mas_bottom);
        make.centerX.mas_equalTo(_currentLab);
    }];
    
    _backBottomView = [[UIView alloc] init];
    _backBottomView.layer.borderColor = [UIColor colorWithHexString:@"#F6F6F6"].CGColor;
    _backBottomView.layer.borderWidth = 2;
    _backBottomView.layer.cornerRadius  = 4;
    _backBottomView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backBottomView];
    [_backBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343*kWidthScale, 74*kHeightScale));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_backTopView.mas_bottom).offset(7*kHeightScale);
    }];
    // 第三个组件
    CellShowSubView *thirdView = [[CellShowSubView alloc] init];
    thirdView.tag = 533;
    [_backBottomView addSubview:thirdView];
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160*kWidthScale, 58*kHeightScale));
        make.left.top.mas_equalTo(0);
    }];
    // 详情
    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
    [_backTopView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(295*kWidthScale, kHeightScale));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(secondView.mas_bottom).offset(15*kHeightScale);
    }];
    // 详情 第三个组件
    CellShowSubView *thirdDetailView = [[CellShowSubView alloc] init];
    thirdDetailView.tag = 543;
    [_backTopView addSubview:thirdDetailView];
    [thirdDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140*kWidthScale, 58*kHeightScale));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(lineLab.mas_bottom);
    }];
    
    // 详情第四个组件
    CellShowSubView *fourthDetailView = [[CellShowSubView alloc] init];
    fourthDetailView.tag = 534;
    [_backTopView addSubview:fourthDetailView];
    [fourthDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140*kWidthScale, 58*kHeightScale));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(thirdDetailView.mas_bottom);
    }];
    
    // 详情 第五个组件
    CellShowSubView *fifthDetailView = [[CellShowSubView alloc] init];
    fifthDetailView.tag = 535;
    [_backTopView addSubview:fifthDetailView];
    [fifthDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140*kWidthScale, 58*kHeightScale));
        make.left.mas_equalTo(thirdDetailView.mas_right).offset(-14*kWidthScale);
        make.top.mas_equalTo(thirdDetailView.mas_top);
    }];
    
    [self.contentView bringSubviewToFront:thirdDetailView];
}

// 培训课程
- (void)setTrainingCourse:(TrainingCourseModel *)trainingCourse {
    if (!_trainingCourse) {
        _trainingCourse = trainingCourse;
    }
    _titleLab.text = @"培训课程";
    NSString *numberStr = [NSString stringWithFormat:@"%.1f", trainingCourse.completionRate*100];
    self.currentLab.text = numberStr;
    [self.circleChart updateChartByCurrent:@([numberStr floatValue])];
    
    CellShowSubView *firstView = [self.contentView viewWithTag:531];
    firstView.numberLab.text = trainingCourse.planTrainCourse;
    firstView.nameLab.text = @"计划培训 (门)";
    
    CellShowSubView *secondView = [self.contentView viewWithTag:532];
    secondView.numberLab.text = trainingCourse.completeTrainCourse;
    secondView.nameLab.text = @"完成培训 (门)";
    
    CellShowSubView *thirdView = [self.contentView viewWithTag:533];
    thirdView.numberLab.text = trainingCourse.completeTrainOutCourse;
    thirdView.nameLab.text = @"计划外培训 (门)";
}

// 课程开发
- (void)setCourseDevelop:(CourseDevelopModel *)courseDevelop {
    if (!_courseDevelop) {
        _courseDevelop = courseDevelop;
    }
    _titleLab.text = @"课程开发";
    NSString *numberStr = [NSString stringWithFormat:@"%.1f", courseDevelop.completionRate*100];
    self.currentLab.text = numberStr;
    [self.circleChart updateChartByCurrent:@([numberStr floatValue])];
    
    CellShowSubView *firstView = [self.contentView viewWithTag:531];
    firstView.numberLab.text = courseDevelop.quarterPlanNum;
    firstView.nameLab.text = @"计划开发 (门)";
    
    CellShowSubView *secondView = [self.contentView viewWithTag:532];
    secondView.numberLab.text = courseDevelop.actualQuarterNum;
    secondView.nameLab.text = @"实际开发 (门)";
}

// 人均完成
- (void)setComplete:(CompleteModel *)complete {
    if (!_complete) {
        _complete = complete;
    }
    _titleLab.text = @"人均完成";
    NSString *numberStr = [NSString stringWithFormat:@"%.1f", complete.completionRate*100];
    self.currentLab.text = numberStr;
    [self.circleChart updateChartByCurrent:@([numberStr floatValue])];
    CellShowSubView *firstView = [self.contentView viewWithTag:531];
    if ([complete.averageHours containsString:@"."]) {
        firstView.numberLab.text = [NSString stringWithFormat:@"%.2f", [complete.averageHours floatValue]];
    }else {
        firstView.numberLab.text = complete.averageHours;
    }
    firstView.nameLab.text = @"年度计划 (小时)";
    
    CellShowSubView *secondView = [self.contentView viewWithTag:532];
    secondView.numberLab.text = complete.averageFinishTotalHours;
    secondView.nameLab.text = @"完成总学时 (小时)";
    
    CellShowSubView *thirdView = [self.contentView viewWithTag:543];
    thirdView.numberLab.text = complete.averageFinishClassHours;
    thirdView.nameLab.text = @"必修学时 (小时)";
    
    CellShowSubView *fourthView = [self.contentView viewWithTag:534];
    fourthView.numberLab.text = complete.averageFinishShareHours;
    fourthView.nameLab.text = @"分享学时 (小时)";
    
    CellShowSubView *fifthView = [self.contentView viewWithTag:535];
    fifthView.numberLab.text = complete.averageFinishElectiveHours;
    fifthView.nameLab.text = @"选修学时 (小时)";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation CellShowSubView

- (instancetype)init {
    if ([super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    _numberLab = [[UILabel alloc] init];
    _numberLab.text = @"13";
    _numberLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _numberLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(14)];
    [self addSubview:_numberLab];
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16*kHeightScale);
        make.left.mas_equalTo(23*kWidthScale);
        make.height.mas_equalTo(20*kHeightScale);
    }];
    
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.text = @"完成总学时 (小时)";
    _nameLab.textColor = [UIColor colorWithHexString:@"#A3A5A8"];
    _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberLab.mas_bottom).offset(2*kHeightScale);
        make.left.mas_equalTo(_numberLab.mas_left);
        make.height.mas_equalTo(20*kHeightScale);
    }];
}

@end
