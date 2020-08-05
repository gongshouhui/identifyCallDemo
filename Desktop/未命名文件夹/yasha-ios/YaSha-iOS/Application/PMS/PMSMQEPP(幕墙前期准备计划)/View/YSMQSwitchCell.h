//
//  YSMQSwitchCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SwitchCellBlock)(BOOL switchValue);
@interface YSMQSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (nonatomic,copy) SwitchCellBlock switchBlock;
@end

NS_ASSUME_NONNULL_END
