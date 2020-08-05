//
//  YSRejectCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRejectCell.h"
@interface YSRejectCell()
@property (nonatomic, strong) UILabel *titleLbel;
@property (nonatomic, strong) UILabel *detailLabel;
@end
@implementation YSRejectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        _clickSubject = [RACSubject subject];
    }
    return self;
}

- (void)initUI {
    _selectButton = [[QMUIButton alloc] init];
    [_selectButton setImage:[UIImage imageNamed:@"unselected+normal"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"selected+normal"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectButton];
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 30*kHeightScale));
    }];
    _selectButton.userInteractionEnabled = NO;
//    YSWeak;
//    [[_selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rejectCellSelectedButtonDidClick:)]) {
//            [weakSelf.delegate rejectCellSelectedButtonDidClick:weakSelf];
//        }
//    }];
    
    _titleLbel = [[UILabel alloc] init];
    _titleLbel.font = [UIFont systemFontOfSize:15];
    _titleLbel.textColor = kGrayColor(51);
    [self.contentView addSubview:self.titleLbel];
    [_titleLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_selectButton.mas_right).offset(10);
        make.height.mas_equalTo(16*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.textColor = [UIColor blackColor];
    _detailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(12*kHeightScale);
        make.left.mas_equalTo(_titleLbel.mas_right).offset(5);
    }];
}

- (void)setRejectModel:(YSRejectModel *)rejectModel {
    _rejectModel = rejectModel;
    self.titleLbel.text = rejectModel.title;
    self.detailLabel.text = rejectModel.name;
    _selectButton.selected = rejectModel.isSelected;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
