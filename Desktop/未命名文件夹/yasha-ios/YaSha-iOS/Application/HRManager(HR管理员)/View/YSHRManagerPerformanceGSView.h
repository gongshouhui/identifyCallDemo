//
//  YSHRManagerPerformanceGSView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/3.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSLineTriangleView : UIView

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *lineLab;

@end

@interface YSHRManagerPerformanceGSView : UIView
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UILabel *shouldNumLab;
@property (nonatomic, strong) UILabel *finishTimeLab;
@property (nonatomic, strong) UILabel *bottomTitleLab;

// indexArray 第一个值是 最亮的 第二值次之 (值从0~5对应S~E)
- (void)upSubViewsValueWith:(NSArray*)indexArray;

@end

NS_ASSUME_NONNULL_END
