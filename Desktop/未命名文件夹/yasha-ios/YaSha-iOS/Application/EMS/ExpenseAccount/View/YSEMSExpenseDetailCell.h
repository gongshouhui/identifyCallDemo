//
//  YSEMSExpenseDetailCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/4.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSEMSMyExpenseModel.h"
@interface YSEMSExpenseDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *firstTypeView;
@property (weak, nonatomic) IBOutlet UILabel *firstTextLb;
@property (weak, nonatomic) IBOutlet UILabel *secondTextLb;
@property (weak, nonatomic) IBOutlet UILabel *thitdTextLb;
@property (weak, nonatomic) IBOutlet UILabel *fourthTextLb;

@property (weak, nonatomic) IBOutlet UILabel *firstValueLb;
@property (weak, nonatomic) IBOutlet UILabel *secondValueLb;
@property (weak, nonatomic) IBOutlet UILabel *thirdValueLb;
@property (weak, nonatomic) IBOutlet UILabel *fourthValueLb;

@property (weak, nonatomic) IBOutlet UIView *secondTypeView;
@property (weak, nonatomic) IBOutlet UIView *thirdTypeView;
@property (weak, nonatomic) IBOutlet UIView *fourthTypeView;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *titleDetailLb;

@property (nonatomic,strong) YSEMSMyExpenseModel *model;
@property (nonatomic,assign) NSInteger colorType;
- (void)createPieChartWithTotalValue:(CGFloat)totalValue text:(NSString *)text itemArray:(NSArray *)array;
@end
