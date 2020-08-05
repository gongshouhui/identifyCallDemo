//
//  YSSonTableViewCell.m
//  YaSha-iOS
//
//  Created by mHome on 2016/11/29.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSSonTableViewCell.h"

@implementation YSSonTableViewCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUi];
    }
    return self;
}
- (void) initUi {
    
    self.headImage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headImage.layer.cornerRadius = 15*kHeightScale;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(9);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kHeightScale));
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.headImage.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 20*kHeightScale));
    }];
    
    self.jobsName = [[UILabel alloc]init];
    self.jobsName.font = [UIFont systemFontOfSize:13];
    self.jobsName.textColor = [UIColor lightGrayColor];
    [self addSubview:self.jobsName];
    [self.jobsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(150*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(200*kWidthScale, 20*kHeightScale));
    }];
    
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
