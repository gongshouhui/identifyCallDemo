//
//  YSHRMSummaryHeaderView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSSummaryModel;
NS_ASSUME_NONNULL_BEGIN
@protocol YSHRMSummaryHeaderDelegate <NSObject>

@optional // 可选实现的方法
- (void)choseBtnActionType:(NSInteger)index;

@end

@interface YSHRMSummaryHeaderView : UIView

@property (nonatomic, assign) id <YSHRMSummaryHeaderDelegate>delegate;
- (void)upSubViewDataWith:(YSSummaryModel*)model;


@end

@interface CustomMBtnView : UIView

@property (nonatomic, strong) UILabel *topLab;
@property (nonatomic, strong) UILabel *bottomLab;
@property (nonatomic, strong) UIButton *backBtn;


@end


NS_ASSUME_NONNULL_END
