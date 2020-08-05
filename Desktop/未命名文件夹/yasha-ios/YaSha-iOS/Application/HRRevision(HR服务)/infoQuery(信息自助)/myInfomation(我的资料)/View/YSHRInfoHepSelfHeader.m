//
//  YSInfoHepSelfHeader.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRInfoHepSelfHeader.h"
#import "YSTagButton.h"
@interface YSHRInfoHepSelfHeader()
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) YSTagButton *workNumBtn;
@property (nonatomic,strong) UILabel *briefLb;
@property (nonatomic,strong) YSTagButton *positionBtn;
@property (nonatomic, strong) UIImageView *bgImageView;

@end
@implementation YSHRInfoHepSelfHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    //hrbackground excellentMine
    //添加背景图
    self.bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hrbackground"]];
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-25);
    }];
    _headImageView = [[UIImageView alloc]init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.layer.cornerRadius = 64*kWidthScale*0.5;
    _headImageView.layer.masksToBounds = YES;
    [self addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(40*kHeightScale);
        make.width.height.mas_equalTo(64*kWidthScale);
    }];
    //放置职位的view
    UIView *posiTionView = [[UIView alloc]init];
    posiTionView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageDidClick)];
    posiTionView.userInteractionEnabled = YES;
    [posiTionView addGestureRecognizer:gesture];
    [self addSubview:posiTionView];
    [posiTionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(40*kHeightScale);
        make.width.height.mas_equalTo(64*kWidthScale);
    }];
    
    //职位
    self.positionBtn = [[YSTagButton alloc]init];
     self.positionBtn.layer.masksToBounds = YES;
     self.positionBtn.layer.cornerRadius = 8;
     self.positionBtn.tagContentEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
    self.positionBtn.borderColor = [UIColor whiteColor];
    [self.positionBtn setTitleColor:[UIColor colorWithHexString:@"#191F25" alpha:0.8]];
    self.positionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    self.positionBtn.backgroundColor = [UIColor colorWithHexString:@"#FFDE18"];
    [posiTionView addSubview:self.positionBtn];
    [self.positionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(posiTionView.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.text = @"    ";
    _nameLb.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.8];
    _nameLb.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_nameLb];
    [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_headImageView.mas_bottom).mas_equalTo(18*kHeightScale);
    }];
    
    _workNumBtn = [[YSTagButton alloc]init];
    _workNumBtn.titleColor = [UIColor whiteColor];
    _workNumBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _workNumBtn.backgroundColor = [UIColor colorWithHexString:@"#1890FF" alpha:0.46];
    _workNumBtn.layer.masksToBounds = YES;
    _workNumBtn.layer.cornerRadius = 10;
    _workNumBtn.tagContentEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
    [self addSubview:_workNumBtn];
    [_workNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_nameLb.mas_bottom).mas_equalTo(10*kHeightScale);
        make.height.mas_equalTo(20);
    }];
    
    _briefLb = [[UILabel alloc]init];
    _briefLb.textColor = [UIColor colorWithHexString:@"#191F25" alpha:0.8];
    _briefLb.textAlignment = NSTextAlignmentCenter;
    _briefLb.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_briefLb];
    YSWeak;
    [_briefLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_workNumBtn.mas_bottom).mas_equalTo(10*kHeightScale);
        /*职位太多的时候显示不完全*/ make.left.mas_equalTo(weakSelf.bgImageView.mas_left).offset(17*kWidthScale);
        make.right.mas_equalTo(weakSelf.bgImageView.mas_right).offset(-17*kWidthScale);
    }];
    
    
    

}
- (void)setInfoModel:(YSPersonalInformationModel *)infoModel
{
    _infoModel = infoModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.headImg] placeholderImage:[UIImage imageNamed:@"头像_mine"]];
    self.nameLb.text = infoModel.name;
    [self.positionBtn setTitle:infoModel.levelId.length?infoModel.levelId : @" " forState:UIControlStateNormal];
    [self.workNumBtn setTitle:infoModel.no forState:UIControlStateNormal];
    
    NSString *dept = infoModel.deptName;
    NSString *job = infoModel.jobStation;
    if (job.length&&dept.length) {
        NSString *brief = [NSString stringWithFormat:@"%@ | %@",dept,job];
        NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:brief];
        [attiStr addAttributes:@{NSForegroundColorAttributeName:kGrayColor(204)} range: [brief rangeOfString:@"|"]];
        self.briefLb.attributedText = attiStr;
    }else{
        self.briefLb.text = [NSString stringWithFormat:@"%@%@",dept,job];
    }
    //是否是 优秀员工 先用杨钊的工号测试
    if ([infoModel.isExcellentEmployee integerValue] == 1) {
        self.bgImageView.image = [UIImage imageNamed:@"excellentMine"];
        //职级
        [self.positionBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
        self.positionBtn.backgroundColor = [UIColor colorWithHexString:@"#C49C6B"];
        //名字
        self.nameLb.textColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
        //工号
        [self.workNumBtn setBackgroundColor:[UIColor colorWithHexString:@"#99FFFFFF"]];
        [self.workNumBtn setTitleColor:[UIColor colorWithHexString:@"#FFC49C6B"] forState:(UIControlStateNormal)];
        //职位
        self.briefLb.textColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
    }
}
- (void)headImageDidClick {
    if ([self.delegate respondsToSelector:@selector(hrInfoHepSelfHeaderImageViewDidClick:)]) {
        [self.delegate hrInfoHepSelfHeaderImageViewDidClick:self];
    }
}
@end
