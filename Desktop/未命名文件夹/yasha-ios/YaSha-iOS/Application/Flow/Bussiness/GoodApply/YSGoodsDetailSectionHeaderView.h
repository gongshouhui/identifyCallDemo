//
//  YSGoodsDetailSectionHeaderView.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/5/16.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFlowGoodsApplyModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol YSGoodsDetailSectionHeaderViewDelegate <NSObject>
- (void)expandButtonDidClick:(UIButton *)button;

@end
@interface YSGoodsDetailSectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *applycount;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
@property (nonatomic,strong) YSFlowGoodsDetailModel *goodModel;
@property (nonatomic,weak) id<YSGoodsDetailSectionHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
