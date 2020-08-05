//
//  YSCalendarGrantCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/2.
//

#import "YSCalendarGrantCell.h"

@interface YSCalendarGrantCell ()

@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation YSCalendarGrantCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.image = [UIImage imageNamed:@"arrow"];
    [self.contentView addSubview:_arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(5, 12));
    }];
}

- (void)setCellModel:(YSCalendarGrantPeopleModel *)cellModel {
    _cellModel = cellModel;
    self.textLabel.text = _cellModel.grantedPersonName;
    self.detailTextLabel.text = _cellModel.grantType == 1 ? @"修改" : @"查阅";
}

@end
