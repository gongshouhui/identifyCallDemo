//
//  YSInfoSelfHelpCell.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRInfoSelfHelpCell.h"
@interface YSHRInfoSelfHelpCell()
@property (nonatomic,strong) UIImageView *headerIV;

@end
@implementation YSHRInfoSelfHelpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    _headerIV = [[UIImageView alloc]init];
    [self.contentView addSubview:_headerIV];
    [_headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(18*kWidthScale);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    self.nameLb = [[UILabel alloc]init];
    self.nameLb.font = [UIFont systemFontOfSize:16];
    self.nameLb.textColor = kGrayColor(51);
    [self.contentView addSubview:self.nameLb];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_headerIV.mas_centerY);
        make.left.mas_equalTo(_headerIV.mas_right).mas_equalTo(12);
    }];
    
    UIImageView *arrowIV = [[UIImageView alloc]init];
    arrowIV.image = [UIImage imageNamed:@"arrow"];
    [self.contentView addSubview:arrowIV];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
}
- (void)setModel:(YSApplicationModel *)model
{
    _model = model;
    self.nameLb.text = model.name;
    self.imageView.image = [UIImage imageNamed:model.imageName];
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
