//
//  YSExpenseShareHeaderView.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/7.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFlowExpensePexpShareModel.h"
#import "YSRightImageButton.h"
@class YSExpenseShareHeaderView;
@protocol YSExpenseShareHeaderViewDelegate<NSObject>
- (void)expandButtonDidClick:(YSExpenseShareHeaderView *)headerView;

@end
@interface YSExpenseShareHeaderView : UIView

@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) YSRightImageButton *arrowBtn;
@property (nonatomic,strong) YSFlowExpensePexpShareModel *model;
@property (nonatomic,weak) id<YSExpenseShareHeaderViewDelegate> delegate;
- (void)updateConstraintForExpenseHeader;
@end
