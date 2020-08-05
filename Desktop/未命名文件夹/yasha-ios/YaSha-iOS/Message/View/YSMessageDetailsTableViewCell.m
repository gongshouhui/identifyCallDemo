//
//  YSMessageDetailsTableViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/6/22.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSMessageDetailsTableViewCell.h"

@implementation YSMessageDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"消息通知送快递开始发生反过来说浪费粮食分类看看里的菇凉深两个";
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = kGrayColor(3);
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(18);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-18);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
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
