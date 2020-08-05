//
//  YSPerfExamBottomView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/10/20.
//

#import "YSPerfExamBottomView.h"

@interface YSPerfExamBottomView ()

@property (nonatomic, strong) UIButton *reBackButton;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation YSPerfExamBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _sendActionSubject = [RACSubject subject];
    self.layer.borderColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00].CGColor;
    self.layer.borderWidth = 0.5f;
    _reBackButton = [[UIButton alloc] init];
    _reBackButton.tag = 0;
    _reBackButton.backgroundColor = [UIColor whiteColor];
    _reBackButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_reBackButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_reBackButton setTitle:@"退回给TA" forState:UIControlStateNormal];
    YSWeak;
    [[_reBackButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.sendActionSubject sendNext:weakSelf.reBackButton];
    }];
    [self addSubview:_reBackButton];
    [_reBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_centerX);
    }];
    
    _confirmButton = [[UIButton alloc] init];
    _confirmButton.tag = 1;
    _confirmButton.backgroundColor = kThemeColor;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmButton setTitle:@"生效" forState:UIControlStateNormal];
    [[_confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.sendActionSubject sendNext:weakSelf.confirmButton];
    }];
    [self addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_centerX);
    }];
}

@end
