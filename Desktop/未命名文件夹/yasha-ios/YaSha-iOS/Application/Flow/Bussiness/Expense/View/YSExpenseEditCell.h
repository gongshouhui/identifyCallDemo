//
//  YSExpenseEditCell.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/3/9.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTextField.h"
#import "YSFlowExpensePexpShareModel.h"
@class YSExpenseEditCell;
@protocol YSExpenseEditCellDelegate<NSObject>
- (void)expenseEditCell:(YSExpenseEditCell *)cell position:(NSDictionary *)dic;
@end
@interface YSExpenseEditCell : UITableViewCell
@property (nonatomic,strong) YSFlowExpenseShareDetailModel *model;
@property (nonatomic,strong) id <YSExpenseEditCellDelegate> delegate;
@end

@interface YSExpenseTextFieldView: UIView
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) YSTextField *textField;
@end
