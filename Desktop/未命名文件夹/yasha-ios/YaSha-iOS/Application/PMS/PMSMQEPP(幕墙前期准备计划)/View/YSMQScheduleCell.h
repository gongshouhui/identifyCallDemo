//
//  YSMQScheduleCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2018/11/1.
//  Copyright © 2018 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSPMSMQEarlyTaskModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSMQScheduleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *percentLb;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
- (void)setCellData:(YSPMSMQEarlyTaskModel *)model;
@end

NS_ASSUME_NONNULL_END
