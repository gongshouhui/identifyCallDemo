//
//  YSFormTextFieldCell.m
//  Form
//
//  Created by 方鹏俊 on 2017/11/9.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormTextFieldCell.h"

@interface YSFormTextFieldCell ()<UITextFieldDelegate>

@end

@implementation YSFormTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    self.textField.font = [UIFont boldSystemFontOfSize:16];
    self.textField.textColor = [UIColor colorWithHexString:flowRightColor];
    YSWeak;
    [[self.textField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        YSStrong;
        strongSelf.cellModel.detailTitle = strongSelf.textField.text;//数据记录在model里
        [strongSelf.sendValueSubject sendNext:strongSelf.textField.text];
        YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
        formCellModel.value = strongSelf.textField.text;
        formCellModel.indexPath = strongSelf.cellModel.indexPath;
        [strongSelf.sendFormCellModelSubject sendNext:formCellModel];
        if (strongSelf.cellModel.countLimited != 0) {
            if (![YSUtility textField:strongSelf.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"" limited:1]) {
                strongSelf.textField.text = [strongSelf.textField.text substringWithRange:NSMakeRange(0, strongSelf.textField.text.length-1)];
            }
        }
    }];
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(17*kHeightScale);
        make.width.mas_equalTo(kSCREEN_WIDTH/3.0*2.0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) return;
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.textField becomeFirstResponder];
    }
}

- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
//    if (cellModel.editable == 0) {
//        self.textField.enabled = NO;
//    }else {
//        self.textField.enabled = YES;
//    }
    self.textField.placeholder = self.cellModel.placeholder;
    self.textField.keyboardType = self.cellModel.keyboardType;
    self.textField.text = self.cellModel.detailTitle;
    self.textField.userInteractionEnabled = !cellModel.disable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    switch (self.cellModel.checkoutType) {
        case YSCheckoutPhoneNumber:
        {
            if (![YSUtility isPhomeNumber:textField.text]) {
                [QMUITips showError:@"请输入正确的手机号" inView:self.superview hideAfterDelay:1.0];
            }
            break;
        }
        case YSCheckoutEmail:
        {
            if (![YSUtility isEmail:textField.text]) {
                [QMUITips showError:@"请输入正确的邮箱" inView:self.superview hideAfterDelay:1.0];
            }
            break;
        }
        case YSCheckoutID:
        {
            if (![YSUtility isIDCode:textField.text]) {
                [QMUITips showError:@"请输入正确的身份证号" inView:self.superview hideAfterDelay:1.0];
            }
            break;
        }
        default:
            break;
    }
    
    return YES;
}
- (void)dealloc {
   
}
@end
