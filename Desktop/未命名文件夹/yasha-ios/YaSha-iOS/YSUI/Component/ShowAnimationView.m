//
//  ShowAnimationView.m
//  Select
//
//  Created by YaSha_Tom on 2017/8/31.
//  Copyright © 2017年 YaSha-Tom. All rights reserved.
//

#import "ShowAnimationView.h"
#import "YSSingleton.h"

@implementation ShowAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _enterSubject = [RACSubject subject];
        self.backgroundColor = [UIColor whiteColor];
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    
    /*创建灰色背景*/
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    bgView.alpha = 0.3;
    _bgView.backgroundColor = kGrayColor(190);
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
//    [self addSubview:bgView];
    
    
    /*添加手势事件,移除View*/
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
//    [bgView addGestureRecognizer:tapGesture];
    
    /*创建显示View*/
    _showView = [[UIImageView alloc] init];
//    _showView.frame = CGRects(33, 52, 310, 564);
    _showView.userInteractionEnabled = YES;
    _showView.image = [UIImage imageNamed:@"ic_ems_tip"];
    [_bgView addSubview:_showView];
    [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgView.mas_top).offset(52*kHeightScale);
        make.left.mas_equalTo(_bgView.mas_left).offset(33*kWidthScale);
        make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-52*kHeightScale);
        make.right.mas_equalTo(_bgView.mas_right).offset(-33*kWidthScale);
    }];
    
    _enterButton = [[UIButton alloc]init];
//    _enterButton.frame = CGRects(59, 568, 145, 34);
    _enterButton.backgroundColor = kUIColor(42, 138, 219, 1);
    [_enterButton setTitle:@"属于试点部门" forState:UIControlStateNormal];
    [_enterButton.titleLabel  sizeToFit];
    _enterButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_enterButton.layer setMasksToBounds:YES];
    [_enterButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    YSWeak;
    [[_enterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.enterSubject sendNext:@"enter"];
    }];
    [_showView addSubview:_enterButton];
    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_showView.mas_bottom).offset(-14*kHeightScale);
        make.left.mas_equalTo(_showView.mas_left).offset(26*kWidthScale);
        make.right.mas_equalTo(_showView.mas_right).offset(-139*kWidthScale);
        make.height.mas_equalTo(34*kHeightScale);
    }];
    
    _backButton = [[UIButton alloc]init];
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    [_backButton setTitleColor:kUIColor(42, 138, 219, 1) forState:UIControlStateNormal];
    [_backButton.layer setMasksToBounds:YES];
    [_backButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    //边框宽度
    [_backButton.layer setBorderWidth:1.0];
    _backButton.layer.borderColor=kUIColor(42, 138, 219, 1).CGColor;
    [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.enterSubject sendNext:@"back"];
    }];
    [_showView addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_showView.mas_bottom).offset(-14*kHeightScale);
        make.left.mas_equalTo(_enterButton.mas_right).offset(23*kWidthScale);
        make.right.mas_equalTo(_showView.mas_right).offset(-26*kWidthScale);
        make.height.mas_equalTo(34*kHeightScale);
    }];
    
   
}
#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    
//    [self dismissContactView];
//    YSSingleton *singleton = [YSSingleton getData];
//    if (singleton.isReset) {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"returnSelectInfo" object:nil userInfo:@{}];
//        singleton.isReset = NO;
//    }
    
}

-(void)dismissContactView {
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}



@end
