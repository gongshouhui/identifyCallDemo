//
//  YSCalendarMonthCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/25.
//
//

#import "YSCalendarMonthCell.h"

@interface YSCalendarMonthCell ()

@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UIImageView *pointImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *addressImageView;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation YSCalendarMonthCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _startTimeLabel = [[UILabel alloc] init];
    _startTimeLabel.font = [UIFont systemFontOfSize:14];
    _startTimeLabel.layer.masksToBounds = YES;
    _startTimeLabel.layer.cornerRadius = 10;
    [self.contentView addSubview:_startTimeLabel];
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 16*kHeightScale));
    }];
    
    _endTimeLabel = [[UILabel alloc] init];
    _endTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_endTimeLabel];
    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_startTimeLabel.mas_centerX);
        make.top.mas_equalTo(_startTimeLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(50*kWidthScale, 20*kHeightScale));
    }];
    
    _pointImageView = [[UIImageView alloc] init];
    _pointImageView.image = [UIImage imageNamed:@"月视图-圆点"];
    [self.contentView addSubview:_pointImageView];
    [_pointImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_startTimeLabel.mas_centerY);
        make.left.mas_equalTo(_startTimeLabel.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(5*kWidthScale, 5*kHeightScale));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_startTimeLabel.mas_centerY);
        make.left.mas_equalTo(_pointImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(16*kHeightScale);
    }];
    
    _addressImageView = [[UIImageView alloc] init];
    _addressImageView.image = [UIImage imageNamed:@"地址icon"];
    [self.contentView addSubview:_addressImageView];
    [_addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_endTimeLabel.mas_centerY);
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(7*kWidthScale, 10*kHeightScale));
    }];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_endTimeLabel.mas_centerY);
        make.left.mas_equalTo(_addressImageView.mas_right).offset(10);
        make.right.mas_equalTo(_titleLabel.mas_right);
        make.height.mas_equalTo(16*kHeightScale);
    }];
}

- (void)setCellModel:(YSCalendarEventModel *)cellModel {
    _cellModel = cellModel;
    _startTimeLabel.text = [[_cellModel.start substringFromIndex:11] substringToIndex:5];
    _endTimeLabel.text = [[_cellModel.end substringFromIndex:11] substringToIndex:5];
    _titleLabel.text = _cellModel.title;
    _addressLabel.text = _cellModel.address;
}

@end
