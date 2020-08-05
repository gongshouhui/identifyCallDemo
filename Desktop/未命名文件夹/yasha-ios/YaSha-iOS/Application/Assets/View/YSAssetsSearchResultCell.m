//
//  YSAssetsSearchResultCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import "YSAssetsSearchResultCell.h"

@interface YSAssetsSearchResultCell ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *titileLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *companyLabel;

@end

@implementation YSAssetsSearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).offset(15*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(145*kWidthScale, 15*kHeightScale));
    }];
    
    _titileLabel = [[UILabel alloc] init];
    _titileLabel.font = [UIFont systemFontOfSize:15];
    _titileLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_titileLabel];
    [_titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15*kHeightScale);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15*kWidthScale);
        make.height.mas_equalTo(15*kHeightScale);
        make.left.mas_equalTo(_numberLabel.mas_right).offset(5);
    }];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.font = [UIFont systemFontOfSize:12];
    _statusLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberLabel.mas_bottom).offset(12*kHeightScale);
        make.left.mas_equalTo(_numberLabel.mas_left);
        make.width.mas_equalTo(50*kWidthScale);
        make.height.mas_equalTo(12*kHeightScale);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_statusLabel.mas_right).offset(15*kHeightScale);
        make.centerY.mas_equalTo(_statusLabel.mas_centerY);
        make.height.mas_equalTo(12*kHeightScale);
        make.width.mas_equalTo(50*kWidthScale);
    }];
    
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.textAlignment = NSTextAlignmentRight;
    _companyLabel.font = [UIFont systemFontOfSize:12];
    _companyLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    [self.contentView addSubview:_companyLabel];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        make.right.mas_equalTo(_titileLabel.mas_right);
        make.height.mas_equalTo(12*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _departmentLabel = [[UILabel alloc] init];
    _departmentLabel.font = [UIFont systemFontOfSize:12];
    _departmentLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    [self.contentView addSubview:_departmentLabel];
    [_departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_statusLabel.mas_centerY);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(15*kWidthScale);
        make.right.mas_equalTo(_companyLabel.mas_left).offset(15*kWidthScale);
        make.height.mas_equalTo(12*kHeightScale);
    }];
}

- (void)setCellModel:(YSAssetsResultModel *)cellModel {
    _cellModel = cellModel;
    _numberLabel.text = _cellModel.assetsNo;
    _titileLabel.text = _cellModel.goodsName;
    _statusLabel.text = _cellModel.assetsStatusStr;
    _nameLabel.text = _cellModel.useMan;
    _departmentLabel.text = _cellModel.useDept;
    _companyLabel.text = _cellModel.ownCompany;
}

@end
