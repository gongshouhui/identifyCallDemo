//
//  UIImage+YSImage.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/11/21.
//

#import <UIKit/UIKit.h>

@interface UIImage (YSImage)
/**
 *  根据颜色生成一张尺寸为1*1的相同颜色图片
 *
 *  @param color 生成图片的颜色
 *
 *  @return 生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  获取矩形的渐变色的UIImage(此函数还不够完善)
 *
 *  @param bounds       UIImage的bounds
 *  @param colors       渐变色数组，可以设置两种颜色
 *  @param gradientType 渐变的方式：0--->从上到下   1--->从左到右
 *
 *  @return 渐变色的UIImage
 */
+(UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(int)gradientType;
- (UIImage *)gradientRampimageWithFrame:(CGRect)frame;
- (NSData *)compressWithMaxLength:(NSUInteger)maxLength;
@end
