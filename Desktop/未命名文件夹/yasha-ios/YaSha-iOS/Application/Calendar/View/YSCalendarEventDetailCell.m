//
//  YSCalendarEventDetailCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/7.
//

#import "YSCalendarEventDetailCell.h"

@interface YSCalendarEventDetailCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *addressImageView;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation YSCalendarEventDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20*kHeightScale);
    }];
    
    _timeImageView = [[UIImageView alloc] init];
    _timeImageView.image = [UIImage imageNamed:@"clock-blue"];
    [self.contentView addSubview:_timeImageView];
    [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(10*kWidthScale, 10*kWidthScale));
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.numberOfLines = 0;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_timeImageView.mas_centerY);
        make.left.mas_equalTo(_timeImageView.mas_right).offset(10);
        make.right.mas_equalTo(_titleLabel.mas_right);
        make.height.mas_equalTo(40*kHeightScale);
    }];
    
    _addressImageView = [[UIImageView alloc] init];
    _addressImageView.image = [UIImage imageNamed:@"地址icon"];
    [self.contentView addSubview:_addressImageView];
    [_addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(7*kWidthScale, 10*kHeightScale));
    }];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_addressImageView.mas_centerY);
        make.left.mas_equalTo(_timeImageView.mas_right).offset(10);
        make.right.mas_equalTo(_titleLabel.mas_right);
        make.height.mas_equalTo(16*kHeightScale);
    }];
}

- (void)setCellModel:(YSCalendarEventModel *)cellModel {
    _cellModel = cellModel;
    _titleLabel.text = _cellModel.title;
    _cellModel.start = [_cellModel.start substringToIndex:16];
    _cellModel.end = [_cellModel.end substringToIndex:16];
    _timeLabel.text = [[_cellModel.start substringToIndex:10] isEqual:[_cellModel.end substringToIndex:10]] ? [NSString stringWithFormat:@"%@ -- %@", _cellModel.start, [_cellModel.end substringFromIndex:11]] : [NSString stringWithFormat:@"%@ -- %@", _cellModel.start, _cellModel.end];
    _addressLabel.text =_cellModel.address;
}

@end
