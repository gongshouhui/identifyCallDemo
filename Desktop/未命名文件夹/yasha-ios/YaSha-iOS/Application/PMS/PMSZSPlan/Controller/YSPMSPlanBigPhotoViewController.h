//
//  YSPMSPlanBigPhotoViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/29.
//

#import <UIKit/UIKit.h>
@class YSPMSPlanImageViewItem;

@interface YSPMSPlanBigPhotoViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) YSPMSPlanImageViewItem *item;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *networkingPhoto;

@end
