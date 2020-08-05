//
//  YSExpenseAccessoryCell.h
//  YaSha-iOS
//
//  Created by 龚守辉 on 2018/1/15.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSNewsAttachmentModel.h"

@protocol YSExpenseAccessoryCellDelegate<NSObject>

- (void)expenseAccessoryCellAccessoryViewDidClickWithModel:(YSNewsAttachmentModel *)model;
@end
@interface YSExpenseAccessoryCell : UITableViewCell
@property (nonatomic,strong) NSArray *accessoryArray;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,weak) id <YSExpenseAccessoryCellDelegate> delegate;
@end

@interface YSAccessoryView : UIView
@property (nonatomic,strong) UIButton *nameButton;
@property (nonatomic,strong) UILabel *sizeLb;
@end
