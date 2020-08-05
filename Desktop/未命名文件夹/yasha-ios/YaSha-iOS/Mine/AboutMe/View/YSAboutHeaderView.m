//
//  YSAboutHeaderView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/4/14.
//
//

#import "YSAboutHeaderView.h"

@interface YSAboutHeaderView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *versionLabel;

@end

@implementation YSAboutHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {

    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.image = [UIImage imageNamed:@"QR"];
    [self addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(150*kWidthScale, 150*kHeightScale));
    }];
    
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.text = [NSString stringWithFormat:@"%@ %@", [YSUtility getAPPName], [YSUtility getAPPVersion]];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_versionLabel];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_logoImageView.mas_bottom).offset(20);
        make.height.mas_equalTo(14*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

@end
