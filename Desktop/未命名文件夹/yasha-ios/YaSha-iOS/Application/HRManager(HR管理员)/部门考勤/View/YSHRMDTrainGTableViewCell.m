//
//  YSHRMDTrainGTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMDTrainGTableViewCell.h"

@interface YSHRMDTrainGTableViewCell ()

@property (nonatomic, strong) UILabel *deptLab;
@property (nonatomic, strong) UILabel *planLab;
@property (nonatomic, strong) UILabel *hoursLab;
@property (nonatomic, strong) UILabel *timeLab;


@end

@implementation YSHRMDTrainGTableViewCell

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
    _deptLab = [[UILabel alloc] init];
    _deptLab.text = @"信息部项目产品部门";
    _deptLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _deptLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_deptLab];
    [_deptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(104*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
    }];
    
    // 计划
    _planLab = [[UILabel alloc] init];
    _planLab.text = @"内";
    _planLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _planLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_planLab];
    [_planLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_deptLab.mas_right).offset(29*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(18*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
    }];
    
    //学时
    _hoursLab = [[UILabel alloc] init];
    _hoursLab.text = @"10.5";
    _hoursLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _hoursLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_hoursLab];
    [_hoursLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_planLab.mas_right).offset(43*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
    }];
    
    // 开课时间
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"2019-12-12";
    _timeLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _timeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hoursLab.mas_right).offset(28*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(96*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(0);
    }];

    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self.contentView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(16*kWidthScale);
        make.right.mas_equalTo(-16*kWidthScale);
        make.height.mas_equalTo(1);
    }];
}

- (void)setDetailModel:(TrainingDetailModel *)detailModel {
    if (!_detailModel) {
        _detailModel = detailModel;
    }
    _deptLab.text = detailModel.courseName;
    _planLab.text = detailModel.setupFlag;
    _hoursLab.text = detailModel.classHour;
    _timeLab.text = detailModel.lectureTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
