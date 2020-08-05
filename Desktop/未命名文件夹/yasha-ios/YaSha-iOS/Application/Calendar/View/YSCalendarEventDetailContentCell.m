//
//  YSCalendarEventDetailContentCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/10.
//

#import "YSCalendarEventDetailContentCell.h"

@interface YSCalendarEventDetailContentCell()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation YSCalendarEventDetailContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}

- (void)setCellModel:(YSCalendarEventModel *)cellModel {
    _cellModel = cellModel;
    _contentLabel.text = _cellModel.content;
}

@end
