//
//  YSMQTextFieldCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/31.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQTextFieldCell.h"
@interface YSMQTextFieldCell()<UITextFieldDelegate>


@end
@implementation YSMQTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textFieldBlock) {
        if ([textField.text doubleValue] > 100) {
            textField.text = @"100";
        }
        if ([textField.text doubleValue] < 0) {
            textField.text = @"0";
        }
        self.textFieldBlock(textField.text);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
