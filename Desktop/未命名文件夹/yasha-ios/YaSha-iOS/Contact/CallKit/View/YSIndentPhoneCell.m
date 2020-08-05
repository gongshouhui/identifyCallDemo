//
//  YSIndentPhoneCell.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/11/27.
//

#import "YSIndentPhoneCell.h"

@interface YSIndentPhoneCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YSIndentPhoneCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.layer.cornerRadius = 3;
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = kThemeColor;
    [self.contentView addSubview:self.imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH/3.0*2.0, kSCREEN_HEIGHT/3.0*2.0));
    }];
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    _imageView.image = [UIImage imageNamed:_imageName];
}

@end
