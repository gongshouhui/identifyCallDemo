//
//  YSContactCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactCell.h"

@interface YSContactCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *avatarLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobStationLabel;
@property (nonatomic, strong) UIImageView *excellentImg;//优秀员工

@end

@implementation YSContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = 15*kWidthScale;
    [self.contentView addSubview:self.avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kWidthScale));
    }];
    
    _avatarLabel = [[UILabel alloc] init];
    _avatarLabel.font = UIFontMake(15);
    _avatarLabel.textAlignment = NSTextAlignmentCenter;
    _avatarLabel.textColor = UIColorWhite;
    _avatarLabel.layer.masksToBounds = YES;
    _avatarLabel.layer.cornerRadius = 15*kWidthScale;
    [self.contentView addSubview:self.avatarLabel];
    [_avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kWidthScale));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_avatarImageView.mas_right).offset(10);
        make.height.mas_equalTo(18*kHeightScale);
//        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _jobStationLabel = [[UILabel alloc] init];
    _jobStationLabel.font = [UIFont systemFontOfSize:12];
    _jobStationLabel.textColor = [UIColor lightGrayColor];
    _jobStationLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.jobStationLabel];
    [_jobStationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(12*kHeightScale);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
    }];
    
    //优秀员工
    _excellentImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"excellentMedalImg"]];
    _excellentImg.hidden = YES;
    [self.contentView addSubview:self.excellentImg];
    [self.excellentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.mas_equalTo(0);
    }];
   [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.excellentImg setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.jobStationLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setCellModel:(YSContactModel *)cellModel{
    _cellModel = cellModel;
    _nameLabel.text = _cellModel.name;
    _jobStationLabel.text = _cellModel.jobStation;
    [_avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kWidthScale));
    }];
    NSString *avatarUrlString = [NSString stringWithFormat:@"%@_S.jpg", _cellModel.headImg];
    //[_avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrlString] placeholderImage:UIImageMake(@"头像")];
	[_avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrlString] placeholderImage:UIImageMake(@"头像") options:(SDWebImageRefreshCached)];
 //优秀员工
    if ([cellModel.isExcellentEmployee integerValue] == 1) {
        self.excellentImg.hidden = NO;
        [self.jobStationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_lessThanOrEqualTo(self.nameLabel.mas_right).with.offset(5);
        }];
    }else {
        [self.jobStationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_lessThanOrEqualTo(self.nameLabel.mas_right).with.offset(30);
        }];
        self.excellentImg.hidden = YES;
    }
}

- (void)setDepartmentModel:(YSDepartmentModel *)departmentModel {
    _nameLabel.text = departmentModel.name;
    _jobStationLabel.text = @"";
    [_avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
}

- (void)setPersonModel:(PPPersonModel *)personModel {
    _personModel = personModel;
    _nameLabel.text = _personModel.name;
    _avatarLabel.backgroundColor = UIColorMake(98, 189, 231);
    _avatarLabel.text = [_personModel.name substringToIndex:1];
}

// 在岗模型
- (void)setDeptModel:(YSTeamCompilePostModel *)deptModel {
    if (!_deptModel) {
        _deptModel = deptModel;
    }
    if (deptModel.code) {
        _nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [YSUtility cancelNullData:deptModel.name], [YSUtility cancelNullData:deptModel.code]];

    }else {
        _nameLabel.text = [NSString stringWithFormat:@"%@", [YSUtility cancelNullData:deptModel.name]];

    }
    _jobStationLabel.text = @"";
    [_avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
}

@end
