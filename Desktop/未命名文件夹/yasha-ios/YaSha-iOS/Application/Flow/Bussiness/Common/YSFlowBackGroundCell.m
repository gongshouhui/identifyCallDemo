//
//  YSFlowBackGroundCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/15.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowBackGroundCell.h"

@implementation YSFlowBackGroundCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, kSCREEN_WIDTH);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = kGrayColor(249);
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    _lableNameLabel = [[UILabel alloc] init];
    _lableNameLabel.font = [UIFont systemFontOfSize:12];
    _lableNameLabel.numberOfLines = 0;
    [self.contentView addSubview:_lableNameLabel];
    [_lableNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.width.mas_equalTo(110*kWidthScale);
        make.bottom.mas_equalTo(-12);
    }];
    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.numberOfLines = 0;
    _valueLabel.font = [UIFont boldSystemFontOfSize:12];
    _valueLabel.textAlignment = NSTextAlignmentRight;
    _valueLabel.textColor = kGrayColor(51);
    [self.contentView addSubview:_valueLabel];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(_lableNameLabel.mas_right).mas_equalTo(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
    }];
    
}

@end
