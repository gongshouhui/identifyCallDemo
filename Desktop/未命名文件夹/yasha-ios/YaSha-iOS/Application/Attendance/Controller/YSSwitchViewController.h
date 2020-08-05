//
//  YSSwitchViewController.h
//  YaSha-iOS
//
//  Created by mHome on 2017/4/26.
//
//

#import "YSCommonPageController.h"
#import "YSAttendanceModel.h"

@interface YSSwitchViewController : YSCommonPageController

@property (nonatomic ,strong) NSString *type;
@property (nonatomic ,strong) YSAttendanceModel *model;

@end
