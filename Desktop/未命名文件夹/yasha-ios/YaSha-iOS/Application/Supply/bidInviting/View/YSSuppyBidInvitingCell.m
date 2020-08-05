//
//  YSSuppyBidInvitingCell.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/2.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSSuppyBidInvitingCell.h"
@interface YSSuppyBidInvitingCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *delayTimeLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@end
@implementation YSSuppyBidInvitingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = kUIColor(51, 51, 51, 1);
    //    self.titleLabel.text = @"万丰高科精品园年产30万套汽车冲压...";
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(-15);
    }];
    

    self.numLabel = [[UILabel alloc]init];
    self.numLabel.font = [UIFont systemFontOfSize:12];
    self.numLabel.textColor = kUIColor(153, 153, 153, 1);
    //    self.nameLabel.text = @"自营.费克峰";
    [self.contentView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.stateLabel.mas_left).mas_equalTo(-15);
    }];
    
    
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    [self.stateLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.stateLabel.textColor = kUIColor(42, 139, 220, 1);
    //    self.timeLabel.text = @"2016.10.01-2017.10.30";
    [self.contentView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
        make.centerY.mas_equalTo(self.numLabel.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.textColor = kGrayColor(51);
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
    }];
    
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.font = [UIFont systemFontOfSize:12];
    self.typeLabel.textColor = kGrayColor(51);
    self.typeLabel.text = @"拟邀标";
    self.typeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numLabel.mas_bottom).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(160);
         make.bottom.mas_equalTo(-15);
    }];
}

- (void)setModel:(YSSupplyBidDetailModel *)model {
    _model = model;
    self.titleLabel.text = model.proName;
    self.numLabel.text = model.code;
    self.stateLabel.text = model.auditStatusStr;
    self.nameLabel.text = model.bidMtrl?model.bidMtrl:@" ";
    self.typeLabel.text = model.flowTypeStr;
    
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
