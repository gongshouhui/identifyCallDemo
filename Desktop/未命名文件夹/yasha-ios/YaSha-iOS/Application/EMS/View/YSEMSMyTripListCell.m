//
//  YSEMSMyTripListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/14.
//

#import "YSEMSMyTripListCell.h"

@interface YSEMSMyTripListCell ()

@property (nonatomic, strong) UILabel *createTimeLabel;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *businessPnameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *daysLabel;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;

@property (nonatomic, strong) UIImageView *tripImageView;
@property (nonatomic, strong) UILabel *tripCountLabel;


@property (nonatomic, strong) UILabel *startCityLabel;
@property (nonatomic, strong) UILabel *endCityLabel;

@end

@implementation YSEMSMyTripListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    _createTimeLabel = [[UILabel alloc] init];
    _createTimeLabel.font = [UIFont systemFontOfSize:13];
    _createTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_createTimeLabel];
    [_createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(13);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _backView = [[UIView alloc] init];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 4.0;
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_createTimeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.image = [UIImage imageNamed:@"出差联系人"];
    [_backView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(_backView).offset(15);
        make.size.mas_equalTo(CGSizeMake(14*kWidthScale, 16*kHeightScale));
    }];
    
    _businessPnameLabel = [[UILabel alloc] init];
    _businessPnameLabel.font = [UIFont boldSystemFontOfSize:16];
    [_backView addSubview:_businessPnameLabel];
    [_businessPnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_avatarImageView.mas_centerY);
        make.left.mas_equalTo(_avatarImageView.mas_right).offset(6);
        make.height.mas_equalTo(17*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _codeLabel = [[UILabel alloc] init];
    _codeLabel.font = [UIFont systemFontOfSize:13];
    _codeLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.00];
    [_backView addSubview:_codeLabel];
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_businessPnameLabel.mas_right);
        make.bottom.mas_equalTo(_businessPnameLabel.mas_bottom);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _daysLabel = [[UILabel alloc] init];
    _daysLabel.textAlignment = NSTextAlignmentRight;
    _daysLabel.font = [UIFont boldSystemFontOfSize:14];
    [_backView addSubview:_daysLabel];
    [_daysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_avatarImageView.mas_centerY);
        make.right.mas_equalTo(_backView.mas_right).offset(-15);
        make.height.mas_equalTo(15*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    [_backView addSubview:_lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_avatarImageView.mas_bottom).offset(12);
        make.left.right.mas_equalTo(_backView);
        make.height.mas_equalTo(1);
    }];
    
    _startTimeLabel = [[UILabel alloc] init];
    _startTimeLabel.font = [UIFont systemFontOfSize:14];
    _startTimeLabel.textColor = [UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1.00];
    [_backView addSubview:_startTimeLabel];
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(_avatarImageView.mas_left);
        make.height.mas_equalTo(15*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _startCityLabel = [[UILabel alloc] init];
    _startCityLabel.numberOfLines = 0;
    _startCityLabel.font = [UIFont boldSystemFontOfSize:14];
    [_backView addSubview:_startCityLabel];
    [_startCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_startTimeLabel.mas_bottom).offset(7);
        make.left.mas_equalTo(_startTimeLabel.mas_left);
//        make.right.mas_equalTo(_tripCountLabel.mas_left).offset(-10);
        make.bottom.mas_equalTo(_backView.mas_bottom).offset(-10);
        make.width.mas_equalTo(115*kHeightScale);
    }];
    
    _tripImageView = [[UIImageView alloc] init];
    _tripImageView.image = [UIImage imageNamed:@"行程往返"];
    [_backView addSubview:_tripImageView];
    [_tripImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backView.mas_centerX);
        make.centerY.mas_equalTo(_startTimeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30*kWidthScale, 20*kHeightScale));
    }];
    
    _tripCountLabel = [[UILabel alloc] init];
    _tripCountLabel.font = [UIFont systemFontOfSize:12];
    _tripCountLabel.textColor = [UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1.00];
    _tripCountLabel.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_tripCountLabel];
    [_tripCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backView.mas_centerX);
        make.centerY.mas_equalTo(_startCityLabel.mas_centerY);
        make.height.mas_equalTo(13*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _endTimeLabel = [[UILabel alloc] init];
    _endTimeLabel.font = [UIFont systemFontOfSize:14];
    _endTimeLabel.textAlignment = NSTextAlignmentRight;
    _endTimeLabel.textColor = [UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1.00];
    [_backView addSubview:_endTimeLabel];
    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineLabel.mas_bottom).offset(12);
        make.right.mas_equalTo(_daysLabel.mas_right);
        make.height.mas_equalTo(15*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _endCityLabel = [[UILabel alloc] init];
    _endCityLabel.numberOfLines = 0;
    _endCityLabel.font = [UIFont boldSystemFontOfSize:14];
    _endCityLabel.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:_endCityLabel];
    [_endCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_endTimeLabel.mas_bottom).offset(7);
        make.left.mas_equalTo(_tripCountLabel.mas_right).offset(10);
        make.right.mas_equalTo(_endTimeLabel.mas_right);
        make.bottom.mas_equalTo(_backView.mas_bottom).offset(-10);
    }];
}

- (void)setCellModel:(YSEMSMyTripListModel *)cellModel {
    _cellModel = cellModel;
    _createTimeLabel.text = _cellModel.createTime;
    _businessPnameLabel.text = _cellModel.businessPname;
    _codeLabel.text = [NSString stringWithFormat:@"(%@)", _cellModel.code];
    _daysLabel.text = [NSString stringWithFormat:@"共%@天", _cellModel.businessDay];
    _startTimeLabel.text = _cellModel.startTime;
    _endTimeLabel.text = _cellModel.endTime;
    YSEMSMyTripSubListModel *subListModel = nil;
    if (_cellModel.businessTripList.count) {
         subListModel = _cellModel.businessTripList[0];
    }
    _startCityLabel.text = [subListModel.businessArea isEqual:@"国内"] ? [NSString stringWithFormat:@"%@%@",subListModel.startProvince , subListModel.startCity] : subListModel.address;
    _endCityLabel.text = [subListModel.businessArea isEqual:@"国内"] ? [NSString stringWithFormat:@"%@%@", subListModel.endProvince, subListModel.endCity] : @"";
    _tripCountLabel.text = [NSString stringWithFormat:@"共%zd个行程", _cellModel.businessTripList.count];
}

@end
