//
//  YSCalendarBottomView.m
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/7/25.
//
//

#import "YSCalendarBottomView.h"

@implementation YSCalendarBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _sendButtonSubject = [RACSubject subject];
    NSArray *titleArray = @[@"月", @"周", @"日"];
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor: i == 0 ? kThemeColor : [UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left).offset(kSCREEN_WIDTH/3*i);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(kSCREEN_WIDTH/3);
        }];
    }
}

- (void)clickedButton:(UIButton *)button {
    [_sendButtonSubject sendNext:button];
}

@end
