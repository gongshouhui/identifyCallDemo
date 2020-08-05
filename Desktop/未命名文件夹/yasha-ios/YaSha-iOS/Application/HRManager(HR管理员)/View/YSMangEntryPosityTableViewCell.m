//
//  YSMangEntryPosityTableViewCell.m
//  YaSha-iOS
//
//  Created by GZl on 2019/4/1.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMangEntryPosityTableViewCell.h"
#import "YSContactModel.h"

@interface YSMangEntryPosityTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *jobLab;
@property (nonatomic, strong) UILabel *timeLab;


@end


@implementation YSMangEntryPosityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    //头像
    _headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _headerImg.layer.masksToBounds = YES;
    _headerImg.layer.cornerRadius = 15;
    [self.contentView addSubview:_headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kHeightScale));
        make.left.mas_equalTo(16*kWidthScale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    // 名字
    _nameLab = [[UILabel alloc] init];
    _nameLab.text = @"";
    _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _nameLab.textColor = kUIColor(0, 0, 0, 0.8);
    [self.contentView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_headerImg.mas_right).offset(21*kWidthScale);
    }];
    // 职位
    _jobLab = [[UILabel alloc] init];
    _jobLab.text = @"产品工程师八个字多了";
    _jobLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _jobLab.textColor = kUIColor(0, 0, 0, 0.8);
    [self.contentView addSubview:_jobLab];
    [_jobLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(126*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_nameLab.mas_right).offset(17*kWidthScale);
    }];
    // 入职时间
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"2018-23-12";
    _timeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
    _timeLab.textColor = kUIColor(0, 0, 0, 0.8);
    [self.contentView addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85*kWidthScale, 20*kHeightScale));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_jobLab.mas_right).offset(16*kWidthScale);
    }];
    
}

// 团队编制 编制详情
- (void)setCompileModel:(YSTeamCompilePostModel *)compileModel {
    if (!_compileModel) {
        _compileModel = compileModel;
    }
    
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:compileModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = compileModel.name;
    _jobLab.text = compileModel.postname;
    _timeLab.text = compileModel.positionName;
    [_timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40*kWidthScale, 20*kHeightScale));
 
        make.left.mas_equalTo(_jobLab.mas_right).offset(44*kWidthScale);
    }];
}
// 在岗
- (void)setWorkModel:(YSTeamCompilePostModel *)workModel {
    if (!_workModel) {
        _workModel = workModel;
    }
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:workModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = workModel.name;
    _jobLab.text = workModel.postName;
    _timeLab.text = workModel.jobgradeCode;
    [_jobLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLab.mas_right).offset(44*kWidthScale);

    }];
    [_timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40*kWidthScale, 20*kHeightScale));
        make.left.mas_equalTo(_jobLab.mas_right).offset(44*kWidthScale);
    }];
    
}
// 入职
- (void)setPostEntyModel:(YSTeamCompilePostModel *)postEntyModel{
    if (!_postEntyModel) {
        _postEntyModel = postEntyModel;
    }
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:postEntyModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = postEntyModel.name;
    _jobLab.text = postEntyModel.postname;
    _timeLab.text = postEntyModel.enterTimeStr;
    
}

// 离职
- (void)setPostLeaveModel:(YSTeamCompilePostModel *)postLeaveModel {
    if (!_postLeaveModel) {
        _postLeaveModel = postLeaveModel;
    }
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:postLeaveModel.headImage] placeholderImage:[UIImage imageNamed:@"managerHeaderBackIHG"]];
    _nameLab.text = postLeaveModel.name;
    _jobLab.text = postLeaveModel.postname;
    _timeLab.text = postLeaveModel.leaveTimeStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
