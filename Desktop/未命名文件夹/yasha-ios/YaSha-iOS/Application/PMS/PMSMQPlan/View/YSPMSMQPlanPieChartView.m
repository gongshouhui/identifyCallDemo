//
//  YSPMSMQPlanPieChartView.m
//  YaSha-iOS
//
//  Created by YaSha_Tom on 2018/3/5.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSPMSMQPlanPieChartView.h"
#import <PNPieChart.h>
#import "YSCircleManageView.h"
#import "UIImage+YSImage.h"

@interface YSPMSMQPlanPieChartView ()

@property (nonatomic, strong) YSCircleManageView * circleView1;

@end

@implementation YSPMSMQPlanPieChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"施工计划实际形象进度";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(21);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200*kWidthScale, 18*kHeightScale));
    }];
    
    UIButton *showMmarkButton = [[UIButton alloc]init];
    showMmarkButton.backgroundColor = [UIColor whiteColor];
    showMmarkButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [showMmarkButton setTitleColor:kUIColor(126, 126, 126, 1) forState:UIControlStateNormal];
    [showMmarkButton setImage:[UIImage imageNamed:@"延期小于5天"] forState:UIControlStateNormal];
    [showMmarkButton setTitle:@"进度" forState:UIControlStateNormal];
    //设置button文字的位置
    showMmarkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //调整与边距的距离
    showMmarkButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:showMmarkButton];
    [showMmarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset((200+20) *kHeightScale);
        make.right.mas_equalTo(self.mas_right).offset(-20*kWidthScale);
        make.size.mas_equalTo(CGSizeMake(75*kWidthScale, 15*kHeightScale));
    }];

}
- (void)showActualPercentage:(NSString *)percentage {
    NSArray *item = nil;
    item = @[[PNPieChartDataItem dataItemWithValue:[percentage integerValue] color:kUIColor(25, 116, 211, 1) description:[NSString stringWithFormat:@"%@%@",percentage,[percentage integerValue] > 0 ? @"%":@""]],
             [PNPieChartDataItem dataItemWithValue:100-[percentage integerValue] color:kUIColor(235, 235, 242, 1) description:@""],
             
             ];
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(103*kWidthScale, 62*kHeightScale, 170*kWidthScale, 170*kHeightScale) items:item];
    pieChart.descriptionTextColor = [UIColor blackColor];
    pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.shouldHighlightSectorOnTouch = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reKeyBoard)];
    [self addGestureRecognizer:tap];
    pieChart.hideValues = YES;
    [pieChart strokeChart];
    [self addSubview:pieChart];
}

- (void) reKeyBoard {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CircleViewSectionClick" object:nil userInfo:nil];
}

@end
