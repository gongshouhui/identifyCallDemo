//
//  YSReportHeaderView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/7/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSReportHeaderView.h"

@implementation YSReportHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		[self initUI];
	}
	return self;
}
- (void)initUI {
	self.backgroundColor = [UIColor whiteColor];
	UIView *sepView = [[UIView alloc]init];
	sepView.backgroundColor = [UIColor colorWithHexString:@"#F9FAFB"];
	[self addSubview:sepView];
	[sepView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.mas_equalTo(0);
		make.height.mas_equalTo(15);
	}];
	UILabel *label = [[UILabel alloc] init];
	
	label.textColor = [UIColor colorWithHexString:@"#111A34"];
	label.font = [UIFont systemFontOfSize:16];
	NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:@"举报内容*"];
	[attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[@"举报内容*" rangeOfString:@"*"]];
	label.attributedText = attstr;
	[self addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.top.mas_equalTo(sepView.mas_bottom).mas_equalTo(15);
	}];
	
	self.textView = [[QMUITextView alloc]init];
	self.textView.placeholder = @"请填写举报内容";
	self.textView.font = [UIFont systemFontOfSize:14];
	self.textView.placeholderColor = [UIColor colorWithHexString:@"#C5CAD5"];
	[self addSubview:self.textView];
	[self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(label.mas_bottom).mas_equalTo(15);
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(-15);
		make.bottom.mas_equalTo(0);
	}];
}
@end
