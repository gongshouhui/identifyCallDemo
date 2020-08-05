//
//  YSContactSelectCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/9.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactSelectCell.h"

@interface YSContactSelectCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobStationLabel;
@property (nonatomic, strong) UIImageView *accessViewImg;

@end

@implementation YSContactSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _selectButton = [[QMUIButton alloc] init];
    [_selectButton setImage:[UIImage imageNamed:@"选择项目-未选"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"选择项目-选中"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectButton];
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kWidthScale));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_selectButton.mas_right).offset(10);
        make.height.mas_equalTo(16*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
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
    
    _accessViewImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"向右箭头"]];
    _accessViewImg.hidden = YES;
    [self addSubview:_accessViewImg];
    [_accessViewImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(8*kWidthScale, 15*kHeightScale));
    }];
}

- (void)setCellModel:(YSContactModel *)cellModel {
    _cellModel = cellModel;
    _nameLabel.text = _cellModel.name;
    _jobStationLabel.text = _cellModel.jobStation;
    _selectButton.selected = cellModel.isSelected;
//    [_selectButton setImage:UIImageMake(cellModel.isSelected ? @"选择项目-选中" : @"选择项目-未选") forState:UIControlStateNormal];
}

- (void)setDepartmentModel:(YSDepartmentModel *)departmentModel {
    _nameLabel.text = departmentModel.name;
    _selectButton.selected = departmentModel.isSelected;
//    [_selectButton setImage:UIImageMake(departmentModel.isSelected ? @"选择项目-选中" : @"选择项目-未选") forState:UIControlStateNormal];
}

// 本地数据-部门选择树
- (void)setSelectDepartModel:(YSDepartmentModel *)selectDepartModel {
    _selectDepartModel = selectDepartModel;
    _nameLabel.text = selectDepartModel.name;
    _accessViewImg.hidden = NO;
    _selectButton.selected = selectDepartModel.isSelected;
    //    [_selectButton setImage:UIImageMake(departmentModel.isSelected ? @"选择项目-选中" : @"选择项目-未选") forState:UIControlStateNormal];
}

@end
