//
//  YSSupplyListTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/10/19.
//

#import "YSSupplyListTableViewCell.h"


@interface YSSupplyListTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView * photoImage;
@property (nonatomic, strong) UILabel *materialLabel;
@property (nonatomic, strong) UILabel *addressLabel;


@end

@implementation YSSupplyListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16*kHeightScale);
        make.left.mas_equalTo(self.contentView.mas_left).offset(12*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(285*kWidthScale, 16*kHeightScale));
    }];
    
    self.photoImage = [[UIImageView alloc]init];
    self.photoImage.image = [UIImage imageNamed:@"冻结"];
    [self.contentView addSubview:self.photoImage];
    [self.photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(0);
    make.left.mas_equalTo(self.titleLabel.mas_right).offset(5*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(73*kWidthScale, 47*kHeightScale));
    }];
    
    self.materialLabel = [[UILabel alloc]init];
    self.materialLabel.font = [UIFont systemFontOfSize:12];
    self.materialLabel.textColor = kUIColor(153, 153, 153, 1);
    [self.contentView addSubview:self.materialLabel];
    [self.materialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14*kHeightScale);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-30*kWidthScale, 16));
    }];
    
    self.addressLabel = [[UILabel alloc]init];
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = kUIColor(153, 153, 153, 1);
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.materialLabel.mas_bottom).offset(10*kHeightScale);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-30*kWidthScale, 16));
    }];
}

- (void)setSupplyListCellData:(YSSupplyListModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】%@",model.companyType, model.name] ;
    self.materialLabel.text = model.cateGoryStr;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.area];
    if (model.isFrozen != 1) {
        [self.photoImage removeFromSuperview];
    }
    
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
