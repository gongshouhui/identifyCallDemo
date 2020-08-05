////
////  YSCopyLabel.m
////  YaSha-iOS
////
////  Created by YaSha_Tom on 2018/7/2.
////  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
////
//
#import "YSCopyLabel.h"

@interface YSCopyLabel()

@property (nonatomic, strong) UIPasteboard *pasteboard;

@end

@implementation YSCopyLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0;
        self.pasteboard = [UIPasteboard generalPasteboard];
        [self attachTapHandle];
    }
    return self;
}

- (void)attachTapHandle {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

//响应事件
- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self becomeFirstResponder]; //UILabel默认是不能响应事件的，所以要让它成为第一响应者
    UIMenuController *menuVC = [UIMenuController sharedMenuController];
    [menuVC setTargetRect:self.frame inView:self.superview]; //定位Menu
    [menuVC setMenuVisible:YES animated:YES]; //展示Menu
}


- (BOOL)canBecomeFirstResponder { //指定UICopyLabel可以成为第一响应者 切忌不要把这个方法不小心写错了哟， 不要写成 becomeFirstResponder
        return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender { //指定该UICopyLabel可以响应的方法
    if (action == @selector(copy:)) {
        return YES;
    }
    if (action == @selector(paste:)) {
        return YES;
    }
    if (action == @selector(delete:)) {
        return YES;
    }
    if (action == @selector(selectAll:)) {
        return YES;
    }
    if (action == @selector(cut:)) {
        return YES;
    }
    return NO;
}


//剪切事件（暂时不用）
- (void)cut:(id)sender{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    //剪切 功能
    self.text = nil;
}

//拷贝
- (void)copy:(id)sender{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    
}
//粘贴
- (void)paste:(id)sender{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    self.text = pboard.string;
}

- (void)delete:(id)sender {
    self.text = nil;
    self.pasteboard = nil;
}

- (void)selectAll:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.text;
    self.textColor = [UIColor blueColor];
    
}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
@end
