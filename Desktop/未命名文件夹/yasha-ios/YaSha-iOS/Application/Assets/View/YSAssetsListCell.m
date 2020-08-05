//
//  YSAssetsListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import "YSAssetsListCell.h"

@interface YSAssetsListCell ()

@property (nonatomic, strong) UILabel *titileLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation YSAssetsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titileLabel = [[UILabel alloc] init];
    _titileLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titileLabel];
    [_titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(17*kHeightScale);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titileLabel.mas_bottom).offset(12);
        make.right.mas_equalTo(_titileLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 12*kHeightScale));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titileLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(_titileLabel.mas_left);
        make.right.mas_equalTo(_timeLabel.mas_left).offset(-15);
        make.height.mas_equalTo(14*kHeightScale);
    }];
}

- (void)setCellModel:(YSAssetsListModel *)cellModel {
    _cellModel = cellModel;
    _titileLabel.text = _cellModel.checkName;
    NSMutableString *scopeString = [NSMutableString string];
    if (![_cellModel.scopeCompany isEqual:@""]) {
        [scopeString appendString:[NSString stringWithFormat:@"%@/", _cellModel.scopeCompany]];
    }
    if (![_cellModel.scopeDept isEqual:@""]) {
        [scopeString appendString:[NSString stringWithFormat:@"%@/", _cellModel.scopeDept]];
    }
    if (![_cellModel.scopeCate isEqual:@""]) {
        [scopeString appendString:_cellModel.scopeCate];
    }
    _nameLabel.text = scopeString;
    _timeLabel.text = [NSString stringWithFormat:@"%@到%@", [_cellModel.startDate substringToIndex:10], [_cellModel.endDate substringToIndex:10]];
}

@end
