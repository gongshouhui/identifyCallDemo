//
//  YSPMSPlanPhotoViewCell.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/29.
//

#import <UIKit/UIKit.h>

@interface YSPMSPlanPhotoViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic,strong) NSString *imageUrl;
- (void) setCollectionViewCell:(NSMutableArray *)imageArray andIndexPath:(NSIndexPath *)indexPath;
@end
