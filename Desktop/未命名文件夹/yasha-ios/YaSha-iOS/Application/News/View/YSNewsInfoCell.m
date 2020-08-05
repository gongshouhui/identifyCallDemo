//
//  YSNewsInfoCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/30.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSNewsInfoCell.h"

@interface YSNewsInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation YSNewsInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.00];
    _titleLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.font = UIFontMake(14);
    [self.contentView addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.height.mas_equalTo(16*kHeightScale);
        make.width.mas_equalTo(60);
    }];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.numberOfLines = 0;
    _detailLabel.font = UIFontMake(16);
    [self.contentView addSubview:self.detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(13);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_greaterThanOrEqualTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

- (void)setInfoDict:(NSDictionary *)infoDict {
    _infoDict = infoDict;
    _titleLabel.text = [[_infoDict allKeys][0] isEqual:@""] ? @" " : [_infoDict allKeys][0];
    _detailLabel.text = [[_infoDict allValues][0] isEqual:@""] ? @" " : [_infoDict allValues][0];
}

@end
