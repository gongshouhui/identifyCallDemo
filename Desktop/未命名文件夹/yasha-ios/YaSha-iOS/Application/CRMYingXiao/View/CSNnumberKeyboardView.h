//
//  CSNnumberKeyboardView.h
//  ProductionToolsDemo
//
//  Created by GZl on 2019/9/9.
//  Copyright © 2019 龙禧. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSNnumberKeyboardView : UIView

@property (nonatomic, copy) NSString *currencyStr;//币种
@property (weak, nonatomic) IBOutlet UILabel *currencyLab;//币种
@property (weak, nonatomic) IBOutlet UIButton *currencyBtn;//币种选择按钮
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

//回传点击的数字带币种
@property(nonatomic,copy) void (^clickedKeyboardBlock)(NSString *number);

//回收以及确定 按钮
@property(nonatomic,copy) void (^choseBtnBlock)(BOOL isReturn);

/**
 返回键盘视图

 @param frame 位置大小
 @param currencyStr 所点击的输入框的当前值(字符串)
 @param currentMoney 币种
 @return 返回键盘视图
 */
- (instancetype)initWithFrame:(CGRect)frame withCurrencyStr:(NSString*)currencyStr withCurrentMoney:(NSString*)currentMoney;



@end

NS_ASSUME_NONNULL_END
