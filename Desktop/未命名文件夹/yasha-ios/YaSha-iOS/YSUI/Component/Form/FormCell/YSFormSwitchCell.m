//
//  YSFormSwitchCell.m
//  Form
//
//  Created by 方鹏俊 on 2017/11/9.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormSwitchCell.h"

@interface YSFormSwitchCell ()

@property (nonatomic, strong) UISwitch *cellSwitch;

@end

@implementation YSFormSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    
    _cellSwitch = [[UISwitch alloc] init];
    [self.contentView addSubview:_cellSwitch];
    YSWeak;
    [[_cellSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        [weakSelf.sendValueSubject sendNext:weakSelf.cellSwitch.isOn ? @"1" : @"0"];
        YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
        formCellModel.value = weakSelf.cellSwitch.isOn ? @"1" : @"0";
        formCellModel.indexPath = weakSelf.cellModel.indexPath;
        weakSelf.cellModel.switchStatusStr = weakSelf.cellSwitch.isOn ? @"是" : @"否";//记录状态
        weakSelf.cellModel.switchStatus = weakSelf.cellSwitch.isOn;//记录状态
        [weakSelf.sendFormCellModelSubject sendNext:formCellModel];
    }];
    [_cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
}

- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
    [_cellSwitch setOn:self.cellModel.switchStatus];
}
- (void)dealloc {
    DLog(@"switchcell 释放");
}
@end
