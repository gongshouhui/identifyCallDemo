//
//  YSMessageListTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/6/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMessageListTableViewCell.h"
@interface YSMessageListTableViewCell ()

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIView *readFlag;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *computerImage;

@end

@implementation YSMessageListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.headImage = [[UIImageView alloc]init];
    self.headImage.image = [UIImage imageNamed:@"消息_icon"];
    [self addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(15*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(45*kWidthScale, 45*kWidthScale));
    }];
    
    self.readFlag = [[UIView alloc]init];
    self.readFlag.backgroundColor = [UIColor redColor];
    self.readFlag.layer.masksToBounds = YES;
    self.readFlag.layer.cornerRadius = 6*kHeightScale;
    [self addSubview:self.readFlag];
    [self.readFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10*kHeightScale);
        make.left.mas_equalTo(self.mas_left).offset(53*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(12*kWidthScale, 12*kWidthScale));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"消息通知";
    self.titleLabel.font = [UIFont systemFontOfSize:14*kWidthScale];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).offset(10*kWidthScale);
        make.top.mas_equalTo(self.mas_top).offset(11*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(210*kWidthScale, 20*kHeightScale));
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @"12:20";
    self.timeLabel.font = [UIFont systemFontOfSize:12*kWidthScale];
    self.timeLabel.textColor = kGrayColor(178);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(6*kWidthScale);
        make.top.mas_equalTo(self.mas_top).offset(15*kHeightScale);
        make.right.mas_equalTo(self.mas_right).offset(-15*kWidthScale);
        make.height.mas_equalTo(17*kHeightScale);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:14*kWidthScale];
    self.contentLabel.textColor = kGrayColor(136);
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).offset(10*kWidthScale);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(200*kWidthScale, 20*kHeightScale));
    }];
    
    
    self.computerImage = [[UIImageView alloc]init];
    [self addSubview:self.computerImage];
    [self.computerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15*kWidthScale);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(8*kHeightScale);
        make.size.mas_equalTo(CGSizeMake(24*kWidthScale, 24*kWidthScale));
    }];
    
};

- (void)setMessageCell:(YSFlowListModel *)cellModel {
    self.titleLabel.text = cellModel.title;
    //    self.contentLabel.text = cellModel.content;
    if ([cellModel.noticeType intValue] == 1) {
        self.contentLabel.text = @"流程知会";
    }else if ([cellModel.noticeType intValue] == 2) {
        self.contentLabel.text = @"办结提醒";
    }else if ([cellModel.noticeType intValue] == 3) {
        self.contentLabel.text = @"系统提醒";
    }else if ([cellModel.noticeType intValue] == 4){
        self.contentLabel.text = @"系统待办";
    }else if ([cellModel.noticeType intValue] == 5){
        self.contentLabel.text = @"撤回提醒";
    }else if ([cellModel.noticeType intValue] == 6){
        self.contentLabel.text = @"驳回提醒";
    }
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    if ([[YSUtility timestampSwitchTime:cellModel.createTime andFormatter:@"yyyy"] isEqualToString:[NSString stringWithFormat:@"%ld",[dateComponent year]]]) {
        self.timeLabel.text = [YSUtility timestampSwitchTime:cellModel.createTime andFormatter:@"MM-dd"];
    }else {
        self.timeLabel.text = [YSUtility timestampSwitchTime:cellModel.createTime andFormatter:@"yyyy-MM-dd"];
    }
    if([[YSUtility timestampSwitchTime:cellModel.createTime andFormatter:@"dd"] isEqualToString:[NSString stringWithFormat:@"%ld",[dateComponent day]]]){
        self.timeLabel.text = [YSUtility timestampSwitchTime:cellModel.createTime andFormatter:@"hh:mm:ss"];
    }else {
        self.timeLabel.text = [YSUtility timestampSwitchTime:cellModel.createTime andFormatter:@"yyyy-MM-dd"];
    }
    
    if ([cellModel.status intValue] == 1) {
        self.readFlag.hidden = YES;
    }else {
        self.readFlag.hidden = NO;
    }
    
    

    if ([cellModel.noticeType isEqualToString:@"3"]) {
        self.computerImage.hidden = YES;
    }else{
        if (cellModel.processType != 1 && cellModel.processType != 5) {
            YSFlowModel *flowModel = [YSUtility getFlowModelWithProcessDefinitionKey:cellModel.processDefinitionKey];
            if (!flowModel.isMobile) {
                self.computerImage.hidden = NO;
                self.computerImage.image = [UIImage imageNamed:@"电脑处理_icon"];
            }else{
                self.computerImage.hidden = YES;
            }
        }else{
            self.computerImage.hidden = YES;
        }
    }
    if ([cellModel.noticeType intValue] == 1 || [cellModel.noticeType intValue] == 2) {
        self.headImage.image = [UIImage imageNamed:@"流程_icon"];
    }else {
        self.headImage.image = [UIImage imageNamed:@"系统_icon"];
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
