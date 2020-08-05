//
//  YSNewsListCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/29.
//

#import "YSNewsListCell.h"

@interface YSNewsListCell ()

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *creatorLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UILabel *publicTimeLabel;
@property (nonatomic, strong) UIImageView *attachmentImageView;
@property (nonatomic, strong) UILabel *alreadyReadLabel;
@property (nonatomic, strong) UIImageView *eyeImageView;
@property (nonatomic, strong) UILabel *visitCountLabel;

@end

@implementation YSNewsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _thumbImageView = [[UIImageView alloc] init];
    _thumbImageView.layer.masksToBounds = YES;
    _thumbImageView.layer.cornerRadius = 3;
    [self.contentView addSubview:_thumbImageView];
    [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(115*kWidthScale, 71*kHeightScale));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_thumbImageView.mas_top);
        make.left.mas_equalTo(_thumbImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(18*kHeightScale);
    }];
    
    _creatorLabel = [[UILabel alloc] init];
    _creatorLabel.font = [UIFont systemFontOfSize:12];
    _creatorLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_creatorLabel];
    [_creatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
        make.centerY.mas_equalTo(_thumbImageView.mas_centerY);
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _pointLabel = [[UILabel alloc] init];
    _pointLabel.layer.masksToBounds = YES;
    _pointLabel.layer.cornerRadius = 1.5;
    _pointLabel.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_pointLabel];
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_creatorLabel.mas_centerY);
        make.left.mas_equalTo(_creatorLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(3*kWidthScale, 3*kHeightScale));
    }];
    
    _publicTimeLabel = [[UILabel alloc] init];
    _publicTimeLabel.font = [UIFont systemFontOfSize:12];
    _publicTimeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_publicTimeLabel];
    [_publicTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_creatorLabel.mas_centerY);
        make.left.mas_equalTo(_pointLabel.mas_right).offset(5);
        make.height.mas_greaterThanOrEqualTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _attachmentImageView = [[UIImageView alloc] init];
    _attachmentImageView.image = [UIImage imageNamed:@"附件"];
    [self.contentView addSubview:_attachmentImageView];
    [_attachmentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_creatorLabel.mas_centerY);
        make.left.mas_equalTo(_publicTimeLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(10*kWidthScale, 10*kHeightScale));
    }];
    
    _alreadyReadLabel = [[UILabel alloc] init];
    _alreadyReadLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_alreadyReadLabel];
    [_alreadyReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.bottom.mas_equalTo(_thumbImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60*kWidthScale, 14*kHeightScale));
    }];
    
    _visitCountLabel = [[UILabel alloc] init];
    _visitCountLabel.font = [UIFont systemFontOfSize:12];
    _visitCountLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_visitCountLabel];
    [_visitCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_thumbImageView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _eyeImageView = [[UIImageView alloc] init];
    _eyeImageView.image = [UIImage imageNamed:@"查看"];
    [self.contentView addSubview:_eyeImageView];
    [_eyeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_visitCountLabel.mas_centerY);
        make.right.mas_equalTo(_visitCountLabel.mas_left).offset(-4);
        make.size.mas_equalTo(CGSizeMake(12*kWidthScale, 8*kWidthScale));
    }];
}

- (void)setCellModel:(YSNewsListModel *)cellModel {
    _cellModel = cellModel;
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YSImageDomain, _cellModel.thumbImg]] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    _titleLabel.text = _cellModel.title;
    _creatorLabel.text = _cellModel.creatorName;
    _publicTimeLabel.text = _cellModel.publicTimeStr;
    [_attachmentImageView setHidden:_cellModel.hasAttachment ? NO : YES];
    _alreadyReadLabel.text = _cellModel.alreadyRead ? @"已读" : @"未读";
    _alreadyReadLabel.textColor = _cellModel.alreadyRead ? kThemeColor : [UIColor redColor];
    _visitCountLabel.text = [NSString stringWithFormat:@"%zd", _cellModel.visitCount];
}

- (void)hideThumbImageView {
    [_thumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(0, 71*kHeightScale));
    }];
}

@end
