//
//  YSHRMTCompileTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRMTCompileTableViewCell.h"

@interface YSHRMTCompileTableViewCell ()

@property (nonatomic, strong) UILabel *companyLab;
@property (nonatomic, strong) UILabel *deptLab;
@property (nonatomic, strong) UILabel *jobLab;
@property (nonatomic, strong) UILabel *compileLab;


@end

@implementation YSHRMTCompileTableViewCell

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
    
    // 公司
    _companyLab = [[UILabel alloc] init];
    _companyLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _companyLab.text = @"亚厦集团的测试";
    _companyLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_companyLab];
    [_companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(16*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 20*kHeightScale));
    }];
    
    // 部门
    _deptLab = [[UILabel alloc] init];
    _deptLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _deptLab.text = @"信息部门的测试";
    _deptLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_deptLab];
    [_deptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_companyLab.mas_right).offset(19*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 20*kHeightScale));
    }];
    
    // 岗位
    _jobLab = [[UILabel alloc] init];
    _jobLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _jobLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_jobLab];
    [_jobLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_deptLab.mas_right).offset(19*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(71*kWidthScale, 20*kHeightScale));
    }];
    
    // 编制/现有
    _compileLab = [[UILabel alloc] init];
    _compileLab.textColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
    _compileLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    [self.contentView addSubview:_compileLab];
    [_compileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_jobLab.mas_right).offset(20*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(70*kWidthScale, 20*kHeightScale));
    }];
}

// 编制列表
- (void)setComplieModel:(YSTeamCompilePostModel *)complieModel {
    if (!_complieModel) {
        _complieModel = complieModel;
    }
    _companyLab.text = complieModel.orgName;
    _deptLab.text = complieModel.deptName;
    _jobLab.text = complieModel.postName;
    _compileLab.text = [NSString stringWithFormat:@"%ld/%ld", complieModel.totalNum, complieModel.countPsndoc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
