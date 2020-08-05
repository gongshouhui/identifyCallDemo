//
//  YSClockListGWTableViewCell.h
//  YaSha-iOS
//
//  Created by GZl on 2019/12/21.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMessageClockListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSClockListGWTableViewCell : UITableViewCell
@property (nonatomic, strong) QMUIButton *detailBtn;
@property (nonatomic, strong) YSMessageClockListModel *model;

@end

NS_ASSUME_NONNULL_END
