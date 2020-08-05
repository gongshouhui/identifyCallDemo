//
//  YSPhoneAddressBookTableViewCell.m
//  YaSha-iOS
//
//  Created by mHome on 2016/11/29.
//  Copyright © 2016年 方鹏俊. All rights reserved.
//

#import "YSPhoneAddressBookTableViewCell.h"

@implementation YSPhoneAddressBookTableViewCell

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
        self.headLabel = [[UILabel alloc]init];
        self.headLabel.textColor = [UIColor whiteColor];
        self.headLabel.textAlignment = NSTextAlignmentCenter;
        self.headLabel.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:189.0/255.0 blue:231.0/255.0 alpha:1.0];
        self.headLabel.layer.cornerRadius = 15*BIZ ;
        //iOS7 以后需要设置
        self.headLabel.clipsToBounds = YES;
        [self.contentView addSubview:self.headLabel];
        [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
//            make.top.mas_equalTo(self.contentView.mas_top).offset(9*BIZ);
            make.left.mas_equalTo(self.contentView.mas_left).offset(14*BIZ);
            make.size.mas_equalTo(CGSizeMake(30*BIZ, 30*BIZ));
        }];
    
    self.namelabel = [[UILabel alloc]init];
    
    [self.contentView addSubview:self.namelabel];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.top.mas_equalTo(self.contentView.mas_top).offset(17*BIZ);
        make.left.mas_equalTo (self.headLabel.mas_right).offset(20*BIZ);
        make.size.mas_equalTo(CGSizeMake(150*BIZ, 20*BIZ));
    }];
    self.telLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.telLabel];

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
