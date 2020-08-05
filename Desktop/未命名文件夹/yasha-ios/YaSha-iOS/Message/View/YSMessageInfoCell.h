//
//  YSMessageInfoCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/12/10.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMessageInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSMessageInfoCell : UITableViewCell
- (void)setMessageInfoCell:(YSMessageInfoDetailModel *)model;
- (void)setQYMessageWith:(YSMessageInfoModel *)model;

//打卡
- (void)setClockListCell:(YSMessageInfoDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
