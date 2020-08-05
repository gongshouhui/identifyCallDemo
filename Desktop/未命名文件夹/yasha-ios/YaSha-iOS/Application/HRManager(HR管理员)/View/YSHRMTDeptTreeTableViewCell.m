//
//  YSHRMTDeptTreeTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/19.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMTDeptTreeTableViewCell.h"

@interface YSHRMTDeptTreeTableViewCell ()


@end


@implementation YSHRMTDeptTreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    self.leftLineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deptTreeChoseImgHR"]];
    [self.contentView addSubview:self.leftLineImg];
    [self.leftLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(3*kWidthScale, 20*kHeightScale));
        
    }];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(20*kHeightScale);
        make.left.mas_equalTo(18*kWidthScale);
        make.right.mas_equalTo(-18*kWidthScale);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
