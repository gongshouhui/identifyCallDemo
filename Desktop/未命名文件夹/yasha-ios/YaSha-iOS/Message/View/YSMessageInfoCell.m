//
//  YSMessageInfoCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/12/10.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMessageInfoCell.h"
#import "YSTagButton.h"
@interface YSMessageInfoCell()
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) YSTagButton *numButton;
@end
@implementation YSMessageInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.headImage = [[UIImageView alloc]init];
    self.headImage.image = [UIImage imageNamed:@"消息_icon"];
    [self.contentView addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(10*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(48*kWidthScale, 48*kWidthScale));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"消息通知";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).offset(10*kWidthScale);
        make.top.mas_equalTo(self.mas_top).offset(11*kHeightScale);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @" ";
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = kGrayColor(178);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(15*kHeightScale);
        make.right.mas_equalTo(self.mas_right).offset(-15*kWidthScale);
    }];
    
    
    self.numButton = [[YSTagButton alloc]init];
    self.numButton.tagContentEdgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
    self.numButton.layer.masksToBounds = YES;
    self.numButton.layer.cornerRadius = 8*kWidthScale;
    [self.numButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.numButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.numButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.numButton setContentHuggingPriority:(UILayoutPriorityDefaultHigh) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:self.numButton];
    [self.numButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15*kWidthScale);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(8*kHeightScale);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.text = @"暂无消息通知";
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = kGrayColor(136);
    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentLabel setContentHuggingPriority:(UILayoutPriorityDefaultLow) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).offset(10*kWidthScale);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8*kHeightScale);
        make.right.mas_equalTo(_numButton.mas_left).mas_equalTo(-10);
    }];
}

- (void)setMessageInfoCell:(YSMessageInfoDetailModel *)model {
    self.titleLabel.text = @"消息通知";
    if (!(model.noReadNumber > 0)) {
        self.numButton.hidden = YES;
        self.contentLabel.text = @"暂无未读消息";
        self.timeLabel.text = @" ";
        return;
    }
    self.numButton.hidden = NO;
    if (model.noReadNumber > 99) {
            [self.numButton setTitle:@"99+" forState:UIControlStateNormal];

    }else {
        [self.numButton setTitle:[NSString stringWithFormat:@"%ld",model.noReadNumber] forState:UIControlStateNormal];

    }
    self.numButton.backgroundColor = [UIColor redColor];
    NSString *typeStr;
    
    if (model.noticeType == 1) {
        typeStr = @"流程知会 : ";
        self.contentLabel.text = [NSString stringWithFormat:@"%@%@",typeStr,model.title];
    }else if (model.noticeType == 2) {
        typeStr = @"办结提醒 : ";
        self.contentLabel.text = [NSString stringWithFormat:@"%@%@",typeStr,model.title];
    }else if (model.noticeType == 3) {
        typeStr = @"系统提醒 : ";
        self.contentLabel.text = [NSString stringWithFormat:@"%@%@",typeStr,model.title];
    }else if (model.noticeType == 5){
        self.contentLabel.text = @"撤回提醒";
    }else if (model.noticeType == 6){
        self.contentLabel.text = @"驳回提醒";
    }else {
        typeStr = @"系统待办 : ";
        self.contentLabel.text = [NSString stringWithFormat:@"%@%@",typeStr,model.title];
    }
    
    self.timeLabel.text = [YSUtility timestampSwitchTime:model.createTime andFormatter:@"HH:mm:ss"];
    //系统的当前时间
    NSString *nowDate = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)];
    
    if ([[YSUtility timestampSwitchTime:model.createTime andFormatter:@"yyyy"] isEqualToString:[YSUtility timestampSwitchTime:nowDate andFormatter:@"yyyy"]]) {
        //同年
        if ([[YSUtility timestampSwitchTime:model.createTime andFormatter:@"yyyy年MM月dd"] isEqualToString:[YSUtility timestampSwitchTime:nowDate andFormatter:@"yyyy年MM月dd"]]) {
            // 同天
            self.timeLabel.text = [YSUtility timestampSwitchTime:model.createTime andFormatter:@"HH:mm"];
            
        }else {
            //不同天
            self.timeLabel.text = [YSUtility timestampSwitchTime:model.createTime andFormatter:@"MM月dd"];
        }
    }else {
        //不同年
        self.timeLabel.text = [YSUtility timestampSwitchTime:model.createTime andFormatter:@"yyyy年MM月dd"];

    }
    
}
- (void)setQYMessageWith:(YSMessageInfoModel *)model {
    if (model.total <= 0) {
        self.numButton.hidden = YES;
    }else{
        self.numButton.hidden = NO;
        [self.numButton setTitle:[NSString stringWithFormat:@"%ld",model.total] forState:UIControlStateNormal];
        self.numButton.backgroundColor = [UIColor redColor];
    }
    self.titleLabel.text = @"亚厦小管家";
    self.headImage.image = [UIImage imageNamed:@"qiyu"];
    self.contentLabel.text = model.data.title;
    self.timeLabel.text = [YSUtility timestampSwitchTime:model.data.createTime andFormatter:@"HH:mm:ss"];
}
// 打卡
- (void)setClockListCell:(YSMessageInfoDetailModel*)model {
    self.headImage.image = [UIImage imageNamed:@"clockListIcon"];
    self.titleLabel.text = @"打卡";
//    if (!(model.noReadNumber > 0)) {
//        self.numButton.hidden = YES;
//        self.contentLabel.text = @"暂无未读消息";
//        self.timeLabel.text = @" ";
//        return;
//    }
    self.numButton.hidden = YES;
//    if (model.noReadNumber > 99) {
//        [self.numButton setTitle:@"99+" forState:UIControlStateNormal];
//
//    }else {
//        [self.numButton setTitle:[NSString stringWithFormat:@"%ld",model.noReadNumber] forState:UIControlStateNormal];
//
//    }    self.numButton.backgroundColor = [UIColor redColor];
    if ([YSUtility judgeIsEmpty:model.content]) {
        self.contentLabel.text = @"暂无未读消息";
    }else {
   
        self.contentLabel.text = [NSString stringWithFormat:@"%@", model.content];
    }
    self.timeLabel.text = [YSUtility timestampSwitchTime:model.sendTime andFormatter:@"yyyy年MM月dd HH:mm"];
    //系统的当前时间
    NSString *nowDate = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)];
    
    if ([[YSUtility timestampSwitchTime:model.sendTime andFormatter:@"yyyy"] isEqualToString:[YSUtility timestampSwitchTime:nowDate andFormatter:@"yyyy"]]) {
        //同年
        if ([[YSUtility timestampSwitchTime:model.sendTime andFormatter:@"yyyy年MM月dd"] isEqualToString:[YSUtility timestampSwitchTime:nowDate andFormatter:@"yyyy年MM月dd"]]) {
            // 同天
            self.timeLabel.text = [YSUtility timestampSwitchTime:model.sendTime andFormatter:@"HH:mm"];
            
        }else {
            //不同天
            self.timeLabel.text = [YSUtility timestampSwitchTime:model.sendTime andFormatter:@"MM月dd"];
        }
    }else {
        //不同年
        self.timeLabel.text = [YSUtility timestampSwitchTime:model.sendTime andFormatter:@"yyyy年MM月dd"];

    }
     
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
