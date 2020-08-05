//
//  YSChoosePeopleTableViewCell.m
//  YaSha-iOS
//
//  Created by mHome on 2017/4/17.
//
//

#import "YSChoosePeopleTableViewCell.h"

@implementation YSChoosePeopleTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.chooseImage = [[UIImageView alloc]init];
//        self.chooseImage.frame = CGRects(15, 10, 28, 28);
        self.chooseImage.image = [UIImage imageNamed:@"未选"];
        self.chooseImage.layer.masksToBounds = YES;
        self.chooseImage.layer.cornerRadius =14*kWidthScale;
        [self.contentView addSubview:self.chooseImage];
        [self.chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 28*kWidthScale));
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView  addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.chooseImage.mas_right).offset(7);
            make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 28*kWidthScale));
        }];
        
        
        self.jobsName = [[UILabel alloc]init];
        self.jobsName.font = [UIFont systemFontOfSize:13];
        self.jobsName.textColor = [UIColor lightGrayColor];
        self.jobsName.textAlignment = NSTextAlignmentRight;
        self.jobsName.frame = CGRects(150, 14, 200, 20);
        [self addSubview:self.jobsName];
    }
    return self;
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
