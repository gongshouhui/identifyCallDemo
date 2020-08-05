//
//  YSMQRemarkInputCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/10/26.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSMQCellModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^RemarkInputBlock)(NSString *remark);
@interface YSMQRemarkInputCell : UITableViewCell
@property (nonatomic,strong) NSString *placeHolder;
@property (nonatomic,copy) RemarkInputBlock remarkBlock;
- (void)setDataForCell:(YSMQCellModel *)model;
@end

NS_ASSUME_NONNULL_END
