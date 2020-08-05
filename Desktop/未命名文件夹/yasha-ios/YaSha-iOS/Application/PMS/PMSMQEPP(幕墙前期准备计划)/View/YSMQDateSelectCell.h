//
//  YSMQDateSelectCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMQCellModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^DateSelectedBlock)(NSString *date);
@interface YSMQDateSelectCell : UITableViewCell
@property (nonatomic,copy) DateSelectedBlock dateBlock;
- (void)setDataForCell:(YSMQCellModel *)model;
@end

NS_ASSUME_NONNULL_END
