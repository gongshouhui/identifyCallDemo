//
//  YSAliNumberKeyboard.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSAliNumberKeyboard : UIView
@property (nonatomic, weak) UITextField *textFiled;

/// 点击确定回调block
@property(nonatomic,copy) void (^confirmClickBlock)();
// 回收键盘
@property (nonatomic, copy) void (^clickedrecyclyBtnBlock)();
// 键盘输入过程
@property (nonatomic, copy) void (^inputTFBlock)(NSString *text);


/// 键盘背景色
@property (nonatomic,strong) UIColor *bgColor;
/// 键盘数字背景色
@property (nonatomic,strong) UIColor *keyboardNumBgColor;
/// 键盘文字颜色
@property (nonatomic,strong) UIColor *keyboardTitleColor;
/// 间隔线颜色
@property (nonatomic,strong) UIColor *marginColor;
/// return键被背景色
@property (nonatomic,strong) UIColor *returnBgColor;
/// return键文字颜色
@property (nonatomic,strong) UIColor *returnTitleColor;
/// return键title
@property (nonatomic,strong) NSString *title;
/// 输出内容格式（币种）
@property (nonatomic,strong) NSString *formatString;
// 最大精度(100.00)
@property (nonatomic, strong) NSString *maxPrecision;

- (void)drawKeyboard;
@end

NS_ASSUME_NONNULL_END
