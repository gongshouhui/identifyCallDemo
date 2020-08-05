//
//  YSAttendanceDetailCell.h
//  YaSha-iOS
//
//  Created by 罗罗诺亚索隆 on 2019/3/19.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSSummaryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YSAttendanceDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLb;
@property (weak, nonatomic) IBOutlet UILabel *attendTypeLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (nonatomic,strong) YSSummaryModel *model;
@end

NS_ASSUME_NONNULL_END
