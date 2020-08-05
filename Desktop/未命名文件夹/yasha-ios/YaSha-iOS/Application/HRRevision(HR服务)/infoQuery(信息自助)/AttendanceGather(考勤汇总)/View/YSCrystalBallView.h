//
//  YSCrystalBallView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2019/1/8.
//  Copyright © 2019年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSSummaryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSCrystalBallView : UIView
@property (nonatomic,strong)UIButton *yearButton;
- (void)setHeaderData:(YSSummaryModel *)headerModel;
@end

NS_ASSUME_NONNULL_END
