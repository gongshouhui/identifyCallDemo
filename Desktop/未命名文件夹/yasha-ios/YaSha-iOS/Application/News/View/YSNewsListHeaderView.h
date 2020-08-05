//
//  YSNewsListHeaderView.h
//  YaSha-iOS
//
//  Created by 方鹏俊 on 2017/9/29.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>
#import "YSNewsListViewController.h"

@interface YSNewsListHeaderView : UIView

@property (nonatomic, strong) RACSubject *searchSubject;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

+ (YSNewsListHeaderView *)initwithType:(YSNewsType)newsType;

@end
