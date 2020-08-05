//
//  YSHRMAttendanceOtherTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMAttendanceOtherTableViewCell.h"

@interface YSHRMAttendanceOtherTableViewCell ()




@end

@implementation YSHRMAttendanceOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    self.headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 15;
    [self.contentView addSubview:self.headerImg];
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kHeightScale));
        make.left.mas_equalTo(16*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
    
    self.nameLab = [[UILabel alloc] init];
    self.nameLab.text = @"";
    self.nameLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    self.nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.headerImg.mas_right).offset(14*kWidthScale);
    }];
    
    
    self.hiddenLab = [[UILabel alloc] init];
    self.hiddenLab.text = @"";
    self.hiddenLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    self.hiddenLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:self.hiddenLab];
    [self.hiddenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
 make.left.mas_equalTo(self.nameLab.mas_right).offset(15*kWidthScale);
    }];
    
    self.rightLab = [[UILabel alloc] init];
    self.rightLab.text = @"";
    self.rightLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    self.rightLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    self.rightLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLab];
    [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(107*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);

        make.right.mas_equalTo(self.contentView.mas_right).offset(-16*kWidthScale);
    }];
    
}
//考勤-记录列表
- (void)setAttendListModel:(YSAttendanceModel *)attendListModel {
    if (!_attendListModel) {
        _attendListModel = attendListModel;
    }
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:attendListModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    self.nameLab.text = attendListModel.name;
    self.hiddenLab.hidden = YES;
    self.rightLab.text = attendListModel.typeName;
}


- (void)setAttentTimeModel:(YSAttendanceModel *)attentTimeModel {
    if (!_attentTimeModel) {
        _attentTimeModel = attentTimeModel;
    }
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:attentTimeModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    self.nameLab.text = attentTimeModel.name;
    if ([attentTimeModel.startRwork isEqual:[NSNull null]] || [attentTimeModel.endRwork isEqualToString:@""]) {
        self.hiddenLab.text = @"上班打卡 -";
    }else {
        self.hiddenLab.text = [NSString stringWithFormat:@"上班打卡 %@", attentTimeModel.startRwork];

    }
    self.rightLab.textAlignment = NSTextAlignmentLeft;
    if ([attentTimeModel.endRwork isEqual:[NSNull null]] || [attentTimeModel.endRwork isEqualToString:@""]) {
        self.rightLab.text = @"下班打卡 -";
    }else {
        self.rightLab.text = [NSString stringWithFormat:@"下班打卡 %@", attentTimeModel.endRwork];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
