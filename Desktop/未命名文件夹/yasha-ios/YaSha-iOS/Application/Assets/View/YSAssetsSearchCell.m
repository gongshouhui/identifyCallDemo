//
//  YSAssetsSearchCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import "YSAssetsSearchCell.h"

@interface YSAssetsSearchCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation YSAssetsSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(75, 30));
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];
}

- (void)setCellWithIndexPath:(NSIndexPath *)indexPath config:(NSDictionary *)config {
    _nameLabel.text = config[@"name"];
    _textField.placeholder = config[@"placeholder"];
    _textField.tag = indexPath.row;
}

@end
