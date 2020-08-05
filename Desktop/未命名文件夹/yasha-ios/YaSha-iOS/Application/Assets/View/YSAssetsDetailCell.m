//
//  YSAssetsDetailCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import "YSAssetsDetailCell.h"

@interface YSAssetsDetailCell ()

@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation YSAssetsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _statusImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_statusImageView];
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(33*kWidthScale, 20*kHeightScale));
    }];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_statusImageView.mas_centerY);
        make.left.mas_equalTo(_statusImageView.mas_right).offset(12);
        make.size.mas_equalTo(CGSizeMake(145*kWidthScale, 15*kHeightScale));
    }];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = [UIFont systemFontOfSize:15];
    _descriptionLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00];
    [self.contentView addSubview:_descriptionLabel];
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_statusImageView.mas_centerY);
        make.left.mas_equalTo(_numberLabel.mas_right).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(16*kHeightScale);
    }];
}

- (void)setCellModel:(YSAssetsDetailListModel *)cellModel {
    _cellModel = cellModel;
    if ([_cellModel.reconfirm isEqual:@"YQR"]) {
        _statusImageView.image = [UIImage imageNamed:@"正常（Small）"];
    } else if ([_cellModel.reconfirm isEqual:@"YC"]) {
        _statusImageView.image = [UIImage imageNamed:@"异常（Small）"];
    } else {
        _statusImageView.image = [UIImage imageNamed:@"待盘（Small）"];
    }
    _numberLabel.text = _cellModel.assetsNo;
    _descriptionLabel.text = _cellModel.info;
}

@end
