//
//  YSPMSPlanPhotoViewCell.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/29.
//

#import "YSPMSPlanPhotoViewCell.h"

@interface YSPMSPlanPhotoViewCell ()

//@property (nonatomic, strong) UIImageView *photoImageView;

@end

@implementation YSPMSPlanPhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.photoImageView = [[UIImageView alloc]init];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.layer.masksToBounds = YES;
        self.photoImageView.layer.borderWidth = 1;
        self.photoImageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [self.contentView addSubview:self.photoImageView];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(110*kWidthScale, 110*kHeightScale));
        }];
    }
    return self;
}

- (void) setCollectionViewCell:(NSMutableArray *)imageArray andIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == imageArray.count -1) {
		if ([imageArray[indexPath.row] isKindOfClass:[NSString class]] ) {
			self.photoImageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
		}else{
			self.photoImageView.image = imageArray[indexPath.row];
		}
		
    }else{
        self.photoImageView.image = [self cutImage:imageArray[indexPath.row]];
    }
}
//处理图片失真问题
- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    if ((image.size.width / image.size.height) < (_photoImageView.frame.size.width / _photoImageView.frame.size.height))
    {
        newSize.width = image.size.width;
        newSize.height = image.size.width * _photoImageView.frame.size.height / _photoImageView.frame.size.width;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
    }else{
        newSize.height = image.size.height;
        newSize.width = image.size.height * _photoImageView.frame.size.width / _photoImageView.frame.size.height;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    return [UIImage imageWithCGImage:imageRef];
}

@end
