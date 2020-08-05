//
//  YSRightImageButton.m
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/15.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSRightImageButton.h"

@implementation YSRightImageButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //首先得先设置lable的尺寸,可以让它的尺寸自适应,根据文字的尺寸来调整
    [self.titleLabel sizeToFit];
    self.titleLabel.x = 0;
    self.titleLabel.centerY = self.height*0.5;
    self.imageView.x = self.titleLabel.width + 10;
    self.imageView.centerY = self.height*0.5;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    

}

@end
