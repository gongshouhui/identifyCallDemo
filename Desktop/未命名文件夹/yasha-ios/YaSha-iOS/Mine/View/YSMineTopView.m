//
//  YSMineTopView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/27.
//
//

#import "YSMineTopView.h"

@interface YSMineTopView ()

@property (nonatomic, strong) UIImageView *bakcImageView;

@end

@implementation YSMineTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 200*kHeightScale+kTopHeight);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _bakcImageView = [[UIImageView alloc] init];
    _bakcImageView.image = YSThemeManagerShare.currentTheme.themeMineBackgroundImage;
    [self addSubview:_bakcImageView];
    [_bakcImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
    
    _avatarButton = [[UIButton alloc] init];
    _avatarButton.layer.masksToBounds = YES;
    _avatarButton.layer.cornerRadius = 37*kWidthScale;
    [self addSubview:_avatarButton];
    [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(80*kHeightScale+kTopHeight);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(74*kWidthScale, 74*kWidthScale));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_avatarButton.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(16*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _genderImageView = [[UIImageView alloc] init];
    [self addSubview:_genderImageView];
    [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(14*kWidthScale, 14*kHeightScale));
    }];
    [_avatarButton setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
}

- (void)setModel:(YSPersonalInformationModel *)model {
    _model = model;
    _nameLabel.text = _model.name;
    !_model.headImg ? [_avatarButton setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal] : [_avatarButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YSImageDomain, [YSUtility getAvatarUrlString:model.headImg]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"] options:SDWebImageRefreshCached];
    [_model.gender isEqual:@"1"] ? (_genderImageView.image = [UIImage imageNamed:@"男性"]) : (_genderImageView.image = [UIImage imageNamed:@"女性"]);
}

@end
