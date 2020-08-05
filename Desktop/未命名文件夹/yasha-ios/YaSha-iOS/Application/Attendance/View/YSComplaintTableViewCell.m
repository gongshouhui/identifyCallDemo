//
//  YSComplaintTableViewCell.m
//  YaSha-iOS
//
//  Created by mHome on 2017/4/26.
//
//

#import "YSComplaintTableViewCell.h"

@implementation YSComplaintTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRects(15, 12, 110, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:15*BIZ];
        [self.contentView addSubview:self.titleLabel];
        self.img = [[UIImageView alloc]initWithFrame:CGRects(352, 14, 8, 14)];
        self.img.image = [UIImage imageNamed:@"选择"];
        [self.contentView addSubview:self.img];
        
        self.conterLabel = [[UILabel alloc]initWithFrame:CGRects(130, 10, 215, 20)];
        self.conterLabel.textAlignment = NSTextAlignmentRight;
        self.conterLabel.font = [UIFont systemFontOfSize:14];
        self.conterLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.conterLabel];
        
        
        self.switchView = [[UISwitch alloc]initWithFrame:CGRectMake(317*BIZ, 7*BIZ, 40*BIZ, 20*BIZ)];
        [self.contentView addSubview:self.switchView];
        
        
        self.textfield = [[UITextField alloc]initWithFrame:CGRects(130, 12, 230, 20)];
        self.textfield.placeholder = @"请输入";
        self.textfield.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.textfield];
        
    }
    return self;
}

@end
