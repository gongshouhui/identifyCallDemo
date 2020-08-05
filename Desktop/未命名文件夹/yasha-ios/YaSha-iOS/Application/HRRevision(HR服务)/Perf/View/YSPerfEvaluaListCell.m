//
//  YSPerfEvaluaListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/19.
//

#import "YSPerfEvaluaListCell.h"

@interface YSPerfEvaluaListCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *personNameLabel;
@property (nonatomic, strong) UILabel *flowStatusLabel;

@end

@implementation YSPerfEvaluaListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(16*kHeightScale);
    }];
    
    _codeLabel = [[UILabel alloc] init];
    _codeLabel.textColor = [UIColor lightGrayColor];
    _codeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_codeLabel];
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    _personNameLabel = [[UILabel alloc] init];
    _personNameLabel.textColor = [UIColor lightGrayColor];
    _personNameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_personNameLabel];
    [_personNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_codeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    _flowStatusLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_flowStatusLabel];
    [_flowStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_personNameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(14*kHeightScale);
    }];
}

- (void)setCellModel:(YSPerfEvaluaListModel *)cellModel  andIndexPath:(NSInteger)index{
    _cellModel = cellModel;
    _nameLabel.text = [NSString stringWithFormat:@"%@", _cellModel.name];
    _codeLabel.text = [NSString stringWithFormat:@"方案编号    %@", _cellModel.planCode];
    _personNameLabel.text = [NSString stringWithFormat:@"被评估人    %@", _cellModel.personName];
    NSMutableAttributedString *flowStatusStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"计划状态    %@", index == 1 ? @"复评" : _cellModel.flowStatusStr]];
    flowStatusStr.yy_font = [UIFont systemFontOfSize:12];
    flowStatusStr.yy_color = [UIColor lightGrayColor];
    [flowStatusStr yy_setColor:[UIColor redColor] range:NSMakeRange(8, 2)];
    _flowStatusLabel.attributedText = flowStatusStr;
}

@end
