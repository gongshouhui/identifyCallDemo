//
//  YSChangePasswordViewCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/6.
//
//

#import "YSChangePasswordViewCell.h"

@interface YSChangePasswordViewCell ()

@end

@implementation YSChangePasswordViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _textField = [[UITextField alloc] init];
    _textField.font = [UIFont systemFontOfSize:Multiply(15)];
    _textField.text = @"";
    _textField.secureTextEntry = YES;
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
    }];
}

- (void)setStyle:(NSUInteger)row {
    NSArray *placeholders = @[@"请输入原始密码", @"请输入新密码", @"请确认新密码"];
    _textField.placeholder = placeholders[row];
    _textField.tag = row + 100;
}

@end
