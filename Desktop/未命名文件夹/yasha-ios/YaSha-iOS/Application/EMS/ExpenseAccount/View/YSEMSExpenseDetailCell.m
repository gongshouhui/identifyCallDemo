//
//  YSEMSExpenseDetailCell.m
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/4.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import "YSEMSExpenseDetailCell.h"
#import "YSExpensePieChartView.h"
@interface YSEMSExpenseDetailCell()
@property (nonatomic,strong)  YSExpensePieChartView *pieChart;
@property (nonatomic,strong) NSArray *colorArray;
@property (nonatomic,strong) NSArray *colorImageNameArr;
@property (weak, nonatomic) IBOutlet UIImageView *firstColorIV;
@property (weak, nonatomic) IBOutlet UIImageView *secondColorIV;
@property (weak, nonatomic) IBOutlet UIImageView *thirdColorIV;
@property (weak, nonatomic) IBOutlet UIImageView *fourthColorIV;
@end
@implementation YSEMSExpenseDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addPieChartView];
    [self layoutIfNeeded];
    // Initialization code
}
- (void)setColorType:(NSInteger)colorType {
    _colorType = colorType;
    switch (colorType) {
        case 4:
        {
            self.colorArray = @[@"FE5578",@"1CD1A1",@"6C5CE7",@"FECA57"];
            self.colorImageNameArr = @[@"ico-红",@"ico-绿",@"ico-紫",@"ico-黄"];
            
        }
            break;
        case 3:
        {
            self.colorArray = @[@"FE5578",@"FECA57",@"6C5CE7",@"FECA57"];
            self.colorImageNameArr = @[@"ico-红",@"ico-黄",@"ico-紫",@""];
        }
            break;
        case 2:
        {
            self.colorArray = @[@"FE5578",@"6C5CE7",@"6C5CE7",@"FECA57"];
            self.colorImageNameArr = @[@"ico-红",@"ico-紫",@"",@""];
        }
            break;
        default:
            break;
    }
    self.firstColorIV.image = [UIImage imageNamed:self.colorImageNameArr[0]];
    self.secondColorIV.image = [UIImage imageNamed:self.colorImageNameArr[1]];
    self.thirdColorIV.image = [UIImage imageNamed:self.colorImageNameArr[2]];
    self.fourthColorIV.image = [UIImage imageNamed:self.colorImageNameArr[3]];
}
- (void)addPieChartView {
   
    
    
//    self.pieChart.legendStyle = PNLegendItemStyleStacked;
//    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
//    
//    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
//    [legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];
//    [self.chartView addSubview:legend];
    
   
}
- (void)createPieChartWithTotalValue:(CGFloat)totalValue text:(NSString *)text itemArray:(NSArray *)array{
   
    NSMutableArray *items = [NSMutableArray array];
    if (totalValue == 0) {
        [items addObject:[PNPieChartDataItem dataItemWithValue:1 color:kGrayColor(245)]];
    }else {
        for (int i = 0; i < array.count; i++) {
            
            [items addObject:[PNPieChartDataItem dataItemWithValue:[array[i] floatValue] color:[UIColor colorWithHexString:self.colorArray[i]]]];
        }
    }
   
    self.pieChart = [[YSExpensePieChartView alloc] initWithFrame:CGRectMake((CGFloat) 0, 0, 140, 140) items:items];
    
    NSString *mergeText = [NSString stringWithFormat:@"%@\n%@",text,[YSUtility thousandsFormat:totalValue]];
    NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc]initWithString:mergeText];
    
    [attiStr addAttributes:@{NSForegroundColorAttributeName:kUIColor(0, 0, 0, 0.45),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]} range:[mergeText rangeOfString:text]];
    [attiStr addAttributes:@{NSForegroundColorAttributeName:kUIColor(0, 0, 0, 0.86),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:16]} range:[mergeText rangeOfString:[YSUtility thousandsFormat:totalValue]]];
    self.pieChart.titleLabel.attributedText = attiStr;
    
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    //    self.pieChart.showAbsoluteValues = YES;
    //self.pieChart.showOnlyValues = YES;
    self.pieChart.hideValues = YES;
    [self.pieChart recompute];
    [self.pieChart strokeChart];
    [self.chartView addSubview:self.pieChart];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
