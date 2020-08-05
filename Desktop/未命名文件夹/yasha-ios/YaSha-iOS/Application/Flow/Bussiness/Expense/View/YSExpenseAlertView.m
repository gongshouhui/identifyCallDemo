//
//  YSExpenseAlertView.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/11.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSExpenseAlertView.h"
#import "AppDelegate.h"
#define ktopMargin 20*kWidthScale
@interface YSExpenseAlertView()
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) NSMutableArray *items;
@end
@implementation YSExpenseAlertView
- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
        
    }
    return _items;
}
- (instancetype)initWithFrame:(CGRect)frame Title:(NSArray *)titles {
    if (self == [super initWithFrame:frame]) {
        self.titles = titles;
        [self initUI];
    }
    return self;
}

- (void)showAlertViewOnWindowComplete:(CompleteBlock)completeBlock {
    
    self.block = completeBlock;
    //设置圆角
    self.layer.cornerRadius = 13;
    self.layer.masksToBounds = YES;
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.3;
    UIWindow *window =  ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    [window addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    //中心点
    self.center = window.center;
    [window addSubview:self];
    
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    YSExpenseSubView *lastView = nil;
    for (int i = 0; i < self.titles.count; i++) {
        YSExpenseSubView *subView = [[YSExpenseSubView alloc]init];
        subView.titleLb.text = self.titles[i];
        [self addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {//第一行
                make.top.mas_equalTo(ktopMargin);
            }else{//其他行
                make.top.mas_equalTo(lastView.mas_bottom).mas_equalTo(15);
            }
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo((self.qmui_height - 2*ktopMargin - (self.titles.count - 1)*15)/(self.titles.count + 1));
        }];
        lastView = subView;
    }
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kUIColor(234, 232, 235, 1);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(lastView.mas_bottom).mas_equalTo(ktopMargin);
    }];
    //分割线
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = kUIColor(234, 232, 235, 1);
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    //取消按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.cancelBtn setTitleColor:kGrayColor(153) forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(lineView1.mas_left).mas_equalTo(0);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo((self.qmui_height - 2*ktopMargin - (self.titles.count - 1)*15)/(self.titles.count + 1));
    }];
    //确定按钮
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:kUIColor(42, 138, 219, 1) forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView1.mas_right).mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo((self.qmui_height - 2*ktopMargin - (self.titles.count - 1)*15)/(self.titles.count + 1));
    }];
}

- (void)showAlertViewOnWindowAnimated:(BOOL)animated Complete:(CompleteBlock)completeBlock {
    
    self.block = completeBlock;
    //设置圆角
    self.layer.cornerRadius = 13;
    self.layer.masksToBounds = YES;
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.3;
    UIWindow *window =  ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    //UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    //中心点
    self.center = window.center;
    [window addSubview:self];
    if (animated) {
        // 将view宽高缩至无限小（点）
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.3 animations:^{
            // 以动画的形式将view慢慢放大至原始大小的1.2倍
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                // 以动画的形式将view恢复至原始大小
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)closeAlertViewAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
        [self.bgView removeFromSuperview];
    }else{
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }
}
#pragma mark - 点击方法
- (void)cancelAction {
    
    [self closeAlertViewAnimated:YES];
    
}
- (void)confirmAction {
    
    if (_items.count) {
        [_items removeAllObjects];
    }
    //遍历获取值
    for (YSExpenseSubView *subView in self.subviews) {
        if ([subView isKindOfClass:[YSExpenseSubView class]]) {
            [self.items addObject:subView.textField.text];
        }
       
    }
    self.block(self.items);
}

@end


@implementation YSExpenseSubView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.textColor = kGrayColor(83);
    self.titleLb.textAlignment = NSTextAlignmentRight;
    self.titleLb.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.titleLb];
//    [self.titleLb setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
//    [self.titleLb setContentCompressionResistancePriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*kWidthScale);
        make.centerY.mas_equalTo(0);
       make.width.mas_equalTo(80*kWidthScale);
    }];
    self.textField = [[UITextField alloc]init];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-20*kWidthScale);
        make.left.mas_equalTo(self.titleLb.mas_right).mas_equalTo(8);
    }];
    
}
@end
