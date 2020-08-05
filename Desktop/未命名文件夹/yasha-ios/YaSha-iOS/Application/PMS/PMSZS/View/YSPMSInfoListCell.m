//
//  YSPMSInfoListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/29.
//
//

#import "YSPMSInfoListCell.h"

@interface YSPMSInfoListCell ()

@property (nonatomic, strong) YSPMSInfoListModel *cellModel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation YSPMSInfoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = kUIColor(51, 51, 51, 1.0);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(16*kHeightScale);
    }];
    
    self.addressLabel = [[UILabel alloc]init];
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = kUIColor(153, 153, 153, 1.0);
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.font = [UIFont systemFontOfSize:12];
    self.typeLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
        make.height.mas_equalTo(14*kHeightScale);
    }];
}

- (void)setCellModel:(YSPMSInfoListModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = _cellModel.name;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",_cellModel.province, _cellModel.city, _cellModel.area];
    NSString *formatStr;
    formatStr = [NSString stringWithFormat:@"%@-%@",_cellModel.statusStr, _cellModel.proStatusName];
    NSMutableAttributedString  *attributedStr = [[NSMutableAttributedString alloc]initWithString:formatStr];
    attributedStr.yy_color = kUIColor(45, 113, 217, 1.0);
    [attributedStr yy_setColor:[UIColor redColor] range:NSMakeRange(0 ,_cellModel.statusStr.length)];
    self.typeLabel.attributedText = attributedStr;
}

@end
