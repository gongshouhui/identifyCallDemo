//
//  YSCalendarEditEventCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/7.
//

#import "YSCalendarEditEventCell.h"

@interface YSCalendarEditEventCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YSCalendarEditEventCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(60*kWidthScale, 44*kHeightScale));
    }];
}

- (void)setStyle:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    _titleLabel.text = dic[@"title"];
    switch (indexPath.row) {
        case 0:
        {
            [self addDetailTextField:dic[@"placeholder"]];
            break;
        }
        case 1:
        {
            [self addAllDaySwitch];
            break;
        }
        case 2:
        {
            [self addDetailLabel];
            break;
        }
        case 3:
        {
            [self addDetailLabel];
            break;
        }
        case 4:
        {
            [self addDetailTextField:dic[@"placeholder"]];
            break;
        }
        case 5:
        {
            [self addTextView];
            break;
        }
    }
}

- (void)addDetailTextField:(NSString *)placeholder {
    _detailTextField = [[UITextField alloc] init];
    _detailTextField.font = [UIFont systemFontOfSize:14];
    _detailTextField.placeholder = placeholder;
    [self.contentView addSubview:_detailTextField];
    [_detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
}

- (void)addAllDaySwitch {
    _allDaySwitch = [[UISwitch alloc] init];
    [self.contentView addSubview:_allDaySwitch];
    [_allDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
}

- (void)addDetailLabel {
    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(10*kWidthScale, 20*kHeightScale));
    }];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
        make.right.mas_equalTo(_arrowImageView.mas_right).offset(-15);
        make.height.mas_equalTo(16*kHeightScale);
    }];
}

- (void)addTextView {
    _textView = [[QMUITextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.placeholder = @"备注";
    _textView.autoResizable = YES;
    _textView.maximumTextLength = 200;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.contentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.contentView);
    }];
}

@end
