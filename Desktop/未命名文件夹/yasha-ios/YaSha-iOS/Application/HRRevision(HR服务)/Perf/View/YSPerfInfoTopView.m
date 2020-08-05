//
//  YSPerfInfoTopView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/18.
//

#import "YSPerfInfoTopView.h"

@interface YSPerfInfoTopView ()

@property (nonatomic, strong) UIImageView *slideImageView;

@end

@implementation YSPerfInfoTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 40);
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _slideImageView = [[UIImageView alloc] init];
    _slideImageView.image = [UIImage imageNamed:@"向左滑动"];
    [self addSubview:_slideImageView];
    [_slideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(86*kWidthScale, 25*kHeightScale));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(_slideImageView.mas_left).offset(-15);
        make.height.mas_equalTo(15*kHeightScale);
    }];
}

@end
