//
//  YSHRCircleView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/8.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRCircleView.h"
@interface YSHRCircleView()
@property(strong,nonatomic)UIBezierPath *path;
@property(strong,nonatomic)CAShapeLayer *shapeLayer;
@property(strong,nonatomic)CAShapeLayer *bgLayer;

@end
@implementation YSHRCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.frame = self.bounds;
        _bgLayer.fillColor = [UIColor clearColor].CGColor;
//        _bgLayer.lineWidth = self.lineWidth;
//        _bgLayer.strokeColor =self.strokeColor.CGColor;
//        _bgLayer.strokeStart = 0.f;
//        _bgLayer.strokeEnd = 0.8f;
        _bgLayer.path = _path.CGPath;
        [self.layer addSublayer:_bgLayer];
    }
    return self;
}

@synthesize value = _value;
-(void)setValue:(CGFloat)value{
    _value = value;
    _bgLayer.strokeEnd = value;
}
-(CGFloat)value{
    return _value;
}

@synthesize lineColr = _lineColr;
-(void)setLineColr:(UIColor *)lineColr{
    _lineColr = lineColr;
    _bgLayer.strokeColor = lineColr.CGColor;
}
-(UIColor*)lineColr{
    return _lineColr;
}

@synthesize lineWidth = _lineWidth;
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    _shapeLayer.lineWidth = lineWidth;
    _bgLayer.lineWidth = lineWidth;
}
-(CGFloat)lineWidth{
    return _lineWidth;
}

@synthesize strokeStart = _strokeStart;
- (void)setStrokeStart:(CGFloat)strokeStart {
    _bgLayer.strokeStart = strokeStart;
}
- (CGFloat)strokeStart{
    return _strokeStart;
}

@synthesize strokeEnd = _strokeEnd ;
- (void)setStrokeEnd :(CGFloat)strokeEnd  {
    _bgLayer.strokeEnd  = strokeEnd ;
}
- (CGFloat)strokeEnd {
    return _strokeEnd;
}

@end
