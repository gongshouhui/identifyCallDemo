//
//  YSHRManagerTGTrainingView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/1.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSHRMTrainingChartView.h"

NS_ASSUME_NONNULL_BEGIN
// 我的团队 个人信息 培训
@interface YSHRManagerTGTrainingView : UIView
@property (nonatomic, strong) UILabel *shouldNumLab;
@property (nonatomic, strong) UILabel *finishTimeLab;
@property (nonatomic, strong) UILabel *bottomTitleLab;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) YSHRMTrainingChartView *lineChatView;

@end



NS_ASSUME_NONNULL_END
