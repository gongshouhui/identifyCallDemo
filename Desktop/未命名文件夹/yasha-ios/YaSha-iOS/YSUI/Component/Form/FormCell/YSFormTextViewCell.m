//
//  YSFormTextViewCell.m
//  Form
//
//  Created by 方鹏俊 on 2017/11/9.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormTextViewCell.h"

@interface YSFormTextViewCell ()<QMUITextViewDelegate>

@property (nonatomic, strong) QMUITextView *textView;

@end

@implementation YSFormTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _textView = [[QMUITextView alloc] init];
    _textView.font = [UIFont boldSystemFontOfSize:14];
    _textView.delegate = self;
    [self.contentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(200);
    }];
}



- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
    _textView.maximumTextLength = self.cellModel.maximumTextLength;
    _textView.text = self.cellModel.detailTitle;
    _textView.placeholder = self.cellModel.placeholder;
    _textView.placeholderColor = [UIColor colorWithHexString:@"999999"];
    _textView.keyboardType = self.cellModel.keyboardType;
    _textView.editable = !self.cellModel.disable;
}

#pragma mark - QMUITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.markedTextRange == nil) {
        [self.sendValueSubject sendNext:_textView.text];
		
        YSFormCellModel *formCellModel = [[YSFormCellModel alloc] init];
        formCellModel.value = _textView.text;
        self.cellModel.detailTitle = _textView.text;//只有备注是这里有用
        [self.sendFormCellModelSubject sendNext:formCellModel];
    }
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    if (_textView.maximumTextLength != 0) {
        [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:[YSUtility getCurrentViewController].view hideAfterDelay:1.0];
    }
}

@end
