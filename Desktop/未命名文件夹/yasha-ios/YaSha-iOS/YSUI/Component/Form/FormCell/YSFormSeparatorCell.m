//
//  YSFormSeparatorCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/12/11.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormSeparatorCell.h"

@implementation YSFormSeparatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addTitleLabel];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    self.titleLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.00];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
}

- (void)setCellModel:(YSFormRowModel *)cellModel {
    [super setCellModel:cellModel];
}

@end
