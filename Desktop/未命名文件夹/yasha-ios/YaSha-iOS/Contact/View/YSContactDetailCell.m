//
//  YSContactDetailCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/24.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactDetailCell.h"

@interface YSContactDetailCell ()

@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation YSContactDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = UIFontMake(16);
    [self addSubview:self.nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(18*kHeightScale);
        make.width.mas_equalTo(100*kWidthScale);
    }];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.numberOfLines = 0;
    _detailLabel.font = UIFontMake(16);
    [self addSubview:self.detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right).mas_equalTo(5);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)setRowDict:(NSDictionary *)rowDict {
    _rowDict = rowDict;
    _nameLabel.text = _rowDict[@"name"];
    _detailLabel.text = _rowDict[@"detail"];
    _detailLabel.textColor = [_rowDict[@"type"] isEqual:@"phone"] ? kThemeColor : UIColorBlack;
    
    //
    if (!_detailLabel.text.length) {
       _detailLabel.text = @"   ";
    }
}

@end
