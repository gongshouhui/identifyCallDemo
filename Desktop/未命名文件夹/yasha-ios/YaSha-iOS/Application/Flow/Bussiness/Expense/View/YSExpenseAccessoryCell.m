//
//  YSExpenseAccessoryCell.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/15.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseAccessoryCell.h"

@interface YSExpenseAccessoryCell()

@end
@implementation YSExpenseAccessoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = kUIColor(153, 153, 153, 1.0);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.text = @"附件";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(100*kWidthScale, 20*kHeightScale));
    }];
    
}
- (void)setAccessoryArray:(NSArray *)accessoryArray {
    _accessoryArray = accessoryArray;
    YSAccessoryView *lastView = nil;
    for (int i = 0; i < self.accessoryArray.count; i++) {
        YSNewsAttachmentModel *model = self.accessoryArray[i];
        YSAccessoryView *accView = [[YSAccessoryView alloc]init];
        accView.tag = 50 + i;
        [accView.nameButton addTarget:self action:@selector(attchViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [accView.nameButton setTitle:model.fileName forState:UIControlStateNormal];
        accView.sizeLb.text = [YSUtility getFileSize:model.fileSize];
        [self.contentView addSubview:accView];
        [accView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.mas_equalTo(10);
            }else{
                make.top.mas_equalTo(lastView.mas_bottom).mas_equalTo(5);
            }
            
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(25);
            make.right.mas_equalTo(0);
            if (i == self.accessoryArray.count - 1) {
                make.bottom.mas_equalTo(-10);
            }
        }];
        lastView = accView;
    }
    
}
- (void)attchViewDidClick:(UIButton *)button {
    YSAccessoryView *view = button.superview;
    NSInteger index = view.tag - 50;
    if ([self.delegate respondsToSelector:@selector(expenseAccessoryCellAccessoryViewDidClickWithModel:)]) {
        [self.delegate expenseAccessoryCellAccessoryViewDidClickWithModel:self.accessoryArray[index]];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
@implementation YSAccessoryView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nameButton setTitleColor:kUIColor(42, 138, 219, 1) forState:UIControlStateNormal];
    self.nameButton.titleLabel.font = [UIFont systemFontOfSize:15];
   [self.nameButton setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.nameButton setContentCompressionResistancePriority:(UILayoutPriorityDefaultLow) forAxis:(UILayoutConstraintAxisHorizontal)];
    //self.nameButton.titleLabel.numberOfLines = 0;
    [self addSubview:self.nameButton];
    
    [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.sizeLb = [[UILabel alloc]init];
    self.sizeLb.font = [UIFont systemFontOfSize:11];
    self.sizeLb.textColor = kGrayColor(153);
    self.sizeLb.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.sizeLb];
    [self.sizeLb setContentHuggingPriority:(UILayoutPriorityDefaultLow) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.sizeLb setContentCompressionResistancePriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
   
    [self.sizeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0); make.left.mas_equalTo(self.nameButton.mas_right).mas_equalTo(5);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
}
@end

