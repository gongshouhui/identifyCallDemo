//
//  YSContentTextCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/23.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContentTextCell.h"
@interface YSContentTextCell()

@end
@implementation YSContentTextCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.label = [[UILabel alloc]init];
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textColor = kGrayColor(153);
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    
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
