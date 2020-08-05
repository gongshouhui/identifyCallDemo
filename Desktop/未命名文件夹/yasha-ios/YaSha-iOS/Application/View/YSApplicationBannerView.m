//
//  YSApplicationBannerView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 17/3/10.
//
//

#import "YSApplicationBannerView.h"

@implementation YSApplicationBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH*375/150);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
}

@end
