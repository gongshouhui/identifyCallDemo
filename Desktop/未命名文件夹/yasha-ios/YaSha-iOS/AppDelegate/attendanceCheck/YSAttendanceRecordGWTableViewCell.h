//
//  YSAttendanceRecordGWTableViewCell.h
//  YaSha-iOS
//
//  Created by GZl on 2019/12/18.
//  Copyright © 2019 亚厦装饰股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSComplaintListModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface YSAttendanceRecordGWTableViewCell : UITableViewCell
@property (nonatomic, strong) QMUIButton *complaintBtn;

- (void)setRecordTimeData:(NSDictionary*)dic;

//考勤记录
@property (nonatomic, strong) YSComplaintListModel *complaintModel;

@end

NS_ASSUME_NONNULL_END


