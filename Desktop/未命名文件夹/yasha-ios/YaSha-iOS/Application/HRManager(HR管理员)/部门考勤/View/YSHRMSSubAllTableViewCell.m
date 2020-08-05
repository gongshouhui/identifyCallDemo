//
//  YSHRMSSubAllTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/9.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMSSubAllTableViewCell.h"

@interface YSHRMSSubAllTableViewCell ()



@end

@implementation YSHRMSSubAllTableViewCell

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
    self.headerImg.layer.cornerRadius = 15;
    self.headerImg.layer.masksToBounds = YES;
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
        make.size.mas_equalTo(CGSizeMake(46*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.headerImg.mas_right).offset(21*kWidthScale);
    }];
    
    
    self.typeLab = [[UILabel alloc] init];
    self.typeLab.text = @"";
    self.typeLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    self.typeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:self.typeLab];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(29*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(22*kWidthScale);
    }];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.text = @"";
    self.timeLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    self.timeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(99*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.typeLab.mas_right).offset(25*kWidthScale);
    }];
    
    self.hoursLab = [[UILabel alloc] init];
    self.hoursLab.text = @"";
    self.hoursLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    self.hoursLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:self.hoursLab];
    [self.hoursLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(46*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.timeLab.mas_right).offset(26*kWidthScale);
    }];
    
}

// 请假
- (void)setLeaveModel:(YSSummaryModel *)leaveModel {
    if (!_leaveModel) {
        _leaveModel = leaveModel;
    }
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:leaveModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = [YSUtility cancelNullData:leaveModel.name];
    _typeLab.text = [YSUtility cancelNullData:leaveModel.subTypeStr];
    _timeLab.text = [YSUtility cancelNullData:leaveModel.time];
    _hoursLab.text = [NSString stringWithFormat:@"%@d", [YSUtility cancelNullData:leaveModel.day].length?[YSUtility cancelNullData:leaveModel.day] : @"0"];
}

// 迟到早退
- (void)setLateModel:(YSSummaryModel *)lateModel {
    if (!_lateModel) {
        _lateModel = lateModel;
    }
    [_typeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLab.mas_right).offset(40*kWidthScale);
    }];
    [_timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(43*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.typeLab.mas_right).offset(43*kWidthScale);
    }];
    [_hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(43*kWidthScale);
    }];
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:lateModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = [YSUtility cancelNullData:lateModel.name];
    _typeLab.text = [YSUtility cancelNullData:lateModel.typeName];
    _timeLab.text = [YSUtility cancelNullData:lateModel.sdate];
    if ([lateModel.typeTime floatValue] > 60.0) {
        _hoursLab.text = [NSString stringWithFormat:@"%.0fh%.0fm", floorf([lateModel.typeTime floatValue]/60), fmod([lateModel.typeTime doubleValue], 60.0)];
    }else {
        _hoursLab.text = [NSString stringWithFormat:@"%@m", lateModel.typeTime ? lateModel.typeTime : @"0"];
    }
}

// 因公外出
- (void)setOutWarkModel:(YSSummaryModel *)outWarkModel {
    if (!_outWarkModel) {
        _outWarkModel = outWarkModel;
    }
    _typeLab.hidden = YES;
    [_timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(101*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(48*kWidthScale);
    }];
    [_hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(47*kWidthScale);
    }];
    
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:outWarkModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = [YSUtility cancelNullData:outWarkModel.name];
    _timeLab.text = [YSUtility cancelNullData:outWarkModel.time];
    _hoursLab.text = [NSString stringWithFormat:@"%@d", [YSUtility cancelNullData:outWarkModel.day].length? [YSUtility cancelNullData:outWarkModel.day] : @"0"];
}
// 旷工
- (void)setAbsenteeisModel:(YSSummaryModel *)absenteeisModel {
    if (!_absenteeisModel) {
        _absenteeisModel = absenteeisModel;
    }
    _typeLab.hidden = YES;
    [_timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(101*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(48*kWidthScale);
    }];
    [_hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(47*kWidthScale);
    }];
    
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:absenteeisModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = [YSUtility cancelNullData:absenteeisModel.name];
    _timeLab.text = [YSUtility cancelNullData:absenteeisModel.absenteeismTime];
    _hoursLab.text = [NSString stringWithFormat:@"%@d", [YSUtility cancelNullData:absenteeisModel.absenteeismDay].length ? [YSUtility cancelNullData:absenteeisModel.absenteeismDay] : @"0"];
}
// 加班
- (void)setWorkModel:(YSSummaryModel *)workModel {
    if (!_workModel) {
        _workModel = workModel;
    }
    _typeLab.hidden = YES;
//    [_timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(101*kWidthScale, 20*kHeightScale));
//        make.centerY.mas_equalTo(0);
//        make.left.mas_equalTo(self.nameLab.mas_right).offset(48*kWidthScale);
//    }];
    [_timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(195*kWidthScale, 20*kHeightScale));
        make.left.mas_equalTo(self.nameLab.mas_left).offset(97*kWidthScale);
        make.centerY.mas_equalTo(0);
    }];
//    [_hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.timeLab.mas_right).offset(47*kWidthScale);
//    }];
    
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:workModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = [YSUtility cancelNullData:workModel.name];
    _timeLab.text = [YSUtility cancelNullData:workModel.time];
    _hoursLab.hidden = YES;
//    _hoursLab.text = [NSString stringWithFormat:@"%@h", [YSUtility cancelNullData:workModel.hour].length? [YSUtility cancelNullData:workModel.hour] : @"0"];
}
// 其他类型的cell 出差
- (void)setOtherModel:(YSSummaryModel *)otherModel {
    if (!_otherModel) {
        _otherModel = otherModel;
    }
    _typeLab.hidden = YES;
    [_timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(101*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(48*kWidthScale);
    }];
    [_hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(47*kWidthScale);
    }];
    
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:otherModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = [YSUtility cancelNullData:otherModel.name];
    _timeLab.text = [YSUtility cancelNullData:otherModel.time];
    _hoursLab.text = [NSString stringWithFormat:@"%@d", [YSUtility cancelNullData:otherModel.day].length? [YSUtility cancelNullData:otherModel.day] : @"0"];
}
#pragma mark--部门绩效
- (void)setPerforModel:(YSTeamCompilePostModel *)perforModel {
    if (!_perforModel) {
        _perforModel = perforModel;
    }
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:perforModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _typeLab.hidden = YES;
    [_timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(65*kWidthScale);
    }];
    [_hoursLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55*kWidthScale, 20*kHeightScale));
 
        make.left.mas_equalTo(self.timeLab.mas_right).offset(64*kWidthScale);
    }];
    _nameLab.text = [YSUtility cancelNullData:perforModel.name];
    _timeLab.text = [NSString stringWithFormat:@"半年度: %@", [YSUtility cancelNullData:perforModel.halfYearPer]];
    _hoursLab.text = [NSString stringWithFormat:@"年度: %@", [YSUtility cancelNullData:perforModel.yearPer]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
