//
//  YSTodayEventCell.m
//  YaSha-iOS
//
//  Created by mHome on 2017/5/4.
//
//

#import "YSTodayEventCell.h"

@implementation YSTodayEventCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void) creatUI{
    self.backView = [[UIView alloc]initWithFrame:CGRects(15, 0, 345, 89)];
    //    self.backView.layer.masksToBounds = YES;
    //    self.backView.layer.cornerRadius = 5;
    self.backView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [self addSubview:self.backView];
    
    self.conterLabel = [[UILabel alloc]initWithFrame:CGRects(15, 22, 120, 14)];
    self.conterLabel.font = [UIFont systemFontOfSize:15*BIZ];
//    self.conterLabel.text = @"上午迟到38分钟";
    [self.backView addSubview:self.conterLabel];
    
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRects(15, 56, 300, 15)];
    self.timeLabel.font = [UIFont systemFontOfSize:13*BIZ];
    self.timeLabel.textColor = [UIColor grayColor];
//    self.timeLabel.text= @"2017-05-04 09:20 迟到";
    [self.backView addSubview:self.timeLabel];
    
    self.dealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dealButton.titleLabel.font = [UIFont systemFontOfSize:12*BIZ];
    self.dealButton.frame = CGRects(284, 14, 47, 21);
    self.dealButton.layer.masksToBounds = YES;
    self.dealButton.layer.cornerRadius = 4;
    [self.backView addSubview:self.dealButton];
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
