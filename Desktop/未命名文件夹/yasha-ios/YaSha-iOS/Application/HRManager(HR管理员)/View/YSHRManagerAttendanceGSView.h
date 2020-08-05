//
//  YSHRManagerAttendanceGSView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/1.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PNChart.h>

NS_ASSUME_NONNULL_BEGIN
// 我的团队 个人信息 考勤界面
@interface YSHRManagerAttendanceGSView : UIView
@property (nonatomic, strong) PNCircleChart *circleChart;
@property (nonatomic, strong) UILabel *currentLab;
@property (nonatomic, strong) UILabel *shouldDay;
@property (nonatomic, strong) UILabel *finishDay;
@property (nonatomic, strong) UILabel *bottomTitleLab;
@property (nonatomic, strong) UIButton *bottomBtn;

// 更新百分比数目
- (void)updateNumberByStr:(NSString*)numberStr;

@end

NS_ASSUME_NONNULL_END
