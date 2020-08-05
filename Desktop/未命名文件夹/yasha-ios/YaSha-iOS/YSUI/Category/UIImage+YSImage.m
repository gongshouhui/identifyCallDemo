//
//  UIImage+YSImage.m
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/21.
//

#import "UIImage+YSImage.h"

@implementation UIImage (YSImage)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}
- (UIImage *)gradientRampimageWithFrame:(CGRect)frame{
    UIGraphicsBeginImageContext(frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    CGContextScaleCTM(context, frame.size.width, frame.size.height);
    
    CGFloat colors[] = {
        
        84.0/255.0, 106.0/255.0, 253.0/255.0, 1.0,
        46.0/255.0, 193.0/255.0, 255.0/255.0, 1.0,
        
        
        
    };
    
    
    CGGradientRef backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    
    CGColorSpaceRelease(rgb);
    
    //设置颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    
    CGContextDrawLinearGradient(context, backGradient, CGPointMake(0, 0), CGPointMake(1, 0), kCGGradientDrawsBeforeStartLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return UIGraphicsGetImageFromCurrentImageContext();
}

/**
 *  获取矩形的渐变色的UIImage(此函数还不够完善)
 *
 *  @param bounds       UIImage的bounds
 *  @param colors       渐变色数组，可以设置两种颜色
 *  @param gradientType 渐变的方式：0--->从上到下   1--->从左到右
 *
 *  @return 渐变色的UIImage
 */
+(UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(int)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, bounds.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(bounds.size.width, 0.0);
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
- (NSData *)compressWithMaxLength:(NSUInteger)maxLength {
	// Compress by quality
	CGFloat compression = 1;
	NSData *data = UIImageJPEGRepresentation(self, compression);
	
	if (data.length < maxLength) return data;
	
	CGFloat max = 1;
	CGFloat min = 0;
	for (int i = 0; i < 6; i++) {
		compression = (max + min) / 2;
		data = UIImageJPEGRepresentation(self, compression);
		
		if (data.length < maxLength * 0.9) {
			min = compression;
		} else if (data.length > maxLength) {
			max = compression;
		} else {
			break;
		}
	}
	
	if (data.length < maxLength) return data;
	UIImage *resultImage = [UIImage imageWithData:data];
	// Compress by size
	NSUInteger lastDataLength = 0;
	while (data.length > maxLength && data.length != lastDataLength) {
		lastDataLength = data.length;
		CGFloat ratio = (CGFloat)maxLength / data.length;
		
		CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
								 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
		UIGraphicsBeginImageContext(size);
		[resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
		resultImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		data = UIImageJPEGRepresentation(resultImage, compression);
		
	}
	
	return data;
}
@end
