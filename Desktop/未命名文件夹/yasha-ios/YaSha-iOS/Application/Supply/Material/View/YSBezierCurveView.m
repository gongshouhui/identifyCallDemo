////
////  YSBezierCurveView.m
////  YaSha-iOS
////
////  Created by YaSha_Tom on 2017/12/20.
////  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
////
//
#import "YSBezierCurveView.h"

static CGRect myFrame;

@interface YSBezierCurveView ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) int kk;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, strong) NSArray *valueArray;

@end

@implementation YSBezierCurveView
//初始化画布
+(instancetype)initWithFrame:(CGRect)frame{
    
    YSBezierCurveView *bezierCurveView = [[YSBezierCurveView alloc]init];
    bezierCurveView.frame = frame;
    
    //背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    backView.backgroundColor = [UIColor whiteColor];
    [bezierCurveView addSubview:backView];
    
    myFrame = frame;
    return bezierCurveView;
}

/**
 *  画坐标轴
 */
-(void)drawXYLine:(NSMutableArray *)x_names andnumerical:(NSMutableArray *)y_numerical{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.Y轴、X轴的直线
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN, MARGIN-23*kHeightScale)];
    
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    
    //2.添加箭头
    [path moveToPoint:CGPointMake(MARGIN, MARGIN-23*kHeightScale)];
    [path addLineToPoint:CGPointMake(MARGIN-5, MARGIN+5-23*kHeightScale)];
    [path moveToPoint:CGPointMake(MARGIN, MARGIN-23*kHeightScale)];
    [path addLineToPoint:CGPointMake(MARGIN+5, MARGIN+5-23*kHeightScale)];
    
    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN-5)];
    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN+5)];
    
    //3.添加索引格
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = 30 + 28*(i+1)*2;
        CGPoint point = CGPointMake(X*kWidthScale,CGRectGetHeight(myFrame)-MARGIN);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, point.y-3)];
    }
    //Y轴（实际长度为200,此处比例缩小一倍使用）
    for (int i=0; i<=10; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i*0.75;
        CGPoint point = CGPointMake(MARGIN,Y);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x+3, point.y)];
    }
    
    //4.添加索引格文字
    //X轴
    for (int i=0; i<x_names.count-1; i++) {
        CGFloat X = 60*kWidthScale + 57*kWidthScale*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(myFrame)-MARGIN, 50*kWidthScale, 20*kHeightScale)];
        textLabel.text = [NSString stringWithFormat:@"%@/01",[x_names[i+1] substringFromIndex:5]] ;
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = kGrayColor(153);
        [self addSubview:textLabel];
    }
    //Y轴
    for (int i=0; i<=10; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i*0.75;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-5, MARGIN, 10*kHeightScale)];
        NSString *min = [y_numerical valueForKeyPath:@"@min.intValue"] ;
        NSString *max = [y_numerical valueForKeyPath:@"@max.intValue"] ;
        if ([max intValue] - [min intValue] > 10) {
            int r = [max intValue] - [min intValue];
            double ref = (double)(r/10.0);
            textLabel.text = [NSString stringWithFormat:@"%d",([min intValue])+(int)(i*round(ref))];
        }else{
            textLabel.text = [NSString stringWithFormat:@"%d",[min intValue]+i-1];
        }
        
        textLabel.font = [UIFont systemFontOfSize:9];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = kGrayColor(153);
        [self addSubview:textLabel];
    }
    
    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = kGrayColor(153).CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
}



/**
 *  画折线图
 */
-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues  andXcoordinates:(NSMutableArray *)coordinates andTimeShow:(NSMutableArray *)timeArr LineType:(LineType) lineType{
    _timeArray = timeArr;
    _valueArray = coordinates;
    _showLabel = [[UILabel alloc]init];
    _showLabel.font = [UIFont systemFontOfSize:12];
    _showLabel.numberOfLines = 0;
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //1.画坐标轴
    [self drawXYLine:x_names andnumerical:coordinates];
    NSString *min = [coordinates valueForKeyPath:@"@min.intValue"] ;
    NSString *max = [coordinates valueForKeyPath:@"@max.intValue"] ;
    
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    DLog(@"==========%@",targetValues);
    for (int i=0; i<targetValues.count; i++) {
        CGFloat doubleValue = 2*[targetValues[i] floatValue]; //目标值放大两
        CGFloat X = 0.0,Y =0.0;
        X =  1.8*([targetValues[i] floatValue])*kWidthScale - 20*kWidthScale;
        if ([max intValue] - [min intValue] > 10) {
            Y = CGRectGetHeight(myFrame)-MARGIN-(16/(([max floatValue] - [min floatValue])/9.5))*([coordinates[i] floatValue]-[min floatValue]+([min intValue]%10))*kHeightScale;
        }else{
//            Y = CGRectGetHeight(myFrame)-MARGIN-16*([coordinates[i] floatValue]-[min floatValue]-1.0);
            Y = CGRectGetHeight(myFrame)-MARGIN+16*([coordinates[i] floatValue]-[min floatValue]-1.0);
        }
    
       
        
        DLog(@"------%f",Y);
        CGPoint point = CGPointMake(X,Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-2, point.y-2, 5, 5) cornerRadius:5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor colorWithRed:248.0/255.0 green:177.0/255.0 blue:63.0/255.0 alpha:1.0].CGColor;
        layer.fillColor = [UIColor colorWithRed:248.0/255.0 green:177.0/255.0 blue:63.0/255.0 alpha:1.0].CGColor;
        layer.path = path.CGPath;
        [self.subviews[0].layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //3.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    switch (lineType) {
        case LineType_Straight: //直线
            for (int i =1; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    PrePonit = [allPoints[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor colorWithRed:248.0/255.0 green:177.0/255.0 blue:63.0/255.0 alpha:1.0].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 4.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
    
    //4.添加目标值文字
//    _kk = allPoints.count;
    for (int i =0; i<allPoints.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
//        label.tag = i+100;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:9];
        [self.subviews[0] addSubview:label];
//
//        // 1. 创建一个点击事件，点击时触发labelClick方法
//        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
//        // 2. 将点击事件添加到label上
//        [label addGestureRecognizer:labelTapGestureRecognizer];
//        label.userInteractionEnabled = YES; // 可以理解为设置label可被点击
//
        
        
        if (i==0) {
            CGPoint NowPoint = [allPoints[0] CGPointValue];
//            label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(myFrame)-NowPoint.y-MARGIN)];
            label.frame = CGRectMake((NowPoint.x-MARGIN), (NowPoint.y-30), 55, 30);
            PrePonit = NowPoint;
			
        }else{
            CGPoint NowPoint = [allPoints[i] CGPointValue];
//            if (NowPoint.y<PrePonit.y) {  //文字置于点上方
                label.frame = CGRectMake((NowPoint.x-MARGIN), (NowPoint.y-30), 55, 30);
//            }else{ //文字置于点下方
//                label.frame = CGRectMake((NowPoint.x-MARGIN), NowPoint.y, 55, 30);
//            }
//            label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(myFrame)-NowPoint.y-MARGIN)];
            PrePonit = NowPoint;
            
        }
        label.text = [NSString stringWithFormat:@"%@\n%@",[_timeArray[i] substringFromIndex:5],_valueArray[i]];
        label.textColor = [UIColor colorWithRed:248.0/255.0 green:177.0/255.0 blue:63.0/255.0 alpha:1.0];
    }
    
}



//// 3. 在此方法中设置点击label后要触发的操作
//- (void)labelClick:(UITapGestureRecognizer *)gestureRecognizer {
//    UILabel *find_label= (UILabel*)[gestureRecognizer view];
//    _showLabel.frame = CGRectMake(find_label.frame.origin.x-20, find_label.frame.origin.y-10, 55, 30);
//
//    _showLabel.text = [NSString stringWithFormat:@"%@\n%@",[_timeArray[(long)find_label.tag-100] substringFromIndex:5],_valueArray[(long)find_label.tag-100]];
//    [self addSubview:_showLabel];
//}

@end

