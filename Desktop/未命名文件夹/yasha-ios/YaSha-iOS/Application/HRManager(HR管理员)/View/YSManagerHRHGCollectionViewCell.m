//
//  YSManagerHRHGCollectionViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSManagerHRHGCollectionViewCell.h"

@interface YSManagerHRHGCollectionViewCell ()

@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *briefLb;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *positionLab;
@property (nonatomic, strong) UIView *backView;

@end

@implementation YSManagerHRHGCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.shadowOpacity = 0.15;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
        self.contentView.layer.borderWidth = 0;
        self.contentView.layer.borderColor = [UIColor colorWithHexString:@"#1890FF"].CGColor;
        self.contentView.layer.cornerRadius = 4;
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    // 公司
    self.companyLab = [[UILabel alloc] init];
    self.companyLab.text = @"";
    self.companyLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(15)];
    self.companyLab.textAlignment = NSTextAlignmentCenter;
    self.companyLab.textColor = kUIColor(71, 76, 81, 1);
    [self.contentView addSubview:self.companyLab];
    [self.companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(2);
        make.right.bottom.mas_equalTo(-2);
    }];
    /*
    _backView = [[UIView alloc] initWithFrame:self.contentView.frame];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
   //头像
    _headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    [_backView addSubview:_headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34*kWidthScale, 34*kHeightScale));
        make.left.mas_equalTo(14*kWidthScale);
        make.centerY.mas_equalTo(_backView.mas_centerY);
    }];
    // 名字
    _nameLab = [[UILabel alloc] init];
    _nameLab.text = @"你猜";
    _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _nameLab.textColor = kUIColor(71, 76, 81, 1);
    [_backView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(_backView.mas_centerY);
        make.left.mas_equalTo(_headerImg.mas_right).offset(9*kWidthScale);
    }];
    // 职位
    _briefLb = [[UILabel alloc] init];
    _briefLb.text = @"产品工程师";
    _briefLb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _briefLb.textColor = kUIColor(71, 76, 81, 1);
    [_backView addSubview:_briefLb];
    [_briefLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(_backView.mas_centerY);
        make.left.mas_equalTo(_nameLab.mas_right).offset(17*kWidthScale);
    }];
    // 工号
    _numberLab = [[UILabel alloc] init];
    _numberLab.text = @"100012";
    _numberLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _numberLab.textColor = kUIColor(71, 76, 81, 1);
    [_backView addSubview:_numberLab];
    [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(_backView.mas_centerY);
        make.left.mas_equalTo(_briefLb.mas_right).offset(17*kWidthScale);
    }];
    // 职级
    _positionLab = [[UILabel alloc] init];
    _positionLab.text = @"P-1";
    _positionLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _positionLab.textColor = kUIColor(71, 76, 81, 1);
    [_backView addSubview:_positionLab];
    [_positionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(_backView.mas_centerY);
        make.left.mas_equalTo(_numberLab.mas_right).offset(17*kWidthScale);
    }];
    */
}



@end
