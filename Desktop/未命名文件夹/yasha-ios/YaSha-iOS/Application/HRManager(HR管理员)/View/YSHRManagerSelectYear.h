//
//  YSHRManagerSelectYear.h
//  YaSha-iOS
//
//  Created by GZl on 2019/3/28.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSHRManagerSelectYear : UIView

@property (nonatomic, strong) NSString *currentSelectedYear;
@property(nonatomic,copy) void (^selectYearBlock)(NSString *currentSelectedYear);
@property (nonatomic, strong) UILabel *titlLab;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)titleStr;

@end

NS_ASSUME_NONNULL_END
