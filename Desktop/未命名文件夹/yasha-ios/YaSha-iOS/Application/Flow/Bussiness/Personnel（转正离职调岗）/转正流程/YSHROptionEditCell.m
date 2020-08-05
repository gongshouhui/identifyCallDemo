//
//  YSHROptionEditCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2020/1/6.
//  Copyright © 2020 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHROptionEditCell.h"
@interface YSHROptionEditCell()<QMUITextViewDelegate>
@property (nonatomic,strong) UILabel *titleLb;
@end
@implementation YSHROptionEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self initUI];
	}
	return self;
}
- (void)initUI {
	UILabel *titleLb = [[UILabel alloc]initWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"#111A34"]];
	self.titleLb = titleLb;
	titleLb.text = @"工作能力(30分)";
	[self.contentView addSubview:titleLb];
	[titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.top.mas_equalTo(10);
	}];
	
	self.scoreTF = [[UITextField alloc]init];
	self.scoreTF.textAlignment = NSTextAlignmentRight;
	self.scoreTF.keyboardType = UIKeyboardTypeNumberPad;
	self.scoreTF.placeholder = @"请打分";
	NSMutableAttributedString *placeholderStr = [[NSMutableAttributedString alloc]initWithString:self.scoreTF.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#C5CAD5"]}];
	self.scoreTF.attributedPlaceholder = placeholderStr;
	[self.contentView addSubview:self.scoreTF];
	[self.scoreTF mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(15);
		make.right.mas_equalTo(-15);
		make.width.mas_equalTo(100);
	}];
	YSWeak;
	[[self.scoreTF rac_signalForControlEvents:(UIControlEventEditingChanged)] subscribeNext:^(UITextField *textField) {
		if (weakSelf.opinionBlock) {
			weakSelf.opinionBlock(textField.text,weakSelf.contentTV.text);
		}
	}];
	
	UIView *lineView = [[UIView alloc]init];
	lineView.backgroundColor = [UIColor colorWithHexString:@"#E2E4EA"];
	[self.contentView addSubview:lineView];
	[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(-15);
		make.height.mas_equalTo(1);
		make.top.mas_equalTo(titleLb.mas_bottom).mas_equalTo(15);
	}];
	
	self.contentTV = [[QMUITextView alloc]init];
	self.contentTV.delegate = self;
	self.contentTV.placeholder = @"请输入描述内容";
	[self.contentView addSubview:self.contentTV];
	[self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(5);
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(-15);
		make.height.mas_equalTo(100);
	}];
	
	
	UIView *bgView = [[UIView alloc]init];
	bgView.backgroundColor = kGrayColor(245);
	[self.contentView addSubview:bgView];
	[bgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(0);
		make.top.mas_equalTo(_contentTV.mas_bottom);
		make.height.mas_equalTo(15);
		make.bottom.mas_equalTo(0);
	}];
	
}
- (void)setOpinionModel:(YSOpinionModel *)opinionModel {
	_opinionModel = opinionModel;
	self.titleLb.text = opinionModel.title;
	self.scoreTF.text = opinionModel.score;
	self.contentTV.text = opinionModel.opinion;
	
	
}
#pragma mark - QMUITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (self.opinionBlock) {
		self.opinionBlock(self.scoreTF.text, textView.text);
	}
}

- (BOOL)textViewShouldReturn:(QMUITextView *)textView {
	if (textView.text.length < 50) {
		[QMUITips showInfo:@"描述不能少于50字" inView:self hideAfterDelay:2.0];
	}
	return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
