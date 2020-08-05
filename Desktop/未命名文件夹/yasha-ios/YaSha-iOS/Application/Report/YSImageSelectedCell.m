//
//  YSImageSelectedCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/7/23.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSImageSelectedCell.h"
@interface YSImageSelectedCell()
@property (nonatomic, strong) UIImageView *photoImageView;
@end
@implementation YSImageSelectedCell
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.photoImageView = [[UIImageView alloc]init];
		self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.photoImageView.layer.masksToBounds = YES;
		self.photoImageView.layer.borderWidth = 1;
		self.photoImageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
		[self.contentView addSubview:self.photoImageView];
		[self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.mas_equalTo(0);
		}];
		
		self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
		[self.contentView addSubview:self.closeBtn];
		[self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(-5);
			make.right.mas_equalTo(5);
			make.width.height.mas_equalTo(30);
		}];
	}
	return self;
}
- (void)setImage:(UIImage *)image {
	_image = image;
	self.photoImageView.image = image;
}

@end
