//
//  YSManagerTeamHeaderView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSManagerTeamHeaderView.h"

@interface YSManagerTeamHeaderView ()

@property (nonatomic, strong) UILabel *subTitleLab;


@end

@implementation YSManagerTeamHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    self.titLab = [[UILabel alloc] init];
    self.titLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(16)];
    self.titLab.numberOfLines = 1;
    self.titLab.text = @"亚厦集团";
    self.titLab.textColor = kUIColor(51, 51, 51, 1);
    [self addSubview:self.titLab];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22*kHeightScale);
        make.left.mas_equalTo(16*kWidthScale);
        make.top.mas_equalTo(17*kHeightScale);
    }];
    _subTitleLab = [[UILabel alloc] init];
    _subTitleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(12)];
    _subTitleLab.text = @"全部";
    _subTitleLab.textColor = kUIColor(71, 76, 81, 1);
    [self addSubview:_subTitleLab];
    [_subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titLab.mas_right).mas_offset(13*kWidthScale);
        make.height.mas_equalTo(17*kHeightScale);
        make.bottom.mas_equalTo(self.titLab.mas_bottom);
    }];
    
    NSArray *nameArray = @[@"全部", @"M序列", @"P序列", @"A序列", @"O序列", @"其他"];
    NSMutableArray *masnoryArray = [NSMutableArray new];
    for (int i = 0; i < nameArray.count; i++) {
        YSManagerTeamBtnView *btnView = [[YSManagerTeamBtnView alloc] init];
        btnView.nameLab.text = nameArray[i];
        btnView.numberLab.text = @"0";
        btnView.backBtn.tag = 450+i;
        if (0 == i) {
            btnView.lineLab.hidden = NO;
        }
        [btnView.backBtn addTarget:self action:@selector(choseSequenceBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btnView];
        [masnoryArray addObject:btnView];
    }
    [masnoryArray mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [masnoryArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(61*kHeightScale);
        make.height.mas_equalTo(66*kHeightScale);
    }];
    
    UILabel *spaceLab = [[UILabel alloc] init];
    spaceLab.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self addSubview:spaceLab];
    [spaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 7*kHeightScale));
        make.top.mas_equalTo(127*kHeightScale);
        make.left.mas_equalTo(0);
    }];
    
    // 公司部门 岗位编制
    UILabel *companyLab = [[UILabel alloc] init];
    companyLab.text = @"公司";
    companyLab.textColor = [UIColor colorWithHexString:@"#111518"];
    companyLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:companyLab];
    [companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.top.mas_equalTo(148*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
    }];
    
    UILabel *deptLab = [[UILabel alloc] init];
    deptLab.text = @"部门";
    deptLab.textColor = [UIColor colorWithHexString:@"#111518"];
    deptLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:deptLab];
    [deptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(companyLab.mas_right).offset(61*kWidthScale);
        make.top.mas_equalTo(148*kHeightScale);
        make.height.mas_equalTo(20*kHeightScale);
//        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
    }];
    
    UILabel *jobLab = [[UILabel alloc] init];
    jobLab.text = @"岗位";
    jobLab.textColor = [UIColor colorWithHexString:@"#111518"];
    jobLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:jobLab];
    [jobLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(deptLab.mas_right).offset(61*kWidthScale);
        make.top.mas_equalTo(148*kHeightScale);
//        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
        make.height.mas_equalTo(20*kHeightScale);
    }];
    
    UILabel *compileLab = [[UILabel alloc] init];
    compileLab.text = @"编制/现有";
    compileLab.textColor = [UIColor colorWithHexString:@"#111518"];
    compileLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:compileLab];
    [compileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(jobLab.mas_right).offset(62*kWidthScale);
        make.top.mas_equalTo(148*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(64*kWidthScale, 20*kHeightScale));
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
// 更新序列数目
- (void)upNumberDataWith:(NSDictionary*)dataDic {
    NSArray *keyArray = @[@"totalNum", @"mRank", @"pRank", @"aRank", @"oRank", @"others"];
    for (int i = 0; i < keyArray.count; i++) {
        YSManagerTeamBtnView *btnView = (YSManagerTeamBtnView*)[self viewWithTag:450+i].superview;
        btnView.numberLab.text = [NSString stringWithFormat:@"%.0f", [[dataDic objectForKey:keyArray[i]] floatValue]];
    }
}
// 选择序列
- (void)choseSequenceBtnAction:(UIButton*)sender {
    for (int i = 0; i < 6; i++) {
        YSManagerTeamBtnView *btnView = (YSManagerTeamBtnView*)[self viewWithTag:450+i].superview;
        btnView.lineLab.hidden = YES;
    }
    NSArray *nameArray = @[@"全部", @"M序列", @"P序列", @"A序列", @"O序列", @"其他"];
    self.subTitleLab.text = nameArray[sender.tag-450];
    YSManagerTeamBtnView *btnView = (YSManagerTeamBtnView*)sender.superview;
    btnView.lineLab.hidden = NO;
    if (self.choseSequenceBlock) {
        self.choseSequenceBlock(sender.tag-450);
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



@implementation YSManagerTeamBtnView

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
