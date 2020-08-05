//
//  YSProgressView.m
//  12.25.YSSlider
//
//  Created by Color on 15/12/25.
//  Copyright © 2015年 com.moon-box. All rights reserved.
//

#import "YSProgressView.h"


@interface YSProgressView ()

/**
 *  进度条 progressView
 */
@property (nonatomic, strong) UIView *progressView;

/**
 *  progressView Rect
 */
@property (nonatomic) CGRect rect_progressView;

/**
 *  限制高度大小
 *
 *  @param rect self.height
 */
- (void)_setHeightRestrictionOfFrame:(CGFloat)height;

@end

@implementation YSProgressView


- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = [UIColor colorWithRed:0.973 green:0.745 blue:0.306 alpha:1.000];
        [self addSubview:self.progressView];
    }
    return _progressView;
}

#pragma mark -  initWithFrame

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.937 green:0.958 blue:1.000 alpha:1.000];
        
        [self _setHeightRestrictionOfFrame:frame.size.height];
    }
    return self;
}

#pragma mark - Privite Method
- (void)_setHeightRestrictionOfFrame:(CGFloat)height
{
    CGRect rect = self.frame;
    
    _progressHeight = MIN(height, 100.0);
    _progressHeight = MAX(_progressHeight, 5.0);
    
    self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, _progressHeight);
    
    self.rect_progressView = CGRectZero;
    _rect_progressView.size.height = _progressHeight;
    self.progressView.frame = self.rect_progressView;
    
    self.layer.cornerRadius = self.progressView.layer.cornerRadius =  _progressHeight / 2.0;
    
    
}

#pragma mark - Setter

- (void)setProgressHeight:(CGFloat)progressHeight
{
    [self _setHeightRestrictionOfFrame:progressHeight];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    
    self.backgroundColor = _progressTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    
    self.progressView.backgroundColor = _trackTintColor;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    
    _progressValue = MIN(progressValue, self.bounds.size.width);
    
    _rect_progressView.size.width = _progressValue;
    
    
    CGFloat maxValue = self.bounds.size.width;
    
    double durationValue = (_progressValue/2.0) / maxValue + .5;
    
    [UIView animateWithDuration:durationValue animations:^{
        
        self.progressView.frame = _rect_progressView;
    }];
}


@end
