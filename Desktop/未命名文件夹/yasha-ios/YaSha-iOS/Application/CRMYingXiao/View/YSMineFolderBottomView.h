//
//  YSMineFolderBottomView.h
//  YaSha-iOS
//
//  Created by GZl on 2019/5/10.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSMineFolderBottomView : UIView
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) QMUIButton *choseBtn;
@property(nonatomic,copy) void (^clickdeChoseBtnBlock)(BOOL isChose);

@end

NS_ASSUME_NONNULL_END
