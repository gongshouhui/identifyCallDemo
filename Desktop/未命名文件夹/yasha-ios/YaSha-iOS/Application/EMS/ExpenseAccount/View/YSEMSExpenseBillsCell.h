//
//  YSEMSExpenseBillsCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/4.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSEMSExpenseDetailModel.h"
@interface YSEMSExpenseBillsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleDetailLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *didHandleWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handlingWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noSumitWidth;

@property (weak, nonatomic) IBOutlet UILabel *didHandleLb;
@property (weak, nonatomic) IBOutlet UILabel *handlingLb;
@property (weak, nonatomic) IBOutlet UILabel *noSumitLb;
@property (nonatomic,strong) YSEMSExpenseDetailModel *model;
@end
