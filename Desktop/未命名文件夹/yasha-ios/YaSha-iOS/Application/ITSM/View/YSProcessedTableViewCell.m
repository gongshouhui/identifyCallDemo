//
//  YSProcessedTableViewCell.m
//  YaSha-iOS
//
//  Created by mHome on 2017/7/5.
//
//

#import "YSProcessedTableViewCell.h"

@interface YSProcessedTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *noLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation YSProcessedTableViewCell

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
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(16*kHeightScale);
    }];
    
    _noLabel = [[UILabel alloc]initWithFrame:CGRects(15, 48, 150, 10)];
    _noLabel.font = [UIFont systemFontOfSize:12];
    _noLabel.textColor = kUIColor(153, 153, 153, 1.0);
    [self.contentView addSubview:_noLabel];
    [_noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textColor = kUIColor(153, 153, 153, 1.0);
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(_noLabel.mas_centerY);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.font = [UIFont systemFontOfSize:12];
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    _phoneLabel.textColor = kUIColor(153, 153, 153, 1.0);
    [self addSubview:_phoneLabel];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_noLabel.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.font = [UIFont systemFontOfSize:12];
    _stateLabel.textColor = kUIColor(153, 153, 153, 1.0);
    [self addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.top.mas_equalTo(_noLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _lastButton = [[UIButton alloc] init];
    [self.contentView addSubview:_lastButton];
    [_lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_stateLabel.mas_centerY);
        make.right.mas_equalTo(_phoneLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(55*kWidthScale, 20*kHeightScale));
    }];
    
    _complaintsButton = [[UIButton alloc] init];
    [self.contentView addSubview:_complaintsButton];
    [_complaintsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_stateLabel.mas_centerY);
        make.right.mas_equalTo(_lastButton.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(55*kWidthScale, 20*kHeightScale));
    }];
}

- (void)setCellModel:(YSITSMUntreatedModel *)cellModel {
    _cellModel = cellModel;
    _titleLabel.text = _cellModel.title;
    _noLabel.text = _cellModel.eventNo;
    _nameLabel.text = _cellModel.tsUserRealName;
    _phoneLabel.text = _cellModel.tsUserMobilePhone;
    _stateLabel.text = _cellModel.statusName;
    
    if ([_cellModel.statusCode isEqual:@"1"] || [_cellModel.statusCode isEqual:@"0"]) {
        [_lastButton setImage:[UIImage imageNamed:@"撤销请求"] forState:UIControlStateNormal];
    } else {
        if ([_cellModel.visitRecord isEqual:@"1"]) {
            [_lastButton setImage:[UIImage imageNamed:@"查看评价"] forState:UIControlStateNormal];
        } else if ([_cellModel.visitRecord isEqual:@"0"]) {
            [_lastButton setImage:[UIImage imageNamed:@"服务评价"] forState:UIControlStateNormal];
            [_complaintsButton setImage:[UIImage imageNamed:@"我要投诉"] forState:UIControlStateNormal];
        } else {
            _lastButton.hidden = YES;
            _complaintsButton.hidden = YES;
        }
    }
}

@end
