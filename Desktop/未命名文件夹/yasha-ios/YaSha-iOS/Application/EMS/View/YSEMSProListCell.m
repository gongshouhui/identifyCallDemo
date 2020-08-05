//
//  YSEMSProListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/21.
//

#import "YSEMSProListCell.h"

@interface YSEMSProListCell ()

@property (nonatomic, strong) UILabel *proNameLabel;
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation YSEMSProListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    _proNameLabel = [[UILabel alloc] init];
    _proNameLabel.font = [UIFont systemFontOfSize:16];
    _proNameLabel.numberOfLines = 0;
    [self.contentView addSubview:_proNameLabel];
    [_proNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];

}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    _selectedButton.selected = selected;
//    _cellModel.isSelected = selected;//选中状态记录model里
//}
- (void)setCellModel:(YSEMSProListModel *)cellModel {
    _cellModel = cellModel;
    _proNameLabel.text = _cellModel.name;
//    _selectedButton.selected = _cellModel.isSelected;
}

@end
