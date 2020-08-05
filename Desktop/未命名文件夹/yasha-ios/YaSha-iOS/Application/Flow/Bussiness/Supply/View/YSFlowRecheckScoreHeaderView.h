//
//  YSFlowRecheckScoreHeaderView.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2017/12/28.
//  Copyright © 2017年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSFlowRecheckScoreHeaderView;
@protocol YSExpenseShareHeaderViewDelegate <NSObject>
- (void)expandButtonDidClick:(YSFlowRecheckScoreHeaderView *)headerView;
@end
@interface YSFlowRecheckScoreHeaderView : UIView
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *detailLb;
@property (nonatomic,strong) UIButton *arrowBtn;
@property (nonatomic,weak) id <YSExpenseShareHeaderViewDelegate> delegate;
@end
