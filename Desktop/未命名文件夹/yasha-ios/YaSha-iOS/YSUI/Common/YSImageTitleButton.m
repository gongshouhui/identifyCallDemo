//
//  YSImageTitleButton.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/5.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSImageTitleButton.h"

@implementation YSImageTitleButton
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, self.space, 0, 0);
    [self.titleLabel sizeToFit];
}
@end
