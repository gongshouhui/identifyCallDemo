//
//  YSSalaryHeaderView.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/24.
//

#import "YSSalaryHeaderView.h"

@interface YSHeaderSectionView : UIView
@property (nonatomic,strong)UILabel *totalNumLb;
@property (nonatomic,strong)UILabel *titlelb;
@property (nonatomic,strong)UILabel *tipLb;
@property (nonatomic,assign)NSInteger type;

@end
@interface YSSalaryHeaderView()
@property (nonatomic,strong)YSHeaderSectionView *sectionView1;
@property (nonatomic,strong)YSHeaderSectionView *sectionView2;
@end
@implementation YSSalaryHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = kUIColor(229, 229, 229, 1);
    UIView *bgView = [[UIView alloc]init];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kUIColor(229, 229, 229, 1);
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.bottom.mas_equalTo(-17);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(0);
    }];
    
    self.sectionView1 = [[YSHeaderSectionView alloc]init];
    self.sectionView1.type = 1;
    [bgView addSubview:self.sectionView1];
    [self.sectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(lineView.mas_left);
    }];
    
    self.sectionView2 = [[YSHeaderSectionView alloc]init];
    self.sectionView2.type = 2;
    [bgView addSubview:self.sectionView2];
    [self.sectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(lineView.mas_right);
    }];
}

- (void)setModel:(YSSalaryDetailModel *)model{
    _model = model;
    self.sectionView1.totalNumLb.text = model.grossPay;
    self.sectionView2.totalNumLb.text= model.payTotal;
}
@end


@implementation YSHeaderSectionView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{

    self.totalNumLb = [[UILabel alloc]init];
    self.totalNumLb.font = [UIFont systemFontOfSize:22];
    self.totalNumLb.textColor = kUIColor(51, 51, 51, 1);
    [self addSubview:self.totalNumLb];
    [self.totalNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(22);
    }];
    
    self.titlelb = [[UILabel alloc]init];
    self.titlelb.font = [UIFont systemFontOfSize:17];
    self.titlelb.textColor = kUIColor(102, 102, 102, 1);
    [self addSubview:self.titlelb];
    
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.totalNumLb.mas_bottom).mas_equalTo(18);
    }];
    
    self.tipLb = [[UILabel alloc]init];
    self.tipLb.font = [UIFont systemFontOfSize:11];
    self.tipLb.textColor = kGrayColor(153);
    [self addSubview:self.tipLb];
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.titlelb.mas_bottom).mas_equalTo(9);
    }];
}


- (void)setType:(NSInteger)type{

    _type = type;
    if (self.type == 1) {
        self.titlelb.text = @"工资总额";
        self.tipLb.text = @"(应发工资 + 应发福利)";
    }else{
        self.titlelb.text = @"实发合计";
        self.tipLb.text = @"(工资总额 - 代扣款项)";
    }
}
@end
