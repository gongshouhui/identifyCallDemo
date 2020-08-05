//
//  TagButton.m
//  CallTest
//
//  Created by 罗罗诺亚索隆 on 2018/7/18.
//  Copyright © 2018年 mianduijifengba. All rights reserved.
//

#import "YSTagButton.h"

@implementation YSTagButton
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1;
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.tagContentEdgeInsets.top != 0 || self.tagContentEdgeInsets.bottom !=0 || self.tagContentEdgeInsets.left !=0 || self.tagContentEdgeInsets.right !=0) {
        self.contentEdgeInsets = self.tagContentEdgeInsets;
    }else{
         self.contentEdgeInsets = UIEdgeInsetsMake(1, 8, 1, 8);
    }
   
    [self.titleLabel sizeToFit];
}

@end
