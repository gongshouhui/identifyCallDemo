//
//  YSFormCommonCell.m
//  Form
//
//  Created by 方鹏俊 on 2017/11/9.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFormCommonCell.h"

@interface YSFormCommonCell ()
@end

@implementation YSFormCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _sendValueSubject = [RACSubject subject];
        _sendAreaSubject = [RACSubject subject];
        _sendFormCellModelSubject= [RACSubject subject];
        _sendOptionsSubject = [RACSubject subject];
        _sendEditSectionSubject = [RACSubject subject];
        _sendDeleteSectionSubject = [RACSubject subject];
        _sendImageDataSubject = [RACSubject subject];
		_sendMultipleOptionsSubject = [RACSubject subject];
        //右侧箭头view
        self.arrowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"向右箭头"]];
        [self addSubview:self.arrowView];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(14);
        }];
    }
    return self;
}

- (void)addTitleLabel {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = UIFontMake(14);
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(120*kWidthScale);
        make.bottom.mas_equalTo(-15);
    }];
    
}

- (void)addDetailLabel {
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.font = [UIFont boldSystemFontOfSize:14];
    _detailLabel.textColor = [UIColor colorWithHexString:flowRightColor];
    _detailLabel.numberOfLines = 0;
    [self.contentView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.left.mas_equalTo(_titleLabel.mas_right).mas_equalTo(10);
    }];
}

- (void)setCellModel:(YSFormRowModel *)cellModel {
    self.accessoryType = UITableViewCellAccessoryNone;
    _cellModel = cellModel;
    _titleLabel.text = _cellModel.title;
    _detailLabel.text = _cellModel.detailTitle;
    
    if (_cellModel.necessary) {
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ *", _cellModel.title]];
        title.yy_font = [UIFont boldSystemFontOfSize:14] ;
        title.yy_color = [UIColor blackColor];
        [title yy_setColor:[UIColor redColor] range:NSMakeRange(_cellModel.title.length+1, 1)];
        _titleLabel.attributedText = title;
        //self.contentView.backgroundColor = [UIColor colorWithHexString:@"FFFFE9"];
       
    }else{
        //self.contentView.backgroundColor = [UIColor whiteColor];
    }
    if (self.cellModel.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        self.arrowView.hidden = NO;
        [_detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(self.arrowView.mas_left).offset(-8);
            make.left.mas_equalTo(_titleLabel.mas_right).mas_equalTo(10);
        }];
    }else{
        self.arrowView.hidden = YES;
    }
    if (cellModel.imageName) {
        self.imageView.image = UIImageMake(cellModel.imageName);
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.imageView.mas_right).offset(5);
            make.height.mas_equalTo(17*kHeightScale);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) return;
    if (_cellModel.disable) {
        return;
    }
    [super setSelected:selected animated:animated];
    if (selected) {
        if (self.cellModel.pushClassName) {
            Class ClassName = NSClassFromString(self.cellModel.pushClassName);
            id class = [[ClassName alloc] init];
            if ([class isKindOfClass:[UIViewController class]]) {
                //cell视图要处理控制器的跳转逻辑，不应该吧？
                [[YSUtility getCurrentViewController].navigationController pushViewController:class animated:YES];
            }
        }
        self.selected = NO;
    }
}

- (void)updateData:(YSFormRowModel *)cellModel {
    _cellModel = cellModel;
}

- (void)dealloc {
    DLog(@"ddddddd");
}

/** fix换行点击时textField未失去第一响应 */
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    [self becomeFirstResponder];
//}

@end


@implementation YSFormCellModel

@end
