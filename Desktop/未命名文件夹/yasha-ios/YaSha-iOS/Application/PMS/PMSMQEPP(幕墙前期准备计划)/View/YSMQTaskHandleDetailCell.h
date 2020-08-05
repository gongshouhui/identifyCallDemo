//
//  YSMQTaskHandleDetailCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/1.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSPMSMQEarlyTaskModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSMQTaskHandleDetailCell : UITableViewCell
- (void)setCellDataWithModel:(YSPMSMQEarlyChildTaskModel *)model;
@end

NS_ASSUME_NONNULL_END
