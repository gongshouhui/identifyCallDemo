//
//  StarRateView.h
//  mhomeapp
//
//  Created by 刘春雷 on 16/9/20.
//  Copyright © 2016年 刘春雷. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarRateView;

typedef void(^finishBlock)(CGFloat currentScore);

typedef NS_ENUM(NSInteger, RateStyle) {

    WholeStar = 0,  // 只能整星评论
    HalfStar = 1,   //允许半星评论
    IncompleteStar = 2  //允许不完整整星评论
};

@protocol StarRateViewDelegate <NSObject>

- (void)starRateView:(StarRateView *)starRateView currentScore:(CGFloat)currentScore;

@end

@interface StarRateView : UIView

@property (nonatomic, assign) BOOL isAnimation; //是否动画显示，默认NO
@property (nonatomic, assign) RateStyle rateStyle;  //评价样式，默认WholeStar
@property (nonatomic, weak) id<StarRateViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnimation:(BOOL)isAnimation delegate:(id)delegate;

- (instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish;
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnimation:(BOOL)isAnimation finish:(finishBlock)finish;

-(void)setCurrentScore:(CGFloat)currentScore;

@end
