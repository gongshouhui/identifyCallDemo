//
//  YSPMSMQPlanPieChartView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/5.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSPMSMQPlanPieChartView : UIView

@property (nonatomic, strong) UILabel *titleLabel;


- (void)showActualPercentage:(NSString *)percentage;
@end
