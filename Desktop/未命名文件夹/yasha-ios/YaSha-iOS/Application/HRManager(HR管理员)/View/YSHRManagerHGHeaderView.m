//
//  YSHRManagerHGHeaderView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/25.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerHGHeaderView.h"

@interface YSHRManagerHGHeaderView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *backImg;



@end

@implementation YSHRManagerHGHeaderView

- (instancetype)initWithFrame:(CGRect)frame withType:(BOOL)isDown {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 标题
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(16)];
        _titleLab.text = @"亚厦集团";
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16*kWidthScale);
            make.top.mas_equalTo(22*kHeightScale);
        }];
        
        
        // 背景图
        _backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manager_YSHRHG"]];
        _backImg.layer.shadowOpacity = 0.2;
        _backImg.layer.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_backImg];
        [_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(61*kHeightScale);
            make.size.mas_equalTo(CGSizeMake(359*kWidthScale, 465*kHeightScale));
            make.centerX.mas_equalTo(0);
        }];
        // 职称
        _briefLb = [[UILabel alloc]init];
        _briefLb.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _briefLb.text = @"";
        _briefLb.textAlignment = NSTextAlignmentCenter;
        _briefLb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
        [self addSubview:_briefLb];
        [_briefLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(_backImg.mas_bottom).mas_equalTo(-125*kHeightScale);
            make.left.mas_equalTo(_backImg.mas_left).offset(50*kWidthScale);
            make.right.mas_equalTo(_backImg.mas_right).offset(-50*kWidthScale);

        }];
        // 工号
        _numberLab = [[UILabel alloc] init];
        _numberLab.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _numberLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
        _numberLab.text = @"";
        [self addSubview:_numberLab];
        [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(_briefLb.mas_top).mas_equalTo(-4*kHeightScale);
        }];
        
        //名字
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)];
        _nameLab.text = @"";
        [self addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(_numberLab.mas_top).mas_equalTo(-6*kHeightScale);
        }];
        //头像
        _headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像_mine"]];
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        _headImg.layer.cornerRadius = 64*kWidthScale*0.5;
        _headImg.layer.masksToBounds = YES;
        [self addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(64*kWidthScale, 64*kWidthScale));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(_nameLab.mas_top).mas_equalTo(-21*kHeightScale);
        }];
        //放置职级别的view
        UIView *posiTionView = [[UIView alloc]init];
        posiTionView.backgroundColor = [UIColor clearColor];
        [self addSubview:posiTionView];
        [posiTionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(_nameLab.mas_top).mas_equalTo(-21*kHeightScale);
            make.width.mas_equalTo(86*kWidthScale);
            make.height.mas_equalTo(90*kHeightScale);
        }];
        
        // 职级
        self.positionBtn = [[YSTagButton alloc]init];
        self.positionBtn.layer.masksToBounds = YES;
        self.positionBtn.layer.cornerRadius = 8;
        self.positionBtn.tagContentEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
        self.positionBtn.borderColor = [UIColor whiteColor];
        [self.positionBtn setTitleColor:[UIColor colorWithHexString:@"#191F25" alpha:0.8]];
        self.positionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(10)];//[UIFont boldSystemFontOfSize:10];
        self.positionBtn.backgroundColor = [UIColor colorWithHexString:@"#FFDE18"];
        [posiTionView addSubview:self.positionBtn];
        [self.positionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(posiTionView.mas_bottom).mas_equalTo(0);
            make.height.mas_equalTo(16);
        }];

        // 详情按钮
        _detailBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImg.mas_top);
            make.left.and.right.mas_equalTo(self); make.bottom.mas_equalTo(_briefLb.mas_bottom).offset(14*kHeightScale);
        }];
        if (isDown) {
            [self loadDownSubViewWith:frame];
        }else {
            [self loadUpSubViewWith:frame];
        }
    }
    return self;
}


// 箭头向下 初始的视图
- (void)loadDownSubViewWith:(CGRect)frame {
    _backImg.image = [UIImage imageNamed:@"manager_YSHRHG"];
    [_backImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(359*kWidthScale, 465*kHeightScale));
    }];
    
    UILabel *topTitleLab = [[UILabel alloc] init];
    topTitleLab.text = @"让客户的等待变成期待";
    topTitleLab.textColor = kUIColor(255, 255, 255, 0.62);
    topTitleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(17)];
    [self addSubview:topTitleLab];
    [topTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backImg.mas_top).offset(72*kHeightScale);
        make.centerX.mas_equalTo(_backImg.mas_centerX);
    }];
    
    
    NSArray *subNameArray = @[@"诚信务实", @"艰苦奋斗", @"创新变革", @"感恩怀德"];
    NSMutableArray *masonryArray = [NSMutableArray new];
    for (int i = 0; i < subNameArray.count; i++) {
        UILabel *subTopLab = [[UILabel alloc] init];
        subTopLab.text = subNameArray[i];
        subTopLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
        subTopLab.textColor = kUIColor(175, 216, 253, 1);
        [self addSubview:subTopLab];
        [masonryArray addObject:subTopLab];
    }
    [masonryArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:60*kWidthScale leadSpacing:38*kWidthScale tailSpacing:38*kWidthScale];
    [masonryArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topTitleLab.mas_bottom).offset(18*kHeightScale);
        make.height.mas_equalTo(20*kWidthScale);
    }];
    
    // 底部四个按钮
    CGFloat width_btn = 359*kWidthScale/4;
    NSArray *nameArray = @[@"编制", @"在岗", @"入职", @"离职"];
    for (int i = 0; i < nameArray.count; i++) {
        CustomBtnView *btnView = [[CustomBtnView alloc] initWithFrame:(CGRectMake(width_btn*i+(kSCREEN_WIDTH-(359*kWidthScale))/2, CGRectGetHeight(frame)-105*kHeightScale, width_btn, 82*kHeightScale))];
        btnView.bottomLab.text = nameArray[i];
        btnView.backBtn.tag = 110+i;
        [btnView.backBtn addTarget:self action:@selector(choseOptionBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btnView];
    }
}

// 箭头向上
- (void)loadUpSubViewWith:(CGRect)frame {
    
    // 返回初始项按钮
    _titBtn = [[QMUIButton alloc] init];
    //        _titBtn.imagePosition = QMUIToastViewPositionTop;默认为靠左
    _titBtn.spacingBetweenImageAndTitle = 6;
    [_titBtn setImage:[UIImage imageNamed:@"backMyTeamHGM"] forState:UIControlStateNormal];
    [_titBtn setBackgroundImage:[UIImage imageNamed:@"backMyTeamHGMB"] forState:(UIControlStateNormal)];
    [_titBtn setTitle:@"我的团队" forState:UIControlStateNormal];
    [_titBtn setTitleColor:[UIColor colorWithHexString:@"#1890FF"] forState:UIControlStateNormal];
    _titBtn.titleLabel.font = UIFontMake(14);
    [self addSubview:_titBtn];
    [_titBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(115*kWidthScale, 30*kHeightScale));
        make.centerY.mas_equalTo(_titleLab.mas_centerY);
    }];
    
    _headImg.image = [UIImage imageNamed:@"头像_mine_litter"];

    _backImg.image = [UIImage imageNamed:@"manager_YSHRHGLitter"];
    
    [_backImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343*kWidthScale, 175*kHeightScale));
    }];
    //头像
    [_headImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backImg.mas_left).offset(26*kWidthScale);
        make.top.mas_equalTo(_backImg.mas_top).offset(17*kHeightScale);
        
        make.size.mas_equalTo(CGSizeMake(64*kWidthScale, 64*kWidthScale));
    }];

    
    //名字
    [_nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImg.mas_right).offset(31*kWidthScale);
        make.top.mas_equalTo(_backImg.mas_top).mas_equalTo(17*kHeightScale);
    }];
    // 工号
    [_numberLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLab.mas_left);
        make.top.mas_equalTo(_nameLab.mas_bottom).mas_equalTo(4*kHeightScale);
    }];
    // 职称
    _briefLb.textAlignment = NSTextAlignmentLeft;
    [_briefLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLab.mas_left);
        make.right.mas_equalTo(_backImg.mas_right).offset(-4);
        make.top.mas_equalTo(_numberLab.mas_bottom).mas_equalTo(4*kHeightScale);
    }];
    
    //职级
    [self.positionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_headImg);
        make.centerY.mas_equalTo(_headImg.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    
    
    
    // 底部四个按钮
    CGFloat width_btn = 343*kWidthScale/4;
    NSArray *nameArray = @[@"编制", @"在岗", @"入职", @"离职"];
    for (int i = 0; i < nameArray.count; i++) {
        CustomBtnView *btnView = [[CustomBtnView alloc] initWithFrame:(CGRectMake(width_btn*i+(kSCREEN_WIDTH-(343*kWidthScale))/2, CGRectGetHeight(frame)-(100*kHeightScale), width_btn, 80*kHeightScale))];
        btnView.bottomLab.text = nameArray[i];
        btnView.backBtn.tag = 110+i;
        [btnView.backBtn addTarget:self action:@selector(choseOptionBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btnView];
    }
}

- (void)choseOptionBtnAction:(UIButton*)sender {
    if (self.choseOptionBtnBlock) {
        self.choseOptionBtnBlock(sender.tag-110);
    }
}


- (void)upBottomNumberDataWith:(NSDictionary*)datDic {
    
    NSArray *dataArray = @[[NSString stringWithFormat:@"%@", [datDic objectForKey:@"totalNum"]], [NSString stringWithFormat:@"%@", [datDic objectForKey:@"countPsndoc"]], [NSString stringWithFormat:@"%@", [datDic objectForKey:@"entryYearCount"]], [NSString stringWithFormat:@"%@", [datDic objectForKey:@"leaveYearCount"]]];
    
    for (int i = 0; i< dataArray.count; i++) {
        CustomBtnView *btnView = (CustomBtnView*)[[self viewWithTag:i+110] superview];
        btnView.topLab.text = [NSString stringWithFormat:@"%@", dataArray[i]];
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


@implementation CustomBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _topLab = [[UILabel alloc] init];
        _topLab.font = [UIFont fontWithName:@"PingFang-SC-Semibold" size:Multiply(14)];
        _topLab.text = @"";
        _topLab.textColor = kUIColor(24, 144, 255, 1);
        [self addSubview:_topLab];
        [_topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_centerY).offset(1);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.text = @"";
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
