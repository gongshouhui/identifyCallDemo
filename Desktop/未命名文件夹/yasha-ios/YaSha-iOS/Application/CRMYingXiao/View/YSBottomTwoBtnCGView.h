//
//  YSBottomTwoBtnCGView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/6/4.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSBottomTwoBtnCGView : UIView

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;


- (void)changeSubViewsWith:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
