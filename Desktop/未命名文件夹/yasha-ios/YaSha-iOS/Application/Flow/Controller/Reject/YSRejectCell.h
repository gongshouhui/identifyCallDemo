//
//  YSRejectCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/8/27.
//  Copyright © 2018年 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSRejectModel.h"
@class YSRejectCell;
@protocol YSRejectCellDelegate <NSObject>

- (void)rejectCellSelectedButtonDidClick:(YSRejectCell *)cell;
@end
@interface YSRejectCell : UITableViewCell
@property (nonatomic,strong) RACSubject *clickSubject;
@property (nonatomic, strong) QMUIButton *selectButton;
@property (nonatomic,strong) YSRejectModel *rejectModel;
@property (nonatomic,assign) id<YSRejectCellDelegate> delegate;
@end
