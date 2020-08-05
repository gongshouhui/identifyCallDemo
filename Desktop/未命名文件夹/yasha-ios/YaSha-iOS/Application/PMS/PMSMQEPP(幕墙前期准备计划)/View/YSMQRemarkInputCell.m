//
//  YSMQRemarkInputCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMQRemarkInputCell.h"
@interface YSMQRemarkInputCell()<QMUITextViewDelegate>
@property (nonatomic,strong) QMUITextView *textView;
@end
@implementation YSMQRemarkInputCell
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
- (void)setPlaceHolder:(NSString *)placeHolder {
    _textView.placeholder = placeHolder;
}
- (void)setDataForCell:(YSMQCellModel *)model {
    self.placeHolder = model.title;
    self.textView.text = model.content;
}

#pragma mark - QMUITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.markedTextRange == nil) {
        if (self.remarkBlock) {
            self.remarkBlock(textView.text);
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
