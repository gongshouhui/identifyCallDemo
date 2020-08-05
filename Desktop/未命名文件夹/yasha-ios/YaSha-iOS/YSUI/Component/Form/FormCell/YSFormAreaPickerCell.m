//
//  YSFormAreaPickerCell.m
//  Form
//
//  Created by 方鹏俊 on 2017/11/20.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormAreaPickerCell.h"
#import "YSAreaPickerView.h"

@interface YSFormAreaPickerCell ()

@property (nonatomic, strong) YSAreaPickerView *areaPickerView;

@end

@implementation YSFormAreaPickerCell

- (YSAreaPickerView *)areaPickerView {
    if (!_areaPickerView) {
        _areaPickerView = [[YSAreaPickerView alloc] init];
    }
    return _areaPickerView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    [self addDetailLabel];
    
    self.textField = [[UITextField alloc] init];
    [self.contentView addSubview:self.textField];
    self.textField.inputView = self.areaPickerView;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    YSWeak;
    [self.areaPickerView.sendAddressSubject subscribeNext:^(YSAddressModel *addressModel) {
        YSStrong;
        [strongSelf.textField resignFirstResponder];
        switch (strongSelf.cellModel.areaPickerType) {
            case YSAreaPickerProvince:
            {
                strongSelf.detailLabel.text = [NSString stringWithFormat:@"%@", addressModel.province];
                break;
            }
            case YSAreaPickerCity:
            {
                strongSelf.detailLabel.text = [NSString stringWithFormat:@"%@-%@", addressModel.province, addressModel.city];
                break;
            }
            case YSAreaPickerArea:
            {
                strongSelf.detailLabel.text = [NSString stringWithFormat:@"%@-%@-%@", addressModel.province, addressModel.city, addressModel.area];
                break;
            }
        }
        strongSelf.cellModel.detailTitle = strongSelf.detailLabel.text;
        strongSelf.cellModel.addressModel = addressModel;
        [strongSelf.sendAreaSubject sendNext:addressModel];//不知道为什么rac传不过去
    }];
    [self.areaPickerView.sendCancelSubject subscribeNext:^(id x) {
        [weakSelf.textField resignFirstResponder];
    }];
}

- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
    if (cellModel.disable == YES) {//不可编辑时
        self.textField.userInteractionEnabled = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) return;
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.textField becomeFirstResponder];
        self.areaPickerView.areaPickerType = self.cellModel.areaPickerType;
        self.selected = NO;
    }
}

@end
