//
//  YSHRMSummaryTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMSummaryTableViewCell.h"

@interface YSHRMSummaryTableViewCell ()

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *proportionLab;


@end

@implementation YSHRMSummaryTableViewCell

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
    _nameLab = [[UILabel alloc] init];
    _nameLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _nameLab.text = @"";
    _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(123*kWidthScale, 20*kHeightScale));
        make.left.mas_equalTo(16*kWidthScale);
    }];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _timeLab.text = @"0.0h";
    _timeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(56*kWidthScale, 20*kHeightScale));
        make.left.mas_equalTo(_nameLab.mas_right).offset(65*kWidthScale);
    }];
    
    _proportionLab = [[UILabel alloc] init];
    _proportionLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _proportionLab.text = @"0.0%";
    _proportionLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_proportionLab];
    [_proportionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);        make.left.mas_equalTo(_timeLab.mas_right).offset(53*kWidthScale);
    }];
}

- (void)setSummaryModel:(YSHRMTSummaryModel *)summaryModel {
    if (!_summaryModel) {
        _summaryModel = summaryModel;
    }
    _nameLab.text = [YSUtility cancelNullData:summaryModel.name];
    if ([summaryModel.avgWorkHour isEqual:[NSNull null]] || summaryModel.avgWorkHour == nil) {
        _timeLab.text = @"";

    }else {
        if (summaryModel.avgWorkHour.length > 5) {
            _timeLab.text = [NSString stringWithFormat:@"%@h", [[YSUtility cancelNullData:summaryModel.avgWorkHour] substringToIndex:5]];
        }else {
            _timeLab.text = [NSString stringWithFormat:@"%@h", [YSUtility cancelNullData:summaryModel.avgWorkHour]];
        }
    }
    
    if ([summaryModel.totalAtdRate isEqual:[NSNull null]] || summaryModel.totalAtdRate == nil) {
        _proportionLab.text = @"";

    }else {
        if (summaryModel.totalAtdRate.length > 5) {
            _proportionLab.text = [NSString stringWithFormat:@"%@%%", [[YSUtility cancelNullData:summaryModel.totalAtdRate] substringToIndex:5]];

        }else {
            _proportionLab.text = [NSString stringWithFormat:@"%@%%", [YSUtility cancelNullData:summaryModel.totalAtdRate]];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
