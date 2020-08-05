//
//  YSAssetsDetailView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import "YSAssetsDetailView.h"

@interface YSAssetsDetailView ()

@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YSAssetsDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _statusImageView = [[UIImageView alloc] init];
    [self addSubview:_statusImageView];
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(54*kWidthScale, 82*kHeightScale));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:15*BIZ];
    _titleLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_statusImageView.mas_bottom).offset(20*kWidthScale);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.mas_equalTo(80*kWidthScale);
    }];
    
    _informationLabel = [[UILabel alloc] init];
    _informationLabel.numberOfLines = 0;
    _informationLabel.font = [UIFont systemFontOfSize:15*BIZ];
    [self addSubview:_informationLabel];
    [_informationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_statusImageView.mas_bottom).offset(20*kWidthScale);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(20*kWidthScale);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)setCellModel:(YSAssetsDetailModel *)cellModel withReconfirm:(NSString *)reconfirm history:(BOOL)history{
    _cellModel = cellModel;
    if (_cellModel.produDate == nil) {
        _cellModel.produDate = @"";
    }
    if ([reconfirm isEqual:@"WQR"]) {
        _statusImageView.image = [UIImage imageNamed:@"待盘"];
    } else if ([reconfirm isEqual:@"YC"]) {
        _statusImageView.image = [UIImage imageNamed:@"状态异常"];
    } else {
        _statusImageView.image = [UIImage imageNamed:@"状态正常"];
    }
    NSString *hasRent = _cellModel.hasRent ? @"是": @"否";
    NSString *information = [NSString stringWithFormat:@"%@\n%@\n%@-%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n", _cellModel.assetsNo, _cellModel.goodsName, _cellModel.secondCateName, _cellModel.thirdCateName, _cellModel.assetsStatusStr, _cellModel.proModel, _cellModel.goodsLevel, _cellModel.serialNo, [YSUtility formatTimestamp:_cellModel.produDate Length:10], _cellModel.ownCompany, _cellModel.useMan, _cellModel.useJobStation, _cellModel.useDept, _cellModel.useCompany, _cellModel.storePlace, _cellModel.remark, hasRent];
    NSMutableAttributedString *informationText = [[NSMutableAttributedString alloc] initWithString:information];
    informationText.yy_lineSpacing = 10.0;
    informationText.yy_alignment = NSTextAlignmentLeft;
    _informationLabel.attributedText = informationText;
    
    if (!history) {
        NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString: @"资产编码\n资产名称\n物品分类\n资产状态\n规格型号\n物品等级\n序列号\n生产日期\n所属公司\n使用人\n使用人岗位\n使用部门\n使用公司\n使用地点\n备注\n是否租赁\n盘点说明:"];
        titleText.yy_lineSpacing = 10.0;
        titleText.yy_alignment = NSTextAlignmentRight;
        _titleLabel.attributedText = titleText;
        _textView = [[UITextView alloc] init];
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 4;
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(_informationLabel.mas_right);
            make.top.mas_equalTo(_informationLabel.mas_bottom).offset(5*kHeightScale);
            make.height.mas_equalTo(100*kHeightScale);
        }];
        
        _confirmNormalButton = [[UIButton alloc] init];
        _confirmNormalButton.layer.masksToBounds = YES;
        _confirmNormalButton.layer.cornerRadius = 2;
        _confirmNormalButton.backgroundColor = kThemeColor;
        [_confirmNormalButton setTitle:@"确认正常" forState:UIControlStateNormal];
        [self addSubview:_confirmNormalButton];
        [_confirmNormalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.bottom.mas_equalTo(self.mas_bottom).offset(Multiply(-30));
            make.size.mas_equalTo(CGSizeMake(Multiply(165), Multiply(40)));
        }];
        
        _confirmErrorButton = [[UIButton alloc] init];
        _confirmErrorButton.layer.masksToBounds = YES;
        _confirmErrorButton.layer.cornerRadius = 2;
        _confirmErrorButton.backgroundColor = [UIColor colorWithRed:1.00 green:0.36 blue:0.38 alpha:1.00];
        [_confirmErrorButton setTitle:@"确认异常" forState:UIControlStateNormal];
        [self addSubview:_confirmErrorButton];
        [_confirmErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.mas_bottom).offset(Multiply(-30));
            make.size.mas_equalTo(CGSizeMake(Multiply(165), Multiply(40)));
        }];
    } else {
        NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString: @"资产编码\n资产名称\n物品分类\n资产状态\n规格型号\n物品等级\n序列号\n生产日期\n所属公司\n使用人\n使用人岗位\n使用部门\n使用公司\n使用地点\n备注\n是否租赁:"];
        titleText.yy_lineSpacing = 10.0;
        titleText.yy_alignment = NSTextAlignmentRight;
        _titleLabel.attributedText = titleText;
    }
}

- (void)setErrorStatusWithCellModel:(YSAssetsDetailModel *)cellModel {
    _cellModel = cellModel;
    if (_cellModel.produDate == nil) {
        _cellModel.produDate = @"";
    }
    _statusImageView.image = [UIImage imageNamed:@"状态异常"];
    NSString *hasRent = _cellModel.hasRent ? @"是": @"否";
    
    NSString *information = [NSString stringWithFormat:@"%@\n%@\n%@-%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n", _cellModel.assetsNo, _cellModel.goodsName, _cellModel.secondCateName, _cellModel.thirdCateName, _cellModel.assetsStatusStr, _cellModel.proModel, _cellModel.goodsLevel, _cellModel.serialNo, [YSUtility formatTimestamp:_cellModel.produDate Length:10], _cellModel.ownCompany, _cellModel.useMan, _cellModel.useJobStation, _cellModel.useDept, _cellModel.useCompany, _cellModel.storePlace, _cellModel.remark, hasRent];
    NSMutableAttributedString *informationText = [[NSMutableAttributedString alloc] initWithString:information];
    informationText.yy_lineSpacing = 10.0;
    informationText.yy_alignment = NSTextAlignmentLeft;
    _informationLabel.attributedText = informationText;
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString: @"资产编码\n资产名称\n物品分类\n资产状态\n规格型号\n物品等级\n序列号\n生产日期\n所属公司\n使用人\n使用人岗位\n使用部门\n使用公司\n使用地点\n备注\n是否租赁"];
    titleText.yy_lineSpacing = 10.0;
    titleText.yy_alignment = NSTextAlignmentRight;
    _titleLabel.attributedText = titleText;
    
    _retryButton = [[UIButton alloc] init];
    _retryButton.layer.masksToBounds = YES;
    _retryButton.layer.cornerRadius = 2;
    _retryButton.backgroundColor = kThemeColor;
    [_retryButton setTitle:@"重新扫描" forState:UIControlStateNormal];
    [self addSubview:_retryButton];
    [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(Multiply(40));
        make.bottom.mas_equalTo(self.mas_bottom).offset(Multiply(-30));
    }];
}

- (void)setErrorStatus {
    _statusImageView.image = [UIImage imageNamed:@"状态异常"];
    _informationLabel.text = @"未找到该资产的信息";
    
    _retryButton = [[UIButton alloc] init];
    _retryButton.layer.masksToBounds = YES;
    _retryButton.layer.cornerRadius = 2;
    _retryButton.backgroundColor = kThemeColor;
    [_retryButton setTitle:@"重新扫描" forState:UIControlStateNormal];
    [self addSubview:_retryButton];
    [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(Multiply(40));
        make.bottom.mas_equalTo(self.mas_bottom).offset(Multiply(-30));
    }];
}

- (void)setCellModel:(YSAssetsDetailModel *)cellModel {
    _cellModel = cellModel;
    if (_cellModel.produDate == nil) {
        _cellModel.produDate = @"";
    }
    _statusImageView.image = [UIImage imageNamed:@"状态正常"];
    NSString *hasRent = _cellModel.hasRent ? @"是": @"否";
    
    NSString *information = [NSString stringWithFormat:@"%@\n%@\n%@-%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n", _cellModel.assetsNo, _cellModel.goodsName, _cellModel.secondCateName, _cellModel.thirdCateName, _cellModel.assetsStatusStr, _cellModel.proModel, _cellModel.goodsLevel, _cellModel.serialNo, [YSUtility formatTimestamp:_cellModel.produDate Length:10], _cellModel.ownCompany, _cellModel.useMan, _cellModel.useJobStation, _cellModel.useDept, _cellModel.useCompany, _cellModel.storePlace, _cellModel.remark, hasRent];
    NSMutableAttributedString *informationText = [[NSMutableAttributedString alloc] initWithString:information];
    informationText.yy_lineSpacing = 10.0;
    informationText.yy_alignment = NSTextAlignmentLeft;
    _informationLabel.attributedText = informationText;
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString: @"资产编码\n资产名称\n物品分类\n资产状态\n规格型号\n物品等级\n序列号\n生产日期\n所属公司\n使用人\n使用人岗位\n使用部门\n使用公司\n使用地点\n备注\n是否租赁\n盘点说明"];
    titleText.yy_lineSpacing = 10.0;
    titleText.yy_alignment = NSTextAlignmentRight;
    _titleLabel.attributedText = titleText;
    
    _confirmButton = [[UIButton alloc] init];
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.layer.cornerRadius = 2;
    _confirmButton.backgroundColor = kThemeColor;
    [_confirmButton setTitle:@"确认盘点" forState:UIControlStateNormal];
    [self addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(Multiply(-30));
        make.size.mas_equalTo(CGSizeMake(Multiply(165), Multiply(40)));
    }];
    
    _finishButton = [[UIButton alloc] init];
    _finishButton.layer.masksToBounds = YES;
    _finishButton.layer.cornerRadius = 2;
    _finishButton.backgroundColor = [UIColor colorWithRed:0.98 green:0.40 blue:0.36 alpha:1.00];
    [_finishButton setTitle:@"完成盘点" forState:UIControlStateNormal];
    [self addSubview:_finishButton];
    [_finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(Multiply(-30));
        make.size.mas_equalTo(CGSizeMake(Multiply(165), Multiply(40)));
    }];
}

- (void)setSearchWithCellModel:(YSAssetsDetailModel *)cellModel {
    _cellModel = cellModel;
    if (_cellModel.produDate == nil) {
        _cellModel.produDate = @"";
    }
    _statusImageView.image = [UIImage imageNamed:@"状态正常"];
    NSString *hasRent = _cellModel.hasRent ? @"是": @"否";
    
    NSString *information = [NSString stringWithFormat:@"%@\n%@\n%@-%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n", _cellModel.assetsNo, _cellModel.goodsName, _cellModel.secondCateName, _cellModel.thirdCateName, _cellModel.assetsStatusStr, _cellModel.proModel, _cellModel.goodsLevel, _cellModel.serialNo, [YSUtility formatTimestamp:_cellModel.produDate Length:10], _cellModel.ownCompany, _cellModel.useMan, _cellModel.useJobStation, _cellModel.useDept, _cellModel.useCompany, _cellModel.storePlace, _cellModel.remark, hasRent];
    NSMutableAttributedString *informationText = [[NSMutableAttributedString alloc] initWithString:information];
    informationText.yy_lineSpacing = 10.0;
    informationText.yy_alignment = NSTextAlignmentLeft;
    _informationLabel.attributedText = informationText;
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString: @"资产编码\n资产名称\n物品分类\n资产状态\n规格型号\n物品等级\n序列号\n生产日期\n所属公司\n使用人\n使用人岗位\n使用部门\n使用公司\n使用地点\n备注\n是否租赁\n盘点说明"];
    titleText.yy_lineSpacing = 10.0;
    titleText.yy_alignment = NSTextAlignmentRight;
    _titleLabel.attributedText = titleText;
    
    _retryButton = [[UIButton alloc] init];
    _retryButton.layer.masksToBounds = YES;
    _retryButton.layer.cornerRadius = 2;
    _retryButton.backgroundColor = kThemeColor;
    [_retryButton setTitle:@"重新扫描" forState:UIControlStateNormal];
    [self addSubview:_retryButton];
    [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(Multiply(40));
        make.bottom.mas_equalTo(self.mas_bottom).offset(Multiply(-30));
    }];
}

@end
