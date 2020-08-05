//
//  YSHRAttendanceNumberView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/3/22.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSHRAttendanceNumberView : UIView

- (instancetype)initWithFrame:(CGRect)frame withImgNameArray:(NSArray*)imageNameArray withLabelTitle:(NSArray*)titleArray;
@property (nonatomic, strong) UILabel *topTitle;
@property (nonatomic, strong) UILabel *subTitle;



@end

NS_ASSUME_NONNULL_END
