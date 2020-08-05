//
//  YSFlowEmptyCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowEmptyCell.h"

@implementation YSFlowEmptyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier background:(UIColor *)color{
	if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		   self.selectionStyle = UITableViewCellSelectionStyleNone;
		   self.backgroundColor = color;
		   UILabel *label = [[UILabel alloc] init];
		   label.font = [UIFont systemFontOfSize:14];
		   label.numberOfLines = 0;
		   [self.contentView addSubview:label];
		   [label mas_makeConstraints:^(MASConstraintMaker *make) {
			   make.top.mas_equalTo(self.contentView.mas_top).offset(0);
			   make.left.mas_equalTo(self.contentView.mas_left).offset(20);
			   make.height.mas_equalTo(10);
			   make.bottom.mas_equalTo(0);
		   }];
	   }
	 return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
