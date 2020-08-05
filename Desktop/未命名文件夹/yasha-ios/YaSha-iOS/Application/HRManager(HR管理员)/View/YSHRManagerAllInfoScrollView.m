//
//  YSHRManagerAllInfoScrollView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/1.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerAllInfoScrollView.h"

@interface YSHRManagerAllInfoScrollView ()


@end


@implementation YSHRManagerAllInfoScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HRManagerInfoBack"]];
    backImg.frame = CGRectMake(0, -kStatusBarHeight, kSCREEN_WIDTH, CGRectGetHeight(self.frame));
    [self addSubview:backImg];
    
    UIImageView *headerBackImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HMangerInfoheaderG"]];
    [self addSubview:headerBackImg];
    [headerBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(90*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(359*kWidthScale, 434*kHeightScale));
    }];
    //头像
    _headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _headerImg.layer.masksToBounds = YES;
    _headerImg.layer.cornerRadius = 35;
    [self addSubview:_headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerBackImg.mas_top).offset(-30*kHeightScale);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 70*kHeightScale));
    }];
    // 职级
    self.positionBtn = [[YSTagButton alloc]init];
    self.positionBtn.layer.masksToBounds = YES;
    self.positionBtn.layer.cornerRadius = 8;
    self.positionBtn.tagContentEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
    self.positionBtn.borderColor = [UIColor whiteColor];
    [self.positionBtn setTitleColor:[UIColor colorWithHexString:@"#191F25" alpha:0.8]];
    self.positionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(11)];
    self.positionBtn.backgroundColor = [UIColor colorWithHexString:@"#FFDE18"];
    [self addSubview:self.positionBtn];
    [self.positionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(_headerImg.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    // 姓名
    _nameLab = [[UILabel alloc] init];
    _nameLab.text = @"";
    _nameLab.textColor = kUIColor(0, 0, 0, 0.8);
    _nameLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(17)];
    [self addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerImg.mas_bottom).offset(24*kHeightScale);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(24*kHeightScale);
    }];
    
    // 职位
    _breftLab = [[UILabel alloc] init];
    _breftLab.text = @"";
    _breftLab.textColor = kUIColor(0, 0, 0, 0.8);
    _breftLab.numberOfLines = 0;
    _breftLab.textAlignment = NSTextAlignmentCenter;
    _breftLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:_breftLab];
    [_breftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLab.mas_bottom).offset(14*kHeightScale);
        make.left.mas_equalTo(headerBackImg.mas_left).offset(30*kWidthScale);
        make.right.mas_equalTo(headerBackImg.mas_right).offset(-30*kWidthScale);
//        make.centerX.mas_equalTo(0);
//        make.height.mas_equalTo(20*kHeightScale);
    }];
    // 工号
    _numberLab = [[UILabel alloc] init];
    _numberLab.text = @"";
    _numberLab.textColor = kUIColor(0, 0, 0, 0.8);
    _numberLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self addSubview:_numberLab];
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_breftLab.mas_bottom).offset(14*kHeightScale);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(20*kHeightScale);
    }];
    
    NSArray *btnNameArray = @[@"岗位信息", @"入职信息", @"基本信息", @"家庭信息", @"学历信息"];
    for (int i = 0; i < btnNameArray.count; i++) {
        YSTagButton *btn = [[YSTagButton alloc] init];
        [btn setTitleColor:kUIColor(24, 144, 255, 1)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 32*kHeightScale*0.5;
        btn.layer.borderColor = kUIColor(38, 150, 255, 1).CGColor;
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
        btn.tag = 140+i;
        [btn setTitle:btnNameArray[i] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(checkInfoDetail:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(36*kWidthScale+(i%3)*(90*kWidthScale+17), 280*kHeightScale+(i/3)*(32*kHeightScale+13), 90*kWidthScale, 32*kHeightScale);
        [self addSubview:btn];
    }
    
    NSArray *bottomBtnName = @[@"考勤", @"培训", @"绩效", @"资产"];
    for (int i = 0; i < bottomBtnName.count; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [btn setTitleColor:kUIColor(24, 144, 255, 1) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(16)];
        btn.frame = CGRectMake(39*kWidthScale+i*(88*kWidthScale), 416*kHeightScale, 32*kWidthScale, 22*kHeightScale);
        [btn setTitle:bottomBtnName[i] forState:(UIControlStateNormal)];
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(clickedOtherScrollViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        
        if (i != bottomBtnName.count -1) {
        UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetMaxX(btn.frame)+27*kWidthScale, CGRectGetMinY(btn.frame)+6*kHeightScale, 1*kWidthScale, 10*kHeightScale))];
        lineLab.backgroundColor = kUIColor(230, 230, 230, 1);
        lineLab.layer.masksToBounds = YES;
        lineLab.layer.cornerRadius = 1;
        [self addSubview:lineLab];
        }
        
    }
    
    // 底部按钮 
    UIImageView *bottomImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HMangerGDownInfo"]];
    bottomImg.frame = CGRectMake((kSCREEN_WIDTH-18*kWidthScale)/2, CGRectGetHeight(self.frame)-60*kHeightScale, 18*kWidthScale, 30*kHeightScale);
    [self addSubview:bottomImg];
    
    _bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _bottomBtn.frame = CGRectMake((kSCREEN_WIDTH-18*kWidthScale)/2, CGRectGetHeight(self.frame)-40*kHeightScale, kSCREEN_WIDTH, 30*kHeightScale);
    _bottomBtn.tag = 200;
    [_bottomBtn addTarget:self action:@selector(clickedOtherScrollViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_bottomBtn];
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomImg.mas_top);
        make.bottom.mas_equalTo(bottomImg.mas_bottom);
        make.width.mas_equalTo(self);
    }];
}

//@"岗位信息", @"入职信息", @"基本信息", @"家庭信息", @"学历信息" 140~144
- (void)checkInfoDetail:(UIButton*)sender {
    if (self.clickedInfoBtnBlock) {
        self.clickedInfoBtnBlock(sender.tag-140);
    }
}
// @"考勤", @"培训", @"绩效", @"资产" 200~203
- (void)clickedOtherScrollViewAction:(UIButton*)sender {
    if (self.choseOtherBtnBlock) {
        self.choseOtherBtnBlock(sender.tag-200);
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
