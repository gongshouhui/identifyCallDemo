//
//  YSFlowHandleCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/31.
//

#import "YSFlowHandleCell.h"

@interface YSFlowHandleCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation YSFlowHandleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.height.mas_equalTo(16*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)setCellModel:(YSInternalModel *)cellModel {
    _cellModel = cellModel;
    _nameLabel.text = [_cellModel.name isEqual:@""] ? _cellModel.text : _cellModel.name;
}

@end
