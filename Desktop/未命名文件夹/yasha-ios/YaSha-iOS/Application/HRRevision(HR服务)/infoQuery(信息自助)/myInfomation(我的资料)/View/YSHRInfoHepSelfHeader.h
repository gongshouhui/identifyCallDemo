//
//  YSInfoHepSelfHeader.h
//  YaSha-iOS
//
//  Created by 蘑菇加 on 2017/12/8.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSPersonalInformationModel.h"
@class YSHRInfoHepSelfHeader;
@protocol YSHRInfoHepSelfHeaderDelegate<NSObject>
- (void)hrInfoHepSelfHeaderImageViewDidClick:(YSHRInfoHepSelfHeader *)headerView;
@end

@interface YSHRInfoHepSelfHeader : UIView
@property (nonatomic,strong) YSPersonalInformationModel *infoModel;
@property (nonatomic,weak) id <YSHRInfoHepSelfHeaderDelegate> delegate;
@property (nonatomic,strong) UIImageView *headImageView;
@end
