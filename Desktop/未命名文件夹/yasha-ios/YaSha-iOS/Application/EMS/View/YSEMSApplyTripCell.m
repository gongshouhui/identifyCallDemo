//
//  YSEMSApplyTripCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/8.
//

#import "YSEMSApplyTripCell.h"

@interface YSEMSApplyTripCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailTitleLabel;
@property (nonatomic, strong) UIImageView *starImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UISwitch *cellSwitch;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation YSEMSApplyTripCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.height.mas_equalTo(17*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)setCellModel:(YSEMSApplyTripModel *)cellModel {
    _cellModel = cellModel;
    _titleLabel.text = _cellModel.title;
    _cellModel.necessary ? [self addStarImageView] : nil;
    [self addArrowImageView];
    [self addDetailTitleLabel];
    _detailTitleLabel.text = _cellModel.arrow ? @"请选择" : @"";
    switch (_cellModel.type) {
        case YSFormRowTypeText:
        {
            break;
        }
        case YSFormRowTypeTextField:
        {
            [self addTextField];
            break;
        }
        case YSFormRowTypeOptions:
        {
            break;
        }
        case YSFormRowTypeSwitch:
        {
            [self addSwitch];
            break;
        }
    }
}

- (void)addStarImageView {
    _starImageView = [[UIImageView alloc] init];
    _starImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_starImageView];
    [_starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_top);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}

- (void)addArrowImageView {
    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.image = [UIImage imageNamed:@"arrow"];
    [self.contentView addSubview:_arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(_cellModel.arrow ? 5 : 0, 12));
    }];
}

- (void)addSwitch {
    _cellSwitch = [[UISwitch alloc] init];
    [self.contentView addSubview:_cellSwitch];
    [_cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(_arrowImageView.mas_left);
    }];
}

- (void)addTextField {
    _textField = [[UITextField alloc] init];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.placeholder = @"请输入";
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(_arrowImageView.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH/3.0*2.0, 50*kHeightScale));
    }];
    [_detailTitleLabel removeFromSuperview];
}

- (void)addDetailTitleLabel {
    _detailTitleLabel = [[UILabel alloc] init];
    _detailTitleLabel.textAlignment = NSTextAlignmentRight;
    _detailTitleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_detailTitleLabel];
    [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(_arrowImageView.mas_left).offset(-5);
        make.height.mas_equalTo(17*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)setCellModel:(YSEMSApplyTripModel *)cellModel payload:(NSDictionary *)payload indexPath:(NSIndexPath *)indexPath {
    _cellModel = cellModel;
    _titleLabel.text = _cellModel.title;
    _cellModel.necessary ? [self addStarImageView] : nil;
    [self addArrowImageView];
    [self addDetailTitleLabel];
    _detailTitleLabel.text = _cellModel.arrow ? @"请选择" : @"";
    switch (_cellModel.type) {
        case YSFormRowTypeText:
        {
            break;
        }
        case YSFormRowTypeTextField:
        {
            [self addTextField];
            break;
        }
        case YSFormRowTypeOptions:
        {
            break;
        }
        case YSFormRowTypeSwitch:
        {
            [self addSwitch];
            break;
        }
    }
    switch (indexPath.row) {
        case 0:
        {
            _detailTitleLabel.text = payload[@"businessPname"];
            break;
        }
        case 1:
        {
            _detailTitleLabel.text = payload[@"businessName"];
            break;
        }
        case 2:
        {
            
            break;
        }
        case 3:
        {
            
            break;
        }
    }
}

- (void)setPayload:(NSDictionary *)payload indexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            _detailTitleLabel.text = payload[@"businessPname"];
            break;
        }
        case 1:
        {
            _detailTitleLabel.text = payload[@"businessName"];
            break;
        }
        case 2:
        {
            
            break;
        }
        case 3:
        {
            
            break;
        }
    }
}

@end
