//
//  YSCircleView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/11/4.
//

#import "YSCircleView.h"
#import <objc/runtime.h>
#define PI 3.14159265358979323846
#define degreesToRadian(x) ( 180.0 / PI * (x))
#define RadiusToDegree(value) ((value / M_PI) * 180)

@interface YSCircleView ()
@property (nonatomic,assign) CGFloat radiu;
@property(nonatomic,assign)CGPoint centerPoint;

/**
 数据源重组 开始结束范围
 */
@property(nonatomic,strong)NSMutableArray *rangeArr;
@end

@implementation YSCircleView

//初始化
-(instancetype)initWithFrame:(CGRect)frame andWithDataArray:(NSArray *)dataArr andWithCircleRadius:(CGFloat)circleRadius type:(MYHCircleManageViewType)type{
    if (self = [super initWithFrame:frame]) {
        if (type == MYHCircleManageViewTypeArc) {
            self.radiu = 0;
        }else if(type == MYHCircleManageViewTypeRound){
            self.radiu = 35.0;
        }
        _dataArray = [[NSMutableArray alloc] init];
        [_dataArray addObjectsFromArray:dataArr];
        _circleRadius = circleRadius;
        _centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        //数据重组,获取范围模型数组
       self.rangeArr = [self getRangeRadiusWithArray:[dataArr copy]];
    }
    return self;
}

- (NSMutableArray *)getRangeRadiusWithArray:(NSMutableArray *)array{
    NSMutableArray *mutArr = [NSMutableArray array];
    CGFloat scale = [self getShareNumber:array];
    CGFloat angle_start = 0;
    for (int i = 0; i < array.count; i++) {
        YSRadiusRange *rangeModel = [[YSRadiusRange alloc]init];
    CGFloat angle_end =([array[i][@"number"]  floatValue] *scale + angle_start);//结束
        rangeModel.startRadiu = RadiusToDegree(angle_start);
        rangeModel.endRadiu = RadiusToDegree(angle_end);
        rangeModel.progressType = [array[i][@"type"] integerValue];
        [mutArr addObject:rangeModel];
        angle_start = angle_end;
        
    }
    return mutArr;
}
-(CGFloat)getShareNumber:(NSMutableArray *)arr{  //比例
    CGFloat f = 0.0;
    for (int  i = 0; i < arr.count; i++) {
        f += [arr[i][@"number"] floatValue];
    }
    return M_PI*2 / f;
}
-(void)drawRect:(CGRect)rect{
    CGFloat bl = [self getShareNumber:_dataArray]; //得到比例
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //float angle_start = radians(0.0); //开始
    CGFloat angle_start =0; //开始时的弧度  －－－－－ 旋转200度
    CGFloat ff = 0;  //记录偏转的角度 －－－－－ 旋转200度
    for (int i = 0; i < _dataArray.count; i++) {
        CGFloat angle_end =([_dataArray[i][@"number"]  floatValue] *bl + ff);  //结束
        ff += [_dataArray[i][@"number"] floatValue] *bl;  //开始之前的角度
        [self drawArcWithCGContextRef:ctx andWithPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) andWithAngle_start:angle_start andWithAngle_end:angle_end andWithColor: _dataArray[i][@"color"] andInt:i];
        angle_start = angle_end;
    }
    
    [self addCenterCircle];//添加中心圆
    
    //画圆心文字
    NSInteger total = 0.0;
    for (int  i = 0; i < _dataArray.count; i++) {
        total += [_dataArray[i][@"number"] floatValue];
    }
    NSString *totalText = [NSString stringWithFormat:@"总数%ld",(long)total];
    NSMutableParagraphStyle * paragraphCenter = [[NSMutableParagraphStyle alloc]init];
    paragraphCenter.alignment = NSTextAlignmentCenter;
    CGSize textSize = [totalText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragraphCenter}];
    [totalText drawAtPoint:CGPointMake(_centerPoint.x - textSize.width/2, _centerPoint.y - textSize.height/2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragraphCenter}];
}
#pragma mark 添加中心的圆
-(void)addCenterCircle{
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.radiu startAngle:0 endAngle:PI * 2 clockwise:YES];
    [[UIColor whiteColor] set];
    [arcPath fill];
    [arcPath stroke];
}
-(void)drawArcWithCGContextRef:(CGContextRef)ctx
                  andWithPoint:(CGPoint) point
            andWithAngle_start:(float)angle_start
              andWithAngle_end:(float)angle_end
                  andWithColor:(UIColor *)color
                        andInt:(int)n {
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextSetFillColor(ctx, CGColorGetComponents( color.CGColor));
    CGContextAddArc(ctx, point.x, point.y, _circleRadius,  angle_start, angle_end, 0);
    CGContextFillPath(ctx);
    // 弧度的中心角度
    CGFloat h = (angle_end + angle_start) / 2.0;
    //小圆的中心点
    CGFloat xx = self.frame.size.width / 2 + (_circleRadius + 10) * cos(h);
    CGFloat yy = self.frame.size.height / 2 + (_circleRadius + 10) * sin(h);
    //画线
    [self addLineAndnumber:color andCGContextRef:ctx andX:xx andY:yy andInt:n angele:h];
}
/**
 * @color 颜色
 * @ctx CGContextRef
 * @x 小圆的中心点的x
 * @y 小圆的中心点的y
 * @n 表示第几个弧行
 * @angele 弧度的中心角度
 */
-(void)addLineAndnumber:(UIColor *)color
        andCGContextRef:(CGContextRef)ctx
                   andX:(CGFloat)x
                   andY:(CGFloat)y
                 andInt:(int)n
                 angele:(CGFloat)angele
{
    //小圆中心点
    CGFloat smallCircleCenterPointX = x;
    CGFloat smallCircleCenterPointY = y;
    //DebugLog(@"X:%f   Y:%f",smallCircleCenterPointX,smallCircleCenterPointY);
    //折点
    CGFloat lineLosePointX = 0.0 ; //指引线的折点
    CGFloat lineLosePointY = 0.0 ; //
    //指引线的终点
    CGFloat lineEndPointX ; //
    CGFloat lineEndPointY ; //
    //数字的起点
    CGFloat numberStartX;
    CGFloat numberStartY;
    //文字的起点
    CGFloat textStartX;
    CGFloat textStartY;
    lineLosePointX = smallCircleCenterPointX+10.0*cos(angele);
    lineLosePointY = smallCircleCenterPointY + 10.0*sin(angele);
    //    NSLog(@"%lf  %lf %lf",10.0*cos(angele),10.0*sin(angele),angele);
    NSString * OldNumberStr = [NSString stringWithFormat:@"%@个",_dataArray[n][@"number"]];
    NSString * numberStr;
    numberStr = OldNumberStr;
    // 数字的长度
    CGSize itemSizeNumber = [numberStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    // 文字的长度
    CGSize textSizeNumber = [[NSString stringWithFormat:@"%@",_dataArray[n][@"name"]] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
    CGFloat lineWidth = 0.0;
    CGFloat maxWidth = itemSizeNumber.width>textSizeNumber.width?itemSizeNumber.width:textSizeNumber.width;
    if (maxWidth < 60) {
        maxWidth = 60;
        lineWidth = 60;
    }else{
        if (maxWidth+10 > self.frame.size.width/2-5) {
            maxWidth = self.frame.size.width/2-5;
        }
        lineWidth = maxWidth+10;
    }
    UIColor * numberColor = color;
    UIColor * textColor = color;
    if (smallCircleCenterPointX > self.frame.size.width / 2) {//往右跑
        //指引线的终点
        lineEndPointX = lineLosePointX + lineWidth; //
        lineEndPointY = lineLosePointY; //
        //数字
        numberStartX = lineEndPointX - itemSizeNumber.width;
        numberStartY = lineEndPointY - itemSizeNumber.height;
        //文字
        textStartX = lineEndPointX - lineWidth;
        textStartY = lineEndPointY;
    }else{//往左跑
        //指引线的终点
        lineEndPointX = lineLosePointX - lineWidth; //
        if (lineEndPointX<3) {
            lineEndPointX = 3;
        }
        lineEndPointY = lineLosePointY; //
        // 数字
        numberStartX = lineEndPointX ;
        numberStartY = lineEndPointY - itemSizeNumber.height;
        //文字
        textStartX = lineEndPointX;
        textStartY = lineEndPointY;
        if (lineLosePointX<maxWidth-15) {
            numberColor = [UIColor blackColor];
        }
    }
    //画边上的小圆
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(smallCircleCenterPointX, smallCircleCenterPointY) radius:4 startAngle:0 endAngle:PI * 2 clockwise:YES];
    [color set];
    [arcPath fill];
    [arcPath stroke];
    //画指引线
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, smallCircleCenterPointX,smallCircleCenterPointY);
    CGContextAddLineToPoint(ctx, lineLosePointX, lineLosePointY);
    CGContextAddLineToPoint(ctx, lineEndPointX, lineEndPointY);
    CGContextSetLineWidth(ctx, 1.0);
    //画笔的颜色
    //CGContextSetRGBStrokeColor( ctx , r , g , b , 1);
    //填充颜色
    CGContextSetFillColorWithColor(ctx , color.CGColor);
    CGContextStrokePath(ctx);
    //指引线上面的数字
    if (numberStartX>=self.frame.size.width/2){//往右边跑
        [numberStr drawAtPoint:CGPointMake(numberStartX-5, numberStartY) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:numberColor}];
    }else{
        [numberStr drawAtPoint:CGPointMake(numberStartX+5, numberStartY) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:numberColor}];
    }
    //指引线下面的text
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    paragraph.alignment = NSTextAlignmentRight;
    if (lineEndPointX < self.frame.size.width /2.0) {//往左边跑
        paragraph.alignment = NSTextAlignmentLeft;
    }else{
        paragraph.alignment = NSTextAlignmentRight;
    }
    if (textStartX>=self.frame.size.width/2) {//往右边跑
        [_dataArray[n][@"name"] drawInRect:CGRectMake(textStartX-1, textStartY, lineWidth, 50) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:textColor,NSParagraphStyleAttributeName:paragraph}];
    }else{
        [_dataArray[n][@"name"] drawInRect:CGRectMake(textStartX+1, textStartY, lineWidth, 50) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:textColor,NSParagraphStyleAttributeName:paragraph}];
    }
   
    
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self setNeedsDisplay];
}
-(CGFloat)radians:(CGFloat)degrees {  //由角度获取弧度
    return degrees * M_PI / 180;
}
//点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    DLog(@"point-------%f,%f",point.x,point.y);
    if (ABS(point.x - _centerPoint.x) > _circleRadius +10) {
        return;
    }
   NSInteger index = [self PointOnArea:point];
    
    if (index != -1) {
        YSRadiusRange *model = self.rangeArr[index];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CircleViewSectionClick" object:nil userInfo:@{@"type":@(model.progressType)}];
    }
}

#pragma mark -- 根据点判断点击的位置在哪个扇形区
- (NSInteger)PointOnArea:(CGPoint)point {
    CGPoint p = [self PointAboutCenter:point];
    CGFloat radius = [self PointToRadiu:p];
    NSInteger num = [self RadiusToTag:radius];
    return num;
}
- (CGPoint)PointAboutCenter:(CGPoint)point {
    CGPoint  p;
    p.x = point.x - _centerPoint.x;
    p.y = point.y - _centerPoint.y;
    return p;
}
- (CGFloat)PointToRadiu:(CGPoint)point {
    float r = atan(point.y/point.x);

    CGFloat degree = RadiusToDegree(r);
    if (point.x < 0 && point.y > 0) {
        degree = 180 + degree;
    } else if (point.x < 0 && point.y < 0) {
        degree += 180;
    } else if (point.x >0 && point.y <0) {
        degree = 360 + degree;
    }
    NSLog(@"%f",degree);
    return degree;
    
}
//判断角度对应扇形区
- (NSInteger)RadiusToTag:(CGFloat)radius {

    for (int i = 0; i < _rangeArr.count; i++) {
        YSRadiusRange * range = _rangeArr[i];
        if (radius >= range.startRadiu && radius <= range.endRadiu) {
            DLog(@"index-------%d",i);
            return i;
            
        }
    }
    return -1;
}


@end

@implementation YSRadiusRange
@end

