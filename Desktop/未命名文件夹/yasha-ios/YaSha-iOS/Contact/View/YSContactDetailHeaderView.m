//
//  YSContactDetailHeaderView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2018/1/8.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactDetailHeaderView.h"

@interface YSContactDetailHeaderView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) QMUIButton *actionButton;

@end

@implementation YSContactDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 250*kHeightScale);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _sendActionSubject = [RACSubject subject];
    
    _backImageView = [[UIImageView alloc] init];
    _backImageView.image = YSThemeManagerShare.currentTheme.themeContactBackgroundImage;
    [self addSubview:self.backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
    
    _avatarButton = [[UIButton alloc] init];
    _avatarButton.layer.masksToBounds = YES;
    _avatarButton.layer.cornerRadius = 37*kWidthScale;
    [self addSubview:self.avatarButton];
    [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(50);
        make.size.mas_equalTo(CGSizeMake(74*kWidthScale, 74*kWidthScale));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_avatarButton.mas_bottom).offset(10);
        make.height.mas_equalTo(18*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _genderImageView = [[UIImageView alloc] init];
    [self addSubview:self.genderImageView];
    [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(16*kWidthScale, 16*kWidthScale));
    }];
    
    NSArray *titleArray = @[@"呼叫", @"短信"];
    for (int i = 0; i < 2; i ++) {
        QMUIButton *actionButton = [[QMUIButton alloc] init];
        actionButton.tag = i+1010;
        actionButton.imagePosition = QMUIToastViewPositionTop;
        actionButton.spacingBetweenImageAndTitle = 8;
        [actionButton setImage:UIImageMake(titleArray[i]) forState:UIControlStateNormal];
        [actionButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [actionButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        actionButton.titleLabel.font = UIFontMake(14);
        YSWeak;
        __weak __typeof(actionButton) weakActionBtn  = actionButton;
        [[actionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf.sendActionSubject sendNext:weakActionBtn];
        }];
        [self addSubview:actionButton];
        [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_avatarButton.mas_centerX).offset(-40+80*i);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(40*kWidthScale, 60*kWidthScale));
        }];
    }
}

- (void)setContactModel:(YSContactModel *)contactModel contactDetailType:(YSContactDetailType)contactDetailType {
    _contactModel = contactModel;
    NSString *avatarUrlString = [NSString stringWithFormat:@"%@_M.jpg", _contactModel.headImg];
    //[_avatarButton sd_setImageWithURL:[NSURL URLWithString:avatarUrlString] forState:UIControlStateNormal placeholderImage:UIImageMake(@"头像")];
	[_avatarButton sd_setImageWithURL:[NSURL URLWithString:avatarUrlString] forState:UIControlStateNormal placeholderImage:UIImageMake(@"头像") options:(SDWebImageRefreshCached)];
    _nameLabel.text = _contactModel.name;
    _genderImageView.image = UIImageMake(_contactModel.sex ? @"男性" : @"女性");
    if (contactDetailType != YSContactDetailInner) {
        for (QMUIButton *button in self.subviews) {
            if ([button isKindOfClass:[QMUIButton class]]) {
                [button removeFromSuperview];
            }
        }
        [_genderImageView removeFromSuperview];
    }
    //优秀员工
    if ([contactModel.isExcellentEmployee integerValue] == 1) {
        _backImageView.image = [UIImage imageNamed:@"contactPerBGImg"];
        QMUIButton *callButton = [self viewWithTag:1010];
        QMUIButton *messageButton = [self viewWithTag:1011];
        [callButton setImage:UIImageMake(@"contactPerCallImg") forState:UIControlStateNormal];
        [messageButton setImage:UIImageMake(@"contactPerMessageImg") forState:UIControlStateNormal];
    }
}
- (void)dealloc {
    DLog(@"释放");
}
@end
