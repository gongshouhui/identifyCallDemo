//
//  YSFlowDetailsConerNavView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/7/30.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSFlowDetailsConerNavView.h"
#import "UIView+Extension.h"

@implementation YSFlowDetailsConerNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.frame = CGRectMake(0, 0,kSCREEN_WIDTH , kTopHeight);
//        self.backgroundColor = kUIColor(46, 106, 253, 1);
        [self setGradientBackgroundWithColors:@[kUIColor(84, 106, 253, 1),kUIColor(46, 193, 255, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"返回白"] forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(7*kHeightScale+kStatusBarHeight);
        make.left.mas_equalTo(self.mas_left).offset(10*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(28*kWidthScale, 28*kHeightScale));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
//    self.titleLabel.text = @"略长的标题文案-备用…";
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10*kHeightScale+kStatusBarHeight);
        make.left.mas_equalTo(self.backButton.mas_right).offset(7);
        make.size.mas_equalTo(CGSizeMake(200*kWidthScale, 22*kHeightScale));
    }];
    
    self.chartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chartButton setImage:[UIImage imageNamed:@"ico24-流程视图"] forState:UIControlStateNormal];
    self.chartButton.tag = 30;
    [self addSubview:self.chartButton];
    [self.chartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(7*kHeightScale+kStatusBarHeight);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.size.mas_equalTo(CGSizeMake(24*kWidthScale, 24*kHeightScale));
    }];
    
    self.documentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.documentButton setImage:[UIImage imageNamed:@"ico24-关联文档"] forState:UIControlStateNormal];
    self.documentButton.tag = 20;
    [self addSubview:self.documentButton];
    [self.documentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(7*kHeightScale+kStatusBarHeight);
        make.right.mas_equalTo(self.chartButton.mas_left).offset(-16);
        make.size.mas_equalTo(CGSizeMake(24*kWidthScale, 24*kHeightScale));
    }];
    
    self.flowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flowButton setImage:[UIImage imageNamed:@"ico24-关联流程"] forState:UIControlStateNormal];
    self.flowButton.tag = 10;
    [self addSubview:self.flowButton];
    [self.flowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(7*kHeightScale+kStatusBarHeight);
        make.right.mas_equalTo(self.documentButton.mas_left).offset(-16);
        make.size.mas_equalTo(CGSizeMake(24*kHeightScale, 24*kHeightScale));
    }];
    
}
@end
