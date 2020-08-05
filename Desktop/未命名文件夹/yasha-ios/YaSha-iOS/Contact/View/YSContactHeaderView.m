//
//  YSContactHeaderView.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/12/12.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSContactHeaderView.h"
@interface YSContactHeaderView()
@property (nonatomic,strong) UIScrollView *headerScrollView;
@end
@implementation YSContactHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 50*kHeightScale + 20.0);
        [self initUI];
    }
    return self;
}
- (void)initUI {
    UIScrollView *headerScrollView = [[UIScrollView alloc] init];
    headerScrollView.backgroundColor = UIColorWhite;
    headerScrollView.showsHorizontalScrollIndicator = NO;
    headerScrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*2, 50*kHeightScale);
    [self addSubview:headerScrollView];
    [headerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50*kHeightScale);
    }];
    self.headerScrollView = headerScrollView;
}
- (void)setHeaderArray:(NSArray *)headerArray {
    _headerArray = headerArray;
    QMUIButton *orgButton;
    UIImageView *arrowImageView;
    for (int i = 0; i < headerArray.count; i ++) {
        orgButton = [[QMUIButton alloc] init];
        orgButton.tag = 100 + i;
        [orgButton setTitle:headerArray[i] forState:UIControlStateNormal];
        [orgButton setTitleColor:i == headerArray.count - 1 ? UIColorGray : kThemeColor forState:UIControlStateNormal];
        [orgButton setEnabled:i == headerArray.count - 1 ? NO : YES];
        orgButton.titleLabel.font = UIFontMake(15);
        [self.headerScrollView addSubview:orgButton];
        [orgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.headerScrollView.mas_centerY);
            if (i == 0) {
                make.left.mas_equalTo(15);
            }else{
                make.left.mas_equalTo(arrowImageView.mas_right).offset(10);
            }
            
            make.height.mas_equalTo(20*kHeightScale);
        }];
        if (i != headerArray.count - 1) {
            arrowImageView = [[UIImageView alloc] init];
            arrowImageView.image = UIImageMake(@"arrow_right");
            [self.headerScrollView addSubview:arrowImageView];
            [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.headerScrollView.mas_centerY);
                make.left.mas_equalTo(orgButton.mas_right).offset(10);
                make.size.mas_equalTo(CGSizeMake(10*kWidthScale, 15*kWidthScale));
            }];
        }
        YSWeak;
        
        __weak __typeof(orgButton) weakOrgButton = orgButton;
        [[orgButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            YSStrong;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(contactHeaderViewDepartmentButton:)]) {
                [strongSelf.delegate contactHeaderViewDepartmentButton:weakOrgButton];
            }
        }];
    }
    [self scrollToBottom];
   
}
- (void)setlastDepartMentButtonWithTitle:(NSString *)title {
    QMUIButton *button = [self.headerScrollView viewWithTag:(100 + self.headerArray.count - 1)];
    [button setTitle:title forState:UIControlStateNormal];
    [self scrollToBottom];
}
- (void)scrollToBottom {
    [self.headerScrollView layoutIfNeeded];
    QMUIButton *lastButton = [self.headerScrollView viewWithTag:100 + _headerArray.count -1];
    CGFloat maxX = CGRectGetMaxX(lastButton.frame) + 15;
    [_headerScrollView setContentSize:CGSizeMake(maxX,50*kHeightScale)];
    CGFloat pointX = (self.headerScrollView.contentSize.width - self.headerScrollView.bounds.size.width) > 0 ? (self.headerScrollView.contentSize.width - self.headerScrollView.bounds.size.width) : 0;
    CGPoint bottomPoint = CGPointMake(pointX, 0);
    [self.headerScrollView setContentOffset:bottomPoint animated:YES];
}
@end
