//
//  YSPMSPlanPieChartView.h
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2017/9/28.
//

#import <UIKit/UIKit.h>
@protocol YSPMSPlanPieChartViewDelegate<NSObject>
- (void)constructionInfoButtonDidClick:(UIButton *)button;
- (void)controlPointsButtonDidClick:(UIButton *)button;
@end
@interface YSPMSPlanPieChartView : UIView

@property (nonatomic, strong) UIButton *delayButton;
@property (nonatomic, strong) UIButton *controlPointsButton;
@property (nonatomic,strong) NSString *currentTitle;
@property(weak,nonatomic)id <YSPMSPlanPieChartViewDelegate> delegate;

- (void)creatPieChart:(NSArray *) absolutelyArray andDelayTitleArray:(NSArray *)delayTitle;
- (void)createEarlyPreparePieChart:(NSArray *)dataArray andChartType:(NSString *)title;

@end
