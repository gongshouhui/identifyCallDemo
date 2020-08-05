//
//  YSAssetsMineDetailView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/20.
//
//

#import "YSAssetsMineDetailView.h"

@interface YSAssetsMineDetailView ()

@property (nonatomic, strong) UIImageView *assetsImageView;
@property (nonatomic, strong) UILabel *basicInfoRightLabel;
@property (nonatomic, strong) UILabel *useInfoRightLabel;

@end

@implementation YSAssetsMineDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT*2);
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _assetsImageView = [[UIImageView alloc] init];
    _assetsImageView.layer.masksToBounds = YES;
    _assetsImageView.layer.cornerRadius = 5.0;
    [self addSubview:_assetsImageView];
    [_assetsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(167*kWidthScale, 167*kHeightScale));
    }];
    
    UIView *basicInfoTitleView = [[UIView alloc] init];
    [self setupTitleView:basicInfoTitleView andTitle:@"基本信息"];
    [self addSubview:basicInfoTitleView];
    [basicInfoTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_assetsImageView.mas_bottom).offset(10*kHeightScale);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    
    UILabel *basicInfoLeftLabel = [[UILabel alloc] init];
    NSMutableAttributedString *basicInfoLeftString = [[NSMutableAttributedString alloc] initWithString: @"资产编码\n资产名称\n物品分类\n资产状态\n规格型号\n物品等级\n序列号\n生产日期\n是否租赁\n所属公司"];
    basicInfoLeftString.yy_color = [UIColor lightGrayColor];
    basicInfoLeftString.yy_font = [UIFont systemFontOfSize:15*kHeightScale];
    basicInfoLeftString.yy_lineSpacing = 10.0*kHeightScale;
    basicInfoLeftString.yy_alignment = NSTextAlignmentLeft;
    basicInfoLeftLabel.attributedText = basicInfoLeftString;
    basicInfoLeftLabel.numberOfLines = 0;
    [self addSubview:basicInfoLeftLabel];
    [basicInfoLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(basicInfoTitleView.mas_bottom).offset(8*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(30*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(90*kWidthScale, 280*kHeightScale));
    }];
    
    _basicInfoRightLabel = [[UILabel alloc] init];
    _basicInfoRightLabel.numberOfLines = 0;
    _basicInfoRightLabel.font = [UIFont systemFontOfSize:15*kWidthScale];
    [self addSubview:_basicInfoRightLabel];
    [_basicInfoRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(basicInfoTitleView.mas_bottom).offset(6*kHeightScale);
        make.left.mas_equalTo(basicInfoLeftLabel.mas_right).offset(30*kWidthScale);
        make.right.mas_equalTo(self.mas_right).offset(-15*kHeightScale);
        make.height.mas_equalTo(280*kHeightScale);
    }];
    
    UIView *useInfoTitleView = [[UIView alloc] init];
    [self setupTitleView:useInfoTitleView andTitle:@"使用信息"];
    [self addSubview:useInfoTitleView];
    [useInfoTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(basicInfoLeftLabel.mas_bottom).offset(8*kHeightScale);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    
    UILabel *useInfoLeftLabel = [[UILabel alloc] init];
    NSMutableAttributedString *useInfoLeftString = [[NSMutableAttributedString alloc] initWithString: @"使用人\n使用人岗位\n使用部门\n使用公司\n使用地点\n备注"];
    useInfoLeftString.yy_color = [UIColor lightGrayColor];
    useInfoLeftString.yy_font = [UIFont systemFontOfSize:15*kWidthScale];
    useInfoLeftString.yy_lineSpacing = 10.0*kHeightScale;
    useInfoLeftString.yy_alignment = NSTextAlignmentLeft;
    useInfoLeftLabel.attributedText = useInfoLeftString;
    useInfoLeftLabel.numberOfLines = 0;
    [self addSubview:useInfoLeftLabel];
    [useInfoLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(useInfoTitleView.mas_bottom).offset(8*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(30*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(90*kWidthScale, 220*kHeightScale));
    }];
    
    _useInfoRightLabel = [[UILabel alloc] init];
    _useInfoRightLabel.numberOfLines = 0;
    [self addSubview:_useInfoRightLabel];
    [_useInfoRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(useInfoTitleView.mas_bottom).offset(5*kHeightScale);
        make.left.mas_equalTo(useInfoLeftLabel.mas_right).offset(30*kWidthScale);
        make.right.mas_equalTo(self.mas_right).offset(-15*kWidthScale);
        make.height.mas_equalTo(220*kHeightScale);
    }];
    
    self.button = [YSUIHelper generateDarkFilledButton];
    [_button setTitle:@"领用确认" forState:UIControlStateNormal];
    [self addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_useInfoRightLabel.mas_bottom).offset(20*kHeightScale);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
    }];
}

- (void)setupTitleView:(UIView *)titleView andTitle:(NSString *)title {
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = kThemeColor;
    [titleView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView);
        make.left.mas_equalTo(titleView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(2*kWidthScale, 18*kHeightScale));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.text = title;
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView);
        make.left.mas_equalTo(lineLabel.mas_right).offset(12);
        make.height.mas_equalTo(15*kHeightScale);
        make.right.mas_equalTo(titleView.mas_right).offset(-15);
    }];
}

- (void)setCellModel:(YSAssetsDetailModel *)cellModel {
    _cellModel = cellModel;
    [_assetsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YSImageDomain, _cellModel.filePath]] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    
    NSString *basicInfoRightString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@", _cellModel.assetsNo, _cellModel.goodsName, [NSString stringWithFormat:@"%@-%@", _cellModel.secondCateName, _cellModel.thirdCateName], _cellModel.assetsStatusStr, _cellModel.proModel, _cellModel.goodsLevel, _cellModel.serialNo, [YSUtility formatTimestamp:_cellModel.produDate Length:10], _cellModel.hasRent ? @"是": @"否", _cellModel.ownCompany];
    NSMutableAttributedString *basicInfoRightAttributedString = [[NSMutableAttributedString alloc] initWithString:basicInfoRightString];
    basicInfoRightAttributedString.yy_font = [UIFont systemFontOfSize:15*kWidthScale];
    basicInfoRightAttributedString.yy_lineSpacing = 10.0*kWidthScale;
    basicInfoRightAttributedString.yy_alignment = NSTextAlignmentLeft;
    _basicInfoRightLabel.attributedText = basicInfoRightAttributedString;
    
    NSString *useInfoRightString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@", _cellModel.useMan, _cellModel.useJobStation, _cellModel.useDept, _cellModel.useCompany, _cellModel.storePlace, _cellModel.remark];
    NSMutableAttributedString *useInfoRightAttributedString = [[NSMutableAttributedString alloc] initWithString:useInfoRightString];
    useInfoRightAttributedString.yy_font = [UIFont systemFontOfSize:15*kWidthScale];
    useInfoRightAttributedString.yy_lineSpacing = 10.0*kWidthScale;
    useInfoRightAttributedString.yy_alignment = NSTextAlignmentLeft;
    _useInfoRightLabel.attributedText = useInfoRightAttributedString;
}

@end
