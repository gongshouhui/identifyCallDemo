//
//  YSAttendanceCell.m
//  YaSha-iOS
//
//  Created by mHome on 2017/4/21.
//
//

#import "YSAttendanceCell.h"

@implementation YSAttendanceCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUi];
    }
    return self;
}
-(void) creatUi{
    
    self.backView = [[UIView alloc]initWithFrame:CGRects(15, 0, 345, 52)];
    self.backView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [self addSubview:self.backView];
    
    self.pointView = [[UIView alloc]initWithFrame:CGRects(12, 27, 4, 4)];
    self.pointView.backgroundColor = [UIColor grayColor];
    self.pointView.layer.masksToBounds = YES;
    self.pointView.layer.cornerRadius = 2;
    [self.backView addSubview:self.pointView];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRects(25, 22, 120, 14)];
    self.contentLabel.font = [UIFont systemFontOfSize:15*BIZ];
    [self.backView addSubview:self.contentLabel];
    
    
    self.dealWithButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dealWithButton.titleLabel.font = [UIFont systemFontOfSize:12*BIZ];
    self.dealWithButton.frame = CGRects(284, 17, 47, 21);
    self.dealWithButton.layer.masksToBounds = YES;
    self.dealWithButton.layer.cornerRadius = 4;
    [self.backView addSubview:self.dealWithButton];
}

@end
