//
//  YSHRManagerHGBTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/28.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRManagerHGBTableViewCell.h"


@interface YSHRManagerHGBTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *briefLb;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *positionLab;


@end

@implementation YSHRManagerHGBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self loadSubViews];
    }
    return self;
}
- (void)loadSubViews {
    UIView *backView = [[UIView alloc] init];
    backView.layer.shadowOpacity = 0.26;
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.shadowColor = [UIColor colorWithHexString:@"#5A5A5A"].CGColor;
    backView.layer.shadowOffset = CGSizeMake(0, 0);
    backView.layer.cornerRadius = 4;
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.right.mas_equalTo(-16*kWidthScale);
        make.top.mas_equalTo(5*kHeightScale);
        make.bottom.mas_equalTo(-5*kHeightScale);
    }];
    //头像
    _headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _headerImg.layer.cornerRadius = 34*kWidthScale*0.5;
    _headerImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34*kWidthScale, 34*kWidthScale));
        make.left.mas_equalTo(30*kWidthScale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    // 名字
    _nameLab = [[UILabel alloc] init];
    _nameLab.text = @"";
    _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _nameLab.textColor = kUIColor(71, 76, 81, 1);
    [self.contentView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_headerImg.mas_right).offset(9*kWidthScale);
    }];
    // 职位
    _briefLb = [[UILabel alloc] init];
    _briefLb.text = @"";
    _briefLb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _briefLb.textColor = kUIColor(71, 76, 81, 1);
    [self.contentView addSubview:_briefLb];
    [_briefLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_nameLab.mas_right).offset(17*kWidthScale);
    }];
    // 工号
    _numberLab = [[UILabel alloc] init];
    _numberLab.text = @"";
    _numberLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _numberLab.textColor = kUIColor(71, 76, 81, 1);
    [self.contentView addSubview:_numberLab];
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_briefLb.mas_right).offset(17*kWidthScale);
    }];
    // 职级
    _positionLab = [[UILabel alloc] init];
    _positionLab.text = @"";
    _positionLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _positionLab.textColor = kUIColor(71, 76, 81, 1);
    [self.contentView addSubview:_positionLab];
    [_positionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_numberLab.mas_right).offset(17*kWidthScale);
    }];
}

- (void)setPersonModel:(YSTeamCompilePostModel *)personModel {
    if (!_personModel) {
        _personModel = personModel;
    }
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YSImageDomain, personModel.headImage]] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = personModel.name;
    _briefLb.text = personModel.postname;
    _numberLab.text = personModel.no;
    _positionLab.text = personModel.positionName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
