
//
//  YSAssetsScanView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/8/24.
//
//

#import "YSAssetsScanView.h"

@interface YSAssetsScanView ()

@property (nonatomic, strong) UILabel *toastLabel;

@end


@implementation YSAssetsScanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _viewOfInterest = [[UIView alloc] init];
    _viewOfInterest.backgroundColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:0.5];
    [self addSubview:_viewOfInterest];
    [_viewOfInterest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(250*kWidthScale, 250*kHeightScale));
    }];
    
    _toastLabel = [[UILabel alloc] init];
    _toastLabel.text = @"把二维码放入框内，即可自动扫描";
    _toastLabel.textColor = [UIColor whiteColor];
    _toastLabel.textAlignment = NSTextAlignmentCenter;
    _toastLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_toastLabel];
    [_toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_viewOfInterest.mas_bottom);
        make.height.mas_equalTo(20*kHeightScale);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _cancelButton = [YSUIHelper generateDarkFilledButton];
    [_cancelButton setTitle:@"取消扫描" forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(300*kWidthScale, 50*kHeightScale));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-30*kHeightScale);
    }];
}

@end
