//
//  YSAssetsMineCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/13.
//
//

#import "YSAssetsMineCell.h"

@interface YSAssetsMineCell ()

@property (nonatomic, strong) UIImageView *assetsImageView;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *proModelLabel;
@property (nonatomic, strong) UILabel *goodsLevelLabel;
@property (nonatomic, strong) UILabel *noLabel;

@end

@implementation YSAssetsMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _assetsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_assetsImageView];
    [_assetsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(96*kWidthScale, 96*kHeightScale));
    }];
    
    _goodsNameLabel = [[UILabel alloc] init];
    _goodsNameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_goodsNameLabel];
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_assetsImageView.mas_top);
        make.left.mas_equalTo(_assetsImageView.mas_right).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(16*kHeightScale);
    }];
    
    _proModelLabel = [[UILabel alloc] init];
    _proModelLabel.font = [UIFont systemFontOfSize:12];
    _proModelLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00];
    [self.contentView addSubview:_proModelLabel];
    [_proModelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_goodsNameLabel.mas_bottom).offset(16*kHeightScale);
        make.left.mas_equalTo(_goodsNameLabel.mas_left);
        make.right.mas_equalTo(_goodsNameLabel.mas_right);
        make.height.mas_equalTo(12*kHeightScale);
    }];
    
    _goodsLevelLabel = [[UILabel alloc] init];
    _goodsLevelLabel.font = [UIFont systemFontOfSize:12];
    _goodsLevelLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00];
    [self.contentView addSubview:_goodsLevelLabel];
    [_goodsLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_proModelLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(_goodsNameLabel.mas_left);
        make.right.mas_equalTo(_goodsNameLabel.mas_right);
        make.height.mas_equalTo(12*kHeightScale);
    }];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = kThemeColor;
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_assetsImageView.mas_bottom);
        make.left.mas_equalTo(_goodsNameLabel.mas_left);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(12*kHeightScale);
    }];
    
    _noLabel = [[UILabel alloc] init];
    _noLabel.font = [UIFont systemFontOfSize:12];
    _noLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00];
    [self.contentView addSubview:_noLabel];
    [_noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_assetsImageView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(12*kHeightScale);
    }];
}

- (void)setCellModel:(YSAssetsMineModel *)cellModel {
    _cellModel = cellModel;
    [_assetsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YSImageDomain, _cellModel.filePath]] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    _goodsNameLabel.text = _cellModel.goodsName;
    _proModelLabel.text = _cellModel.proModel;
    _goodsLevelLabel.text = _cellModel.goodsLevelName;
    _statusLabel.text = _cellModel.assetsStatusStr;
    _noLabel.text = _cellModel.assetsNo;
}

@end
