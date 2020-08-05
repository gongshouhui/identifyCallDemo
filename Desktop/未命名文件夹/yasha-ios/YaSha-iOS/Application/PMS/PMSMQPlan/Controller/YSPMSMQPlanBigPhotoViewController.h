//
//  YSPMSMQPlanBigPhotoViewController.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/1.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSPMSPlanImageViewItem;

@interface YSPMSMQPlanBigPhotoViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *imageData;
@property (nonatomic, strong) YSPMSPlanImageViewItem *item;
@property (nonatomic, assign) NSInteger index;
/**是否需要网络下载*/
@property (nonatomic, strong) NSString *networkingPhoto;

@end
