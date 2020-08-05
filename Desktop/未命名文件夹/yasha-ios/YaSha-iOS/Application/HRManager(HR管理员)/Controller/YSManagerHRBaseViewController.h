//
//  YSManagerHRBaseViewController.h
//  YaSha-iOS
//
//  Created by GZl on 2019/3/26.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSHRCommonListController.h"

typedef NS_ENUM(NSInteger, RefreshStateType) {
    RefreshStateTypeHeader,
    RefreshStateTypeFooter,
};

NS_ASSUME_NONNULL_BEGIN

@interface YSManagerHRBaseViewController : YSHRCommonListController
@property (nonatomic, assign) RefreshStateType refreshType;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UILabel *navTitleLabe;

// 只显示搜索按钮
- (void)ys_showManagerSearchBar;
// 显示搜索 组织按钮
- (void)ys_showManagerScreenBar;
// 搜索按钮
- (void)clickedSeachBarAction;
// 组织按钮
- (void)clickedScreenBarAction;

// 刷新数据
- (void)refershTeamDataWithType:(RefreshStateType)type;

//返回方法
- (void)temaBack;

@end

NS_ASSUME_NONNULL_END
