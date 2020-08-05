//
//  YSMonthListView.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelecDateBlock)(NSString *date);
@interface YSMonthListView : UIView
@property (nonatomic,copy) SelecDateBlock dateBlock;
- (void)resetState;
@end
