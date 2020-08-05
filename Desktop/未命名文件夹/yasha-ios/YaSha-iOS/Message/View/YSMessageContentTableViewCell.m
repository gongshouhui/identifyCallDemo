//
//  YSMessageContentTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/8/6.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMessageContentTableViewCell.h"

@interface YSMessageContentTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation YSMessageContentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"消息通知 : ";
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(18);
        make.top.mas_equalTo(self.mas_top).offset(4);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-4);
        make.width.mas_equalTo(80*kWidthScale);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
//    self.contentLabel.text = @"消息通知水电费广东省发送到发送到道森股份胜多负少胜多负少发送水电费水电费是第三方的双丰收第三方第三方v";
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(8);
        make.top.mas_equalTo(self.mas_top).offset(4);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-4);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    
}

- (void)setMessageContent:(YSFlowListModel *)model andIndexPath:(NSIndexPath *)inde{
    switch (inde.row) {
        case 0:
            self.titleLabel.text = @"消息类型 : ";
            self.contentLabel.text = @"系统消息";
            break;
        case 1:
            self.titleLabel.text = @"发送人 : ";
            self.contentLabel.text = model.sender;
            break;
        case 2:
            self.titleLabel.text = @"发送时间 : ";
        self.contentLabel.text = [YSUtility timestampSwitchTime:model.sendTime andFormatter:@"yyyy-MM-dd hh:mm"];
            break;
        case 3:
            self.titleLabel.text = @"所属系统 : ";
            self.contentLabel.text = model.systemName;
            break;
        case 4:
            self.titleLabel.text = @"消息内容 : ";
            self.contentLabel.text = model.content;
            break;
            
        default:
            break;
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
