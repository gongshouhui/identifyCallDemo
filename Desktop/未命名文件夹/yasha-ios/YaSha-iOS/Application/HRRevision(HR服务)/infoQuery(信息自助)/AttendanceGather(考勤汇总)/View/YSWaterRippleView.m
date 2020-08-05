//
//  YSWaterRippleView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/8.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSWaterRippleView.h"
@interface YSWaterRippleView ()
@property (nonatomic,strong) CADisplayLink *waveDisplaylink;
@property (nonatomic,assign) CGFloat wave_offsety;
@property (nonatomic,assign) CGFloat offsety_scale;
@property (nonatomic,assign) CGFloat wave_move_width;
@property (nonatomic,assign) CGFloat  wave_offsetx;
@property (nonatomic,strong) dispatch_source_t timer;
@end
@implementation YSWaterRippleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    
    return self;
}

#pragma mark - initView
- (void)initView {
    
    _wave_Amplitude = self.frame.size.height/30;
    _wave_Cycle = 2*M_PI/(self.frame.size.width * .9);
    
    
    _wave_h_distance = 2*M_PI/_wave_Cycle * .65;
    _wave_v_distance = _wave_Amplitude * .2;
    
    _wave_move_width = 0.5;
    
    _wave_scale = 0.5;
    
    _offsety_scale = 0.01;
    
//    _topColor = self.;
//    _bottomColor = 
    
    _progress_animation = YES;
    _wave_offsety = (1-_progress) * (self.frame.size.height + 2.2* _wave_Amplitude);
    [self startWave];
}


#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    if (_borderPath) {
        if (_border_fillColor) {
            [_border_fillColor setFill];
            [_borderPath fill];
        }
        
        if (_border_strokeColor) {
            [_border_strokeColor setStroke];
            [_borderPath stroke];
        }
        
        [_borderPath addClip];
    }
    [self drawWaveColor:_topColor offsetx:0 offsety:0];
    [self drawWaveColor:_bottomColor offsetx:_wave_h_distance offsety:_wave_v_distance];
    
}

#pragma mark - draw wave
- (void)drawWaveColor:(UIColor *)color offsetx:(CGFloat)offsetx offsety:(CGFloat)offsety {
    
    //波浪动画，所以进度的实际操作范围是，多加上两个振幅的高度,到达设置进度的位置y坐标
    CGFloat end_offY = (1-_progress) * (self.frame.size.height + 2* _wave_Amplitude);
    if (_progress_animation) {
        if (_wave_offsety != end_offY) {
            if (end_offY < _wave_offsety) {//上升
                _wave_offsety = MAX(_wave_offsety-=(_wave_offsety - end_offY)*_offsety_scale, end_offY);
            } else {
                _wave_offsety = MIN(_wave_offsety+=(end_offY-_wave_offsety)*_offsety_scale, end_offY);
            }
        }
    } else {
        _wave_offsety = end_offY;
    }
    
    UIBezierPath *wave = [UIBezierPath bezierPath];
    for (float next_x= 0.f; next_x <= self.frame.size.width; next_x ++) {
        //正弦函数
        CGFloat next_y = _wave_Amplitude * sin(_wave_Cycle*next_x + _wave_offsetx + offsetx/self.bounds.size.width*2*M_PI) + _wave_offsety + offsety;
        if (next_x == 0) {
            [wave moveToPoint:CGPointMake(next_x, next_y - _wave_Amplitude)];
        } else {
            [wave addLineToPoint:CGPointMake(next_x, next_y - _wave_Amplitude)];
        }
    }
    [wave addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [wave addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [color set];
    [wave fill];
}

#pragma mark - animation
- (void)changeoff {
    _wave_offsetx += _wave_move_width*_wave_scale;
    [self setNeedsDisplay];
}

#pragma mark - reStart
- (void)startWave {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.timer = timer;
     dispatch_resume(timer);
    // 设置首次执行事件、执行间隔和精确度(默认为0.1s)
//    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), 0.1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.05*NSEC_PER_SEC, 0.1*NSEC_PER_SEC);
    YSWeak;
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf changeoff];
        });
       
    });
   
    
//    if (!_waveDisplaylink) {
//
//        _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeoff)];
//        [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    }
}

- (void)dealloc {
    dispatch_source_cancel(self.timer);
}

@end
