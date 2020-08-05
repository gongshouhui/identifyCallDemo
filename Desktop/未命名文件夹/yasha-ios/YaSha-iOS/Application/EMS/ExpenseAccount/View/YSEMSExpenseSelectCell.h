//
//  YSEMSExpenseSelectCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/9/3.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelecDateBlock)(NSString *date);
typedef void(^SwitchBlock)(NSInteger index);
@interface YSEMSExpenseSelectCell : UITableViewCell
@property (nonatomic,strong) UISegmentedControl *segControl;
@property (nonatomic,copy) SelecDateBlock dateBlock;
@property (nonatomic,copy) SwitchBlock switchBlock;
- (void)setDateButtonTitle:(NSString *)title;
@end
