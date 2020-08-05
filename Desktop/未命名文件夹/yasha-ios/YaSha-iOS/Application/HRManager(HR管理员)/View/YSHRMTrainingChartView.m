//
//  YSHRMTrainingChartView.m
//  YaSha-iOS
//
//  Created by GZl on 2019/5/5.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#define KKWidth self.frame.size.width
#define KKHeight self.frame.size.height
#define KKTop 10
#define KKRight 20


#import "YSHRMTrainingChartView.h"
#import <objc/runtime.h>

@interface YSHRMTrainingChartView ()

@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic, strong) UIView *lineChartView;
@property (nonatomic, strong) NSMutableArray *pointCenterArr;

@end

@implementation YSHRMTrainingChartView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        /*
        //左上角按钮
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0  blue:122/255.0  alpha:1];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        //下面按钮
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _bottomLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 10 - 20 / 2);
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.textColor = [UIColor colorWithRed:0/255.0 green:165/255.0  blue:87/255.0  alpha:1];
        _bottomLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomLabel];
        */
        
        //中间区域
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 + _titleLabel.frame.size.height + 10, self.bounds.size.width, self.bounds.size.height - (10 + _titleLabel.frame.size.height + 10) - 40)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
        [self addLineChartView];
        
        self.pointCenterArr = [NSMutableArray array];
    }
    return self;
    
}
#pragma mark - 外部赋值
//外部Y坐标轴赋值
-(void)setDataArrOfY:(NSArray *)dataArrOfY
{
    _dataArrOfY = dataArrOfY;
    [self addYAxisViews];
}

//外部X坐标轴赋值
-(void)setDataArrOfX:(NSArray *)dataArrOfX
{
    _dataArrOfX = dataArrOfX;
    [self addXAxisViews];
//    [self addLinesView]; // 方格
}

//点数据
-(void)setDataArrOfPoint:(NSArray *)dataArrOfPoint
{
    [self.pointCenterArr removeAllObjects];
    [_lineChartView removeFromSuperview];
    [self addLineChartView];
    _dataArrOfPoint = dataArrOfPoint;
    [self addPointView];
    [self addBezierLine];
}

#pragma mark - UI
- (void)addLineChartView
{
    _lineChartView = [[UIView alloc]initWithFrame:CGRectMake(15 + 30 + 5, 0, _contentView.bounds.size.width - (15 + 30 + 5) - 15, _contentView.bounds.size.height-20)];
//    _lineChartView.layer.masksToBounds = YES;
//    _lineChartView.layer.borderWidth = 0.5;
//    _lineChartView.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0  blue:216/255.0  alpha:1].CGColor;
    _lineChartView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_lineChartView];
}
#pragma mark--Y轴坐标
-(void)addYAxisViews
{
    CGFloat height = _lineChartView.bounds.size.height / (_dataArrOfY.count - 1);
    for (int i = 0;i< _dataArrOfY.count ;i++ )
    {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, height * i - height / 2, 30, height)];
        leftLabel.font = [UIFont systemFontOfSize:10];
        leftLabel.textColor = [UIColor clearColor];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.text = _dataArrOfY[i];
        leftLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:leftLabel];
    }
}

#pragma mark--X轴坐标
-(void)addXAxisViews
{
    CGFloat height = _lineChartView.bounds.size.width /( _dataArrOfX.count - 1);
    for (int i = 0;i< _dataArrOfX.count;i++ )
    {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*height - height / 2 + _lineChartView.frame.origin.x, _lineChartView.bounds.origin.y + _lineChartView.bounds.size.height+10, height, 20)];
        leftLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:Multiply(14)];
        leftLabel.textColor = [UIColor colorWithHexString:@"#AEE1FF"];
        leftLabel.text = _dataArrOfX[i];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:leftLabel];
    }
    
}

#pragma mark--网格线条
-(void)addLinesView
{
    CGFloat white = _lineChartView.bounds.size.height /( _dataArrOfY.count - 1);
    CGFloat height = _lineChartView.bounds.size.width /( _dataArrOfX.count - 1);
    //横格
    for (int i = 0;i < _dataArrOfY.count - 2 ;i++ )
    {
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, white * (i + 1),_lineChartView.bounds.size.width , 0.5)];
        hengView.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0  blue:216/255.0  alpha:1];
        [_lineChartView addSubview:hengView];
    }
    //竖格
    for (int i = 0;i< _dataArrOfX.count - 2 ;i++ )
    {
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * (i + 1), 0, 0.5, _lineChartView.bounds.size.height)];
        shuView.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0  blue:216/255.0  alpha:1];
        [_lineChartView addSubview:shuView];
    }
}

#pragma mark - 点和根据点画贝塞尔曲线
-(void)addPointView
{
    //区域高
    CGFloat height = self.lineChartView.bounds.size.height;
    //y轴最小值
    float arrmin = [_dataArrOfY[_dataArrOfY.count - 1] floatValue];
    //y轴最大值
    float arrmax = [_dataArrOfY[0] floatValue];
    //区域宽
    CGFloat width = self.lineChartView.bounds.size.width;
    //X轴间距
    float Xmargin = width / (_dataArrOfX.count - 1 );
    
    for (int i = 0; i<_dataArrOfPoint.count; i++)
    {
        //nowFloat是当前值
        float nowFloat = [_dataArrOfPoint[i] floatValue];
        //点点的x就是(竖着的间距 * i),y坐标就是()
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake((Xmargin)*i - 2 / 2, height - (nowFloat - arrmin)/(arrmax - arrmin) * height - 2 / 2 , 2, 2)];
        //        v.backgroundColor = [UIColor blueColor];
        //        [_lineChartView addSubview:v];
        
        NSValue *point = [NSValue valueWithCGPoint:v.center];
        [self.pointCenterArr addObject:point];
    }
    
}
#pragma mark--曲线和渐变色
-(void)addBezierLine
{
    //取得起点
    CGPoint p1 = [[self.pointCenterArr objectAtIndex:0] CGPointValue];
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //添加线
    for (int i = 0;i<self.pointCenterArr.count;i++ )
    {
        if (i != 0)
        {
            CGPoint prePoint = [[self.pointCenterArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.pointCenterArr objectAtIndex:i] CGPointValue];
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
        }
        
        
    }
    //显示线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithHexString:@"#E6E423"].CGColor;
    shapeLayer.lineWidth = 8;
    [_lineChartView.layer addSublayer:shapeLayer];
    //设置动画
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =2.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    
    //遮罩层相关
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    CGPoint lastPoint;
    for (int i = 0;i<self.pointCenterArr.count;i++ )
    {
        if (i != 0)
        {
            CGPoint prePoint = [[self.pointCenterArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.pointCenterArr objectAtIndex:i] CGPointValue];
            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            if (i == self.pointCenterArr.count-1)
            {
                lastPoint = nowPoint;
            }
        }
        //转折圆点
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lineChartView addSubview:btn];
        btn.frame = CGRectMake(0, 0, 18, 18);
        btn.tag = i;
        btn.center = [[self.pointCenterArr objectAtIndex:i] CGPointValue];
        btn.layer.cornerRadius = 9;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor colorWithHexString:@"#E6E423"];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.text = [NSString stringWithFormat:@"%.1f", [self.dataArrOfPoint[i] floatValue]];
        [titleLab sizeToFit];
        titleLab.center = CGPointMake(btn.center.x, btn.center.y - titleLab.frame.size.height);
        titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:Multiply(15)];
        [_lineChartView addSubview:titleLab];
        
    }
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    CGPoint lastPointX1 = CGPointMake(lastPointX,_lineChartView.bounds.size.height);
    [bezier1 addLineToPoint:lastPointX1];
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, _lineChartView.bounds.size.height)];
    [bezier1 addLineToPoint:p1];
    
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor colorWithHexString:@"#E6E423"].CGColor;
    [_lineChartView.layer addSublayer:shadeLayer];
    
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0, _lineChartView.bounds.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#E6E423" alpha:0.4].CGColor,(__bridge id)[UIColor colorWithHexString:@"#E6E423" alpha:0].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [_lineChartView.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 2.0f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2*lastPoint.x, _lineChartView.bounds.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
}



-(CGFloat)getMaxValueForAry:(NSArray *)ary{
    
    CGFloat max = [ary[0] floatValue];
    for (int i=0; i<ary.count; i++) {
        if (max < [ary[i] floatValue]) {
            max = [ary[i] floatValue];
        }
    }
    return max;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
