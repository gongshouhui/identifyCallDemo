//
//  YSExpenseAlertView.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/11.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^CompleteBlock)(NSArray *array);
@interface YSExpenseAlertView : UIView
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,copy) CompleteBlock block;
/**初始化*/
- (instancetype)initWithFrame:(CGRect)frame Title:(NSArray *)titles;
/**展示*/
- (void)showAlertViewOnWindowAnimated:(BOOL)animated Complete:(CompleteBlock)completeBlock;
- (void)closeAlertViewAnimated:(BOOL)animated;
@end

@interface YSExpenseSubView : UIView
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UITextField *textField;

@end
