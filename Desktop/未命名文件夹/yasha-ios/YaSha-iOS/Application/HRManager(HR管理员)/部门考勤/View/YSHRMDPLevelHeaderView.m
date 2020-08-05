//
//  YSHRMDPLevelHeaderView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMDPLevelHeaderView.h"

@interface YSHRMDPLevelHeaderView ()

@property (nonatomic, strong) QMUIPopupMenuView *rightPopupMenuView;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) UIButton *coverBtn;

@end

@implementation YSHRMDPLevelHeaderView


- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
        if (type == 1) {
            // 绩效等级
            [self loadLevelViews];
        }else if (type==2){
            // 奖励信息
            [self loadReardViews];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withMenuArray:(NSArray *)titleArray {
    if ([super initWithFrame:frame]) {
        [self handelDataWith:titleArray];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    self.yearButton = [[QMUIButton alloc]init];
    self.yearButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.yearButton setTitleColor:[UIColor colorWithHexString:@"#191F25" alpha:0.8] forState:UIControlStateNormal];
    [self.yearButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comp = [gregorian components: unitFlags fromDate:dt];
    self.currentSelectedYear = [NSString stringWithFormat:@"%ld",comp.year];
    [self.yearButton setTitle:[NSString stringWithFormat:@"%ld",comp.year] forState:UIControlStateNormal];
    if (self.menuArray) {
        if (comp.month < 4) {
            self.currentSelectedYear = [NSString stringWithFormat:@"%ld 第一季度",comp.year];
            [self.yearButton setTitle:[NSString stringWithFormat:@"%ld 第一季度",comp.year] forState:UIControlStateNormal];
        }else if (comp.month < 7) {
            self.currentSelectedYear = [NSString stringWithFormat:@"%ld 第二季度",comp.year];
            [self.yearButton setTitle:[NSString stringWithFormat:@"%ld 第二季度",comp.year] forState:UIControlStateNormal];
        }else if (comp.month < 10) {
            self.currentSelectedYear = [NSString stringWithFormat:@"%ld 第三季度",comp.year];
            [self.yearButton setTitle:[NSString stringWithFormat:@"%ld 第三季度",comp.year] forState:UIControlStateNormal];
        }else if (comp.month <= 12) {
            self.currentSelectedYear = [NSString stringWithFormat:@"%ld 第四季度",comp.year];
            [self.yearButton setTitle:[NSString stringWithFormat:@"%ld 第四季度",comp.year] forState:UIControlStateNormal];
        }
    
    }
    self.yearButton.imagePosition = QMUIButtonImagePositionRight;
    self.yearButton.spacingBetweenImageAndTitle = 8;
    [self addSubview:self.yearButton];
    [self.yearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.top.mas_equalTo(22*kHeightScale);
        make.height.mas_equalTo(20*kHeightScale);
    }];
    [self.yearButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.yearButton];
    
    
    self.titLab = [[UILabel alloc] init];
    self.titLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    self.titLab.numberOfLines = 1;
    self.titLab.text = @"亚厦集团";
    self.titLab.textColor = [[UIColor colorWithHexString:@"#191F25"] colorWithAlphaComponent:0.8];
    [self addSubview:self.titLab];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22*kHeightScale);
        make.right.mas_equalTo(self.mas_right).offset(-16*kWidthScale);
        make.top.mas_equalTo(23*kHeightScale);
    }];
    
}

- (void)loadLevelViews {
    
    UILabel *subTitleLab = [[UILabel alloc] init];
    subTitleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(16)];
    subTitleLab.text = @"等级";
    subTitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:subTitleLab];
    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.height.mas_equalTo(22*kHeightScale);
        make.top.mas_equalTo(69*kHeightScale);
    }];
    
    NSArray *nameArray = @[@"全部", @"S级", @"A级", @"B级", @"C级", @"D级", @"E级"];
    NSMutableArray *masnoryArray = [NSMutableArray new];
    for (int i = 0; i < nameArray.count; i++) {
        YSHRMDPLevelBtnView *btnView = [[YSHRMDPLevelBtnView alloc] init];
        btnView.nameLab.text = nameArray[i];
        btnView.numberLab.text = @"";
        btnView.backBtn.tag = 450+i;
        if (0 == i) {
            btnView.lineLab.hidden = NO;
            btnView.numberLab.textColor = [UIColor colorWithHexString:@"#1890FF"];
            btnView.nameLab.textColor = [UIColor colorWithHexString:@"#1890FF"];
        }
        [btnView.backBtn addTarget:self action:@selector(choseSequenceBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btnView];
        [masnoryArray addObject:btnView];
    }
    [masnoryArray mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [masnoryArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(112*kHeightScale);
        make.height.mas_equalTo(66*kHeightScale);
    }];
}

- (void)loadReardViews {
    // 头像姓名称号
    UILabel *companyLab = [[UILabel alloc] init];
    companyLab.text = @"头像";
    companyLab.textColor = [UIColor colorWithHexString:@"#111518"];
    companyLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:companyLab];
    [companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.top.mas_equalTo(69*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
    }];
    
    UILabel *deptLab = [[UILabel alloc] init];
    deptLab.text = @"姓名";
    deptLab.textColor = [UIColor colorWithHexString:@"#111518"];
    deptLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:deptLab];
    [deptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(companyLab.mas_right).offset(23*kWidthScale);
        make.top.mas_equalTo(69*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
    }];
    
    UILabel *jobLab = [[UILabel alloc] init];
    jobLab.text = @"称号";
    jobLab.textColor = [UIColor colorWithHexString:@"#111518"];
    jobLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:jobLab];
    [jobLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(deptLab.mas_right).offset(102*kWidthScale);
        make.top.mas_equalTo(69*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
    }];
    
    
    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"##DDDDDD"];
    [self addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1*kHeightScale);
        make.left.mas_equalTo(16*kWidthScale);
        make.right.mas_equalTo(-16*kWidthScale);
    }];
}

#pragma mark--级别选项
- (void)choseSequenceBtnAction:(UIButton*)sender {
    for (int i = 0; i < 7; i++) {
        YSHRMDPLevelBtnView *btnView = (YSHRMDPLevelBtnView*)[self viewWithTag:450+i].superview;
        btnView.lineLab.hidden = YES;
        btnView.numberLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
        btnView.nameLab.textColor = [[UIColor colorWithHexString:@"#191F25"] colorWithAlphaComponent:0.4];
    }
    YSHRMDPLevelBtnView *btnView = (YSHRMDPLevelBtnView*)sender.superview;
    btnView.lineLab.hidden = NO;
    btnView.numberLab.textColor = [UIColor colorWithHexString:@"#1890FF"];
    btnView.nameLab.textColor = [UIColor colorWithHexString:@"#1890FF"];
    if (self.choseSequenceBlock) {
        self.choseSequenceBlock(sender.tag-450);
    }
}
#pragma mark--时间选择
- (void)clickSelect:(UIButton *)button {
    
    if (self.menuArray) {
        // 培训
        YSCutomQuarterPickerView *pickView = [[YSCutomQuarterPickerView alloc] initWithFrame:(CGRectMake(0, kSCREEN_HEIGHT-300, kSCREEN_WIDTH, 300))];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self.coverBtn];
        [window addSubview:pickView];
        YSWeak;
        pickView.choseTimeBlock = ^(NSString * _Nonnull timeStr) {
            YSStrong;
            [strongSelf clickedCoverBtnAction:nil];
            if (timeStr) {
                [strongSelf.yearButton setTitle:timeStr forState:(UIControlStateNormal)];
                strongSelf.currentSelectedYear = timeStr;
               
                if (strongSelf.selectYearBlock) {
                    strongSelf.selectYearBlock(timeStr);
                }
            }
        };
    }else {
        [self.rightPopupMenuView showWithAnimated:YES];
        [self.rightPopupMenuView layoutWithTargetView:self.yearButton];
        
        
    }
}

- (UIButton *)coverBtn {
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _coverBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _coverBtn.backgroundColor = [[UIColor darkTextColor] colorWithAlphaComponent:0.3];
        [_coverBtn addTarget:self action:@selector(clickedCoverBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _coverBtn;
    
}

- (void)clickedCoverBtnAction:(UIButton*)sender {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];

    UIView *outsideView = [window.subviews lastObject];
    [UIView animateWithDuration:1 animations:^{
        [outsideView removeFromSuperview];
        [window addSubview:_coverBtn];
    } completion:^(BOOL finished) {
        [_coverBtn removeFromSuperview];
        _coverBtn = nil;
    }];
    
}
// 处理部门培训的 时间数据
- (void)handelDataWith:(NSArray*)titleArray {
    self.menuArray = [NSMutableArray new];
    for (NSInteger i = [[[NSDate date] dateByAddingHours:8] year]; i >= 2016 ; i --) {
        for (int j = 0; j < titleArray.count; j++) {
            [self.menuArray addObject:[NSString stringWithFormat:@"%zd %@", i, titleArray[j]]];
        }
    }
    
}

- (QMUIPopupMenuView *)rightPopupMenuView {
    if (!_rightPopupMenuView) {
        _rightPopupMenuView = [[QMUIPopupMenuView alloc] init];
        _rightPopupMenuView.automaticallyHidesWhenUserTap = YES;
        // 控制弹出方向
        _rightPopupMenuView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
        _rightPopupMenuView.maskViewBackgroundColor = UIColorMaskWhite;
        _rightPopupMenuView.maximumWidth = 80*kWidthScale;
        _rightPopupMenuView.shouldShowItemSeparator = YES;
        _rightPopupMenuView.separatorInset = UIEdgeInsetsMake(0, _rightPopupMenuView.padding.left, 0, _rightPopupMenuView.padding.right);
        YSWeak;
        NSMutableArray *mutableArray = [NSMutableArray array];
        if (self.menuArray) {
            // 部门培训 使用
            _rightPopupMenuView.maximumWidth = 140*kWidthScale;
            for (NSString *titleStr in self.menuArray) {
                QMUIPopupMenuItem *popupMenuItem = [QMUIPopupMenuItem itemWithImage:UIImageMake(@"") title:titleStr handler:^{
                    YSStrong;
                    [strongSelf.yearButton setTitle:titleStr forState:UIControlStateNormal];
                    if (strongSelf.selectYearBlock) {
                        strongSelf.selectYearBlock(titleStr);
                    }
                    [strongSelf.rightPopupMenuView hideWithAnimated:YES];
                }];
                [mutableArray addObject:popupMenuItem];
            }
        }else {
            for (NSInteger i = [[[NSDate date] dateByAddingHours:8] year]; i >= 2018; i --) {
                QMUIPopupMenuItem *popupMenuItem = [QMUIPopupMenuItem itemWithImage:UIImageMake(@"") title:[NSString stringWithFormat:@"%zd", i] handler:^{
                    YSStrong;
                    [strongSelf.yearButton setTitle:[NSString stringWithFormat:@"%zd", i] forState:UIControlStateNormal];
                    if (strongSelf.selectYearBlock) {
                        strongSelf.selectYearBlock([NSString stringWithFormat:@"%zd", i]);
                    }
                    [strongSelf.rightPopupMenuView hideWithAnimated:YES];
                }];
                [mutableArray addObject:popupMenuItem];
            }
            
        }
        _rightPopupMenuView.items = [mutableArray copy];
        _rightPopupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            
        };
    }
    return _rightPopupMenuView;
}


#pragma mark--更新绩效统计信息
- (void)upLevelBtnViewdataWith:(NSDictionary*)dataDic {

    NSArray *numberArray = @[[dataDic objectForKey:@"ALL"], [dataDic objectForKey:@"S"], [dataDic objectForKey:@"A"], [dataDic objectForKey:@"B"], [dataDic objectForKey:@"C"], [dataDic objectForKey:@"D"], [dataDic objectForKey:@"E"]];
    for (int i = 0; i < 7; i++) {
        YSHRMDPLevelBtnView *btnView = (YSHRMDPLevelBtnView*)[[self viewWithTag:450+i] superview];
        btnView.numberLab.text = numberArray[i];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation YSHRMDPLevelBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    _numberLab = [[UILabel alloc] init];
    _numberLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _numberLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)];
    _numberLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_numberLab];
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(21*kHeightScale);
    }];
    _nameLab = [[UILabel alloc] init];
    _nameLab.textColor = [UIColor colorWithHexString:@"#A3A5A8"];
    _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(12)];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(17*kHeightScale);
        make.top.mas_equalTo(_numberLab.mas_bottom).offset(7*kHeightScale);
    }];
    
    _lineLab = [[UILabel alloc] init];
    _lineLab.layer.cornerRadius = 2;
    _lineLab.layer.masksToBounds = YES;
    _lineLab.hidden = YES;
    _lineLab.backgroundColor = [UIColor colorWithHexString:@"#1890FF"];
    [self addSubview:_lineLab];
    [_lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16*kWidthScale, 4*kHeightScale));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_nameLab.mas_bottom).offset(7*kHeightScale);
    }];
    
    _backBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end

@interface YSCutomQuarterPickerView ()<PGPickerViewDataSource, PGPickerViewDelegate>

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) PGPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, assign) NSInteger first_row;
@property (nonatomic, assign) NSInteger second_row;

@end

@implementation YSCutomQuarterPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kSCREEN_WIDTH, 44))];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F1EDF6"];
    [self addSubview:headerView];

    CGFloat btn_width = 100;
    // 取消按钮
    _cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _cancelButton.frame = CGRectMake(10, 0, btn_width, 44);
    [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    @weakify(self);
    [[_cancelButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        if (self.choseTimeBlock) {
            self.choseTimeBlock(nil);
        }
    }];
    _cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(16)];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [headerView addSubview:_cancelButton];
    
    // 确定按钮
    _confirmButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _confirmButton.frame = CGRectMake(kSCREEN_WIDTH - btn_width - 10, 0, btn_width, 44);
    [_confirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
    _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(16)];
    [_confirmButton setTitleColor:[UIColor colorWithHexString:@"#69BDFF"] forState:(UIControlStateNormal)];
    [[_confirmButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        if (self.choseTimeBlock) {
            NSString *str = [NSString stringWithFormat:@"%@ %@", self.yearArray[self.first_row], self.monthArray[self.second_row]];
            self.choseTimeBlock(str);
        }
    }];
    [headerView addSubview:_confirmButton];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comp = [gregorian components: unitFlags fromDate:dt];
    self.yearArray = [NSMutableArray new];
    for (int i = 2016; i <= comp.year; i++) {
        [self.yearArray addObject:[@(i) stringValue]];
    }
    self.monthArray = @[@"第一季度", @"第二季度", @"第三季度", @"第四季度"];
    CGRect frame = CGRectMake(0, 44, kSCREEN_WIDTH, 200);
    PGPickerView *pickerView = [[PGPickerView alloc]initWithFrame:frame];
    pickerView.rowHeight = 50;
    pickerView.isHiddenMiddleText = YES;
    pickerView.middleTextColor = [UIColor colorWithHexString:@"#69BDFF"];
    pickerView.isHiddenWheels = YES;
    pickerView.lineBackgroundColor = [UIColor colorWithHexString:@"#69BDFF"];
    
    pickerView.textColorOfSelectedRow = [UIColor colorWithHexString:@"#69BDFF"];
    pickerView.textFontOfSelectedRow = [UIFont systemFontOfSize:17];
    pickerView.textColorOfOtherRow = [UIColor lightGrayColor];
    pickerView.textFontOfOtherRow = [UIFont systemFontOfSize:17];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    self.first_row = 0;
    self.second_row = 0;

    self.first_row = self.yearArray.count-1;
    [self.pickerView selectRow:self.yearArray.count-1 inComponent:0 animated:NO];
}



#pragma mark--pickerView
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearArray.count;
    }else {
        
        NSInteger row = [pickerView selectedRowInComponent:0];
        if (row >= self.yearArray.count || row < 0) {
            //-1没有选中行 默认是选中第一列的最后一行
            row = self.yearArray.count-1;
        }
        int nowyear = [[self.yearArray objectAtIndex:row] intValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy";
        int chose_year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        dateFormatter.dateFormat = @"MM";
        int max_month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        if (nowyear == chose_year) {
            if (max_month < 4) {
                return 1;
            }else if (max_month < 7) {
                return 2;
            }else if (max_month < 10) {
                return 3;
            }else {
                return 4;
            }
        }
        return 4;
    };
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (0 == component) {
        return self.yearArray[row];
    }else {
        return self.monthArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component ==0) {
        self.first_row = row;
        [pickerView reloadComponent:1];
    }else if (component==1){
        self.second_row = row;
    }
    
}




@end
