//
//  YSSupplyMaterialListCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/13.
//

#import "YSSupplyMaterialListCell.h"

@interface YSSupplyMaterialListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *materialLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic,strong) UIImageView *disableIV;
@end

@implementation YSSupplyMaterialListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"防滑地砖";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16*kHeightScale);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15*kWidthScale);
        make.height.mas_equalTo(16*kHeightScale);
        make.right.mas_equalTo(-15*kHeightScale);
    }];
    
    _materialLabel = [[UILabel alloc]init];
    _materialLabel.font = [UIFont systemFontOfSize:12];
    _materialLabel.textColor = kUIColor(153, 153, 153, 1.0);
    _materialLabel.text = @"装饰材料 标准品 电线类";
    [self.contentView addSubview:_materialLabel];
    [_materialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(14*kHeightScale);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    _sizeLabel = [[UILabel alloc]init];
    _sizeLabel.font = [UIFont systemFontOfSize:12];
    _sizeLabel.textColor = kUIColor(153, 153, 153, 1.0);
    _sizeLabel.text = @"800*800";
    [self.contentView addSubview:_sizeLabel];
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.top.mas_equalTo(_materialLabel.mas_bottom).offset(10*kHeightScale);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    _brandLabel = [[UILabel alloc]init];
    _brandLabel.font = [UIFont systemFontOfSize:12];
    _brandLabel.textColor = kUIColor(42, 139, 220, 1.0);
    _brandLabel.textAlignment = NSTextAlignmentRight;
    _brandLabel.text = @"宝胜";
    [self.contentView addSubview:_brandLabel];
    [_brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_sizeLabel.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15*kWidthScale);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(160*kWidthScale, 15*kHeightScale));
    }];
    
    //禁用标识
    _disableIV = [[UIImageView alloc]init];
    _disableIV.image = [UIImage imageNamed:@"禁用"];
    [self.contentView addSubview:_disableIV];
    [_disableIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.width.mas_equalTo(66*kWidthScale);
        make.height.mas_equalTo(39*kHeightScale);
    }];
    
}

- (void)setModel:(YSMaterialInfoModel *)model
{
    _model = model;
    
    if (model.name.length) {
        self.titleLabel.text = model.name;
    }else{
        self.titleLabel.text = model.mtrlFour;
    }
    self.materialLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@",model.mtrlOne,model.mtrlTwo,model.mtrlThree,model.mtrlFour];
    self.sizeLabel.text = model.no;
    self.brandLabel.text = model.brand.length?model.brand:@"暂缺";
    self.disableIV.hidden = model.status == 10 ?YES:NO;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
