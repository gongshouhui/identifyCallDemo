//
//  YSPerfListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/25.
//
//

#import "YSPerfListCell.h"

@interface YSPerfListCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *flowStatusLabel;
@property (nonatomic, strong) UIImageView *levelImage;

@end

@implementation YSPerfListCell

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
        make.height.mas_equalTo(16*kHeightScale);
        make.width.mas_equalTo(300*kWidthScale);
    }];
    
    
    _levelImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_levelImage];
    [_levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(19*kWidthScale, 22*kHeightScale));
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
    
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.textColor = [UIColor lightGrayColor];
    _scoreLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_scoreLabel];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_codeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(14*kHeightScale);
    }];
    
    _flowStatusLabel = [[UILabel alloc] init];
    _flowStatusLabel.textColor = [UIColor lightGrayColor];
    _flowStatusLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_flowStatusLabel];
    [_flowStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scoreLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(14*kHeightScale);
    }];
}

- (void)setCellModel:(YSPerfListModel *)cellModel {
    _cellModel = cellModel;
    _nameLabel.text = [NSString stringWithFormat:@"%@", _cellModel.name];
    _codeLabel.text = [NSString stringWithFormat:@"方案编号    %@", _cellModel.code];
    DLog(@"======%@",_cellModel.score);
    _scoreLabel.text = [NSString stringWithFormat:@"评估总分    %@", _cellModel.score == nil ? @"": _cellModel.score ];
    _flowStatusLabel.text = [NSString stringWithFormat:@"计划状态    %@", _cellModel.flowStatusStr];
    if (![_cellModel.scoreStr isEqual:@" "] || _cellModel.scoreStr != nil || ![_cellModel.scoreStr isEqual:[NSNull null]] ) {
        _levelImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_cellModel.grade]];
    }
}

@end
