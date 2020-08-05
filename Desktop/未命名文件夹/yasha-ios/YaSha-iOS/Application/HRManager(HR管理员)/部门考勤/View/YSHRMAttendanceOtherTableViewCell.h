//
//  YSHRMAttendanceOtherTableViewCell.h
//  YaSha-iOS
//
//  Created by GZl on 2019/4/8.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSAttendanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSHRMAttendanceOtherTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headerImg;

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *hiddenLab;
@property (nonatomic, strong) UILabel *rightLab;

@property (nonatomic, strong) YSAttendanceModel *attendListModel;//考勤-记录列表
@property (nonatomic, strong) YSAttendanceModel *attentTimeModel;//考勤-打卡时间


@end

NS_ASSUME_NONNULL_END
