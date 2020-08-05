//
//  YSAddPeopleTableViewCell.m
//  YaSha-iOS
//
//  Created by mHome on 2016/11/30.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSAddPeopleTableViewCell.h"

@implementation YSAddPeopleTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUi];
    }
    return self;
}
-(void) initUi
{
    self.titleBtn = [[UIButton alloc]init];
    [self.titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15*kHeightScale);
    [self.contentView addSubview:self.titleBtn];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 25*kWidthScale));
    }];
    
    self.content = [[UITextField alloc]init];
    self.content.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.titleBtn.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(180*kWidthScale, 25*kWidthScale));
    }];
    
    self.img = [[UIImageView alloc]init];
    self.img.image = [UIImage imageNamed:@"下拉"];
    [self.contentView  addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(18);
        make.right.mas_equalTo(self.titleBtn.mas_right).offset(-3);
        make.size.mas_equalTo(CGSizeMake(10*kWidthScale, 8*kWidthScale));
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
