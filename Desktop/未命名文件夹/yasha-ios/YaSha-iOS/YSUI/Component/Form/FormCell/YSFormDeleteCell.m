//
//  YSFormDeleteCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/24.
//

#import "YSFormDeleteCell.h"

@interface YSFormDeleteCell ()

@property (nonatomic, strong) QMUIButton *editButton;
@property (nonatomic, strong) QMUIButton *deleteButton;

@end

@implementation YSFormDeleteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = kThemeColor;
    
    _editButton = [[QMUIButton alloc] init];
    [_editButton setImage:UIImageMake(@"ic_ems_apply_edit") forState:UIControlStateNormal];
    YSWeak;
    [[_editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.sendEditSectionSubject sendNext:weakSelf.cellModel];
    }];
    [self.contentView addSubview:self.editButton];
    
    _deleteButton = [[QMUIButton alloc] init];
    [_deleteButton setImage:UIImageMake(@"ic_ems_apply_delete") forState:UIControlStateNormal];
    [[_deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.sendDeleteSectionSubject sendNext:weakSelf.cellModel];
    }];
    [self.contentView addSubview:self.deleteButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kWidthScale));
    }];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(_deleteButton.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kWidthScale));
    }];
}

@end
